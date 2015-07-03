//
//  ViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 16/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "ViewController.h"
#import "LoginModel.h"

#import "LoginViewController.h"
#import "TabBarController.h"

#import "AppDelegate.h"
#import "INTUAnimationEngine.h"
#import "RegTmpToken+ContextOpt.h"
#import "NicknameInputViewController.h"
#import "AlreadLogedViewController.h"

#define TITLELABEL                          0
#define SGLABEL                             1

#define AREACODE                            2
#define PHONEAREA                           3
#define CONFIRMBTN                          4
#define CONFIRMAREA                         5
#define REGISTER                            6

#define LOGIN_AREACODE                      7
#define LOGIN_PHONEAREA                     8
#define LOGIN_PASSWORD                      9
#define LOGIN_FORGET                        10

#define LOGIN_ENTER                         11
#define LOGIN_WEIBO                         12
#define LOGIN_WECHAT                        13
#define LOGIN_QQ                            14

#define POINT_SIZE                          15

@interface ViewController ()

@property (nonatomic, weak) LoginModel* lm;
@property (nonatomic, weak) UIViewController* loginController;
@property (nonatomic, weak) UIViewController* contentController;
@property (nonatomic, weak) UIViewController* secretController;

enum DisplaySide {
    shareSide,
    secretSide,
};

@property (nonatomic) enum DisplaySide currentDispley;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *termsButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneArea;
@property (weak, nonatomic) IBOutlet UITextField *confirmArea;

// Stores the Animation ID for the currently running animation, or NSNotFound if no animation is currently running.
#pragma mark -- animation properties
@property (weak, nonatomic) IBOutlet UIButton *confirmCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sgLabel;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

#pragma mark -- login properties
@property (weak, nonatomic) IBOutlet UIButton *loginAreaBtn;
@property (weak, nonatomic) IBOutlet UITextField *loginPhoneArea;
@property (weak, nonatomic) IBOutlet UITextField *loginPwdArea;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;

@property (weak, nonatomic) IBOutlet UIButton *weiboLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqLoginBtn;
@end

@implementation ViewController {
    CGPoint points[POINT_SIZE];      // for animation
    CGPoint point;                   // for gesture
    
    BOOL isMoved;

    NSDictionary* result;
    
    CGFloat h_offset;
    CGFloat v_offset_title;
    CGFloat v_offset_input;
    
    BOOL isHerMoved;
}

@synthesize lm = _lm;
@synthesize loginController = _loginController;
@synthesize contentController = _contentController;
@synthesize secretController = _secretController;
@synthesize currentDispley = _currentDispley;

@synthesize loginButton = _loginButton;
@synthesize termsButton = _termsButton;
@synthesize phoneArea = _phoneArea;
@synthesize confirmArea = _confirmArea;

#pragma mark -- animation properties
@synthesize titleLabel = _titleLabel;
@synthesize sgLabel = _sgLabel;
@synthesize areaBtn = _areaBtn;
@synthesize confirmCodeBtn = _confirmCodeBtn;
@synthesize nextBtn = _nextBtn;

#pragma mark -- login properties
@synthesize loginAreaBtn = _loginAreaBtn;
@synthesize loginPhoneArea = _loginPhoneArea;
@synthesize loginPwdArea = _loginPwdArea;
@synthesize forgetBtn = _forgetBtn;
@synthesize enterBtn = _enterBtn;

@synthesize weiboLoginBtn = _weiboLoginBtn;
@synthesize wechatLoginBtn = _wechatLoginBtn;
@synthesize qqLoginBtn = _qqLoginBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.lm = [[LoginModel alloc]init];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    AppDelegate * del =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    _lm = del.lm;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogedIn:) name:@"login success" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appIsReady:) name:@"app ready" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDataIsReady:) name:@"query data ready" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryGroupIsReady:) name:@"group data ready" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogedOut:) name:@"current user sign out" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changingSide:) name:@"changing side" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:_phoneArea];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmCodeTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:_confirmArea];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginPhoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:_loginPhoneArea];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginPwdTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:_loginPwdArea];
   
    _phoneArea.keyboardType = UIKeyboardTypePhonePad;
    _confirmArea.keyboardType = UIKeyboardTypePhonePad;
    _loginPhoneArea.keyboardType = UIKeyboardTypePhonePad;
    _loginPwdArea.secureTextEntry = YES;
    _loginPwdArea.keyboardType = UIKeyboardTypeWebSearch;

    _phoneArea.delegate = self;
    _confirmArea.delegate = self;
    _loginPhoneArea.delegate = self;
    _loginPwdArea.delegate = self;
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
    
    memset(points, 0, sizeof(CGPoint) * POINT_SIZE);
    
    _termsButton.enabled = NO;
    _loginButton.enabled = NO;
    [self initialSubViewsProperties];
}

- (void)initialSubViewsProperties {
    _confirmCodeBtn.hidden = YES;
    _nextBtn.hidden = YES;
    
    _enterBtn.hidden = YES;
    
    isMoved = NO;
    isHerMoved = NO;
    
    _phoneArea.text = @"";
    _confirmArea.text = @"";
    _loginPhoneArea.text = @"";
    _loginPwdArea.text = @"";
    
    _wechatLoginBtn.hidden = NO;
    _weiboLoginBtn.hidden = NO;
    _qqLoginBtn.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initialSubViewsProperties];
}

- (void)viewDidLayoutSubviews {

    // animation properties
    int tmp_height = 30 + [UIScreen mainScreen].applicationFrame.origin.y;
    v_offset_title = _titleLabel.center.y - tmp_height;
    tmp_height += 60 + 8 + _sgLabel.frame.size.height;
    v_offset_input = _areaBtn.center.y - tmp_height;
    
    h_offset = [UIScreen mainScreen].applicationFrame.size.width;
    
    points[TITLELABEL] = CGPointMake(_titleLabel.center.x, _titleLabel.center.y - (isMoved ? v_offset_title : 0));
    points[SGLABEL] = CGPointMake(_sgLabel.center.x, _sgLabel.center.y - (isMoved ? v_offset_title : 0));
    
    //    points[AREACODE] = CGPointMake(_areaBtn.center.x , _areaBtn.center.y - (isMoved ? v_offset_input: 0));
    points[AREACODE] = CGPointMake(_areaBtn.center.x - (isHerMoved ? h_offset : 0), _areaBtn.center.y - (isMoved ? v_offset_input: 0));
    
    points[LOGIN_AREACODE] = CGPointMake(points[AREACODE].x + h_offset, points[AREACODE].y);
    
    //    points[PHONEAREA] = CGPointMake(_phoneArea.center.x , _phoneArea.center.y - (isMoved ? v_offset_input: 0));
    points[PHONEAREA] = CGPointMake(_phoneArea.center.x - (isHerMoved ? h_offset : 0), _phoneArea.center.y - (isMoved ? v_offset_input: 0));
    
    points[LOGIN_PHONEAREA] = CGPointMake(points[PHONEAREA].x + h_offset, points[PHONEAREA].y);
    
    //    points[CONFIRMBTN] = CGPointMake(_confirmCodeBtn.center.x , _confirmCodeBtn.center.y - (isMoved ? v_offset_input: 0));
    points[CONFIRMBTN] = CGPointMake(_confirmCodeBtn.center.x - (isHerMoved ? h_offset : 0), _confirmCodeBtn.center.y - (isMoved ? v_offset_input: 0));
    //    points[CONFIRMAREA] = CGPointMake(_confirmArea.center.x , _confirmArea.center.y - (isMoved ? v_offset_input: 0));
    points[CONFIRMAREA] = CGPointMake(_confirmArea.center.x - (isHerMoved ? h_offset : 0), _confirmArea.center.y - (isMoved ? v_offset_input: 0));
    
    points[LOGIN_PASSWORD] = CGPointMake(points[CONFIRMAREA].x + h_offset, points[CONFIRMAREA].y);
    
    //    points[REGISTER] = CGPointMake(_nextBtn.center.x , _nextBtn.center.y - (isMoved ? v_offset_input: 0));
    points[REGISTER] = CGPointMake(_nextBtn.center.x - (isHerMoved ? h_offset : 0), _nextBtn.center.y - (isMoved ? v_offset_input: 0));
    
    points[LOGIN_FORGET] = CGPointMake(points[REGISTER].x + h_offset, points[REGISTER].y);
    
    points[LOGIN_ENTER] = CGPointMake(points[CONFIRMAREA].x + h_offset, points[CONFIRMAREA].y + 60);
    
    points[LOGIN_WEIBO] = CGPointMake(points[LOGIN_ENTER].x, points[LOGIN_ENTER].y);
    points[LOGIN_WECHAT] = CGPointMake(points[LOGIN_WEIBO].x - 60 - 8, points[LOGIN_WEIBO].y);
    points[LOGIN_QQ] = CGPointMake(points[LOGIN_WEIBO].x + 60 + 8, points[LOGIN_WEIBO].y);
    
    [self reLayoutSubviews];
}

- (void)reLayoutSubviews {
    _titleLabel.center = points[TITLELABEL];
    _sgLabel.center = points[SGLABEL];
    
    _areaBtn.center = points[AREACODE];
    _phoneArea.center = points[PHONEAREA];
    _confirmCodeBtn.center = points[CONFIRMBTN];
    _confirmArea.center = points[CONFIRMAREA];
    _nextBtn.center = points[REGISTER];
    
    _loginAreaBtn.center = points[LOGIN_AREACODE];
    _loginPhoneArea.center = points[LOGIN_PHONEAREA];
    _loginPwdArea.center = points[LOGIN_PASSWORD];
    _forgetBtn.center = points[LOGIN_FORGET];
    
    _enterBtn.center = points[LOGIN_ENTER];
    _weiboLoginBtn.center = points[LOGIN_WEIBO];
    _wechatLoginBtn.center = points[LOGIN_WECHAT];
    _qqLoginBtn.center = points[LOGIN_QQ];
}

- (void)animaitonCompleted {
    // animation properties
    int tmp_height = 30 + [UIScreen mainScreen].applicationFrame.origin.y;
    v_offset_title = _titleLabel.center.y - tmp_height;
    tmp_height += 60 + 8 + _sgLabel.frame.size.height;
    v_offset_input = _areaBtn.center.y - tmp_height;
    
    h_offset = [UIScreen mainScreen].applicationFrame.size.width;
    
    points[TITLELABEL] = CGPointMake(_titleLabel.center.x, _titleLabel.center.y - (isMoved ? v_offset_title : 0));
    points[SGLABEL] = CGPointMake(_sgLabel.center.x, _sgLabel.center.y - (isMoved ? v_offset_title : 0));
    
    points[AREACODE] = CGPointMake(_areaBtn.center.x , _areaBtn.center.y - (isMoved ? v_offset_input: 0));
//    points[AREACODE] = CGPointMake(_areaBtn.center.x - (isHerMoved ? h_offset : 0), _areaBtn.center.y - (isMoved ? v_offset_input: 0));
    
    points[LOGIN_AREACODE] = CGPointMake(points[AREACODE].x + h_offset, points[AREACODE].y);
    
    points[PHONEAREA] = CGPointMake(_phoneArea.center.x , _phoneArea.center.y - (isMoved ? v_offset_input: 0));
//    points[PHONEAREA] = CGPointMake(_phoneArea.center.x - (isHerMoved ? h_offset : 0), _phoneArea.center.y - (isMoved ? v_offset_input: 0));
    
    points[LOGIN_PHONEAREA] = CGPointMake(points[PHONEAREA].x + h_offset, points[PHONEAREA].y);
    
    points[CONFIRMBTN] = CGPointMake(_confirmCodeBtn.center.x , _confirmCodeBtn.center.y - (isMoved ? v_offset_input: 0));
//    points[CONFIRMBTN] = CGPointMake(_confirmCodeBtn.center.x - (isHerMoved ? h_offset : 0), _confirmCodeBtn.center.y - (isMoved ? v_offset_input: 0));
    points[CONFIRMAREA] = CGPointMake(_confirmArea.center.x , _confirmArea.center.y - (isMoved ? v_offset_input: 0));
//    points[CONFIRMAREA] = CGPointMake(_confirmArea.center.x - (isHerMoved ? h_offset : 0), _confirmArea.center.y - (isMoved ? v_offset_input: 0));
    
    points[LOGIN_PASSWORD] = CGPointMake(points[CONFIRMAREA].x + h_offset, points[CONFIRMAREA].y);
    
    points[REGISTER] = CGPointMake(_nextBtn.center.x , _nextBtn.center.y - (isMoved ? v_offset_input: 0));
//    points[REGISTER] = CGPointMake(_nextBtn.center.x - (isHerMoved ? h_offset : 0), _nextBtn.center.y - (isMoved ? v_offset_input: 0));
    
    points[LOGIN_FORGET] = CGPointMake(points[REGISTER].x + h_offset, points[REGISTER].y);
    
    points[LOGIN_ENTER] = CGPointMake(points[CONFIRMAREA].x + h_offset, points[CONFIRMAREA].y + 60);

    points[LOGIN_WEIBO] = CGPointMake(points[LOGIN_ENTER].x, points[LOGIN_ENTER].y);
    points[LOGIN_WECHAT] = CGPointMake(points[LOGIN_WEIBO].x - 60 - 8, points[LOGIN_WEIBO].y);
    points[LOGIN_QQ] = CGPointMake(points[LOGIN_WEIBO].x + 60 + 8, points[LOGIN_WEIBO].y);
    
    [self reLayoutSubviews];
}

- (void)startAnimation:(BOOL)bReverse
{
    static const CGFloat kAnimationDuration = 0.8; // in seconds
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                                          delay:0.0
                                                         easing:INTUEaseInOutQuadratic
                                                        options:INTUAnimationOptionNone
                                                     animations:^(CGFloat progress) {
                                                         if (!isMoved) {
                                                             self.titleLabel.center = INTUInterpolateCGPoint(points[TITLELABEL], CGPointMake(points[TITLELABEL].x, points[TITLELABEL].y - v_offset_title), progress);
                                                             self.sgLabel.center = INTUInterpolateCGPoint(points[SGLABEL], CGPointMake(points[SGLABEL].x, points[SGLABEL].y - v_offset_title), progress);
                                                             
                                                             self.areaBtn.center = INTUInterpolateCGPoint(points[AREACODE], CGPointMake(points[AREACODE].x, points[AREACODE].y - v_offset_input), progress);
                                                             self.phoneArea.center = INTUInterpolateCGPoint(points[PHONEAREA], CGPointMake(points[PHONEAREA].x, points[PHONEAREA].y - v_offset_input), progress);
                                                             self.confirmCodeBtn.center = INTUInterpolateCGPoint(points[CONFIRMBTN], CGPointMake(points[CONFIRMBTN].x, points[CONFIRMBTN].y - v_offset_input), progress);
                                                             self.confirmArea.center = INTUInterpolateCGPoint(points[CONFIRMAREA], CGPointMake(points[CONFIRMAREA].x, points[CONFIRMAREA].y - v_offset_input), progress);
                                                             self.nextBtn.center = INTUInterpolateCGPoint(points[REGISTER], CGPointMake(points[REGISTER].x, points[REGISTER].y - v_offset_input), progress);
                                                             
                                                             self.loginAreaBtn.center = INTUInterpolateCGPoint(points[LOGIN_AREACODE], CGPointMake(points[LOGIN_AREACODE].x, points[LOGIN_AREACODE].y - v_offset_input), progress);
                                                             self.loginPhoneArea.center = INTUInterpolateCGPoint(points[LOGIN_PHONEAREA], CGPointMake(points[LOGIN_PHONEAREA].x, points[LOGIN_PHONEAREA].y - v_offset_input), progress);
                                                             self.loginPwdArea.center = INTUInterpolateCGPoint(points[LOGIN_PASSWORD], CGPointMake(points[LOGIN_PASSWORD].x, points[LOGIN_PASSWORD].y - v_offset_input), progress);
                                                             self.forgetBtn.center = INTUInterpolateCGPoint(points[LOGIN_FORGET], CGPointMake(points[LOGIN_FORGET].x, points[LOGIN_FORGET].y - v_offset_input), progress);

                                                             self.enterBtn.center = INTUInterpolateCGPoint(points[LOGIN_ENTER], CGPointMake(points[LOGIN_ENTER].x, points[LOGIN_ENTER].y - v_offset_input), progress);
                                                             self.weiboLoginBtn.center = INTUInterpolateCGPoint(points[LOGIN_WEIBO], CGPointMake(points[LOGIN_WEIBO].x, points[LOGIN_WEIBO].y - v_offset_input), progress);
                                                             self.wechatLoginBtn.center = INTUInterpolateCGPoint(points[LOGIN_WECHAT], CGPointMake(points[LOGIN_WECHAT].x, points[LOGIN_WECHAT].y - v_offset_input), progress);
                                                             self.qqLoginBtn.center = INTUInterpolateCGPoint(points[LOGIN_QQ], CGPointMake(points[LOGIN_QQ].x, points[LOGIN_QQ].y - v_offset_input), progress);

                                                         } else {
                                                            
                                                             self.titleLabel.center = INTUInterpolateCGPoint(points[TITLELABEL], CGPointMake(points[TITLELABEL].x, points[TITLELABEL].y + v_offset_title), progress);
                                                             self.sgLabel.center = INTUInterpolateCGPoint(points[SGLABEL], CGPointMake(points[SGLABEL].x, points[SGLABEL].y + v_offset_title), progress);
                                                             
                                                             self.areaBtn.center = INTUInterpolateCGPoint(points[AREACODE], CGPointMake(points[AREACODE].x, points[AREACODE].y + v_offset_input), progress);
                                                             self.phoneArea.center = INTUInterpolateCGPoint(points[PHONEAREA], CGPointMake(points[PHONEAREA].x, points[PHONEAREA].y + v_offset_input), progress);
                                                             self.confirmCodeBtn.center = INTUInterpolateCGPoint(points[CONFIRMBTN], CGPointMake(points[CONFIRMBTN].x, points[CONFIRMBTN].y + v_offset_input), progress);
                                                             self.confirmArea.center = INTUInterpolateCGPoint(points[CONFIRMAREA], CGPointMake(points[CONFIRMAREA].x, points[CONFIRMAREA].y + v_offset_input), progress);
                                                             self.nextBtn.center = INTUInterpolateCGPoint(points[REGISTER], CGPointMake(points[REGISTER].x, points[REGISTER].y + v_offset_input), progress);
                                                             
                                                             self.loginAreaBtn.center = INTUInterpolateCGPoint(points[LOGIN_AREACODE], CGPointMake(points[LOGIN_AREACODE].x, points[LOGIN_AREACODE].y + v_offset_input), progress);
                                                             self.loginPhoneArea.center = INTUInterpolateCGPoint(points[LOGIN_PHONEAREA], CGPointMake(points[LOGIN_PHONEAREA].x, points[LOGIN_PHONEAREA].y + v_offset_input), progress);
                                                             self.loginPwdArea.center = INTUInterpolateCGPoint(points[LOGIN_PASSWORD], CGPointMake(points[LOGIN_PASSWORD].x, points[LOGIN_PASSWORD].y + v_offset_input), progress);
                                                             self.forgetBtn.center = INTUInterpolateCGPoint(points[LOGIN_FORGET], CGPointMake(points[LOGIN_FORGET].x, points[LOGIN_FORGET].y + v_offset_input), progress);

                                                             self.enterBtn.center = INTUInterpolateCGPoint(points[LOGIN_ENTER], CGPointMake(points[LOGIN_ENTER].x, points[LOGIN_ENTER].y + v_offset_input), progress);
                                                             self.weiboLoginBtn.center = INTUInterpolateCGPoint(points[LOGIN_WEIBO], CGPointMake(points[LOGIN_WEIBO].x, points[LOGIN_WEIBO].y + v_offset_input), progress);
                                                             self.wechatLoginBtn.center = INTUInterpolateCGPoint(points[LOGIN_WECHAT], CGPointMake(points[LOGIN_WECHAT].x, points[LOGIN_WECHAT].y + v_offset_input), progress);
                                                             self.qqLoginBtn.center = INTUInterpolateCGPoint(points[LOGIN_QQ], CGPointMake(points[LOGIN_QQ].x, points[LOGIN_QQ].y + v_offset_input), progress);
                                                         }
                                                         
//                                                         NSLog(@"Progress: %.2f", progress);
                                                     }
                                                     completion:^(BOOL finished) {
                                                         // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                                         NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
//                                                         self.animationID = NSNotFound;
                                                         isMoved = !isMoved;
//                                                         [self viewDidLayoutSubviews];
                                                         [self animaitonCompleted];
                                                     }];
}

- (void)startHerAnimation {
    static const CGFloat kAnimationDuration = 0.8; // in seconds
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      if (!isHerMoved) {
                                          self.areaBtn.center = INTUInterpolateCGPoint(points[AREACODE], CGPointMake(points[AREACODE].x - h_offset, points[AREACODE].y), progress);
                                          self.phoneArea.center = INTUInterpolateCGPoint(points[PHONEAREA], CGPointMake(points[PHONEAREA].x - h_offset, points[PHONEAREA].y), progress);
                                          self.confirmCodeBtn.center = INTUInterpolateCGPoint(points[CONFIRMBTN], CGPointMake(points[CONFIRMBTN].x - h_offset, points[CONFIRMBTN].y), progress);
                                          self.confirmArea.center = INTUInterpolateCGPoint(points[CONFIRMAREA], CGPointMake(points[CONFIRMAREA].x - h_offset, points[CONFIRMAREA].y), progress);
                                          self.nextBtn.center = INTUInterpolateCGPoint(points[REGISTER], CGPointMake(points[REGISTER].x - h_offset, points[REGISTER].y), progress);
                                          
                                          self.loginAreaBtn.center = INTUInterpolateCGPoint(points[LOGIN_AREACODE], CGPointMake(points[LOGIN_AREACODE].x - h_offset, points[LOGIN_AREACODE].y), progress);
                                          self.loginPhoneArea.center = INTUInterpolateCGPoint(points[LOGIN_PHONEAREA], CGPointMake(points[LOGIN_PHONEAREA].x - h_offset, points[LOGIN_PHONEAREA].y), progress);
                                          self.loginPwdArea.center = INTUInterpolateCGPoint(points[LOGIN_PASSWORD], CGPointMake(points[LOGIN_PASSWORD].x - h_offset, points[LOGIN_PASSWORD].y), progress);
                                          self.forgetBtn.center = INTUInterpolateCGPoint(points[LOGIN_FORGET], CGPointMake(points[LOGIN_FORGET].x - h_offset, points[LOGIN_FORGET].y), progress);

                                          self.enterBtn.center = INTUInterpolateCGPoint(points[LOGIN_ENTER], CGPointMake(points[LOGIN_ENTER].x - h_offset, points[LOGIN_ENTER].y), progress);
                                          self.weiboLoginBtn.center = INTUInterpolateCGPoint(points[LOGIN_WEIBO], CGPointMake(points[LOGIN_WEIBO].x - h_offset, points[LOGIN_WEIBO].y), progress);
                                          self.wechatLoginBtn.center = INTUInterpolateCGPoint(points[LOGIN_WECHAT], CGPointMake(points[LOGIN_WECHAT].x - h_offset, points[LOGIN_WECHAT].y), progress);
                                          self.qqLoginBtn.center = INTUInterpolateCGPoint(points[LOGIN_QQ], CGPointMake(points[LOGIN_QQ].x - h_offset, points[LOGIN_QQ].y), progress);
                                          
                                      } else {
                                          self.areaBtn.center = INTUInterpolateCGPoint(points[AREACODE], CGPointMake(points[AREACODE].x + h_offset, points[AREACODE].y), progress);
                                          self.phoneArea.center = INTUInterpolateCGPoint(points[PHONEAREA], CGPointMake(points[PHONEAREA].x + h_offset, points[PHONEAREA].y), progress);
                                          self.confirmCodeBtn.center = INTUInterpolateCGPoint(points[CONFIRMBTN], CGPointMake(points[CONFIRMBTN].x + h_offset, points[CONFIRMBTN].y), progress);
                                          self.confirmArea.center = INTUInterpolateCGPoint(points[CONFIRMAREA], CGPointMake(points[CONFIRMAREA].x + h_offset, points[CONFIRMAREA].y), progress);
                                          self.nextBtn.center = INTUInterpolateCGPoint(points[REGISTER], CGPointMake(points[REGISTER].x + h_offset, points[REGISTER].y), progress);
                                          
                                          self.loginAreaBtn.center = INTUInterpolateCGPoint(points[LOGIN_AREACODE], CGPointMake(points[LOGIN_AREACODE].x + h_offset, points[LOGIN_AREACODE].y), progress);
                                          self.loginPhoneArea.center = INTUInterpolateCGPoint(points[LOGIN_PHONEAREA], CGPointMake(points[LOGIN_PHONEAREA].x + h_offset, points[LOGIN_PHONEAREA].y), progress);
                                          self.loginPwdArea.center = INTUInterpolateCGPoint(points[LOGIN_PASSWORD], CGPointMake(points[LOGIN_PASSWORD].x + h_offset, points[LOGIN_PASSWORD].y), progress);
                                          self.forgetBtn.center = INTUInterpolateCGPoint(points[LOGIN_FORGET], CGPointMake(points[LOGIN_FORGET].x + h_offset, points[LOGIN_FORGET].y), progress);

                                          self.enterBtn.center = INTUInterpolateCGPoint(points[LOGIN_ENTER], CGPointMake(points[LOGIN_ENTER].x + h_offset, points[LOGIN_ENTER].y), progress);
                                          self.weiboLoginBtn.center = INTUInterpolateCGPoint(points[LOGIN_WEIBO], CGPointMake(points[LOGIN_WEIBO].x + h_offset, points[LOGIN_WEIBO].y), progress);
                                          self.wechatLoginBtn.center = INTUInterpolateCGPoint(points[LOGIN_WECHAT], CGPointMake(points[LOGIN_WECHAT].x + h_offset, points[LOGIN_WECHAT].y), progress);
                                          self.qqLoginBtn.center = INTUInterpolateCGPoint(points[LOGIN_QQ], CGPointMake(points[LOGIN_QQ].x + h_offset, points[LOGIN_QQ].y), progress);
                                      }
                                      
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      isHerMoved = !isHerMoved;
//                                      [self viewDidLayoutSubviews];
                                      [self animaitonCompleted];
                                      if (isHerMoved) {
                                          [_loginButton setTitle:@"注册" forState:UIControlStateNormal];
                                      } else {
                                          [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
                                      }
                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)didSelectEntry {
////    NSArray* arr = self.lm.enumAllAuthorisedUsers;
////    NSString* token = [_lm isLoginedByUser];
//
//    if ([_lm isLoginedByUser]) {
//        [self performSegueWithIdentifier:@"contentSegue" sender:nil];
//    } else {
//        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
//    }
//}

- (IBAction)didSelectLoginBtn:(id)sender {
//    if ([_lm isLoginedByUser]) {
//        [self performSegueWithIdentifier:@"contentSegue" sender:nil];
//    } else {
//        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
//    }
//    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    [self startHerAnimation];
}

- (BOOL)isValidPhoneNumber:(NSString*)phoneNo inArea:(NSString*)areaCode {
//    return phoneNo.length == 11;
    return YES;
}

- (IBAction)didConfirmCodeBtn {
    NSString* phoneNo = _phoneArea.text;
    
    if ([self isValidPhoneNumber:phoneNo inArea:@"+86"] && [self.lm sendLoginRequestToPhone:phoneNo]) {
        NSLog(@"Start counting down");
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"input wrong phone number" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)isValidPhoneCode:(NSString*)phoneCode {
    return phoneCode.length == 5;
}

- (IBAction)didSelectNextStep {
    NSString* code = _confirmArea.text;
    
    if (![self isValidPhoneCode:code]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"input wrong phone number" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    RegTmpToken* token = [RegTmpToken enumRegTokenINContext:self.lm.doc.managedObjectContext WithPhoneNo:_phoneArea.text];
    
    if (token == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"input wrong phone number" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    } else {
        NSDictionary* tmp =[[NSDictionary alloc]init];
        LoginModelConfirmResult reVal = [self.lm sendConfirrmCode:code ToPhone:_phoneArea.text withToken:token.reg_token toResult:&tmp];
        result = tmp;
        if (reVal == LoginModelResultSuccess) {
            [self performSegueWithIdentifier:@"loginSuccessSegue" sender:nil];
            NSLog(@"login success");
        } else if (reVal ==LoginModelResultOthersLogin) {
            [self performSegueWithIdentifier:@"alreadyLogSegue" sender:nil];
            NSLog(@"already login by others");
        }
    }
    
}

- (IBAction)didSelectEnterBtn {
    [_lm loginWithPhoneNo:_loginPhoneArea.text andPassword:_loginPwdArea.text];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        _loginController = [segue destinationViewController];
//        ((LoginViewController*)((UINavigationController*)[segue destinationViewController]).childViewControllers[0]).lm = self.lm;
    } else if ([segue.identifier isEqualToString:@"areaCode"]) {
        NSLog(@"area code controller");
        // set protocol and set comfired country code
    } else if ([segue.identifier isEqualToString:@"loginSuccessSegue"]) {
        ((NicknameInputViewController*)segue.destinationViewController).login_attr = result;
        ((NicknameInputViewController*)segue.destinationViewController).lm = _lm;
    } else if ([segue.identifier isEqualToString:@"alreadyLogSegue"]) {
        ((AlreadLogedViewController*)segue.destinationViewController).login_attr = result;
        ((AlreadLogedViewController*)segue.destinationViewController).lm = _lm;
    } else {
        _contentController = [segue destinationViewController];
        ((TabBarController*)[segue destinationViewController]).lm = self.lm;
        _loginController = nil;
        _currentDispley = shareSide;
    }
}

- (void)userLogedIn:(id)sender {
    NSLog(@"login success");
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app registerDeviceTokenWithCurrentUser];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
//    if (_loginController) {
//        [_loginController dismissViewControllerAnimated:YES completion:^(void){
            if ([_lm isLoginedByUser]) {
                AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                [delegate createQueryModel];
            }
//        }];
//    }
}

- (void)userLogedOut:(id)sender {
    NSLog(@"user login out");
    [_lm signOutCurrentUser];
    if (_contentController) {
        [_contentController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)appIsReady:(id)sender {
    NSLog(@"application is ready");
//    _entryButton.enabled = YES;
    _loginButton.enabled = YES;
    _termsButton.enabled = YES;
    
    if ([_lm isLoginedByUser]) {
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate createQueryModel];
        [delegate registerDeviceTokenWithCurrentUser];
    }
}

- (void)queryDataIsReady:(id)sender {
    NSLog(@"queryDataIsReady");
    NSLog(@"the login user is : %@", _lm.current_user_id);
    NSLog(@"the login user token is : %@", _lm.current_auth_token);
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate createGroupModel];
//    [self performSegueWithIdentifier:@"contentSegue" sender:nil];
}

- (void)queryGroupIsReady:(id)sender {
    NSLog(@"query group is ready");
    [self performSegueWithIdentifier:@"contentSegue" sender:nil];
}

- (void)changingSide:(NSNotification*)sender {
    NSLog(@"changing Side");
   
    if (_currentDispley == shareSide) {
        [((TabBarController*)_contentController) showSecretSideOnController:[sender.userInfo objectForKey:@"parent"]];
    }
}

- (void)loginPhoneTextFieldChanged:(id)sender {
    if ([_loginPhoneArea.text isEqualToString:@""]) {
        // show third party login and hide enter button
        _enterBtn.hidden = YES;
        _weiboLoginBtn.hidden = NO;
        _wechatLoginBtn.hidden = NO;
        _qqLoginBtn.hidden = NO;
    } else {
        // show enter button and hide third party login
        _enterBtn.hidden = NO;
        _weiboLoginBtn.hidden = YES;
        _wechatLoginBtn.hidden = YES;
        _qqLoginBtn.hidden = YES;
    }
}

- (void)loginPwdTextFieldChanged:(id)sender {
    // do nothing for now
}


- (void)phoneTextFieldChanged:(id)sender {
    if ([_phoneArea.text isEqualToString:@""]) {
        _confirmCodeBtn.hidden = YES;
    } else {
        _confirmCodeBtn.hidden = NO;
    }
}

- (void)confirmCodeTextFieldChanged:(id)sender {
    if ([_confirmArea.text isEqualToString:@""]) {
        _nextBtn.hidden = YES;
    } else {
        _nextBtn.hidden = NO;
    }
}

- (IBAction)didSelectAreaBtn:(id)sender {
    [self performSegueWithIdentifier:@"areaCode" sender:nil];
}

#pragma mark -- ui text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!isMoved) {
        [self startAnimation:NO];
        if (textField.tag==0) {
            [self moveView:-210];
        }
        if (textField.tag==1) {
            [self moveView:-600];
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    return NO;
}

- (void)moveView:(float)move
{
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGRect frame = self.view.frame;
//    CGRect frameNew = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + move);
    CGRect frameNew = CGRectMake(0, 0, frame.size.width, frame.size.height + move);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                                          delay:0.0
                                                         easing:INTUEaseInOutQuadratic
                                                        options:INTUAnimationOptionNone
                                                     animations:^(CGFloat progress) {
                                                         self.view.frame = INTUInterpolateCGRect(frame, frameNew, progress);
                                                         
                                                         // NSLog(@"Progress: %.2f", progress);
                                                     }
                                                     completion:^(BOOL finished) {
                                                         // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                                         NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
//                                                         self.animationID = NSNotFound;
                                                     }];
}

#pragma mark -- pan gusture
- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    NSLog(@"pan gesture");
    if (_phoneArea.isEditing == YES || _confirmArea.isEditing == YES || _loginPhoneArea.isEditing == YES || _loginPwdArea.isEditing == YES) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            point = [gesture translationInView:self.view];
            
        } else if (gesture.state == UIGestureRecognizerStateEnded) {
            if (isMoved) {
                CGPoint newPos = [gesture translationInView:self.view];
            
                if (newPos.y - point.y) {
                    NSLog(@"down gesture");
                    [_phoneArea resignFirstResponder];
                    [_confirmArea resignFirstResponder];
                    [_loginPhoneArea resignFirstResponder];
                    [_loginPwdArea resignFirstResponder];
                }
                [self moveView:210];
                [self startAnimation:YES];
            }
        }
    }
}

- (IBAction)didSelectWeiboLoginBtn {
    [_lm loginWithWeibo];
}
- (IBAction)didSelectWechatLoginBtn {
}
- (IBAction)didSelectQQLoginBtn {
}
@end
