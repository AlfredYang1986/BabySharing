//
//  ChatGroupController.m
//  BabySharing
//
//  Created by Alfred Yang on 19/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "ChatGroupController.h"
//#import "MessageChatGroupHeader2.h"
#import "MessageChatGroupHeader3.h"
#import "INTUAnimationEngine.h"

#import "AppDelegate.h"
#import "LoginModel.h"
#import "MessageModel.h"

#import "RemoteInstance.h"
#import "GotyeOCAPI.h"

#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"

//#import "chatEmojiView.h"         // emoji not implement
#import "ChatMessageCell.h"

#import "ChatGroupUserInfoTableDelegateAndDatasource.h"
#import "PersonalCentreTmpViewController.h"
#import "PersonalCentreOthersDelegate.h"

#define BACK_BTN_WIDTH          23
#define BACK_BTN_HEIGHT         23
#define BOTTOM_MARGIN           10.5
    
#define INPUT_HEIGHT            37
    
#define INPUT_CONTAINER_HEIGHT  49
    
#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
    
#define USER_BTN_WIDTH          40
#define USER_BTN_HEIGHT         23


#define USER_INFO_PANE_HEIGHT               194
#define USER_INFO_PANE_MARGIN               10.5
#define USER_INGO_PANE_BOTTOM_MARGIN        4
#define USER_INFO_PANE_WIDTH                width - 2 * USER_INFO_PANE_MARGIN
#define USER_INFO_CONTAINER_HEIGHT          USER_INFO_PANE_HEIGHT

#define USER_INFO_BACK_BTN_HEIGHT           30
#define USER_INFO_BACK_BTN_WIDTH            30

@interface ChatGroupController () <UITableViewDataSource, UITableViewDelegate, /*UITextFieldDelegate,*/ GotyeOCDelegate, /*ChatEmoji,*/ UITextViewDelegate, userInfoPaneDelegate, ChatMessageCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *queryView;
@end

@implementation ChatGroupController {
    
    UIView * inputContainer;
    UIButton* userBtn;
    UITextView* inputView;
    UIButton* backBtn;
    
    CATextLayer* group_count;
    
    NSDictionary* founder_dic;
    NSMutableArray* current_message;
    NSMutableArray* current_talk_users;
    
//    UIView* userInfoPane;
    UIButton* back_btn;
    UITableView* userInfoTable;
    ChatGroupUserInfoTableDelegateAndDatasource* delegate;
    
    /**
     * for emoji not implement for first version
     */
//    UIView* keyboardView;
//    ChatEmojiView* emoji;
    CGRect keyBoardFrame;
//    BOOL isEmoji;
    
    /**
     * dispatch_semaphore_wait
     */
    BOOL isLoaded;
    dispatch_semaphore_t semaphore;
    
    /**
     * re-design layout
     */
//    MessageChatGroupHeader2* header;
    MessageChatGroupHeader3* header;
}

@synthesize queryView = _queryView;

@synthesize founder_id = _founder_id;
@synthesize lm = _lm;
@synthesize mm = _mm;

@synthesize group_id = _group_id;
@synthesize group_name = _group_name;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _lm = app.lm;
    _mm = app.mm;
  
    current_talk_users = [[NSMutableArray alloc]init];
  
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageChatGroupHeader2" owner:self options:nil];
//    header = [nib objectAtIndex:0];
    header = [[MessageChatGroupHeader3 alloc]init];
    header.frame = CGRectMake(0, 0, width, [header preferredHeight]);
    header.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:header];
    [self.view bringSubviewToFront:header];
    
    _queryView = [[UITableView alloc]init];
    _queryView.delegate = self;
    _queryView.dataSource = self;
    [self.view addSubview:_queryView];
    [self.view bringSubviewToFront:_queryView];
    
    _queryView.backgroundColor = [UIColor clearColor];
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去除表框
//    [_queryView registerNib:[UINib nibWithNibName:@"MessageChatGroupHeader2" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"chat group header"];
  
    [self setUpInputView];
    [self setUpUserInfoPane];
    
    /**
     * get founder info
     */
    semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_queue_t up = dispatch_queue_create("Get Profile Details", nil);
    dispatch_async(up, ^{
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//        [dic setValue:_lm.current_auth_token forKey:@"query_auth_token"];
//        [dic setValue:_lm.current_user_id forKey:@"query_user_id"];
        [dic setValue:_lm.current_auth_token forKey:@"auth_token"];
        [dic setValue:_lm.current_user_id forKey:@"user_id"];
        [dic setValue:_founder_id forKey:@"owner_user_id"];
        
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_QUERY_DETAILS]]];
        
        if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
            founder_dic = [result objectForKey:@"result"];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setFounderInfoForChatGroupHeader];
                [self setGroupInfoForChatGroupHeader];
                [header setNeedsLayout];
            });
            
        } else {
            NSDictionary* reError = [result objectForKey:@"error"];
            NSString* msg = [reError objectForKey:@"message"];
            
            NSLog(@"query user profile failed");
            NSLog(@"%@", msg);
        }
   
        dispatch_semaphore_signal(semaphore);
    });
    
    [self enterChatGroup];
    
    /**
     * input method
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [_queryView addGestureRecognizer:tap];
    
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
//    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
//}
//
//- (BOOL)prefersStatusBarHidden {
//    return YES; //返回NO表示要显示，返回YES将hiden
//}

- (void)resetGroupID:(NSNumber *)group_id {
    _group_id = group_id;
   
    GotyeOCGroup* group = [GotyeOCGroup groupWithId:_group_id.longLongValue];
    int unReadCount = [GotyeOCAPI getUnreadMessageCount:group];
   
    if (unReadCount > 0) {
        [GotyeOCAPI setMessageReadIncrement:unReadCount];
        current_message = [[GotyeOCAPI getMessageList:group more:NO] mutableCopy];
        [GotyeOCAPI setMessageReadIncrement:10];
    } else {
        current_message = [[NSMutableArray alloc]init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    CGFloat header_height = [MessageChatGroupHeader2 preferredHeightWithContent:@"abcde"];
    CGFloat header_height = [header preferredHeight];
    header.frame = CGRectMake(0, 0, width, header_height);
    
    _queryView.frame = CGRectMake(0, header_height, width, height - header_height - INPUT_CONTAINER_HEIGHT);
    inputContainer.frame = CGRectMake(0, height - INPUT_CONTAINER_HEIGHT, SCREEN_WIDTH, INPUT_CONTAINER_HEIGHT);
    userInfoTable.frame = CGRectMake(USER_INFO_PANE_MARGIN + width, height - USER_INFO_CONTAINER_HEIGHT, USER_INFO_PANE_WIDTH, USER_INFO_CONTAINER_HEIGHT);
    //CGRectMake(USER_INFO_PANE_MARGIN + width, height - USER_INGO_PANE_BOTTOM_MARGIN - USER_INFO_PANE_HEIGHT, width - 2 * USER_INFO_PANE_MARGIN, USER_INFO_PANE_HEIGHT);
}

- (void)enterChatGroup {
    /**
     * start enter group
     */
    dispatch_queue_t en = dispatch_queue_create("Get Profile Details", nil);
    dispatch_async(en, ^{
        [_mm joinChatGroup:_group_id andFinishBlock:^(BOOL success, id result) {
            NSLog(@"join group success");
            /**
             * get user lst
             */
            GotyeOCGroup* group = [GotyeOCGroup groupWithId:_group_id.longLongValue];
            [GotyeOCAPI joinGroup:group];
        }];
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [GotyeOCAPI addListener:self];
   
    if (!isLoaded) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        isLoaded = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated {
//    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [GotyeOCAPI removeListener:self];
}

- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [self.queryView numberOfSections];
    if (s<1) return;
    NSInteger r = [self.queryView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.queryView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)reloadData {
    [_queryView reloadData];
    [userInfoTable reloadData];
   
    [self scrollTableToFoot:YES];
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setUpUserInfoPane {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
//    userInfoPane = [[UIView alloc]initWithFrame:CGRectMake(USER_INFO_PANE_MARGIN, height - USER_INGO_PANE_BOTTOM_MARGIN - USER_INFO_PANE_HEIGHT, width - 2 * USER_INFO_PANE_MARGIN, USER_INFO_PANE_HEIGHT)];
//    userInfoPane.backgroundColor = [UIColor clearColor];
    
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];

    userInfoTable = [[UITableView alloc]initWithFrame:CGRectMake(USER_INFO_PANE_MARGIN, height - USER_INFO_CONTAINER_HEIGHT, USER_INFO_PANE_WIDTH, USER_INFO_CONTAINER_HEIGHT)];
    
    delegate = [[ChatGroupUserInfoTableDelegateAndDatasource alloc]init];
    delegate.delegate = self;
    
    userInfoTable.delegate = delegate;
    userInfoTable.dataSource = delegate;
    userInfoTable.scrollEnabled = NO;
    userInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    userInfoTable.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.6];
    userInfoTable.layer.cornerRadius = 5.0;
    userInfoTable.clipsToBounds = YES;
    [userInfoTable registerNib:[UINib nibWithNibName:@"MessageFriendsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"user info header"];
    [userInfoTable registerNib:[UINib nibWithNibName:@"MessageChatGroupInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"user info cell"];
    
//    [userInfoPane addSubview:userInfoTable];
    
    [self.view addSubview:userInfoTable];
    [self.view bringSubviewToFront:userInfoTable];
    
    if (back_btn == nil) {
        back_btn = [[UIButton alloc]init];
        CALayer* layer = [CALayer layer];
        layer.contents = (id)[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"group_chat" ofType:@"png"]].CGImage;
        layer.frame = CGRectMake(0, 0, 22, 22);
        layer.position = CGPointMake(USER_INFO_BACK_BTN_WIDTH / 2, USER_INFO_BACK_BTN_HEIGHT / 2);
        
        //  [back_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"dongda_next_light" ofType:@"png"]] forState:UIControlStateNormal];
        [back_btn addTarget:self action:@selector(userInfo2InputView) forControlEvents:UIControlEventTouchUpInside];
        back_btn.frame = CGRectMake(userInfoTable.bounds.size.width - USER_INFO_BACK_BTN_WIDTH - 10.5, 10.5, USER_INFO_BACK_BTN_WIDTH, USER_INFO_BACK_BTN_HEIGHT);
        [back_btn.layer addSublayer:layer];
        //  [userInfoPane addSubview:back_btn];
    }
    
    userInfoTable.center = CGPointMake(userInfoTable.center.x + width, userInfoTable.center.y);
}

- (void)setUpInputView {
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];

    inputContainer = [[UIView alloc]initWithFrame:CGRectMake(0, height - INPUT_CONTAINER_HEIGHT, SCREEN_WIDTH, INPUT_CONTAINER_HEIGHT)];
    inputContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:inputContainer];
    [self.view bringSubviewToFront:inputContainer];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, (INPUT_CONTAINER_HEIGHT - BACK_BTN_HEIGHT) / 2, BACK_BTN_WIDTH, BACK_BTN_HEIGHT)];
    backBtn.layer.borderColor = [UIColor blueColor].CGColor;
    [backBtn addTarget:self action:@selector(backBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"dongda_back" ofType:@"png"]] forState:UIControlStateNormal];
    [inputContainer addSubview:backBtn];
    
    inputView = [[UITextView alloc]init];
    CGFloat input_width = [UIScreen mainScreen].bounds.size.width - 8 - BACK_BTN_WIDTH - BOTTOM_MARGIN - USER_BTN_WIDTH - BOTTOM_MARGIN - 8;
    inputView.frame = CGRectMake(8 + BACK_BTN_WIDTH + BOTTOM_MARGIN, (INPUT_CONTAINER_HEIGHT - INPUT_HEIGHT) / 2 - 2, input_width, INPUT_HEIGHT);
    inputView.delegate = self;
    inputView.backgroundColor = [UIColor clearColor];
    inputView.inputView.backgroundColor = [UIColor redColor];
    inputView.scrollEnabled = NO;
    
    UIImageView* img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:[resourceBundle_dongda pathForResource:@"group_chat_input_bg" ofType:@"png"]];
    img.frame = CGRectMake(0, 0, input_width, INPUT_HEIGHT);
    [inputView addSubview:img];
    [inputView sendSubviewToBack:img];
    
    [inputContainer addSubview:inputView];
    
    userBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - USER_BTN_WIDTH - BOTTOM_MARGIN, (INPUT_CONTAINER_HEIGHT - BACK_BTN_HEIGHT) / 2, USER_BTN_WIDTH, USER_BTN_HEIGHT)];
    [userBtn addTarget:self action:@selector(inputView2UserInfo) forControlEvents:UIControlEventTouchDown];
//    [userBtn setImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"group_chat_head" ofType:@"png"]] forState:UIControlStateNormal];
    CALayer* layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"group_chat_head" ofType:@"png"]].CGImage;
    layer.frame = CGRectMake(0, 0, 16, 16);
    layer.position = CGPointMake(12, USER_BTN_HEIGHT / 2);
    [userBtn.layer addSublayer: layer];
  
    if (group_count == nil) {
        group_count = [CATextLayer layer];
        group_count.string = [NSString stringWithFormat:@"%d", _joiner_count.intValue];
        group_count.foregroundColor = [UIColor colorWithWhite:0.2902 alpha:1.f].CGColor;
        group_count.fontSize = 14.f;
        group_count.contentsScale = 2.f;
        group_count.alignmentMode = @"center";
        group_count.frame = CGRectMake(0 + 16 + 8, 0, 30, USER_BTN_HEIGHT);
        group_count.position = CGPointMake(0 + 16 + 14, USER_BTN_HEIGHT / 2 + 3);
        [userBtn.layer addSublayer:group_count];
    }
    
    [inputContainer addSubview:userBtn];
}

#pragma mark -- gotye delegate
//- (void)onEnterRoom:(GotyeStatusCode)code room:(GotyeOCRoom *)room {
//    NSLog(@"enter room status code %d", code);
//    [GotyeOCAPI reqRoomMemberList:room pageIndex:0];
//}
- (void)onJoinGroup:(GotyeStatusCode)code group:(GotyeOCGroup *)group {
    NSLog(@"enter room status code %d", code);
    [GotyeOCAPI reqGroupMemberList:group pageIndex:0];
    [GotyeOCAPI markMessagesAsRead:group isRead:YES];
}

- (void)onGetGroupMemberList:(GotyeStatusCode)code group:(GotyeOCGroup *)group pageIndex:(unsigned int)pageIndex curPageMemberList:(NSArray *)curPageMemberList allMemberList:(NSArray *)allMemberList {
    
//-(void) onGetRoomMemberList:(GotyeStatusCode)code room:(GotyeOCRoom*)room pageIndex:(unsigned)pageIndex curPageMemberList:(NSArray*)curPageMemberList allMemberList:(NSArray*)allMemberList {

    dispatch_queue_t up = dispatch_queue_create("Get user list", nil);
    dispatch_async(up, ^{
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (int index = 0; index < MIN(allMemberList.count, 6); ++index) {
            GotyeOCUser* user = [allMemberList objectAtIndex:index];
            [arr addObject:user.name];
        }
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:_lm.current_user_id forKey:@"user_id"];
        [dic setObject:_lm.current_auth_token forKey:@"auth_token"];
        
        [dic setObject:[arr copy] forKey:@"query_list"];
        
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_QUERY_MULTIPLE]]];
        
        if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
           
            current_talk_users = [result objectForKey:@"result"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
            
        } else {

            NSLog(@"error: %@", [result objectForKey:@"error"]);
        }
    });
}

#pragma mark -- message delegate
/**
 * @brief 接收消息回调
 * @param message: 接收到的消息对象
 * @param downloadMediaIfNeed: 是否自动下载
 */
-(void) onReceiveMessage:(GotyeOCMessage*)message downloadMediaIfNeed:(bool*)downloadMediaIfNeed {
  
    [current_message addObject:message];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [_queryView reloadData];
        [self reloadData];
    });
}

- (void)onSendMessage:(GotyeStatusCode)code message:(GotyeOCMessage *)message {
    [current_message addObject:message];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [_queryView reloadData];
        [self reloadData];
        inputView.text = @"";
    });
}

- (void)backBtnSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setGroupInfoForChatGroupHeader {
//    [header setChatGroupThemeTitle:_group_name];
    header.theme_label_text = _group_name;
}

//- (void)setFounderInfoForChatGroupHeader:(MessageChatGroupHeader2*)header {
- (void)setFounderInfoForChatGroupHeader {
//    [header setFounderScreenName:[founder_dic objectForKey:@"screen_name"]];
//    [header setFounderScreenPhoto:[founder_dic objectForKey:@"screen_photo"]];
//    [header setFounderRelations:[founder_dic objectForKey:@"relations"]];
//    [header setFounderRoleTag:[founder_dic objectForKey:@"role_tag"]];
}

#pragma mark -- table view delegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark -- table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return current_message.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GotyeOCMessage* m = [current_message objectAtIndex:indexPath.row];
    return [ChatMessageCell preferredHeightWithInputText:m.text];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"message cell"];
    
    if (cell == nil) {
        cell = [[ChatMessageCell alloc]init];
    }
   
    GotyeOCMessage* m = [current_message objectAtIndex:indexPath.row];
    cell.message = m;
    cell.delegate = self;
    
    return cell;
}

#pragma mark -- move view when chat
- (void)moveView:(float)move {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGRect rc_start = _queryView.frame;
    CGRect rc_end = CGRectMake(rc_start.origin.x, rc_start.origin.y, rc_start.size.width, rc_start.size.height + move);
    
    CGRect input_start = inputContainer.frame;
    CGRect input_end = CGRectMake(input_start.origin.x, input_start.origin.y + move, input_start.size.width, input_start.size.height);
    
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      _queryView.frame = INTUInterpolateCGRect(rc_start, rc_end, progress);
                                      inputContainer.frame = INTUInterpolateCGRect(input_start, input_end, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      // self.animationID = NSNotFound;
                                      [self scrollTableToFoot:YES];
                                  }];
}


- (void)moveView:(float)move withFinish:(SEL)block {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGRect rc_start = _queryView.frame;
    CGRect rc_end = CGRectMake(rc_start.origin.x, rc_start.origin.y, rc_start.size.width, rc_start.size.height + move);
    
    CGRect input_start = inputContainer.frame;
    CGRect input_end = CGRectMake(input_start.origin.x, input_start.origin.y + move, input_start.size.width, input_start.size.height);
    
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      _queryView.frame = INTUInterpolateCGRect(rc_start, rc_end, progress);
                                      inputContainer.frame = INTUInterpolateCGRect(input_start, input_end, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      // self.animationID = NSNotFound;
                                      [self performSelector:block withObject:nil];
                                  }];
}

#pragma mark -- textfield delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
//    [self moveView:-250];
//    [self moveView:-keyBoardFrame.size.height];
}

- (void)textViewDidChange:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
//        GotyeOCRoom* room = [GotyeOCRoom roomWithId:_group_id.longLongValue];
        GotyeOCGroup* group = [GotyeOCGroup groupWithId:_group_id.longLongValue];
        GotyeOCMessage* m = [GotyeOCMessage createTextMessage:group text:textView.text];
        [GotyeOCAPI sendMessage:m];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark -- input view 2 user info view
- (void)userInfo2InputView {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGPoint input_start = inputContainer.center;
    CGPoint input_end   = CGPointMake(input_start.x + width, input_start.y);
    
    CGPoint user_start  = userInfoTable.center;
    CGPoint user_end   = CGPointMake(user_start.x + width, user_start.y);
    
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      inputContainer.center = INTUInterpolateCGPoint(input_start, input_end, progress);
                                      userInfoTable.center = INTUInterpolateCGPoint(user_start, user_end, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      // self.animationID = NSNotFound;
                                  }];
}

- (void)inputView2UserInfo {
    if (inputView.isFirstResponder) {
        [inputView resignFirstResponder];
        [self moveView:keyBoardFrame.size.height withFinish:@selector(inputView2UserInfo)];
    } else {
        static const CGFloat kAnimationDuration = 0.30; // in seconds
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        CGPoint input_start = inputContainer.center;
        CGPoint input_end   = CGPointMake(input_start.x - width, input_start.y);
        
        CGPoint user_start  = userInfoTable.center;
        CGPoint user_end   = CGPointMake(user_start.x - width, user_start.y);
        
        [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                           delay:0.0
                                          easing:INTUEaseInOutQuadratic
                                         options:INTUAnimationOptionNone
                                      animations:^(CGFloat progress) {
                                          inputContainer.center = INTUInterpolateCGPoint(input_start, input_end, progress);
                                          userInfoTable.center = INTUInterpolateCGPoint(user_start, user_end, progress);
                                          
                                          // NSLog(@"Progress: %.2f", progress);
                                      }
                                      completion:^(BOOL finished) {
                                          // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                          NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                          // self.animationID = NSNotFound;
                                      }];
    }
}

#pragma mark -- user info delegate
- (NSString*)getFounderScreenName {
    return [founder_dic objectForKey:@"screen_name"];
}

- (NSString*)getFounderScreenPhoto {
    return [founder_dic objectForKey:@"screen_photo"];
}

- (NSString*)getFounderRoleTag {
    return [founder_dic objectForKey:@"role_tag"];
}

- (NSInteger)getFounderRelations {
    return ((NSNumber*)[founder_dic objectForKey:@"relations"]).intValue;
//    return 2;
}

- (NSNumber*)getGroupJoinNumber {
    return _joiner_count;
}

- (NSArray*)getGroupJoinNumberList {
    return current_talk_users;
}

- (UIButton*)getBackBtn {
    return back_btn;
}

#pragma mark -- emoji
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
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (inputContainer.frame.origin.y + inputContainer.frame.size.height == height) {
        [self moveView:-keyBoardFrame.size.height];
    }
    
//    if (isEmoji) {
//        [emoji removeFromSuperview];
//        emoji.frame = keyBoardFrame;
//        [keyboardView addSubview:emoji];
//        [keyboardView bringSubviewToFront:emoji];
//    }
}

- (void)keyboardWasChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
}

- (void)keyboardDidHidden:(NSNotification*)notification {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (inputContainer.frame.origin.y + inputContainer.frame.size.height != height) {
        [self moveView:keyBoardFrame.size.height];
    }
}

- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    if (inputView.isFirstResponder) {
        [inputView resignFirstResponder];
    }
}

#pragma mark -- chat cell select delegate
- (void)didSelectedScreenPhotoForUserID:(NSString*)user_id {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalCentreTmpViewController* pc = [storyboard instantiateViewControllerWithIdentifier:@"PersonalCenter"];
    PersonalCentreOthersDelegate* pd = [[PersonalCentreOthersDelegate alloc]init];
    pc.current_delegate = pd;
    pc.owner_id = user_id;
    pc.isPushed = YES;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:pc animated:YES];
}
@end
