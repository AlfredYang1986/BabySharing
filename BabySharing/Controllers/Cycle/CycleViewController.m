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

@interface CycleViewController () <UITableViewDataSource, UITableViewDelegate, DropDownMenuProcotol, WEPopoverControllerDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UITableView *cycleTableView;

@property (weak, nonatomic) LoginModel* lm;
@end

@implementation CycleViewController {
	WEPopoverController *popoverController;
}

@synthesize descriptionView = _descriptionView;
@synthesize cycleTableView = _cycleTableView;

@synthesize lm = _lm;

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
}

- (void)viewDidLayoutSubviews {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
   
    CGRect rc = CGRectMake(0, 20 + 44, width, height - 44 - 49);
    _descriptionView.frame = rc;
    _cycleTableView.frame = rc;
    
    if (![self hasViewDescription]) {
        _cycleTableView.hidden = YES;

    } else {
        _descriptionView.hidden = YES;
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
        
    }
    
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;
}

#pragma mark -- segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@""]) {
    }
}
@end
