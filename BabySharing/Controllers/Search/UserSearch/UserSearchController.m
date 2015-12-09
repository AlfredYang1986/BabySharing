//
//  UserSearchController.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "UserSearchController.h"
#import "UserSearchCell.h"

@interface UserSearchController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *queryView;
@end

@implementation UserSearchController

@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_queryView registerNib:[UINib nibWithNibName:@"UserSearchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"user search cell"];
    
    _queryView.delegate = self;
    _queryView.dataSource = self;
    _queryView.backgroundColor = [UIColor lightGrayColor];
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

#pragma mark -- table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSearchCell* cell = [tableView dequeueReusableCellWithIdentifier:@"user search cell"];
    
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UserSearchCell" owner:self options:nil];
        cell = [nib firstObject];
    }
   
    [cell setUserRoleTag:@"创业妈妈"];
    [cell setUserScreenName:@"妮妮妮猫"];
    [cell setUserScreenPhoto:@"test"];
    [cell setUserContentImages:@[@"", @"", @"", @""]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UserSearchCell preferredHeight];
}
@end
