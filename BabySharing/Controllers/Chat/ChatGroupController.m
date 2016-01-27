//
//  ChatGroupController.m
//  BabySharing
//
//  Created by Alfred Yang on 19/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "ChatGroupController.h"
#import "MessageChatGroupHeader2.h"
#import "INTUAnimationEngine.h"

#import "AppDelegate.h"
#import "LoginModel.h"
#import "MessageModel.h"

#import "RemoteInstance.h"
#import "GotyeOCAPI.h"

#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"

#import "chatEmojiView.h"
#import "ChatMessageCell.h"

@interface ChatGroupController () <UITableViewDataSource, UITableViewDelegate, /*UITextFieldDelegate,*/ GotyeOCDelegate, ChatEmoji, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
//@property (weak, nonatomic) IBOutlet UITextField *inputField;
//@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
//@property (weak, nonatomic) IBOutlet UIButton *funcBtn;
//@property (weak, nonatomic) IBOutlet UIView *inputContainer;

@end

@implementation ChatGroupController {
    
    UIView * inputContainer;
    UIButton* userBtn;
    UITextView* inputView;
    UIButton* backBtn;
    
    NSDictionary* founder_dic;
    NSMutableArray* current_message;
    NSMutableArray* current_talk_users;
    
    /**
     * for emoji
     */
    UIView* keyboardView;
    ChatEmojiView* emoji;
    CGRect keyBoardFrame;
    BOOL isEmoji;
}

@synthesize queryView = _queryView;
//@synthesize inputField = _inputField;
//@synthesize faceBtn = _faceBtn;
//@synthesize funcBtn = _funcBtn;
//@synthesize inputContainer = _inputContainer;

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
    
    current_message = [[NSMutableArray alloc]init];
    current_talk_users = [[NSMutableArray alloc]init];
   
    _queryView.backgroundColor = [UIColor clearColor];
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去除表框
    [_queryView registerNib:[UINib nibWithNibName:@"MessageChatGroupHeader2" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"chat group header"];
  
    [self setUpInputView];
    
    /**
     * get founder info
     */
    dispatch_queue_t up = dispatch_queue_create("Get Profile Details", nil);
    dispatch_async(up, ^{
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:_lm.current_auth_token forKey:@"query_auth_token"];
        [dic setValue:_lm.current_user_id forKey:@"query_user_id"];
        [dic setValue:_founder_id forKey:@"owner_user_id"];
        
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_QUERY_DETAILS]]];
        
        if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
            founder_dic = [result objectForKey:@"result"];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                UIView* tmp = [_queryView headerViewForSection:0];
                [self setFounderInfoForChatGroupHeader:(MessageChatGroupHeader2*)tmp];
                [self setGroupInfoForChatGroupHeader:(MessageChatGroupHeader2*)tmp];
//                [_queryView reloadData];
                [self reloadData];
            });
            
        } else {
            NSDictionary* reError = [result objectForKey:@"error"];
            NSString* msg = [reError objectForKey:@"message"];
            
            NSLog(@"query user profile failed");
            NSLog(@"%@", msg);
        }
    });
    
    /**
     * start enter group
     */
    dispatch_queue_t en = dispatch_queue_create("Get Profile Details", nil);
    dispatch_async(en, ^{
        [_mm joinChatGroup:_group_id andFinishBlock:^(BOOL success, id result) {
            NSLog(@"join group success");
        }];
    });
    
    /**
     * get user lst
     */
    GotyeOCRoom* room = [GotyeOCRoom roomWithId:_group_id.longLongValue];
    if (![GotyeOCAPI isInRoom:room]) {
        [GotyeOCAPI enterRoom:room];
    } else {
        [GotyeOCAPI reqRoomMemberList:room pageIndex:0];
    }
    
    /**
     * get local messages for chat group
     */
    
    /**
     * get emoji
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    emoji = [[ChatEmojiView alloc]init];
    emoji.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [GotyeOCAPI removeListener:self];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [GotyeOCAPI addListener:self];
}

- (void)viewWillDisappear:(BOOL)animated {
//    self.navigationController.navigationBarHidden = NO;
}

- (void)reloadData {
    [_queryView reloadData];
    inputView.text = @"";
//    [userBtn setTitle:[NSString stringWithFormat:@"%d", _joiner_count.intValue] forState:UIControlStateNormal];
//    [userBtn setTitle:@"123" forState:UIControlStateNormal];
//    [userBtn setNeedsDisplay];
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

- (void)setUpInputView {
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    
#define BACK_BTN_WIDTH          23
#define BACK_BTN_HEIGHT         23
#define BOTTOM_MARGIN           10.5
    
#define INPUT_HEIGHT            37
    
#define INPUT_CONTAINER_HEIGHT  49
    
#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
    
#define USER_BTN_WIDTH          40
#define USER_BTN_HEIGHT         23

    inputContainer = [[UIView alloc]initWithFrame:CGRectMake(0, height - INPUT_CONTAINER_HEIGHT, SCREEN_WIDTH, INPUT_CONTAINER_HEIGHT)];
    inputContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:inputContainer];
    [self.view bringSubviewToFront:inputContainer];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, (INPUT_CONTAINER_HEIGHT - BACK_BTN_HEIGHT) / 2, BACK_BTN_WIDTH, BACK_BTN_HEIGHT)];
    backBtn.layer.borderColor = [UIColor blueColor].CGColor;
    [backBtn addTarget:self action:@selector(backBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"dongda_back_light" ofType:@"png"]] forState:UIControlStateNormal];
    [inputContainer addSubview:backBtn];
    
    inputView = [[UITextView alloc]init];
    CGFloat input_width = [UIScreen mainScreen].bounds.size.width - 8 - BACK_BTN_WIDTH - BOTTOM_MARGIN - USER_BTN_WIDTH - BOTTOM_MARGIN - 8;
    inputView.frame = CGRectMake(8 + BACK_BTN_WIDTH + BOTTOM_MARGIN, (INPUT_CONTAINER_HEIGHT - INPUT_HEIGHT) / 2, input_width, INPUT_HEIGHT);
    inputView.delegate = self;
    inputView.backgroundColor = [UIColor clearColor];
    inputView.scrollEnabled = NO;
    
    UIImageView* img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:[resourceBundle_dongda pathForResource:@"group_chat_input_bg" ofType:@"png"]];
    img.frame = CGRectMake(0, 0, input_width, INPUT_HEIGHT);
    [inputView addSubview:img];
    [inputView sendSubviewToBack:img];
    
    [inputContainer addSubview:inputView];
    
    userBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - USER_BTN_WIDTH - BOTTOM_MARGIN, (INPUT_CONTAINER_HEIGHT - BACK_BTN_HEIGHT) / 2, USER_BTN_WIDTH, USER_BTN_HEIGHT)];
    [userBtn addTarget:self action:@selector(backBtnSelected) forControlEvents:UIControlEventTouchDown];
//    [userBtn setImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"group_chat_head" ofType:@"png"]] forState:UIControlStateNormal];
    CALayer* layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"group_chat_head" ofType:@"png"]].CGImage;
    layer.frame = CGRectMake(0, 0, 16, 16);
    layer.position = CGPointMake(8, USER_BTN_HEIGHT / 2);
    [userBtn.layer addSublayer: layer];
   
    CATextLayer* text = [CATextLayer layer];
    text.string = @"12";
    text.fontSize = 12.f;
    text.contentsScale = 2.f;
    text.alignmentMode = @"center";
    text.frame = CGRectMake(0 + 16 + 8, 0, 30, USER_BTN_HEIGHT);
    text.position = CGPointMake(0 + 16 + 15, USER_BTN_HEIGHT / 2 + 3);
    [userBtn.layer addSublayer:text];
    
    [inputContainer addSubview:userBtn];
}

#pragma mark -- gotye delegate
- (void)onEnterRoom:(GotyeStatusCode)code room:(GotyeOCRoom *)room {
    NSLog(@"enter room status code %d", code);
    [GotyeOCAPI reqRoomMemberList:room pageIndex:0];
}

-(void) onGetRoomMemberList:(GotyeStatusCode)code room:(GotyeOCRoom*)room pageIndex:(unsigned)pageIndex curPageMemberList:(NSArray*)curPageMemberList allMemberList:(NSArray*)allMemberList {

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
           
            MessageChatGroupHeader2* tmp = (MessageChatGroupHeader2*)[_queryView headerViewForSection:0];
            current_talk_users = [result objectForKey:@"result"];
//            [tmp setChatGroupUserList:current_talk_users];
            
        } else {
//            NSDictionary* reError = [result objectForKey:@"error"];
//            NSString* msg = [reError objectForKey:@"message"];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//            [alert show];
            NSLog(@"error: %@", [result objectForKey:@"error"]);
        }
    });
}

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
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)chatBtnSelected {
//    [_inputField becomeFirstResponder];
    [self moveView:-250];
}

- (void)backBtnSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setGroupInfoForChatGroupHeader:(MessageChatGroupHeader2*)header {
    [header setChatGroupThemeTitle:_group_name];
//    [header setCHatGroupJoinerNumber:_joiner_count];
}

- (void)setFounderInfoForChatGroupHeader:(MessageChatGroupHeader2*)header {
    [header setFounderScreenName:[founder_dic objectForKey:@"screen_name"]];
    [header setFounderScreenPhoto:[founder_dic objectForKey:@"screen_photo"]];
    [header setFounderRelations:[founder_dic objectForKey:@"relations"]];
    [header setFounderRoleTag:[founder_dic objectForKey:@"role_tag"]];
}

#pragma mark -- table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [MessageChatGroupHeader2 preferredHeightWithContent:@"abcde"];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    MessageChatGroupHeader2* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"chat group header"];
    
    if (header == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageChatGroupHeader" owner:self options:nil];
        header = [nib objectAtIndex:0];
    }
    
    [self setFounderInfoForChatGroupHeader:header];
    [self setGroupInfoForChatGroupHeader:header];
//    [header setChatGroupUserList:current_talk_users];
    return header;
}

#pragma mark -- table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return current_message.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ChatMessageCell preferredHeightWithInputText:@"abcde"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"message cell"];
    
    if (cell == nil) {
        cell = [[ChatMessageCell alloc]init];
    }
   
    GotyeOCMessage* m = [current_message objectAtIndex:indexPath.row];
    cell.message = m;
    
    return cell;
    
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
//    }
//   
//    GotyeOCMessage* m = [current_message objectAtIndex:indexPath.row];
//    cell.textLabel.text = m.text;
// 
//    NSString* photo_name = nil;
//    NSPredicate* pred = [NSPredicate predicateWithFormat:@"user_id=%@", m.sender.name];
//    NSArray* talker = [current_talk_users filteredArrayUsingPredicate:pred];
//    if (talker.count != 0) {
//        photo_name = [talker.firstObject objectForKey:@"screen_photo"];
//    } else {
//        NSDictionary* one_user = [_lm querMultipleProlfiles:@[m.sender.name]].firstObject;
//        [current_talk_users addObject:one_user];
//        photo_name = [one_user objectForKey:@"screen_photo"];
//    }
//    
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
//    
//    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
//        if (success) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (self) {
//                    cell.imageView.image = user_img;
//                    NSLog(@"owner img download success");
//                }
//            });
//        } else {
//            NSLog(@"down load owner image %@ failed", photo_name);
//        }
//    }];
//    
//    if (userImg == nil) {
//        userImg = [UIImage imageNamed:filePath];
//    }
//    [cell.imageView setImage:userImg];
//    
//    return cell;
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
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

#pragma mark -- textfield delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self moveView:-250];
}

- (void)textViewDidChange:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self moveView:+250];
        [textView resignFirstResponder];
        
        GotyeOCRoom* room = [GotyeOCRoom roomWithId:_group_id.longLongValue];
        GotyeOCMessage* m = [GotyeOCMessage createTextMessage:room text:textView.text];
        [GotyeOCAPI sendMessage:m];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self moveView:-250];
//}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self moveView:+250];
//    [textField resignFirstResponder];
//    
//    GotyeOCRoom* room = [GotyeOCRoom roomWithId:_group_id.longLongValue];
//    GotyeOCMessage* m = [GotyeOCMessage createTextMessage:room text:textField.text];
//    [GotyeOCAPI sendMessage:m];
//    return YES;
//}

#pragma mark -- emoji
- (void)keyboardDidShow:(NSNotification*)notification {
    UIView *result = nil;
    NSArray *windowsArray = [UIApplication sharedApplication].windows;
    for (UIView *tmpWindow in windowsArray) {
        NSArray *viewArray = [tmpWindow subviews];
        for (UIView *tmpView  in viewArray) {
            NSLog(@"%@", [NSString stringWithUTF8String:object_getClassName(tmpView)]);
//            if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIPeripheralHostView"]) {
            if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIInputSetContainerView"]) {
                result = tmpView;
                break;
            }
        }
        
        if (result != nil) {
            break;
        }
    }
    
    keyboardView = result;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
    
    if (isEmoji) {
        [emoji removeFromSuperview];
        emoji.frame = keyBoardFrame;
        [keyboardView addSubview:emoji];
        [keyboardView bringSubviewToFront:emoji];
    }
}

- (IBAction)emojiBtnSelected {
    
//    if (isEmoji == NO) {
//        [_inputField becomeFirstResponder];
//        isEmoji = YES;
//        
//        if (keyboardView) {
//            [emoji removeFromSuperview];
//            emoji.frame = keyBoardFrame;
//            [keyboardView addSubview:emoji];
//            [keyboardView bringSubviewToFront:emoji];
//        }
//    } else {
//        [emoji removeFromSuperview];
//        isEmoji = NO;
//    }
}

- (void)ChatEmojiSelected:(NSString*)emoji_str {
//    _inputField.text = [_inputField.text stringByAppendingString:emoji_str];
//    NSLog(@"text now is: %@", _inputField.text);
}

@end
