//
//  ChatViewController.m
//  ChatModel
//
//  Created by Alfred Yang on 5/05/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageModel.h"
//#import "Messages.h"
#import "SRWebSocket.h"
#import "ModelDefines.h"
#import "EnumDefines.h"
#import "AppDelegate.h"
#import "MessageModel.h"
#import "UserHeadView.h"
#import "INTUAnimationEngine.h"
#import "ChatViewCell.h"

#define HEAD_VIEW_WIDTH     32
#define HEAD_VIEW_MARGIN    3

//@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate, SRWebSocketDelegate, UITextFieldDelegate>
@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIView *resentUserView;

@property (weak, nonatomic, readonly) NSString* current_user_id;
@property (weak, nonatomic, readonly) MessageModel* mm;
@end

@implementation ChatViewController {
    BOOL _isLoading;
    NSArray* _chat_list;
    BOOL _isWebSocketConnecting;
    SRWebSocket* _socket;
}

@synthesize queryView = _queryView;
@synthesize messageTextField = _messageTextField;
@synthesize group = _group;
@synthesize sub_group = _sub_group;
@synthesize mm = _mm;
@synthesize resentUserView = _resentUserView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isLoading = NO;
    _isWebSocketConnecting = NO;
    
    _messageTextField.delegate = self;

    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _current_user_id = delegate.lm.current_user_id;
    _mm = delegate.mm;
//    NSString* url = [MESSAGE_WEB_SOCKET_SENDBOX stringByAppendingString:_current_user_id];
//    NSString* url = [MESSAGE_WEB_SOCKET stringByAppendingString:_current_user_id];
    
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    _socket = [[SRWebSocket alloc]initWithURLRequest:request];
//    _socket.delegate = self;

    /**
     * chat view cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"ChatViewOtherCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OtherCell"];
    
    [_queryView registerNib:[UINib nibWithNibName:@"ChatViewOwnerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OwnerCell"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadChatMessage];
    [_socket open];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_socket close];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger total = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
        
        cell.textLabel.text = @"refreshing...";
        return cell;
    } else if (indexPath.row == total - 1){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
        
        cell.textLabel.text = @"athena";
        return cell;
    } else {
       
//        Messages* cur = [self enumMessageAtIndex:indexPath.row - 1];
//        ChatViewCell* cell = nil;
//        if ([cur.owner isEqualToString:_current_user_id]) {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"OwnerCell"];
//            
//            if (cell == nil) {
//                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatViewOwnerCell" owner:self options:nil];
//                cell = [nib objectAtIndex:0];
//            }
//            
//        } else {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell"];
//            
//            if (cell == nil) {
//                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatViewOtherCell" owner:self options:nil];
//                cell = [nib objectAtIndex:0];
//            }           
//        }
//
//        cell.chat_content = [NSString stringWithFormat:@"%@ (%@)",
//                               [self enumMessageContentAtIndex:indexPath.row - 1],
//                               [self enumMessageDateAtIndex:indexPath.row - 1]];
//        cell.user_id = cur.owner;
//        
//        return cell;
        return nil;
    }
}

- (NSString*)enumMessageContentAtIndex:(NSInteger)index {
//    return ((Messages*)[_chat_list objectAtIndex:index]).content;
    return nil;
}

- (NSString*)enumMessageDateAtIndex:(NSInteger)index {
//    NSDate* date = ((Messages*)[_chat_list objectAtIndex:index]).date;
    NSDate* date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
//    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    [dateFormatter setLocale:usLocale];
    
    [dateFormatter setDateFormat:@"MMM dd HH:mm"];
    
    return [dateFormatter stringFromDate:date];
}

- (MessageType)enumMessageTypeAtIndex:(NSInteger)index {
    return MessageTypeTextMessage;
}

- (MessageStatus)enumMessageStatusAtIndex:(NSInteger)index {
//    Messages* m = ((Messages*)[_chat_list objectAtIndex:index]);
//    return (MessageStatus)m.status.intValue;
    return MessagesStatusReaded;
}
            
- (Messages*)enumMessageAtIndex:(NSInteger)index {
   return ((Messages*)[_chat_list objectAtIndex:index]);
}

- (NSInteger)enumChatsCounts{
    return _chat_list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2 + [self enumChatsCounts];
}

#pragma mark -- scroll refresh
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 假设偏移表格高度的20%进行刷新
    if (!_isLoading) { // 判断是否处于刷新状态，刷新中就不执行
        // 取内容的高度：
        // 如果内容高度大于UITableView高度，就取TableView高度
        // 如果内容高度小于UITableView高度，就取内容的实际高度
        float height = scrollView.contentSize.height > _queryView.frame.size.height ?_queryView.frame.size.height : scrollView.contentSize.height;
        if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2) { // 调用上拉刷新方
            
            NSLog(@"append chats");
            // append comments
            CGRect rc = _queryView.frame;
            rc.origin.y = rc.origin.y - 44;
            [_queryView setFrame:rc];
            
//            sleep(2);
            _isLoading = YES;
            rc.origin.y = rc.origin.y + 44;
            [_queryView setFrame:rc];
        }
        
        if (- scrollView.contentOffset.y / _queryView.frame.size.height > 0.2) { // 调用下拉刷新方法
            
            NSLog(@"refresh chats");
            CGRect rc = _queryView.frame;
            rc.origin.y = rc.origin.y + 44;
            [_queryView setFrame:rc];
            
//            _chat_list = [_mm loadMessagesWithTargetID:_target_id];
            [self reloadChatMessage];
            _isLoading = YES;
            rc.origin.y = rc.origin.y - 44;
            [_queryView setFrame:rc];
        }
    }
    _isLoading = NO;
}

- (void)reloadChatMessage {
//    NSIndexPath* p = [NSIndexPath indexPathForRow:[self enumChatsCounts] inSection:0];
//    [_queryView scrollToRowAtIndexPath:p atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (IBAction)didSelectSendBtn {
//    [_mm addMessageToTarget:_target_id Content:txt];
//    _chat_list = [_mm localMessagesWithTargetID:_target_id];
//    [_queryView reloadData];
//    
//    // add this to historical chat
//    [_mm addFriendToHistoryChat:_target_id];
    
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:_target.owner.user_id forKey:@"user_id"];
//    [dic setValue:_target_id forKey:@"receiver"];
//    [dic setValue:[NSNumber numberWithInt: MessageTypeTextMessage] forKey:@"message_type"];
//    [dic setValue:txt forKey:@"message_content"];
    
//    [dic setValue:@"123" forKey:@"text"];
    
    
//    NSError * error = nil;
//    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
//    NSString* txt = _messageTextField.text;
    
//    if (txt.length != 0) {
//        NSString* jsonData = [NSString stringWithFormat: @"{\"method\":\"message\", \"user_id\":\"%@\", \"receiver_type\":%d, \"receiver\":\"%@\", \"message_type\":%d, \"message_content\":\"%@\"}", _current_user_id, (int)MessageReceiverTypeTmpGroup, _sub_group.sub_group_id, (int)MessageTypeTextMessage, txt];
//    
//        [_socket send:jsonData];
    
//        [_mm addMessageToTarget:_target_id Content:txt];
//        _chat_list = [_mm localMessagesWithTargetID:_target_id];
//        [_queryView reloadData];
    
        // add this to historical chat
//        [_mm addFriendToHistoryChat:_target_id];
//    }
}

//#pragma mark -- SRWebSocketDelegate
//- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
//    NSString *receiveData = message;
//    NSData *utf8Data = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
////    NSData* data = (NSData*)message;
//    NSLog(@"%@", utf8Data);
//   
//    NSError * error = nil;
//    NSDictionary * apperals = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:&error];
//    NSLog(@"%@", apperals);
//
//    if ([[apperals objectForKey:@"method"] isEqualToString:@"message"]) {
//        [_mm addMessageWithData:apperals];
//        _chat_list = [_mm queryAllMessagesWithReceiver:_sub_group.sub_group_id andUser:_current_user_id];
//        [_queryView reloadData];
//    } else if ([[apperals objectForKey:@"method"] isEqualToString:@"joinTmpGroup"]) {
//        if ([[apperals objectForKey:@"status"] isEqualToString:@"success"]) {
//            NSLog(@"joinTmpGroup success");
//            NSArray* arr = [apperals objectForKey:@"resent_users"];
//          
//            for (UserHeadView* uv in _resentUserView.subviews) {
//                [uv removeFromSuperview];
//            }
//            
//            for (NSInteger index = 0; index < arr.count; ++index) {
//               
//                CGFloat origin_x = HEAD_VIEW_MARGIN + index * HEAD_VIEW_WIDTH;
//                CGFloat origin_y = HEAD_VIEW_MARGIN;
//                UserHeadView* uv = [[UserHeadView alloc]initWithFrame:CGRectMake(origin_x, origin_y, HEAD_VIEW_WIDTH, HEAD_VIEW_WIDTH)];
//         
//                uv.backgroundColor = [UIColor redColor];
//                [_resentUserView addSubview:uv];
//                uv.user_id = [arr objectAtIndex:index];
//            }
//        }
//    }
//}
//
//- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
//    NSLog(@"Opened success");
//    NSString* jsonData = [NSString stringWithFormat: @"{\"method\":\"joinTmpGroup\", \"user_id\":\"%@\", \"receiver\":\"%@\"}", _current_user_id, _sub_group.sub_group_id];
//    [_socket send:jsonData];
//}
//
//- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
//    NSLog(@"Web Socket error: %@", error.description);
//}
//
//- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
//    NSLog(@"Close web socket");
//}

#pragma mark -- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *) textField
{
//    currentTextField = _messageTextField;
    if (textField.tag==0) {
        [self moveView:-250];
    }
    if (textField.tag==1) {
        [self moveView:-600];
    }
}

- (void)textFieldDidEndEditing:(UITextField *) textField
{
//    currentTextField = nil;
    if (textField.tag==0) {
        [self moveView:250];
    }
    if (textField.tag==1) {
        [self moveView:600];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *) textFiel
{
    [self respondsToSelector:nil];
    [_messageTextField endEditing:YES];
    return TRUE;
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

@end
