//
//  CycleViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleViewController.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "MessageModel.h"
#import "DropDownMenu.h"
#import "WEPopoverController.h"
#import "MyCycleCellHeader.h"

#import "CycleAddDescriptionViewController.h"
#import "CycleDetailController.h"

#import "Reachability.h"
#import "CycleOverCell.h"
#import "Targets.h"

#import "ChatGroupController.h"
#import "INTUAnimationEngine.h"
#import "HomeViewController.h"

#define TABLE_VIEW_TOP_MARGIN   74

/*DropDownMenuProcotol, WEPopoverControllerDelegate, UIPopoverControllerDelegate,*/
@interface CycleViewController () <UITableViewDataSource, UITableViewDelegate,  createUpdateDetailProtocol>
@property (weak, nonatomic) IBOutlet UITableView *cycleTableView;

@property (weak, nonatomic) LoginModel* lm;
@property (weak, nonatomic) MessageModel* mm;
@property (weak, nonatomic) Reachability* ry;

@property (weak, nonatomic) id<CycleSyncDataProtocol> notifyObject;
@end

@implementation CycleViewController {
//	WEPopoverController *popoverController;
    
    NSMutableDictionary* dic_description;
    BOOL isSync;
    
    BOOL isRecommmend;
    
    NSArray* chatGroupArray_mine;
    NSArray* chatGroupArray_recommend;
}

//@synthesize descriptionView = _descriptionView;
@synthesize cycleTableView = _cycleTableView;

@synthesize lm = _lm;
@synthesize mm = _mm;
@synthesize ry = _ry;

@synthesize notifyObject = _notifyObject;

@synthesize baseController = _baseController;

- (void)viewDidLoad {
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.f]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        [[UINavigationBar appearance] setShadowImage:[self imageWithColor:[UIColor colorWithWhite:0.5922 alpha:0.25] size:CGSizeMake(width, 1)]];
        [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(width, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    CALayer* line_notify = [CALayer layer];
    line_notify.borderWidth = 1.f;
    line_notify.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    line_notify.frame = CGRectMake(0, 73, width, 1);
    [self.view.layer addSublayer:line_notify];

    _cycleTableView.dataSource = self;
    _cycleTableView.delegate = self;
    [_cycleTableView registerNib:[UINib nibWithNibName:@"CycleOverCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cycle over cell"];
    [_cycleTableView registerClass:[MyCycleCellHeader class] forHeaderFooterViewReuseIdentifier:@"my cycle header"];
   
    self.preferredContentSize = CGSizeMake(100, 100);
    
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _lm = app.lm;
    _mm = app.mm;
    _ry = app.reachability;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];

    isRecommmend = NO;
    isSync = NO;
  
    if (_ry.isReachable) {
        [self resetDataForViews];
    }
    
    UILabel* label_t = [[UILabel alloc]init];
    label_t.text = @"圈聊";
    label_t.textColor = [UIColor colorWithRed:0.3059 green:0.3059 blue:0.3059 alpha:1.f];
    label_t.font = [UIFont systemFontOfSize:18.f];
    [label_t sizeToFit];
    self.navigationItem.titleView = label_t;
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(-12, 0, 25, 25);
//    layer.position = CGPointMake(barBtn.frame.size.width / 2, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
    [barBtn addTarget:self action:@selector(didPopViewController) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    self.view.backgroundColor = [UIColor colorWithRed:0.9529 green:0.9529 blue:0.9529 alpha:1.f];
    
    _cycleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didPopViewController {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    dic_description = [[_lm currentDeltailInfoLocal] mutableCopy];
    chatGroupArray_mine = [_mm enumMyChatGroupLocal];
    chatGroupArray_recommend = [_mm enumRecommendChatGroupLocal];
    [self viewDidLayoutSubviews];
}

- (void)reachabilityChanged:(Reachability*)sender {
    
    if (self.tabBarController.selectedIndex != 1) return;
    
    if ([sender isReachable]) {
        [self resetDataForViews];

    } else if (![sender isReachable]) {
        isSync = NO;
        [_notifyObject detailInfoSynced:isSync];
    }
}

- (void)resetDataForViews {
    [_lm currentDeltailInfoAsyncWithFinishBlock:^(BOOL success, NSDictionary * dic) {
        if (success) {
            dic_description = [dic mutableCopy];
            [_lm updateDetailInfoLocalWithData:dic];
            [_mm enumChatGroupWithFinishBlock:^(BOOL success, NSArray* result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    chatGroupArray_mine = [_mm enumMyChatGroupLocal];
                    chatGroupArray_recommend = [_mm enumRecommendChatGroupLocal];
                    [_cycleTableView reloadData];
                });
            }];
            if (dic_description.count > 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self resetViews];
                });
            }
            isSync = YES;
            [_notifyObject detailInfoSynced:isSync];
        }
    }];
}

- (BOOL)isDescriptionValidate {
    return dic_description && dic_description.count > 1 && ((NSNumber*)[dic_description objectForKey:@"age"]).integerValue > 0 && ((NSArray*)[dic_description objectForKey:@"kids"]).count > 0;
}

- (void)resetViews {
    _cycleTableView.hidden = NO;
}

- (void)viewDidLayoutSubviews {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
  
    CGRect rc = CGRectMake(0, TABLE_VIEW_TOP_MARGIN, width, height);
    _cycleTableView.frame = rc;
    
    [self resetViews];
}

- (BOOL)hasViewDescription {
    return [_lm isCurrentHasDetailInfo];
}

- (void)addDescriptionBtnSelected {
    [self performSegueWithIdentifier:@"addDescription" sender:nil];
}

#pragma mark -- table view delegate
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    
    UITableViewRowAction * act = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"退 出" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        /**
         * 1. leave chat group
         */
        Targets* tmp = nil;
        if (indexPath.section == 0) {
            tmp = [chatGroupArray_mine objectAtIndex:indexPath.row];
        } else {
            tmp = [chatGroupArray_recommend objectAtIndex:indexPath.row];
        }
        
        NSNumber* group_id = tmp.group_id;
        
        [_mm leaveChatGroup:group_id andFinishBlock:^(BOOL success, id result) {
            /**
             * 2. table view reload data
             */
            chatGroupArray_mine = [_mm enumMyChatGroupLocal];
            [tableView reloadData];
        }];
        

        
    }];
    act.backgroundColor = [UIColor colorWithRed:0.2745 green:0.8588 blue:0.7922 alpha:1.f];

    UITableViewRowAction * act2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取 消" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView endEditing:YES];
        [tableView reloadData];
        
    }];
    act2.backgroundColor = [UIColor colorWithRed:0.6078 green:0.6078 blue:0.6078 alpha:1.f];
    
    return @[act2, act];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"enterChatGroup" sender:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isRecommmend) return 2;
    else return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* reVal = [[UIView alloc]init];
    reVal.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    if (section == 0) {
        label.text = @"最近关注的";
    } else {
        label.text = @"猜你喜欢";
    }
   
    label.textColor = [UIColor colorWithWhite:0.3509 alpha:1.f];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:12.f];
    [label sizeToFit];
    [reVal addSubview:label];
    
//    label.center = CGPointMake(10.5f + label.frame.size.width / 2, 34 / 2);
    label.center = CGPointMake(10.5f + label.frame.size.width / 2, 46 / 2);
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(10.5, 46 - 1, [UIScreen mainScreen].bounds.size.width - 10.5, 1);
    [reVal.layer addSublayer:line];
    
    return reVal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 46;
}

#pragma mark -- table view datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CycleOverCell preferredHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return chatGroupArray_mine.count;
    else return chatGroupArray_recommend.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    CycleOverCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cycle over cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CycleOverCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    Targets* tmp = nil;
    if (indexPath.section == 0) {
        tmp = [chatGroupArray_mine objectAtIndex:indexPath.row];
    } else {
        tmp = [chatGroupArray_recommend objectAtIndex:indexPath.row];
    }
   
    cell.current_session = tmp;
    
    return cell;
}

#pragma mark -- segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ((UIViewController*)segue.destinationViewController).hidesBottomBarWhenPushed = YES;
    
    if ([segue.identifier isEqualToString:@"addCycle"]) {
    } else if ([segue.identifier isEqualToString:@"addDescription"]) {
        ((CycleAddDescriptionViewController*)segue.destinationViewController).lm = self.lm;
        ((CycleAddDescriptionViewController*)segue.destinationViewController).dic_description = dic_description;
        ((CycleAddDescriptionViewController*)segue.destinationViewController).isEditable = isSync;
        _notifyObject = (CycleAddDescriptionViewController*)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"enterChatGroup"]) {
        
        NSIndexPath* path = (NSIndexPath*)sender;
        Targets* tmp = nil;
        if (path.section == 0) {
            tmp = [chatGroupArray_mine objectAtIndex:path.row];
        } else {
            tmp = [chatGroupArray_recommend objectAtIndex:path.row];
        }
        ((ChatGroupController*)segue.destinationViewController).group_id = tmp.group_id;
        ((ChatGroupController*)segue.destinationViewController).joiner_count = tmp.number_count;
        ((ChatGroupController*)segue.destinationViewController).group_name = tmp.target_name;
        ((ChatGroupController*)segue.destinationViewController).founder_id = tmp.owner_id;
    }
}

#pragma mark -- create update detail chat group
- (void)createUpdateChatGroup:(BOOL)success {
    if (success) {
        chatGroupArray_mine = [_mm enumMyChatGroupLocal];
        chatGroupArray_recommend = [_mm enumRecommendChatGroupLocal];
        [_cycleTableView reloadData];
    }
}

#pragma mark --
- (void)blockTouchEventForOtherViews {
    UIView* block_target = [self.view viewWithTag:-99];
    UIView* block_view = [[UIView alloc]initWithFrame:block_target.bounds];
    block_view.tag = -119;
    block_view.backgroundColor = [UIColor clearColor];
    [block_target addSubview:block_view];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToHome:)];
    [block_view addGestureRecognizer:tap];
}

- (void)backToHome:(UITapGestureRecognizer*)gesture {
   
    static const CGFloat kAnimationDuration = 0.5; // in seconds
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
   
    UIView* target = [gesture.view superview];
    [gesture.view removeFromSuperview];
    CGRect rc_1 = CGRectMake(0, 0, width, height);
    CGRect rc_2 = CGRectMake(width - 100, 0, width, height);

    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      target.frame = INTUInterpolateCGRect(rc_2, rc_1, progress);
                                  }
                                  completion:^(BOOL finished) {
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      [target removeFromSuperview];
                                      [self.navigationController popViewControllerAnimated:NO];
                                  }];
}

- (void)backToHomeThenPushChatGroup:(Targets*)tmp {
    static const CGFloat kAnimationDuration = 0.5; // in seconds
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    UIView* target = [self.view viewWithTag:-99];
    UIView* block_view = [target viewWithTag:-119];
    [block_view removeFromSuperview];
    CGRect rc_1 = CGRectMake(0, 0, width, height);
    CGRect rc_2 = CGRectMake(width - 100, 0, width, height);
    
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      target.frame = INTUInterpolateCGRect(rc_2, rc_1, progress);
                                  }
                                  completion:^(BOOL finished) {
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      [target removeFromSuperview];
                                      [self.navigationController popViewControllerAnimated:NO];
                                      [_baseController pushControllerWithTarget:tmp];
                                  }];
}
@end
