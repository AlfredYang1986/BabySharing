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
//#import "SearchUserTagsController.h"
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

#define NEXT_BTN_MARGIN_BOTTOM  80

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

#define SCREEN_PHOTO_TOP_MARGIN                 SCREEN_HEIGHT / 7
#define SCREEN_PHOTO_WIDTH                      100
#define SCREEN_PHOTO_HEIGHT                     100

#define SCREEN_PHOTO_2_GENDER_BTN_MARGIN        30

#define GENDER_BTN_WIDTH                        38
#define GENDER_BTN_HEIGHT                       GENDER_BTN_WIDTH

#define FATHER_ICON_WIDTH                       11.5
#define FATHER_ICON_HEIGHT                      FATHER_ICON_WIDTH

#define GENDER_BTN_BETWEEN_MARGIN               SCREEN_WIDTH / 4

#define INPUT_VIEW_2_SCREEN_PHOTO_MARGIN        SCREEN_HEIGHT / 5

#define TICK_BTN_WIDTH                          17
#define TICK_BTN_HEIGHT                         TICK_BTN_WIDTH

#define TICK_BTN_2_PRIVACY_MARGIN               10

@interface NicknameInputViewController () </*SearchUserTagControllerDelegate,*/ NickNameInputViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SearchActionsProtocol>
@property (strong, nonatomic) IBOutlet UIButton *loginImgBtn;
//@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation NicknameInputViewController {
    NickNameInputView* inputView;
    NSURL* user_img_url;
    
    UIView* mother_view;
    UIView* father_view;

    UIButton * user_private_btn;
    OBShapedButton* tick_btn;
}

@synthesize loginImgBtn = _loginImgBtn;
//@synthesize nextBtn = _nextBtn;

@synthesize lm = _lm;
@synthesize login_attr = _login_attr;
@synthesize isSNSLogIn = _isSNSLogIn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
   
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];

    /***********************************************************************************************************************/
    // Screen photo
    _loginImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_PHOTO_WIDTH, SCREEN_PHOTO_HEIGHT)];
    _loginImgBtn.layer.cornerRadius = SCREEN_PHOTO_HEIGHT / 2;
    _loginImgBtn.clipsToBounds = YES;
    _loginImgBtn.backgroundColor = [UIColor clearColor];
    _loginImgBtn.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_PHOTO_TOP_MARGIN + SCREEN_PHOTO_HEIGHT / 2);
    [self.view addSubview:_loginImgBtn];
    [self.view bringSubviewToFront:_loginImgBtn];
   
    if (_isSNSLogIn) {
        _loginImgBtn.hidden = YES;
    } else {
         _loginImgBtn.clipsToBounds = YES;
        
        UIImage* img = [UIImage imageNamed:[resourceBundle_dongda pathForResource:[NSString stringWithFormat:@"login_camera_btn"] ofType:@"png"]];
        [_loginImgBtn setBackgroundImage:img forState:UIControlStateNormal];
        [_loginImgBtn addTarget:self action:@selector(didSelectImgBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    /***********************************************************************************************************************/
    
    /***********************************************************************************************************************/
    // input view
    inputView = [[NickNameInputView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    inputView.delegate = self;
    inputView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_PHOTO_TOP_MARGIN + SCREEN_PHOTO_HEIGHT + INPUT_VIEW_2_SCREEN_PHOTO_MARGIN + inputView.frame.size.height / 2);
    
    [self.view addSubview:inputView];
    /***********************************************************************************************************************/
   
    /***********************************************************************************************************************/
    // mother view
    mother_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GENDER_BTN_WIDTH, 2 * GENDER_BTN_HEIGHT)];
    UIButton* mother_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, GENDER_BTN_WIDTH, GENDER_BTN_HEIGHT)];
    mother_btn.backgroundColor = [UIColor clearColor];
    [mother_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_mother" ofType:@"png"]] forState:UIControlStateNormal];
    [mother_btn addTarget:self action:@selector(didSelectGenderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mother_view addSubview:mother_btn];
    
    CALayer* mother_text_layer = [CALayer layer];
    mother_text_layer.frame = CGRectMake(0, GENDER_BTN_HEIGHT, GENDER_BTN_WIDTH, 30);
    
    CATextLayer* mother_text_line_one = [CATextLayer layer];
    mother_text_line_one.contentsScale = 2.f;
    mother_text_line_one.fontSize = 12.f;
    mother_text_line_one.string = @"妈咪";
    mother_text_line_one.frame = CGRectMake(0, 0, GENDER_BTN_WIDTH, 15);
    mother_text_line_one.alignmentMode = @"center";
    [mother_text_layer addSublayer:mother_text_line_one];
    
    CATextLayer* mother_text_line_two = [CATextLayer layer];
    mother_text_line_two.contentsScale = 2.f;
    mother_text_line_two.fontSize = 12.f;
    mother_text_line_two.string = @"要够辣";
    mother_text_line_two.frame = CGRectMake(0, 15, GENDER_BTN_WIDTH, 15);
    mother_text_line_two.alignmentMode = @"center";
    [mother_text_layer addSublayer:mother_text_line_two];
    
    [mother_view.layer addSublayer:mother_text_layer];
    mother_view.center = CGPointMake(SCREEN_WIDTH / 2 - GENDER_BTN_BETWEEN_MARGIN, SCREEN_PHOTO_TOP_MARGIN + SCREEN_PHOTO_HEIGHT + SCREEN_PHOTO_2_GENDER_BTN_MARGIN + GENDER_BTN_HEIGHT / 2);
    [self.view addSubview:mother_view];
    /***********************************************************************************************************************/
    
    /***********************************************************************************************************************/
    // father view
    father_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GENDER_BTN_WIDTH, 2 * GENDER_BTN_HEIGHT)];
    UIButton* father_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, GENDER_BTN_WIDTH, GENDER_BTN_HEIGHT)];
    father_btn.backgroundColor = [UIColor clearColor];
    CALayer* layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, FATHER_ICON_WIDTH, FATHER_ICON_HEIGHT);
    layer.contents = (id)[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_father" ofType:@"png"]].CGImage;
    layer.position = CGPointMake(GENDER_BTN_WIDTH / 2, GENDER_BTN_HEIGHT / 2);
    [father_btn.layer addSublayer:layer];
    [father_btn addTarget:self action:@selector(didSelectGenderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [father_view addSubview:father_btn];

    CALayer* father_text_layer = [CALayer layer];
    father_text_layer.frame = CGRectMake(0, GENDER_BTN_HEIGHT, GENDER_BTN_WIDTH, 30);
    
    CATextLayer* father_text_line_one = [CATextLayer layer];
    father_text_line_one.contentsScale = 2.f;
    father_text_line_one.fontSize = 12.f;
    father_text_line_one.string = @"爸比";
    father_text_line_one.frame = CGRectMake(0, 0, GENDER_BTN_WIDTH, 15);
    father_text_line_one.alignmentMode = @"center";
    [father_text_layer addSublayer:father_text_line_one];
    
    CATextLayer* father_text_line_two = [CATextLayer layer];
    father_text_line_two.contentsScale = 2.f;
    father_text_line_two.fontSize = 12.f;
    father_text_line_two.string = @"要靠谱";
    father_text_line_two.frame = CGRectMake(0, 15, GENDER_BTN_WIDTH, 15);
    father_text_line_two.alignmentMode = @"center";
    [father_text_layer addSublayer:father_text_line_two];
    
    [father_view.layer addSublayer:father_text_layer];
    father_view.center = CGPointMake(SCREEN_WIDTH / 2 + GENDER_BTN_BETWEEN_MARGIN, SCREEN_PHOTO_TOP_MARGIN + SCREEN_PHOTO_HEIGHT + SCREEN_PHOTO_2_GENDER_BTN_MARGIN + GENDER_BTN_HEIGHT / 2);
    [self.view addSubview:father_view];
    /***********************************************************************************************************************/
   
    /***********************************************************************************************************************/
    // private button
#define PRIVACY_BOTTOM_MARGIN               30
    UIFont* font = [UIFont systemFontOfSize:14.f];
    CGSize sz = [@"用户协议&隐私政策" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    
    user_private_btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - sz.width) / 2 + TICK_BTN_2_PRIVACY_MARGIN, SCREEN_HEIGHT - PRIVACY_BOTTOM_MARGIN, sz.width, sz.height)];
    user_private_btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [user_private_btn setTitleColor:[UIColor colorWithWhite:1.f alpha:0.6] forState:UIControlStateNormal];
    [user_private_btn setTitle:@"用户协议&隐私政策" forState:UIControlStateNormal];
    [user_private_btn addTarget:self action:@selector(userPrivacyBtnSelected) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:user_private_btn];
    /***********************************************************************************************************************/
    
    /***********************************************************************************************************************/
    // tick btn
    tick_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(0, 0, TICK_BTN_WIDTH, TICK_BTN_HEIGHT)];
    [tick_btn setImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_privacy_tick" ofType:@"png"]] forState:UIControlStateSelected];
    [tick_btn setImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_privacy_untick" ofType:@"png"]] forState:UIControlStateNormal];
    tick_btn.selected = YES;
    tick_btn.center = CGPointMake(user_private_btn.frame.origin.x - TICK_BTN_2_PRIVACY_MARGIN - TICK_BTN_WIDTH / 2, user_private_btn.center.y);
    [tick_btn addTarget:self action:@selector(didTickPrivacy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tick_btn];
    /***********************************************************************************************************************/
}

- (void)didPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

//- (void)viewDidLayoutSubviews {
//    /**
//     * layout subview then layout input view
//     */
//    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height / 2 + inputView.bounds.size.height / 2;
//    inputView.center = CGPointMake(width, height);
//}

- (void)userPrivacyBtnSelected {
    [self performSegueWithIdentifier:@"UserPrivacy" sender:nil];
}

- (void)didTickPrivacy {
    tick_btn.selected = !tick_btn.selected;
}

- (IBAction)didConfirm {

    NSString* auth_token = [_login_attr objectForKey:@"auth_token"];
    NSString* user_id = [_login_attr objectForKey:@"user_id"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    if (_isSNSLogIn) {
//        [dic setValue:[inputView getInputTags] forKey:@"role_tag"];
        [dic setValue:inputView.role_tag forKey:@"role_tag"];
    } else {
//        [dic setValue:[inputView getInputName] forKey:@"screen_name"];
//        [dic setValue:[inputView getInputTags] forKey:@"role_tag"];
        [dic setValue:inputView.screen_name forKey:@"screen_name"];
        [dic setValue:inputView.role_tag forKey:@"role_tag"];
    }

    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];

    
    if ([_lm updateUserProfile:[dic copy]]) {
//    if ([_lm sendScreenName:[inputView getInputName] forToken:auth_token andUserID:user_id]) {
        NSString* phoneNo = (NSString*)[_login_attr objectForKey:@"phoneNo"];
        [LoginToken unbindTokenInContext:_lm.doc.managedObjectContext WithPhoneNum:phoneNo];
        LoginToken* token = [LoginToken enumLoginUserInContext:_lm.doc.managedObjectContext withUserID:user_id];
        [_lm setCurrentUser:token];
        [_lm.doc.managedObjectContext save:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login success" object:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"set nick name error" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)didSelectAddPicBtn {
    NSLog(@"Get Fucking IMG");
}

#pragma mark -- NickNameInputView Delegate
- (void)didStartEditingScreenName {
    NSLog(@"start input name");
    [self moveView:-210];
}

- (void)didEndEditingScreenName {
    NSLog(@"End input name");
    [self moveView:210];
}

- (void)didEditRoleTag {
    NSLog(@"Start input tags");
    [inputView endInputName];
//    [self performSegueWithIdentifier:@"SeachRoleTags" sender:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SearchViewController" bundle:nil];
    SearchViewController* svc = [storyboard instantiateViewControllerWithIdentifier:@"Search"];
    SearchRoleTagDelegate* sd = [[SearchRoleTagDelegate alloc]init];
    sd.delegate = svc;
    sd.actions = self;
    [self.navigationController pushViewController:svc animated:YES];
    svc.delegate = sd;   
}

- (void)didClickNextBtn {
    
}

- (NSString*)getPreScreenName {
    return @"No Implementation";
}

- (NSString*)getPreRoleTag {
    return @"No Implementation";
}

- (void)didSelectGenderBtn:(UIButton*)sender {
    
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
    [self presentModalViewController:pickerImage animated:YES];
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
    [self presentModalViewController:picker animated:YES];//进入照相界面
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    dispatch_queue_t aq = dispatch_queue_create("weibo profile img queue", nil);
    dispatch_async(aq, ^{
        /**
         * 1. save the img to local
         */
        UIImage* img = image;
        if (img) {
            NSString* img_name = [TmpFileStorageModel generateFileName];
            [TmpFileStorageModel saveToTmpDirWithImage:img withName:img_name];
            
            /**
             * 2. change img_name in the server
             */
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:[_lm getCurrentAuthToken] forKey:@"auth_token"];
            [dic setValue:[_lm getCurrentUserID] forKey:@"user_id"];
            [dic setValue:img_name forKey:@"screen_photo"];
//            [lm updateUserProfile:[dic copy]];
            if ([_lm updateUserProfile:[dic copy]]) {
                /**
                 * 4. refresh UI
                 */
                dispatch_async(dispatch_get_main_queue(), ^(void){
//                    [_delegate personalDetailChanged:[dic copy]];
//                    [_queryView reloadData];
                    [_loginImgBtn setBackgroundImage:img forState:UIControlStateNormal];
                });
            }
           
            /**
             * 3. updata picture
             */
            dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
            dispatch_async(post_queue, ^(void){
                [RemoteInstance uploadPicture:img withName:img_name toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_UPLOAD]] callBack:^(BOOL successs, NSString *message) {
                    if (successs) {
                        NSLog(@"post image success");
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        [alert show];
                    }
                }];
            });
        }
    });
}

#pragma mark -- controler protocol
- (void)didSelectItem:(NSString*)item {
//    [inputView resetTags:item];
//    [self.navigationController popToViewController:self animated:YES];
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
    return @"添加你的角色";
}

- (UINavigationController*)getViewController {
    return self.navigationController;
}
@end
