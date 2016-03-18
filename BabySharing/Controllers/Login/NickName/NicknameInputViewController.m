//
//  NicknameInputViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "NicknameInputViewController.h"
#import "LoginToken+ContextOpt.h"
#import "INTUAnimationEngine.h"
#import "SearchViewController.h"
#import "SearchRoleTagDelegate.h"
#import "NickNameInputView.h"
#import "SGActionView.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"
#import "ModelDefines.h"
#import "AppDelegate.h"
#import "ModelDefines.h"
#import "RemoteInstance.h"
#import "OBShapedButton.h"

#import "Tools.h"

#define NEXT_BTN_MARGIN_BOTTOM  80

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

#define SCREEN_PHOTO_TOP_MARGIN                 SCREEN_HEIGHT / 6
#define SCREEN_PHOTO_WIDTH                      100
#define SCREEN_PHOTO_HEIGHT                     100

#define SCREEN_PHOTO_2_GENDER_BTN_MARGIN        30

#define GENDER_BTN_WIDTH                        38
#define GENDER_BTN_HEIGHT                       GENDER_BTN_WIDTH

#define FATHER_ICON_WIDTH                       11.5
#define FATHER_ICON_HEIGHT                      FATHER_ICON_WIDTH

#define GENDER_BTN_BETWEEN_MARGIN               SCREEN_WIDTH / 4

#define INPUT_VIEW_2_SCREEN_PHOTO_MARGIN        (SCREEN_HEIGHT / 15 - 5)

#define TICK_BTN_WIDTH                          17
#define TICK_BTN_HEIGHT                         TICK_BTN_WIDTH

#define TICK_BTN_2_PRIVACY_MARGIN               10

@interface NicknameInputViewController () </*SearchUserTagControllerDelegate,*/ NickNameInputViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SearchActionsProtocol>
@property (strong, nonatomic) UIView* fakeBar;
@end

@implementation NicknameInputViewController {
    NickNameInputView* inputView;
    NSURL* user_img_url;
    
    UIButton * user_private_btn;
    OBShapedButton* tick_btn;

    UIButton *loginImgBtn;
    
    BOOL isChangeImg;
    CGRect keyBoardFrame;
}

//@synthesize loginImgBtn = _loginImgBtn;
//@synthesize nextBtn = _nextBtn;

@synthesize lm = _lm;
@synthesize login_attr = _login_attr;
@synthesize isSNSLogIn = _isSNSLogIn;

@synthesize fakeBar = _fakeBar;

@synthesize gender = _gender;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
   
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];

    /***********************************************************************************************************************/
    // Screen photo
    loginImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_PHOTO_WIDTH, SCREEN_PHOTO_HEIGHT)];
//    loginImgBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_PHOTO_WIDTH, SCREEN_PHOTO_HEIGHT)];
    loginImgBtn.layer.cornerRadius = SCREEN_PHOTO_HEIGHT / 2;
    loginImgBtn.clipsToBounds = YES;
    loginImgBtn.tag = -110;
    loginImgBtn.backgroundColor = [UIColor clearColor];
//    loginImgBtn.backgroundColor = [UIColor redColor];
    loginImgBtn.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_PHOTO_TOP_MARGIN + SCREEN_PHOTO_HEIGHT / 2);
    [self.view addSubview:loginImgBtn];
    [self.view bringSubviewToFront:loginImgBtn];
   
    loginImgBtn.clipsToBounds = YES;
    UIImage* img = [UIImage imageNamed:[resourceBundle_dongda pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"]];
    [loginImgBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self asyncGetUserImage];
    [loginImgBtn addTarget:self action:@selector(didSelectImgBtn) forControlEvents:UIControlEventTouchUpInside];
    /***********************************************************************************************************************/
    
    /***********************************************************************************************************************/
    // input view
//    inputView = [[NickNameInputView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    inputView = [[NickNameInputView alloc] init];
    inputView.delegate = self;
    [inputView setUpWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    inputView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_PHOTO_TOP_MARGIN + SCREEN_PHOTO_HEIGHT + INPUT_VIEW_2_SCREEN_PHOTO_MARGIN + inputView.frame.size.height / 2);
  
    [self.view addSubview:inputView];
    /***********************************************************************************************************************/
   
    /***********************************************************************************************************************/
    // private button
#define PRIVACY_BOTTOM_MARGIN               35
    UIFont* font = [UIFont systemFontOfSize:12.f];
//    CGSize sz = [@"点击进入即同意隐私条款&用户协议" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGSize sz = [@"点击进入即同意用户协议" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    
    user_private_btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - sz.width) / 2 /*+ TICK_BTN_2_PRIVACY_MARGIN*/, SCREEN_HEIGHT - PRIVACY_BOTTOM_MARGIN, sz.width, sz.height)];
    user_private_btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [user_private_btn setTitleColor:[UIColor colorWithWhite:0.6078 alpha:1.f] forState:UIControlStateNormal];
//    [user_private_btn setTitle:@"点击进入即同意隐私条款&用户协议" forState:UIControlStateNormal];
    [user_private_btn setTitle:@"点击进入即同意用户协议" forState:UIControlStateNormal];
    [user_private_btn addTarget:self action:@selector(userPrivacyBtnSelected) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:user_private_btn];
    /***********************************************************************************************************************/
    
    /***********************************************************************************************************************/
    // fake bar
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define FAKE_BAR_HEIGHT         44
#define STATUS_BAR_HEIGHT       20
    
#define BACK_BTN_LEFT_MARGIN    16 + 10
//    _fakeBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 74)];
//    _fakeBar.backgroundColor = [UIColor whiteColor];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    NSString* filepath = [resourceBundle_dongda pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer_btn = [CALayer layer];
    layer_btn.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer_btn.frame = CGRectMake(0, 0, 25, 25);
//    layer_btn.position = CGPointMake(40 / 2, 40 / 2);
    [barBtn.layer addSublayer:layer_btn];
    barBtn.center = CGPointMake(BACK_BTN_LEFT_MARGIN + barBtn.frame.size.width / 2, STATUS_BAR_HEIGHT + FAKE_BAR_HEIGHT / 2);
    [barBtn addTarget:self action:@selector(didPopViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"创建个人信息";
    label.font = [UIFont systemFontOfSize:18.f];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    /***********************************************************************************************************************/
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];

    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    
    /**
     * input method
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userProfileUpdated:) name:kDongDaNotificationkeyUserprofileUpdate object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDongDaNotificationkeyUserprofileUpdate object:nil];
}

- (void)didPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (![[_login_attr objectForKey:@"screen_photo"] isEqualToString:@""]) {
        [self asyncGetUserImage];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)asyncGetUserImage {
    
    UIImage* img = [TmpFileStorageModel enumImageWithName:[_login_attr objectForKey:@"screen_photo"] withDownLoadFinishBolck:^(BOOL success, UIImage* download_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [loginImgBtn setBackgroundImage:download_img forState:UIControlStateNormal];
                NSLog(@"change img success");
            });
        } else {
            NSLog(@"down load image %@ failed", [_login_attr objectForKey:@"screen_photo"]);
        }
    }];
    if (img) {
        [loginImgBtn setBackgroundImage:img forState:UIControlStateNormal];
    }
}

- (void)userPrivacyBtnSelected {
    [self performSegueWithIdentifier:@"UserPrivacy" sender:nil];
}

- (void)didTickPrivacy {
    tick_btn.selected = !tick_btn.selected;
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    [inputView endInputName];
}

- (IBAction)didConfirm {

    NSString* screen_photo = [_login_attr objectForKey:@"screen_photo"];
    if (!screen_photo || [screen_photo isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"您的用户头像没有输入，请选择" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        return;
    }
    
    if (inputView.screen_name.length == 0 || inputView.role_tag.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"您的名称或者角色没有输入，请输入" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        return;
    }
    
    NSString* auth_token = [_login_attr objectForKey:@"auth_token"];
    NSString* user_id = [_login_attr objectForKey:@"user_id"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:inputView.screen_name forKey:@"screen_name"];
    [dic setValue:inputView.role_tag forKey:@"role_tag"];

    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    
    [dic setValue:[NSNumber numberWithInteger:self.gender] forKey:@"gender"];
    
    [dic setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    [dic setValue:[NSNumber numberWithInt:1] forKey:@"refresh_token"];
    
    if ([[_login_attr allKeys] containsObject:@"phoneNo"]) {
        [dic setValue:[_login_attr objectForKey:@"phoneNo"] forKey:@"phoneNo"];
        [dic setValue:[NSNumber numberWithInt:1] forKey:@"create"];
    }
    
    if (isChangeImg) {
        [dic setValue:screen_photo forKey:@"screen_photo"];
        
        dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
        dispatch_async(post_queue, ^(void){
            UIImage* img = [TmpFileStorageModel enumImageWithName:screen_photo withDownLoadFinishBolck:nil];
            [RemoteInstance uploadPicture:img withName:screen_photo toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_UPLOAD]] callBack:^(BOOL successs, NSString *message) {
                if (successs) {
                    NSLog(@"post image success");
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    [alert show];
                }
             }];
        });
    }
   
    NSString* newID = nil;
    if ([_lm updateAndCreateUserProfile:[dic copy] andUserId:&newID]) {
//    if ([_lm sendScreenName:[inputView getInputName] forToken:auth_token andUserID:user_id]) {
        NSString* phoneNo = (NSString*)[_login_attr objectForKey:@"phoneNo"];
        [LoginToken unbindTokenInContext:_lm.doc.managedObjectContext WithPhoneNum:phoneNo];
        LoginToken* token = [LoginToken enumLoginUserInContext:_lm.doc.managedObjectContext withUserID:newID];
        [_lm setCurrentUser:token];
        [_lm.doc.managedObjectContext save:nil];        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDongDaNotificationkeyLoginSuccess object:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"set nick name error" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)didSelectAddPicBtn {
    NSLog(@"Get Fucking IMG");
}

#pragma mark -- NickNameInputView Delegate
- (void)didEditRoleTag {
    NSLog(@"Start input tags");
    [inputView endInputName];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SearchViewController" bundle:nil];
    SearchViewController* svc = [storyboard instantiateViewControllerWithIdentifier:@"Search"];
    SearchRoleTagDelegate* sd = [[SearchRoleTagDelegate alloc] init];
    sd.delegate = svc;
    sd.actions = self;
    svc.isShowsSearchIcon = NO;
    [self.navigationController pushViewController:svc animated:YES];
    svc.delegate = sd;   
}

- (void)didClickNextBtn {
    [self didConfirm];
}

- (NSString *)getPreScreenName {
//    NSString* name = [_login_attr objectForKey:@"name"];
//    NSString* screen_name = [_login_attr objectForKey:@"screen_name"];
//    
//    if (!name || [name isEqualToString:@""])
//        return screen_name;
//    else return name;
    return [_login_attr objectForKey:@"screen_name"];
}

- (NSString *)getPreRoleTag {
    return [_login_attr objectForKey:@"role_tag"];
}

- (void)didSelectGenderBtn:(UIButton*)sender {
    if (sender.tag == -99) {
        self.gender = DongDaGenderFather;
    } else if (sender.tag == -98) {
        self.gender = DongDaGenderMother;
    }
}

#pragma mark -- Search tags delegate
- (void)moveView:(float)move {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGRect rc_start = self.view.frame;
    CGRect rc_end = CGRectMake(rc_start.origin.x, rc_start.origin.y + move, self.view.frame.size.width, self.view.frame.size.height);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      self.view.frame = INTUInterpolateCGRect(rc_start, rc_end, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                      inputView.isMoved = !inputView.isMoved;
                                  }];
}

#pragma mark -- change user img
- (void)didSelectImgBtn {
    [SGActionView showSheetWithTitle:@"" itemTitles:@[@"打开照相机", @"从相册中选择", @"取消"] selectedIndex:-1 selectedHandle:^(NSInteger index) {
        switch (index) {
            case 0:
                [self openAppCamera];
                break;
            case 1:
                [self openCameraRoll];
                break;
            default:
                break;
        }
    }];
}

- (void)openCameraRoll {
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:nil];
//    [self presentModalViewController:pickerImage animated:YES];
}

- (void)openAppCamera {
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
    //        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    }
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
//    [self presentModalViewController:picker animated:YES];//进入照相界面
}

#pragma mark -- UIImagePickerControllerDelegate
/**
 * TODO: change at last
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    isChangeImg = YES;
    NSString* img_name = [TmpFileStorageModel generateFileName];
    [TmpFileStorageModel saveToTmpDirWithImage:image withName:img_name];
    [_login_attr setValue:img_name forKey:@"screen_photo"];
    [loginImgBtn setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark -- controler protocol
- (void)didSelectItem:(NSString*)item {
    inputView.role_tag = item;
    [self.navigationController popToViewController:self animated:YES];
}

- (void)addNewItem:(NSString*)item {
    dispatch_queue_t aq = dispatch_queue_create("add tag", nil);
    dispatch_async(aq, ^{
        
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:app.lm.current_user_id forKey:@"user_id"];
        [dic setValue:app.lm.current_auth_token forKey:@"auth_token"];
        [dic setValue:item forKey:@"tag_name"];
        
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:ROLETAGS_ADD_ROLETAGE]];
        
        if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
            NSString* msg = [result objectForKeyedSubscript:@"result"];
            NSLog(@"query role tags : %@", msg);
            
        } else {
            NSDictionary* reError = [result objectForKey:@"error"];
            NSString* msg = [reError objectForKey:@"message"];
            
            NSLog(@"query role tags error : %@", msg);
        }
    });
    
    inputView.role_tag = item;
    [self.navigationController popToViewController:self animated:YES];
}

- (NSString*)getControllerTitle {
    return @"添加角色";
}

- (NSString *)getPlaceHolder {
    return @"说说你是谁";
}

- (UINavigationController*)getViewController {
    return self.navigationController;
}

#pragma mark -- get input view height
- (void)keyboardDidShow:(NSNotification*)notification {
    UIView *result = nil;
    NSArray *windowsArray = [UIApplication sharedApplication].windows;
    for (UIView *tmpWindow in windowsArray) {
        NSArray *viewArray = [tmpWindow subviews];
        for (UIView *tmpView  in viewArray) {
            NSLog(@"%@", [NSString stringWithUTF8String:object_getClassName(tmpView)]);
            // if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIPeripheralHostView"]) {
            if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIInputSetContainerView"]) {
                result = tmpView;
                break;
            }
        }
        
        if (result != nil) {
            break;
        }
    }
    
    //    keyboardView = result;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
   
    CGFloat height = [UIScreen mainScreen].bounds.size.height - (inputView.frame.size.height + inputView.frame.origin.y);
    if (!inputView.isMoved) {
        [self moveView:-height];
    }
}

- (void)keyboardWasChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
}

- (void)keyboardDidHidden:(NSNotification*)notification {
    CGFloat height = [UIScreen mainScreen].bounds.size.height - (inputView.frame.size.height + inputView.frame.origin.y);
    if (inputView.isMoved) {
        [self moveView:height];
    }
}

- (void)userProfileUpdated:(NSNotification*)notification {
    NSDictionary* reVal = [notification userInfo];
    NSLog(@"info : %@", reVal);
    
    
}
@end
