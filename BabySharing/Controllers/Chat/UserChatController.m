//
//  UserChatController.m
//  BabySharing
//
//  Created by Alfred Yang on 11/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "UserChatController.h"
#import "GotyeOCAPI.h"
#import "INTUAnimationEngine.h"
#import "AppDelegate.h"

#import "RemoteInstance.h"
#import "ModelDefines.h"

#import "Targets.h"
#import "GotyeOCMessage.h"
#import "TmpFileStorageModel.h"
#import "LoginToken.h"

#import "ChatEmojiView.h"
#import "ChatMessageCell.h"

@interface UserChatController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, ChatEmoji>
@property (weak, nonatomic) IBOutlet UIButton *funcBtn;
@property (weak, nonatomic) IBOutlet UIButton *emojiBtn;
@property (weak, nonatomic) IBOutlet UIView *inputContainer;
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@end

@implementation UserChatController {
    UIView* keyboardView;
    ChatEmojiView* emoji;
    CGRect keyBoardFrame;
    BOOL isEmoji;
}

@synthesize chat_user_id = _chat_user_id;
@synthesize chat_user_name = _chat_user_name;
@synthesize chat_user_photo = _chat_user_photo;

@synthesize lm = _lm;
@synthesize mm = _mm;

@synthesize funcBtn = _funcBtn;
@synthesize emojiBtn = _emojiBtn;
@synthesize queryView = _queryView;
@synthesize inputContainer = _inputContainer;
@synthesize inputField =_inputField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去除表框
   
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (_lm == nil) {
        _lm = app.lm;
    }
    
    if (_mm == nil) {
        _mm = app.mm;
    }
    
    if (_chat_user_name == nil || _chat_user_photo == nil) {
        dispatch_queue_t up = dispatch_queue_create("Get Profile Details", nil);
        dispatch_async(up, ^{
            
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:_lm.current_auth_token forKey:@"query_auth_token"];
            [dic setValue:_lm.current_user_id forKey:@"query_user_id"];
            [dic setValue:_chat_user_id forKey:@"owner_user_id"];
            
            NSError * error = nil;
            NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
            
            NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_QUERY_DETAILS]]];
            
            if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
                NSDictionary* dic_profile_details = [result objectForKey:@"result"];
                Targets* t = [_mm addTarget:dic_profile_details];
                _chat_user_name = t.target_name;
                _chat_user_photo = t.target_photo;
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_queryView reloadData];
                });
                
            } else {
                NSDictionary* reError = [result objectForKey:@"error"];
                NSString* msg = [reError objectForKey:@"message"];
                
                NSLog(@"query user profile failed");
                NSLog(@"%@", msg);
            }
        });
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    emoji = [[ChatEmojiView alloc]init];
    emoji.delegate = self;
    
    [_queryView registerClass:[ChatMessageCell class] forCellReuseIdentifier:@"message cell"];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    NSString* filepath = [resourceBundle pathForResource:@"Previous_blue" ofType:@"png"];
    NSString* filepath = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, 13, 20);
    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
//    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
//    [barBtn setImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];

    UILabel* label = [[UILabel alloc]init];
    label.text = _chat_user_name;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mm beginActiveForTarget:_chat_user_id];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mm endActiveForTarget:_chat_user_id];
    [emoji removeFromSuperview];
}

- (void)viewDidLayoutSubviews {
    if ([_inputField isFirstResponder]) {
        CGFloat move = 250;
        CGRect rc_start = _queryView.frame;
        CGRect rc_end = CGRectMake(rc_start.origin.x, rc_start.origin.y, rc_start.size.width, rc_start.size.height - move);

        CGRect input_start = _inputContainer.frame;
        CGRect input_end = CGRectMake(input_start.origin.x, input_start.origin.y - move, input_start.size.width, input_start.size.height);
        
        _queryView.frame = rc_end;
        _inputContainer.frame = input_end;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- uitableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_mm getAllMessagesWithTarget:_chat_user_id andTargetType:MessageReceiverTypeUser].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GotyeOCMessage* m = [[_mm getAllMessagesWithTarget:_chat_user_id andTargetType:MessageReceiverTypeUser] objectAtIndex:indexPath.row];
    return [ChatMessageCell preferredHeightWithInputText:m.text];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    ChatMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"message cell"];
    
    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
//        cell = [[ChatMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"message cell"];
        cell = [[ChatMessageCell alloc]init];
    }
   
    GotyeOCMessage* m = [[_mm getAllMessagesWithTarget:_chat_user_id andTargetType:MessageReceiverTypeUser] objectAtIndex:indexPath.row];
    
    cell.message = m;
    
//    cell.textLabel.text = m.text;
// 
//    NSString* photo_name = nil;
//    if ([m.sender.name isEqualToString:_chat_user_id]) {
//        photo_name = _chat_user_photo;
//    } else {
//        photo_name = _lm.getCurrentUser.who.screen_image;
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
    
    return cell;
}

#pragma mark -- move view when chat
- (void)moveView:(float)move {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGRect rc_start = _queryView.frame;
//    CGRect rc_end = CGRectMake(rc_start.origin.x, rc_start.origin.y + move, rc_start.size.width, rc_start.size.height);
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
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self moveView:-250];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self moveView:+250];
    [textField resignFirstResponder];
    keyboardView = nil;
    [_mm sendMessageToUser:_chat_user_id messageType:MessageTypeTextMessage messageContent:textField.text];
    [_queryView reloadData];
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
