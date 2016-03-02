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
#import "LoginInputView.h"
#import "LoginSNSView.h"
#import "ChooseAreaViewController.h"
#import "GotyeOCAPI.h"
#import "GotyeOCDeleget.h"
#import "RemoteInstance.h"

@interface ViewController () <LoginInputViewDelegate, AreaViewControllerDelegate, GotyeOCDelegate>

@property (nonatomic, weak) LoginModel* lm;
@property (nonatomic, weak) MessageModel* mm;
@property (nonatomic, weak) UIViewController* loginController;
@property (nonatomic, weak) TabBarController* contentController;
@property (nonatomic, weak) UIViewController* secretController;

enum DisplaySide {
    shareSide,
    secretSide,
};

@property (nonatomic) enum DisplaySide currentDispley;
@end

@implementation ViewController {
    CGPoint point;                   // for gesture
    
    BOOL isMoved;
    
    BOOL isHerMoved;
    
    NSTimer* timer;
    NSInteger seconds;
   
    UIImageView* title;                // title
    UILabel* slg;
    
    LoginInputView* inputView;
    LoginSNSView* snsView;
    BOOL isSNSLogin;
    
    BOOL isQueryModelReady;
    BOOL isMessageModelReady;
    
    INTUAnimationID moving_id;
}

@synthesize lm = _lm;
@synthesize loginController = _loginController;
@synthesize contentController = _contentController;
@synthesize secretController = _secretController;
@synthesize currentDispley = _currentDispley;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self classForCoder];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f]];
    
    AppDelegate * del =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    _lm = del.lm;
   
    [self createSubviews];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSLogedIn:) name:@"SNS login success" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogedIn:) name:@"login success" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appIsReady:) name:@"app ready" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDataIsReady:) name:@"query data ready" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageAndNotificationDataIsReady:) name:@"message data ready" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogedOut:) name:@"current user sign out" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changingSide:) name:@"changing side" object:nil];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    isSNSLogin = NO;

    [GotyeOCAPI addListener:self];
    
    isQueryModelReady = NO;
    isMessageModelReady = NO;
    
    moving_id = -1;

    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
}

#define LOGO_WIDTH     150
#define LOGO_HEIGHT     50
#define LOGO_TOP_MARGIN 97

#define INPUT_VIEW_TOP_MARGIN       ([UIScreen mainScreen].bounds.size.height / 6.0)
#define INPUT_VIEW_START_POINT      (title.frame.origin.y + title.frame.size.height + INPUT_VIEW_TOP_MARGIN)

- (void)createSubviews {

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
  
    /**
     * 2. logo view
     */
    title = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, LOGO_WIDTH, LOGO_HEIGHT)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    title.image = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"login_logo"] ofType:@"png"]];
    title.center = CGPointMake(width / 2, LOGO_TOP_MARGIN + title.frame.size.height / 2);
    
    [self.view addSubview:title];
    [self.view bringSubviewToFront:title];
    
    /**
     * 3. slogen view
     */
    slg = [[UILabel alloc]init];
    slg.textAlignment = NSTextAlignmentCenter;
    slg.textColor = [UIColor colorWithWhite:0.5922 alpha:1.f];
    slg.font = [UIFont systemFontOfSize:15.f];
    slg.text = @"品质妈咪的生活指南";
    [slg sizeToFit];
    slg.center = CGPointMake(title.center.x, title.center.y + 48);

    [self.view addSubview:slg];
    [self.view bringSubviewToFront:slg];
    
    /**
     * 1. input view
     */
    inputView = [[LoginInputView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    inputView.delegate = self;
    
    CGFloat last_height = inputView.bounds.size.height;
    inputView.frame = CGRectMake(0, INPUT_VIEW_START_POINT, width, last_height);
    [self.view addSubview:inputView];
    [self.view bringSubviewToFront:inputView];

    
    /**
     * 4. SNS view
     */
    snsView = [[LoginSNSView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    snsView.delegate = self;
    
    CGFloat sns_height = snsView.bounds.size.height;
    snsView.frame = CGRectMake(0, height - sns_height, width, sns_height);
//    snsView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:snsView];
    [self.view bringSubviewToFront:snsView];

}

- (void)dealloc {
    [GotyeOCAPI removeListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isValidPhoneNumber:(NSString*)phoneNo inArea:(NSString*)areaCode {
//    return phoneNo.length == 11;
    // 正则表达式
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3,4,5,7,8]\\d{9}$"] evaluateWithObject:phoneNo];
}

- (BOOL)isValidPhoneCode:(NSString*)phoneCode {
    return phoneCode.length == 5;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginSegue"]) {
        _loginController = [segue destinationViewController];
    } else if ([segue.identifier isEqualToString:@"areaCode"]) {
        NSLog(@"area code controller");
        ((ChooseAreaViewController*)segue.destinationViewController).delegate = self;
        // set protocol and set comfired country code
    } else if ([segue.identifier isEqualToString:@"UserPrivacy"]) {
        // do nothing ....
        
    } else if ([segue.identifier isEqualToString:@"loginSuccessSegue"]) {
        ((NicknameInputViewController*)segue.destinationViewController).login_attr = (NSDictionary*)sender;
        ((NicknameInputViewController*)segue.destinationViewController).lm = _lm;
        ((NicknameInputViewController*)segue.destinationViewController).isSNSLogIn = isSNSLogin;
    } else if ([segue.identifier isEqualToString:@"alreadyLogSegue"]) {
        ((AlreadLogedViewController*)segue.destinationViewController).login_attr = (NSDictionary*)sender;
        ((AlreadLogedViewController*)segue.destinationViewController).lm = _lm;
    } else {
        _contentController = [segue destinationViewController];
        ((TabBarController*)[segue destinationViewController]).lm = self.lm;
        ((TabBarController*)[segue destinationViewController]).mm = self.mm;
        _loginController = nil;
        _currentDispley = shareSide;
    }
}

- (void)SNSLogedIn:(id)sender {
    NSLog(@"SNS login success");
    if ([_lm isLoginedByUser]) {
        isSNSLogin = YES;
        [self performSegueWithIdentifier:@"loginSuccessSegue" sender:[_lm getCurrentUserAttr]];
    
    } else {
        // ERROR
        NSLog(@"something error with SNS login");
    }
}

- (void)userLogedIn:(id)sender {
    NSLog(@"login success");
    isSNSLogin = NO;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    if ([_lm isLoginedByUser]) {
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if (!isQueryModelReady) [delegate createQueryModel];
        else [self queryDataIsReady:nil];
        [delegate registerDeviceTokenWithCurrentUser];
    }
}

- (void)userLogedOut:(id)sender {
    NSLog(@"user login out");
    [_lm signOutCurrentUser];
    [GotyeOCAPI logout];
    if (_contentController) {
        [_contentController dismissViewControllerAnimated:YES completion:nil];
        _contentController = nil;
    }
}

- (void)appIsReady:(id)sender {
    NSLog(@"application is ready");
    
    if ([_lm isLoginedByUser]) {
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if (!isQueryModelReady) [delegate createQueryModel];
        else [self queryDataIsReady:nil];

        [delegate registerDeviceTokenWithCurrentUser];
        [_lm onlineCurrentUser];
//        [GotyeOCAPI login:_lm.current_user_id password:nil];
    }
}

- (void)queryDataIsReady:(id)sender {
    NSLog(@"queryDataIsReady");
    NSLog(@"the login user is : %@", _lm.current_user_id);
    NSLog(@"the login user token is : %@", _lm.current_auth_token);
   
    isQueryModelReady = YES;
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!isMessageModelReady) [delegate createMessageAndNotificationModel];
    else [self messageAndNotificationDataIsReady:nil];
}

- (void)messageAndNotificationDataIsReady:(id)sender {
    NSLog(@"message is ready");
    
    isMessageModelReady = YES;
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _mm = app.mm;
    
    if (inputView.frame.origin.y + inputView.frame.size.height != [UIScreen mainScreen].bounds.size.height) {
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        
        CGFloat last_height = inputView.bounds.size.height;
        inputView.frame = CGRectMake(0, INPUT_VIEW_START_POINT, inputView.bounds.size.width, last_height);
    }
 
    if (![GotyeOCAPI isOnline]) {
        [GotyeOCAPI login:_lm.current_user_id password:nil];
    } else if ([GotyeOCAPI getLoginUser].name != _lm.current_user_id) {
        [GotyeOCAPI login:_lm.current_user_id password:nil];
    }
}

- (void)changingSide:(NSNotification*)sender {
    NSLog(@"changing Side");
   
    if (_currentDispley == shareSide) {
        [((TabBarController*)_contentController) showSecretSideOnController:[sender.userInfo objectForKey:@"parent"]];
    }
}

- (void)moveView:(float)move {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGPoint p_start = inputView.center;
    CGPoint p_end = CGPointMake(p_start.x, p_start.y + move);
    moving_id = [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                                          delay:0.0
                                                         easing:INTUEaseInOutQuadratic
                                                        options:INTUAnimationOptionNone
                                                     animations:^(CGFloat progress) {
                                                         inputView.center = INTUInterpolateCGPoint(p_start, p_end, progress);
                                                     }
                                                     completion:^(BOOL finished) {
                                                         // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                                         NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                                         moving_id = -1;
                                                     }];
}

#pragma mark -- pan gusture
- (void)handlePan:(UIPanGestureRecognizer*)gesture {

}

- (void)handleTap:(UITapGestureRecognizer*)gesture {
    [inputView endEditing];
}

#pragma mark -- LoinInputView Delegate
- (void)didSelectQQBtn {
    [_lm loginWithQQ];
}

- (void)didSelectWeiboBtn {
    [_lm loginWithWeibo];
}

- (void)didSelectWechatBtn {
    [_lm loginWithWeChat];
}

- (void)didSelectAreaCodeBtn {
    [self performSegueWithIdentifier:@"areaCode" sender:nil];
}

- (void)didSelectConfirmBtn {
    NSString* phoneNo = [inputView getInputPhoneNumber];
    
    if ([self isValidPhoneNumber:phoneNo inArea:@"+86"] && [self.lm sendLoginRequestToPhone:phoneNo]) {
        [inputView sendConfirmCodeRequestSuccess];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"input wrong phone number" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didSelectNextBtn {
    NSString* code = [inputView getInputConfirmCode];
    NSString* phoneNo = [inputView getInputPhoneNumber];
    
    if (![self isValidPhoneCode:code]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"验证码错误" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    RegTmpToken* token = [RegTmpToken enumRegTokenINContext:self.lm.doc.managedObjectContext WithPhoneNo:phoneNo];
    
    if (token == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"input wrong phone number" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    } else {
        NSDictionary* tmp =[[NSDictionary alloc] init];
        LoginModelConfirmResult reVal = [self.lm sendConfirrmCode:code ToPhone:phoneNo withToken:token.reg_token toResult:&tmp];
        if (reVal == LoginModelResultSuccess) {
            [self performSegueWithIdentifier:@"loginSuccessSegue" sender:tmp];
            NSLog(@"login success");
        } else if (reVal ==LoginModelResultOthersLogin) {
            [self performSegueWithIdentifier:@"alreadyLogSegue" sender:tmp];
            NSLog(@"already login by others");
        }
    }
}

- (void)didStartEditing {
    
    if (moving_id >= 0) {
        
        [INTUAnimationEngine cancelAnimationWithID:moving_id];
        
        title.hidden = YES;
        slg.hidden = YES;
        CGFloat last_height = inputView.bounds.size.height;
        inputView.frame = CGRectMake(0, INPUT_VIEW_START_POINT - 110, [UIScreen mainScreen].bounds.size.width, last_height);
        return;
    }
    
    if (fabs(inputView.frame.origin.y - INPUT_VIEW_START_POINT) < 1.f / 10000.0) {
        title.hidden = YES;
        slg.hidden = YES;
        [self moveView:-110];
    }
    NSLog(@"%@ === %@", @"dfdd", inputView);
}

- (void)didEndEditing {
    if (![inputView isEditing]) {
        [self moveView:110];
        title.hidden = NO;
        slg.hidden = NO;
    }
}

- (void)didSelectUserPrivacyBtn {
    [self performSegueWithIdentifier:@"UserPrivacy" sender:nil];
}

#pragma mark -- choose area controller delegate
- (void)didSelectArea:(NSString*)code {
    [inputView setAreaCode:code];
}

#pragma mark -- Gotaye Delegate
/**
 * @brief 登录回调
 * @param code: 状态id
 * @param user: 当前登录用户
 */
-(void) onLogin:(GotyeStatusCode)code user:(GotyeOCUser*)user {
    NSLog(@"XMPP on Login");
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.im_user = user;
//    [GotyeOCAPI activeSession:[GotyeOCUser userWithName:@"alfred_test"]];
//    [app registerDeviceTokenWithCurrentUser];
//    if (!isQueryModelReady) [app createQueryModel];
//    else [self queryDataIsReady:nil];
//    [self performSegueWithIdentifier:@"contentSegue" sender:nil];
    if (_contentController == nil) {
        [self performSegueWithIdentifier:@"contentSegue" sender:nil];
    }
}

/**
 * @brief  正在重连回调
 * @param code: 状态id
 * @param user: 当前登录用户
 */
-(void) onReconnecting:(GotyeStatusCode)code user:(GotyeOCUser*)user {
    NSLog(@"XMPP on Reconnecting");
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.im_user = user;
   
//    [GotyeOCAPI activeSession:[GotyeOCUser userWithName:@"alfred_test"]];
    [GotyeOCAPI beginReceiveOfflineMessage];
}

/**
 * @brief  退出登录回调
 * @param code: 状态id
 */
-(void) onLogout:(GotyeStatusCode)code {
    NSLog(@"XMPP on Logout");
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.im_user = nil;
}

/**
 * @brief 接收消息回调
 * @param message: 接收到的消息对象
 * @param downloadMediaIfNeed: 是否自动下载
 */
-(void) onReceiveMessage:(GotyeOCMessage*)message downloadMediaIfNeed:(bool*)downloadMediaIfNeed {
    if (message.sender.type == GotyeChatTargetTypeRoom) {
        return;
    }
    
    if ([message.sender.name isEqualToString:@"alfred_test"]) {
        NSLog(@"this is a system notification");
        
        [_mm addNotification:[RemoteInstance searchDataFromData:[message.text dataUsingEncoding:NSUTF8StringEncoding]] withFinishBlock:^{
            [_contentController unReadMessageCountChanged:nil];
        }];
        
        [GotyeOCAPI markOneMessageAsRead:message isRead:YES];
//        GotyeOCUser* u = [GotyeOCUser userWithName:@"alfred_test"];
//        [GotyeOCAPI deleteMessage:u msg:message];
//        [GotyeOCAPI deleteSession:u alsoRemoveMessages:YES];
        
    } else {
        NSLog(@"this is a chat message");
       
        // TODO: add logic for chat message
        [_contentController unReadMessageCountChanged:nil];
    }
}

/**
 * @brief 获取历史/离线消息回调
 * @param code: 状态id
 * @param msglist: 消息列表
 * @param downloadMediaIfNeed: 是否需要下载
 */
//-(void) onGetMessageList:(GotyeStatusCode)code totalCount:(unsigned)totalCount downloadMediaIfNeed:(bool*)downloadMediaIfNeed {
-(void) onGetMessageList:(GotyeStatusCode)code msglist:(NSArray *)msgList downloadMediaIfNeed:(bool*)downloadMediaIfNeed {
    NSLog(@"get message count : %lu", (unsigned long)msgList.count);

    /**
     * for notification
     */
    GotyeOCUser* u = [GotyeOCUser userWithName:@"alfred_test"];
    NSArray* arr = [GotyeOCAPI getMessageList:u more:YES];
    for (int index = 0; index < arr.count; ++index) {
        GotyeOCMessage* m = [arr objectAtIndex:index];
        if (m.status == GotyeMessageStatusUnread) {
            
            [_mm addNotification:[RemoteInstance searchDataFromData:[m.text dataUsingEncoding:NSUTF8StringEncoding]] withFinishBlock:^{
//                [_contentController addOneNotification];
            }];
        
            [GotyeOCAPI markOneMessageAsRead:m isRead:YES];
        }
    }
//    [GotyeOCAPI deleteMessages:u msglist:arr];
//    [GotyeOCAPI deleteSession:u alsoRemoveMessages:YES];
    
    /**
     * for messages
     */
    [_contentController unReadMessageCountChanged:nil];
}

/**
 * @brief 发送消息回调
 * @param code: 状态id
 * @param message: 消息对象
 */
-(void) onSendMessage:(GotyeStatusCode)code message:(GotyeOCMessage*)message {
    NSLog(@"send message success: %@", message);
}
@end
