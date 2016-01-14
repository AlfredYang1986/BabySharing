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

@interface AlreadLogedViewController ()
@property (strong, nonatomic) IBOutlet UIButton *loginImgBtn;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet OBShapedButton *currentTagLabel;
@property (strong, nonatomic) IBOutlet OBShapedButton *yesBtn;
@property (strong, nonatomic) IBOutlet OBShapedButton *noBtn;
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

#define SCREEN_PHOTO_TOP_MARGIN                 [UIScreen mainScreen].bounds.size.height / 6
#define SCREEN_PHOTO_WIDTH                      100
#define SCREEN_PHOTO_HEIGHT                     SCREEN_PHOTO_WIDTH

#define SCREEN_NAME_2_PHOTO_MARGIN              17

#define SCREEN_NAME_2_ROLE_TAG_MARGIN           10

#define IS_TAHT_YOU_LABEL_TO_CENTER_MARGIN      30
#define YES_BTN_TOP_MARGIN                      81
#define YES_BTN_2_NO_BTN_MARGIN                 34

#define YES_NO_BTN_TO_EDGE_MARGIN               95
#define YES_NO_BTN_HEIGHT                       32
#define YES_NO_BTN_WIDTH                        ([UIScreen mainScreen].bounds.size.width - 2 * YES_NO_BTN_TO_EDGE_MARGIN)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    /**
     * user screen photo
     */
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
   
    UIImage* img = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"User_Big"] ofType:@"png"]];
    _loginImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_loginImgBtn setBackgroundImage:img forState:UIControlStateNormal];
    _loginImgBtn.layer.cornerRadius = _loginImgBtn.frame.size.width / 2;
    _loginImgBtn.clipsToBounds = YES;
    _loginImgBtn.backgroundColor = [UIColor clearColor];
    _loginImgBtn.center = CGPointMake(width / 2, SCREEN_PHOTO_TOP_MARGIN + _loginImgBtn.frame.size.height / 2);
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
    _nickNameLabel.textColor = [UIColor whiteColor];
    _nickNameLabel.center = CGPointMake(width / 2, SCREEN_PHOTO_TOP_MARGIN + _loginImgBtn.frame.size.height + SCREEN_NAME_2_PHOTO_MARGIN + _nickNameLabel.frame.size.height / 2);
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
    qa.text = @"这是你吗?";
    qa.font = [UIFont boldSystemFontOfSize:20.f];
    [qa sizeToFit];
    qa.textColor = [UIColor whiteColor];
    qa.center = CGPointMake(width / 2, height / 2 + IS_TAHT_YOU_LABEL_TO_CENTER_MARGIN);
    [self.view addSubview:qa];
    [self.view bringSubviewToFront:qa];
    
    /**
     * border for yes btn and no btn
     */
    _yesBtn = [[OBShapedButton alloc]initWithFrame:CGRectMake(0, 0, YES_NO_BTN_WIDTH, YES_NO_BTN_HEIGHT)];
    [_yesBtn setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_yes_btn_bg" ofType:@"png"]] forState:UIControlStateNormal];
    [_yesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yesBtn setTitle:@"是, 进入咚哒" forState:UIControlStateNormal];
    _yesBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _yesBtn.center = CGPointMake(width / 2, height / 2 + qa.frame.size.height + YES_BTN_TOP_MARGIN + YES_NO_BTN_HEIGHT / 2);
    [self.view addSubview:_yesBtn];
    [self.view bringSubviewToFront:_yesBtn];
    [_yesBtn addTarget:self action:@selector(didSelectMeButton) forControlEvents:UIControlEventTouchUpInside];

    _noBtn = [[OBShapedButton alloc]initWithFrame:CGRectMake(0, 0, YES_NO_BTN_WIDTH, YES_NO_BTN_HEIGHT)];
    [_noBtn setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_no_btn_bg" ofType:@"png"]] forState:UIControlStateNormal];
    [_noBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_noBtn setTitle:@"否, 重新注册" forState:UIControlStateNormal];
    _noBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _noBtn.center = CGPointMake(width / 2, height / 2 + qa.frame.size.height + YES_BTN_TOP_MARGIN + YES_NO_BTN_HEIGHT + YES_BTN_2_NO_BTN_MARGIN + YES_NO_BTN_HEIGHT / 2);
    [self.view addSubview:_noBtn];
    [self.view bringSubviewToFront:_noBtn];
    [_noBtn addTarget:self action:@selector(didSelectCreateNewAccount) forControlEvents:UIControlEventTouchUpInside];
}

- (void)asyncGetUserImage {
    dispatch_queue_t queue = dispatch_queue_create("get user image", nil);
    dispatch_async(queue, ^{
        [TmpFileStorageModel enumImageWithName:[_login_attr objectForKey:@"screen_photo"] withDownLoadFinishBolck:^(BOOL success, UIImage* download_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_loginImgBtn setBackgroundImage:download_img forState:UIControlStateNormal];
                    NSLog(@"change img success");
                });
            } else {
                NSLog(@"down load image %@ failed", [_login_attr objectForKey:@"screen_photo"]);
            }
        }];
    
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_loginImgBtn setBackgroundImage:img forState:UIControlStateNormal];
//        });
    });
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
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
