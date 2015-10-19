//
//  ChatGroupController.m
//  BabySharing
//
//  Created by Alfred Yang on 19/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "ChatGroupController.h"
#import "MessageChatGroupHeader.h"
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

@interface ChatGroupController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GotyeOCDelegate, ChatEmoji>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *funcBtn;
@property (weak, nonatomic) IBOutlet UIView *inputContainer;

@end

@implementation ChatGroupController {
    UIButton* chatBtn;
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
@synthesize inputField = _inputField;
@synthesize faceBtn = _faceBtn;
@synthesize funcBtn = _funcBtn;
@synthesize inputContainer = _inputContainer;

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
    
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去除表框
    [_queryView registerNib:[UINib nibWithNibName:@"MessageChatGroupHeader" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"chat group header"];
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    
    chatBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, height - 38, 30, 30)];
    chatBtn.layer.borderColor = [UIColor blueColor].CGColor;
    chatBtn.layer.borderWidth = 1.f;
    chatBtn.layer.cornerRadius = 15.f;
    chatBtn.clipsToBounds = YES;
    [chatBtn addTarget:self action:@selector(chatBtnSelected) forControlEvents:UIControlEventTouchDown];
    [chatBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Chat" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:chatBtn];
    [self.view bringSubviewToFront:chatBtn];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - 38, height - 38, 30, 30)];
    backBtn.layer.borderColor = [UIColor blueColor].CGColor;
    backBtn.layer.borderWidth = 1.f;
    backBtn.layer.cornerRadius = 15.f;
    backBtn.clipsToBounds = YES;
    [backBtn addTarget:self action:@selector(backBtnSelected) forControlEvents:UIControlEventTouchDown];
    [backBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Previous" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [self.view bringSubviewToFront:backBtn];
  
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
                [self setFounderInfoForChatGroupHeader:(MessageChatGroupHeader*)tmp];
                [self setGroupInfoForChatGroupHeader:(MessageChatGroupHeader*)tmp];
                [_queryView reloadData];
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
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLayoutSubviews {
    if ([_inputField isFirstResponder]) {
        CGFloat move = 299;
        CGRect rc_start = _queryView.frame;
        CGRect rc_end = CGRectMake(rc_start.origin.x, rc_start.origin.y, rc_start.size.width, rc_start.size.height - move);

        CGRect input_start = _inputContainer.frame;
        CGRect input_end = CGRectMake(input_start.origin.x, input_start.origin.y - move, input_start.size.width, input_start.size.height);
        
        _queryView.frame = rc_end;
        _inputContainer.frame = input_end;
    }
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
           
            MessageChatGroupHeader* tmp = (MessageChatGroupHeader*)[_queryView headerViewForSection:0];
            current_talk_users = [result objectForKey:@"result"];
            [tmp setChatGroupUserList:current_talk_users];
            
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
        [_queryView reloadData];
    });
}

- (void)onSendMessage:(GotyeStatusCode)code message:(GotyeOCMessage *)message {
    [current_message addObject:message];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_queryView reloadData];
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
    [_inputField becomeFirstResponder];
    [self moveView:-250];
}

- (void)backBtnSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setGroupInfoForChatGroupHeader:(MessageChatGroupHeader*)header {
    [header setChatGroupThemeTitle:_group_name];
    [header setCHatGroupJoinerNumber:_joiner_count];
}

- (void)setFounderInfoForChatGroupHeader:(MessageChatGroupHeader*)header {
    [header setFounderScreenName:[founder_dic objectForKey:@"screen_name"]];
    [header setFounderScreenPhoto:[founder_dic objectForKey:@"screen_photo"]];
    [header setFounderRelations:[founder_dic objectForKey:@"relations"]];
    [header setFounderRoleTag:[founder_dic objectForKey:@"role_tag"]];
}

#pragma mark -- table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [MessageChatGroupHeader preferredHeight];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MessageChatGroupHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"chat group header"];
    
    if (header == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageChatGroupHeader" owner:self options:nil];
        header = [nib objectAtIndex:0];
    }
   
    [self setFounderInfoForChatGroupHeader:header];
    [self setGroupInfoForChatGroupHeader:header];
    [header setChatGroupUserList:current_talk_users];
    return header;
}

#pragma mark -- table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return current_message.count;
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
    move = move > 0 ? move + 49 : move - 49;
    CGRect rc_start = _queryView.frame;
    CGRect rc_end = CGRectMake(rc_start.origin.x, rc_start.origin.y, rc_start.size.width, rc_start.size.height + move);
    
    CGRect input_start = _inputContainer.frame;
    CGRect input_end = CGRectMake(input_start.origin.x, input_start.origin.y + move, input_start.size.width, input_start.size.height);
    
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      _queryView.frame = INTUInterpolateCGRect(rc_start, rc_end, progress);
                                      _inputContainer.frame = INTUInterpolateCGRect(input_start, input_end, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

#pragma mark -- textfield delegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self moveView:-250];
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self moveView:+250];
    [textField resignFirstResponder];
    
    GotyeOCRoom* room = [GotyeOCRoom roomWithId:_group_id.longLongValue];
    GotyeOCMessage* m = [GotyeOCMessage createTextMessage:room text:textField.text];
    [GotyeOCAPI sendMessage:m];
    return YES;
}

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
    
    if (isEmoji == NO) {
        [_inputField becomeFirstResponder];
        isEmoji = YES;
        
        if (keyboardView) {
            [emoji removeFromSuperview];
            emoji.frame = keyBoardFrame;
            [keyboardView addSubview:emoji];
            [keyboardView bringSubviewToFront:emoji];
        }
    } else {
        [emoji removeFromSuperview];
        isEmoji = NO;
    }
}

- (void)ChatEmojiSelected:(NSString*)emoji_str {
    _inputField.text = [_inputField.text stringByAppendingString:emoji_str];
    NSLog(@"text now is: %@", _inputField.text);
}

@end
