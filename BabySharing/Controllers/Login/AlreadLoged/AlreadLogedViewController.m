//
//  AlreadLogedViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "AlreadLogedViewController.h"
#import "NicknameInputViewController.h"
#import "loginToken+ContextOpt.h"
#import "TmpFileStorageModel.h"
#import "OBShapedButton.h"
#import "SGActionView.h"

@interface AlreadLogedViewController ()
@property (strong, nonatomic) IBOutlet UIButton *loginImgBtn;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet OBShapedButton *currentTagLabel;
@property (strong, nonatomic) IBOutlet OBShapedButton *yesBtn;
//@property (strong, nonatomic) IBOutlet OBShapedButton *noBtn;
@property (strong, nonatomic) IBOutlet UIButton *noBtn;
@property (strong, nonatomic) UIView* fakeBar;
@end

@implementation AlreadLogedViewController {
    BOOL isSync;
}

@synthesize lm = _lm;
@synthesize login_attr = _login_attr;

@synthesize loginImgBtn = _loginImgBtn;
@synthesize nickNameLabel = _nickNameLabel;
@synthesize currentTagLabel = _currentTagLabel;
@synthesize yesBtn = _yesBtn;
@synthesize noBtn = _noBtn;

#define SCREEN_PHOTO_TOP_MARGIN                 [UIScreen mainScreen].bounds.size.height * (0.5 - 0.1844)
#define SCREEN_PHOTO_CENTER_MARGIN              -[UIScreen mainScreen].bounds.size.height * 0.1828 +12 + 10
#define SCREEN_PHOTO_WIDTH                      100
#define SCREEN_PHOTO_HEIGHT                     SCREEN_PHOTO_WIDTH

#define SCREEN_NAME_2_PHOTO_MARGIN              6 //22

#define SCREEN_NAME_2_ROLE_TAG_MARGIN           10

#define IS_TAHT_YOU_LABEL_TO_CENTER_MARGIN      20
#define IS_TAHT_YOU_LABEL_TO_IMG_MARGIN         -108
#define IS_TAHT_YOU_LABEL_TO_TOP_MARGIN         20
#define YES_BTN_TOP_MARGIN                      61 //81
#define YES_BTN_2_NO_BTN_MARGIN                 34

#define YES_NO_BTN_TO_EDGE_MARGIN               32.5
#define YES_NO_BTN_HEIGHT                       37
//#define YES_NO_BTN_WIDTH                        ([UIScreen mainScreen].bounds.size.width - 2 * YES_NO_BTN_TO_EDGE_MARGIN)
#define YES_NO_BTN_WIDTH                        ([UIScreen mainScreen].bounds.size.width * 0.584)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    /**
     * user screen photo
     */
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
   
    UIImage* img = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"]];
    _loginImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_PHOTO_WIDTH, SCREEN_PHOTO_HEIGHT)];
    [_loginImgBtn setBackgroundImage:img forState:UIControlStateNormal];
    _loginImgBtn.layer.cornerRadius = _loginImgBtn.frame.size.width / 2;
    _loginImgBtn.clipsToBounds = YES;
    _loginImgBtn.backgroundColor = [UIColor clearColor];
    _loginImgBtn.center = CGPointMake(width / 2, SCREEN_PHOTO_CENTER_MARGIN + height / 2);
    
    _loginImgBtn.layer.borderWidth = 3.f;
    _loginImgBtn.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.30].CGColor;
    // 添加动作选择头像
    [_loginImgBtn addTarget:self action:@selector(didSelectImgBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_loginImgBtn];
    [self.view bringSubviewToFront:_loginImgBtn];
   
    isSync = NO;
    [self asyncGetUserImage];
    
    /**
     * add under line for nick name label
     */
    NSString* name = [_login_attr objectForKey:@"screen_name"];
    if (!name || [name isEqualToString:@""]) {
        name = [_login_attr objectForKey:@"phoneNo"];
    }

    _nickNameLabel = [[UILabel alloc]init];
    _nickNameLabel.text = name;
    _nickNameLabel.font = [UIFont systemFontOfSize:14.f];
    [_nickNameLabel sizeToFit];
    _nickNameLabel.textColor = [UIColor colorWithWhite:0.5922 alpha:1.f];
//    _nickNameLabel.center = CGPointMake(width / 2, SCREEN_PHOTO_TOP_MARGIN + _loginImgBtn.frame.size.height + SCREEN_NAME_2_PHOTO_MARGIN + _nickNameLabel.frame.size.height / 2);
    _nickNameLabel.center = CGPointMake(width / 2, SCREEN_PHOTO_CENTER_MARGIN + height / 2 + SCREEN_NAME_2_PHOTO_MARGIN + _nickNameLabel.frame.size.height / 2);
    [self.view addSubview:_nickNameLabel];
    [self.view bringSubviewToFront:_nickNameLabel];
    
   
    /**
     * border for role tags
     */
    BOOL hasTag = YES;
    NSString* tag =[_login_attr objectForKey:@"role_tag"];
    if (!tag || [tag isEqualToString:@""]) {
        tag = @"添加角色标签";
//        hasTag = NO;
    }
   
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    _currentTagLabel = [[OBShapedButton alloc]init];
    [_currentTagLabel setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"home_role_tag" ofType:@"png"]] forState:UIControlStateNormal];
    _currentTagLabel.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_currentTagLabel setTitle:tag forState:UIControlStateNormal];
    [_currentTagLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_currentTagLabel sizeToFit];
    
    if (hasTag) {
        CGFloat offset_y = SCREEN_PHOTO_TOP_MARGIN + _loginImgBtn.frame.size.height + SCREEN_NAME_2_PHOTO_MARGIN + _nickNameLabel.frame.size.height / 2;
        _nickNameLabel.center = CGPointMake(width / 2 - _nickNameLabel.frame.size.width / 2 - SCREEN_NAME_2_ROLE_TAG_MARGIN, offset_y);
        _currentTagLabel.center = CGPointMake(width / 2 + _currentTagLabel.frame.size.width / 2 + SCREEN_NAME_2_ROLE_TAG_MARGIN, offset_y);
    }
    
    [self.view addSubview:_currentTagLabel];
    [self.view bringSubviewToFront:_currentTagLabel];
   
    /**
     * Is that you? label
     */
    UILabel* qa = [[UILabel alloc]init];
    qa.text = @"检测到该手机号已注册如下账号";
    qa.font = [UIFont systemFontOfSize:14.f];
    [qa sizeToFit];
    qa.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    qa.center = CGPointMake(width / 2, _loginImgBtn.center.y + IS_TAHT_YOU_LABEL_TO_IMG_MARGIN);
    [self.view addSubview:qa];
    [self.view bringSubviewToFront:qa];
    
    /**
     * border for yes btn and no btn
     */
    _yesBtn = [[OBShapedButton alloc]initWithFrame:CGRectMake(0, 0, YES_NO_BTN_WIDTH, YES_NO_BTN_HEIGHT)];
    [_yesBtn setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_yes_btn_bg" ofType:@"png"]] forState:UIControlStateNormal];
    [_yesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yesBtn setTitle:@"是我, 进入咚哒" forState:UIControlStateNormal];
    _yesBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _yesBtn.center = CGPointMake(width / 2, height / 2 + qa.frame.size.height + YES_BTN_TOP_MARGIN + YES_NO_BTN_HEIGHT / 2);
    [self.view addSubview:_yesBtn];
    [self.view bringSubviewToFront:_yesBtn];
    [_yesBtn addTarget:self action:@selector(didSelectMeButton) forControlEvents:UIControlEventTouchUpInside];

    _noBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, YES_NO_BTN_WIDTH, YES_NO_BTN_HEIGHT)];
//    [_noBtn setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_no_btn_bg" ofType:@"png"]] forState:UIControlStateNormal];
    [_noBtn setTitleColor:[UIColor colorWithWhite:0.2902 alpha:1.f] forState:UIControlStateNormal];
    [_noBtn setTitle:@"不是我, 重新注册" forState:UIControlStateNormal];
    _noBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _noBtn.center = CGPointMake(width / 2, height / 2 + qa.frame.size.height + YES_BTN_TOP_MARGIN + YES_NO_BTN_HEIGHT + YES_BTN_2_NO_BTN_MARGIN + YES_NO_BTN_HEIGHT / 2);
    [self.view addSubview:_noBtn];
    [self.view bringSubviewToFront:_noBtn];
    [_noBtn addTarget:self action:@selector(didSelectCreateNewAccount) forControlEvents:UIControlEventTouchUpInside];
    
    /***********************************************************************************************************************/
    // fake bar
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define FAKE_BAR_HEIGHT         44
#define STATUS_BAR_HEIGHT       20
    
#define BACK_BTN_LEFT_MARGIN    10 //16 + 10
    _fakeBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 74)];
    _fakeBar.backgroundColor = [UIColor clearColor];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    NSString* filepath = [resourceBundle_dongda pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer_btn = [CALayer layer];
    layer_btn.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer_btn.frame = CGRectMake(0, 0, 25, 25);
//    layer_btn.position = CGPointMake(40 / 2, 40 / 2);
    [barBtn.layer addSublayer:layer_btn];
    barBtn.center = CGPointMake(BACK_BTN_LEFT_MARGIN + barBtn.frame.size.width / 2, STATUS_BAR_HEIGHT + FAKE_BAR_HEIGHT / 2);
//    barBtn.center = CGPointMake(BACK_BTN_LEFT_MARGIN + barBtn.frame.size.width / 2, STATUS_BAR_HEIGHT + FAKE_BAR_HEIGHT / 2);
    
    [barBtn addTarget:self action:@selector(didPopViewController) forControlEvents:UIControlEventTouchDown];
    [_fakeBar addSubview:barBtn];
    [self.view addSubview:_fakeBar];
    [self.view bringSubviewToFront:_fakeBar];
    /***********************************************************************************************************************/

    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
}

- (void)asyncGetUserImage {
    UIImage* img = [TmpFileStorageModel enumImageWithName:[_login_attr objectForKey:@"screen_photo"] withDownLoadFinishBolck:^(BOOL success, UIImage* download_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_loginImgBtn setBackgroundImage:download_img forState:UIControlStateNormal];
                NSLog(@"change img success");
            });
        } else {
            NSLog(@"down load image %@ failed", [_login_attr objectForKey:@"screen_photo"]);
        }
    }];
    if (img) {
        [_loginImgBtn setBackgroundImage:img forState:UIControlStateNormal];
    }
}

- (void)didPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self asyncGetUserImage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
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



#pragma mark --
- (IBAction)didSelectMeButton {

    NSString* user_id = (NSString*)[_login_attr objectForKey:@"user_id"];
    NSString* phoneNo = (NSString*)[_login_attr objectForKey:@"phoneNo"];
    [LoginToken removeTokenInContext:_lm.doc.managedObjectContext WithPhoneNum:phoneNo];
    LoginToken* token = [LoginToken createTokenInContext:_lm.doc.managedObjectContext withUserID:user_id andAttrs:_login_attr];
    
    [_lm setCurrentUser:token];
    [_lm.doc.managedObjectContext save:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login success" object:nil];
//    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
//        NSLog(@"Login success");
//        [_lm reloadDataFromLocalDB];
//    }];
}

- (IBAction)didSelectCreateNewAccount {
    NSDictionary* tmp = [[NSDictionary alloc]init];
    if ([_lm sendCreateNewUserWithPhone:[_login_attr objectForKey:@"phoneNo"] toResult:&tmp]) {
        [self performSegueWithIdentifier:@"bindNewAccountSegue" sender:tmp];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"bindNewAccountSegue"]){
        ((NicknameInputViewController*)segue.destinationViewController).login_attr = (NSDictionary*)sender;
        ((NicknameInputViewController*)segue.destinationViewController).lm = _lm;
    }
}

@end
