//
//  PersonalSettingController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PersonalSettingController.h"
#include <vector>

@interface PersonalSettingController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@end

@implementation PersonalSettingController {
    NSArray* data;
    std::vector<SEL> functions;
}

@synthesize current_auth_token = _current_auth_token;
@synthesize current_user_id = _current_user_id;
@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data = @[@"头像", @"", @"昵称", @"", @"角色", @"", @"个性签名", @"", @"自己的描述", @"", @"账号绑定"];
    
    functions.push_back(@selector(phoneSelected));
    functions.push_back(nil);
    functions.push_back(@selector(screenNameSelected));
    functions.push_back(nil);
    functions.push_back(@selector(roleTagSelected));
    functions.push_back(nil);
    functions.push_back(@selector(personalSignSelected));
    functions.push_back(nil);
    functions.push_back(@selector(personalDescriptionSelected));
    functions.push_back(nil);
    functions.push_back(@selector(accountBoundSelected));

    _queryView.scrollEnabled = NO;
    [_queryView setSeparatorColor:[UIColor clearColor]];
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

#pragma mark - uitableview delegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![[data objectAtIndex:indexPath.row] isEqualToString:@""];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self performSelector:functions[indexPath.row] withObject:nil];
}

#pragma mark -- uitableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }

    cell.textLabel.text = [data objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([cell.textLabel.text isEqualToString:@""]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark -- functions 
- (void)phoneSelected {
    
}

- (void)screenNameSelected {
    
}

- (void)roleTagSelected {
    
}

- (void)personalSignSelected {
    
}

- (void)personalDescriptionSelected {
    
}

- (void)accountBoundSelected {
    
}
@end
