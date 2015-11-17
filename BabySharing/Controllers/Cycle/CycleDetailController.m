//
//  CycleDetailController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleDetailController.h"
#import "AppDelegate.h"

@interface CycleDetailController () <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

//@property (weak, nonatomic) IBOutlet UITextView *themeField;
@property (weak, nonatomic) IBOutlet UIView *userListView;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@end

@implementation CycleDetailController {
    NSArray* titles;
    NSArray* titles_cn;
    NSArray* imgs;
}

@synthesize cycleDetails = _cycleDetails;
//@synthesize themeField = _themeField;
@synthesize userListView = _userListView;
@synthesize queryView = _queryView;

- (void)viewDidLoad {
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTextViewEdit:)];
    [self.view addGestureRecognizer:tap];
    
    titles = [NSArray arrayWithObjects:@"gourp_name", @"time", @"location", @"tag", nil];
    titles_cn = [NSArray arrayWithObjects:@"主题", @"时间", @"位置", @"标签", nil];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    imgs = [NSArray arrayWithObjects:[UIImage imageNamed:[resourceBundle pathForResource:@"UserSearchUnselected" ofType:@"png"]],
            [UIImage imageNamed:[resourceBundle pathForResource:@"Time_Publish" ofType:@"png"]],
            [UIImage imageNamed:[resourceBundle pathForResource:@"Location_Publish" ofType:@"png"]],
            [UIImage imageNamed:[resourceBundle pathForResource:@"Tag_Publish" ofType:@"png"]], nil];
    
    _queryView.scrollEnabled = NO;
    _queryView.delegate = self;
    _queryView.dataSource = self;
    
    UILabel* label_t = [[UILabel alloc]init];
    label_t.text = @"创建圈子";
    label_t.textColor = [UIColor whiteColor];
    [label_t sizeToFit];
    self.navigationItem.titleView = label_t;
   
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString* filepath = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, 13, 20);
    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
    [barBtn addTarget:self action:@selector(didPopViewController) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    
    UIButton* barBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    [barBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (_cycleDetails) {
        [barBtn1 setTitle:@"修改" forState:UIControlStateNormal];
        [barBtn1 addTarget:self action:@selector(updateCycleDetailBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [barBtn1 setTitle:@"完成" forState:UIControlStateNormal];
        [barBtn1 addTarget:self action:@selector(createCycleDetailBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    }
   
    [barBtn1 sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn1];
}

- (void)didPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateCycleDetailBtnSelected {
   
    NSIndexPath* i = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell* cell = [_queryView cellForRowAtIndexPath:i];
    UITextField* t = (UITextField*)[cell viewWithTag:1];
    
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSMutableDictionary* dic = [_cycleDetails mutableCopy];
    [dic setObject:t.text forKey:@"group_name"];
    [app.mm updateChatGroupWithGroup:[dic copy] andFinishBlock:^(BOOL success, NSDictionary *result) {
        [_delegate createUpdateChatGroup:success];
    }];
    [self.navigationController popViewControllerAnimated:YES];   
}

- (void)createCycleDetailBtnSelected {

    NSIndexPath* i = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell* cell = [_queryView cellForRowAtIndexPath:i];
    UITextField* t = (UITextField*)[cell viewWithTag:1];
   
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.mm createChatGroupWithGroupThemeName:t.text andFinishBlock:^(BOOL success, NSDictionary *result) {
        [_delegate createUpdateChatGroup:success];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endTextViewEdit:(UITapGestureRecognizer*)gesture {
//    [_themeField resignFirstResponder];
}

#pragma mark -- textview delegate

#pragma mark -- table view 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
   
    cell.imageView.image = [imgs objectAtIndex:indexPath.row];
    cell.textLabel.text = [titles_cn objectAtIndex:indexPath.row];
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 44;
    UITextField* text = [[UITextField alloc]initWithFrame:CGRectMake(100, 8, width - 116, height - 16)];
    
    text.tag = indexPath.row + 1;
    if (indexPath.row == 3) {
        text.placeholder = @"可添加多个标签";
    }
    
    [cell addSubview:text];
    
    return cell;
}

@end