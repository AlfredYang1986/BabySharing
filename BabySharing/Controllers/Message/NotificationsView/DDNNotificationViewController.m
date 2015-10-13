//
//  DDNNotificationViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 9/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "DDNNotificationViewController.h"
#import "Notifications.h"
#import "MessageModel.h"
#import "LoginModel.h"
#import "EnumDefines.h"
#import "MessageNotificationDetailCell.h"

@interface DDNNotificationViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@end

@implementation DDNNotificationViewController {
    NSArray* queryData;
}

@synthesize mm = _mm;
@synthesize lm = _lm;

@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    queryData = [_mm enumNotifications];
   
    [_queryView registerNib:[UINib nibWithNibName:@"MessageNotificationDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Notificaton Detail View Cell"];
    
    [_mm markAllNotificationsAsReaded];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unRead Message Changed" object:nil];
 
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
    label.text = @"Notifications";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
//    [self.navigationItem.titleView setTintColor:[UIColor whiteColor]];
}

- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:indexPath];
    
    //    QueryContent* cur = [_qm.querydata objectAtIndex:indexPath.row - 1];
    //    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:cur];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MessageNotificationDetailCell preferedHeight];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete one row");
    }
}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    MessageNotificationDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Notificaton Detail View Cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageNotificationDetailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Notifications* tmp = [queryData objectAtIndex:indexPath.row];
    
    [cell setUserImage:tmp.sender_screen_photo];
    cell.detailView.text = [cell getActtionTmplate:tmp.type.integerValue];//, tmp.sender_screen_name];
    cell.nameLabel.text = tmp.sender_screen_name;
   
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return queryData.count;
}
@end
