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

@interface CycleViewController () <UITableViewDataSource, UITableViewDelegate, DropDownMenuProcotol, WEPopoverControllerDelegate, UIPopoverControllerDelegate, createUpdateDetailProtocol>
//@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UITableView *cycleTableView;

@property (weak, nonatomic) LoginModel* lm;
@property (weak, nonatomic) MessageModel* mm;
@property (weak, nonatomic) Reachability* ry;

@property (weak, nonatomic) id<CycleSyncDataProtocol> notifyObject;
@end

@implementation CycleViewController {
	WEPopoverController *popoverController;
    
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

//- (void)setUpDescriptionView {
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    
//    NSString* str = @"丰富自己的描述，找到属于自己的圈子";
//    UIFont* font = [UIFont systemFontOfSize:17.f];
//    CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
//    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 66)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = str;
//    label.backgroundColor = [UIColor lightGrayColor];
//    label.textColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
//    [_descriptionView addSubview:label];
//    
//    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    btn.layer.cornerRadius = 50.f;
//    btn.clipsToBounds = YES;
//   
//    CALayer* outer_layer = [CALayer layer];
//    outer_layer.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:0.3].CGColor;
//    outer_layer.bounds = CGRectMake(0, 0, 100, 100);
//    outer_layer.position = CGPointMake(btn.frame.size.width / 2, btn.frame.size.height / 2);
//    [btn.layer addSublayer:outer_layer];
//    
//    CALayer* mid_layer = [CALayer layer];
//    mid_layer.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.8941 alpha:1.f].CGColor;
//    mid_layer.bounds = CGRectMake(0, 0, 80, 80);
//    mid_layer.cornerRadius = mid_layer.bounds.size.width / 2;
//    mid_layer.masksToBounds = YES;
//    mid_layer.position = CGPointMake(btn.frame.size.width / 2, btn.frame.size.height / 2);
//    [btn.layer addSublayer:mid_layer];
//
//    CALayer* inner_layer = [CALayer layer];
//    inner_layer.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f].CGColor;
//    inner_layer.bounds = CGRectMake(0, 0, 60, 60);
//    inner_layer.cornerRadius = inner_layer.bounds.size.width / 2;
//    inner_layer.masksToBounds = YES;
//    inner_layer.position = CGPointMake(btn.frame.size.width / 2, btn.frame.size.height / 2);
//    [btn.layer addSublayer:inner_layer];
//    
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setTitle:@"描述" forState:UIControlStateNormal];
//    [btn setFont:[UIFont systemFontOfSize:14.f]];
//    btn.center = CGPointMake(width / 2, height / 2 - 100);
//    [_descriptionView addSubview:btn];
//    [btn addTarget:self action:@selector(addDescriptionBtnSelected) forControlEvents:UIControlEventTouchDown];
//    
//    UILabel* label_2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, size.height + 10)];
//    label_2.textAlignment = NSTextAlignmentCenter;
//    label_2.text = @"了解更多";
//    label_2.textColor = [UIColor redColor];
//    label_2.center = CGPointMake(btn.center.x, btn.center.y + 100);
//    [_descriptionView addSubview:label_2];
//    
//    UILabel* label_3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, size.width + 10)];
//    label_3.textAlignment = NSTextAlignmentCenter;
//    label_3.text = @"... ...";
//    label_3.textColor = [UIColor redColor];
//    label_3.center = CGPointMake(btn.center.x, btn.center.y + 100 + size.height + 20);
//    [_descriptionView addSubview:label_3];
//   
//    _descriptionView.backgroundColor = [UIColor whiteColor];   
//}

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
//    if (dic_description && dic_description.count > 1) {
//    if ([self isDescriptionValidate]) {
//        _cycleTableView.hidden = NO;
//        _descriptionView.hidden = YES;
//    } else {
//        _cycleTableView.hidden = YES;
//        _descriptionView.hidden = NO;
//    }
    _cycleTableView.hidden = NO;
}

- (void)viewDidLayoutSubviews {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
  
    CGRect rc = CGRectMake(0, TABLE_VIEW_TOP_MARGIN, width, height);
//    _descriptionView.frame = rc;
    _cycleTableView.frame = rc;
    
    [self resetViews];
}

- (BOOL)hasViewDescription {
    return [_lm isCurrentHasDetailInfo];
//    return YES;
}

- (void)addDescriptionBtnSelected {
    [self performSegueWithIdentifier:@"addDescription" sender:nil];
}

#pragma mark -- table view delegate
/*改变删除按钮的title*/
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    
    UITableViewRowAction * act = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删 除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView.dataSource tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }];
    act.backgroundColor = [UIColor colorWithRed:0.2745 green:0.8588 blue:0.7922 alpha:1.f];

    UITableViewRowAction * act2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取 消" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView endEditing:YES];
        
    }];
    act2.backgroundColor = [UIColor colorWithRed:0.6078 green:0.6078 blue:0.6078 alpha:1.f];
    
    return @[act2, act];
}


/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.row > 0) {
        NSLog(@"delete one row");
//        GotyeOCChatTarget* gotTarget = [_mm getTargetByIndex:indexPath.row - 1];
//        [GotyeOCAPI deleteSession:gotTarget alsoRemoveMessages:YES];
//        [tableView reloadData];
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // TODO: segue to user chat
    [self performSegueWithIdentifier:@"enterChatGroup" sender:indexPath];
    
//    Targets* tmp = nil;
//    if (indexPath.section == 0) {
//        tmp = [chatGroupArray_mine objectAtIndex:indexPath.row];
//    } else {
//        tmp = [chatGroupArray_recommend objectAtIndex:indexPath.row];
//    }
//    [self backToHomeThenPushChatGroup:tmp];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isRecommmend) return 2;
    else return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* reVal = [[UIView alloc]init];
    reVal.backgroundColor = [UIColor whiteColor];
//    reVal.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    if (section == 0) {
//        label.text = @"我的圈子";
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
    
//    if (section == 0) {
//        MyCycleCellHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"my cycle header"];
//        if (header == nil) {
//            header = [[MyCycleCellHeader alloc]init];
//        }
//       
//        header.role_tag = @"tags";
//        [header viewLayoutSubviews];
//        return header;
//        
//    } else if (section == 1) {
//        return nil;
//        
//    } else {
//        return nil;
//    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return [MyCycleCellHeader preferHeight];
//    } else {
//        return 44;
//    }
//    return 34;
    return 46;
}

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 1) {
//        return @"推荐";
//    } return nil;
//}

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
    
    cell.themeLabel.text = tmp.target_name;
    
    return cell;
}

- (void)plusBtnSelected:(id)sender {

    if (!popoverController) {
     
        NSArray* arr = nil;
//        if (_descriptionView.hidden == NO) {
            arr = @[@"创建圈子", @"编辑描述", @"更多推荐", @"取消"];
//        } else {
//            if (isRecommmend) arr = @[@"编辑描述", @"更多推荐", @"关闭圈子推荐", @"取消"];
//            else arr = @[@"编辑描述", @"更多推荐", @"开启圈子推荐", @"取消"];
//        }
        
//        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        DropDownMenu* menu = [[DropDownMenu alloc]init];
        [menu setMenuText:arr];
        menu.dropdownDelegate = self;
        
        popoverController = [[WEPopoverController alloc] initWithContentViewController:menu];
        popoverController.delegate = self;
        popoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
        
//        [popoverController presentPopoverFromBarButtonItem:sender
        [popoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                                  permittedArrowDirections:(UIPopoverArrowDirectionUp)
                                                  animated:YES];
        
    } else {
        [popoverController dismissPopoverAnimated:YES];
        popoverController = nil;
    }
}


#pragma mark -- drop down menu
- (void)dropDownMenu:(DropDownMenu *)menu didSelectMuneItemAtIndex:(NSInteger)index {
   
//    if (_descriptionView.hidden == NO && index == 0) {
//        [self performSegueWithIdentifier:@"addCycle" sender:nil];
//    } else if (_descriptionView.hidden == YES && index == 0) {
//        [self performSegueWithIdentifier:@"addDescription" sender:nil];
//    } else if (_descriptionView.hidden == NO && index == 1) {
//        [self performSegueWithIdentifier:@"addDescription" sender:nil];
//    }
    
    if (index == 0) {
        [self performSegueWithIdentifier:@"addCycle" sender:nil];
    } else if (index == 1) {
        [self performSegueWithIdentifier:@"addDescription" sender:nil];
    }
    
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;
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
