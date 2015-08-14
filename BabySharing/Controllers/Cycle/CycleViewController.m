//
//  CycleViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleViewController.h"
#import "LoginModel.h"
#import "DropDownMenu.h"
#import "WEPopoverController.h"
#import "MyCycleCellHeader.h"

#import "AppDelegate.h"
#import "CycleAddDescriptionViewController.h"

#import "Reachability.h"

@interface CycleViewController () <UITableViewDataSource, UITableViewDelegate, DropDownMenuProcotol, WEPopoverControllerDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UITableView *cycleTableView;

@property (weak, nonatomic) LoginModel* lm;
@property (weak, nonatomic) Reachability* ry;

@property (weak, nonatomic) id<CycleSyncDataProtocol> notifyObject;
@end

@implementation CycleViewController {
	WEPopoverController *popoverController;
    
    NSMutableDictionary* dic_description;
    BOOL isSync;
}

@synthesize descriptionView = _descriptionView;
@synthesize cycleTableView = _cycleTableView;

@synthesize lm = _lm;
@synthesize ry = _ry;

@synthesize notifyObject = _notifyObject;

- (void)viewDidLoad {
    _cycleTableView.dataSource = self;
    _cycleTableView.delegate = self;

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    NSString* str = @"丰富自己的描述，找到属于自己的圈子";
    UIFont* font = [UIFont systemFontOfSize:17.f];
    CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, size.height + 10)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = str;
    label.center = CGPointMake(width / 2, height / 2 - 100);
    [_descriptionView addSubview:label];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width * 0.6, 30)];
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.cornerRadius = 8.f;
    btn.clipsToBounds = YES;
    
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"描述" forState:UIControlStateNormal];
    [btn setFont:[UIFont systemFontOfSize:14.f]];
    btn.center = CGPointMake(label.center.x, label.center.y + 25);
    [_descriptionView addSubview:btn];
    
    UILabel* label_2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, size.height + 10)];
    label_2.textAlignment = NSTextAlignmentCenter;
    label_2.text = @"了解更多";
    label_2.center = CGPointMake(label.center.x, label.center.y + 100);
    [_descriptionView addSubview:label_2];
   
    _descriptionView.backgroundColor = [UIColor whiteColor];
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"Plus2" ofType:@"png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:filepath] style:UIBarButtonItemStylePlain target:self action:@selector(plusBtnSelected:)];
    
    self.preferredContentSize = CGSizeMake(100, 100);
    
    [_cycleTableView registerClass:[MyCycleCellHeader class] forHeaderFooterViewReuseIdentifier:@"my cycle header"];
    
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _lm = app.lm;
    _ry = app.reachability;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
 
    isSync = NO;
    dic_description = [[_lm currentDeltailInfoLocal] mutableCopy];
    [self viewDidLayoutSubviews];
   
    if (_ry.isReachable) {
        [self resetDataForViews];
    }
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

- (void)resetViews {
    if (dic_description && dic_description.count > 1) {
        _cycleTableView.hidden = NO;
        _descriptionView.hidden = YES;
    } else {
        _cycleTableView.hidden = YES;
        _descriptionView.hidden = NO;
    }
}

- (void)viewDidLayoutSubviews {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
   
    CGRect rc = CGRectMake(0, 20 + 44, width, height - 44 - 49);
    _descriptionView.frame = rc;
    _cycleTableView.frame = rc;
    
    if (dic_description && dic_description.count > 1) {
        _cycleTableView.hidden = NO;
        _descriptionView.hidden = YES;
    } else {
        _cycleTableView.hidden = YES;
        _descriptionView.hidden = NO;
    }
}

- (BOOL)hasViewDescription {
    return [_lm isCurrentHasDetailInfo];
//    return YES;
}

#pragma mark -- table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        MyCycleCellHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"my cycle header"];
        if (header == nil) {
            header = [[MyCycleCellHeader alloc]init];
        }
       
        header.role_tag = @"tags";
        [header viewLayoutSubviews];
        return header;
        
    } else if (section == 1) {
        
    } else {
        return nil;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [MyCycleCellHeader preferHeight];
    } else {
        return 44;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"推荐";
    } return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = @"alfred";
    
    return cell;
}

- (void)plusBtnSelected:(id)sender {

    if (!popoverController) {
     
        NSArray* arr = nil;
        if (_descriptionView.hidden == NO) {
            arr = @[@"创建圈子", @"编辑描述", @"取消"];
        } else {
            arr = @[@"更多推荐", @"关闭圈子推荐", @"取消"];
        }
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        DropDownMenu* menu = [[DropDownMenu alloc]init];
        [menu setMenuText:arr];
        menu.dropdownDelegate = self;
        
        popoverController = [[WEPopoverController alloc] initWithContentViewController:menu];
        popoverController.delegate = self;
        popoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
        
        [popoverController presentPopoverFromBarButtonItem:sender
                                  permittedArrowDirections:(UIPopoverArrowDirectionUp)
                                                  animated:YES];
        
    } else {
        [popoverController dismissPopoverAnimated:YES];
        popoverController = nil;
    }
}


#pragma mark -- drop down menu
- (void)dropDownMenu:(DropDownMenu *)menu didSelectMuneItemAtIndex:(NSInteger)index {
   
    if (_descriptionView.hidden == NO && index == 0) {
        [self performSegueWithIdentifier:@"addCycle" sender:nil];
    } else if (_descriptionView.hidden == NO && index == 1) {
        [self performSegueWithIdentifier:@"addDescription" sender:nil];
    }
    
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;
}

#pragma mark -- segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addCycle"]) {
    } else if ([segue.identifier isEqualToString:@"addDescription"]) {
        ((CycleAddDescriptionViewController*)segue.destinationViewController).lm = self.lm;
        ((CycleAddDescriptionViewController*)segue.destinationViewController).dic_description = dic_description;
        ((CycleAddDescriptionViewController*)segue.destinationViewController).isEditable = isSync;
        _notifyObject = (CycleAddDescriptionViewController*)segue.destinationViewController;
    }
}
@end
