//
//  PersonalSettingController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PersonalSettingController.h"
#include <vector>
#import "PersonalSettingCell.h"
#import "PersonalChangeScreenNameController.h"

@interface PersonalSettingController () <UITableViewDataSource, UITableViewDelegate, chanageScreenNameProtocol>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@end

@implementation PersonalSettingController {
    NSArray* data;
    std::vector<SEL> functions;
    NSArray* title;
}

@synthesize current_auth_token = _current_auth_token;
@synthesize current_user_id = _current_user_id;
@synthesize queryView = _queryView;
@synthesize dic_profile_details = _dic_profile_details;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data = @[@"头像", @"", @"昵称", @"", @"角色", @"", @"个性签名", @"", @"自己的描述", @"", @"账号绑定"];
    title = @[@"screen_photo", @"", @"screen_name", @"", @"role_tag", @"", @"个性签名", @"", @"自己的描述", @"", @"账号绑定"];
    
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

//    _queryView.scrollEnabled = NO;
    [_queryView setSeparatorColor:[UIColor clearColor]];
    
    [_queryView registerNib:[UINib nibWithNibName:@"PersonalSettingCell" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"personal setting cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"addScreenName"]) {
        ((PersonalChangeScreenNameController*)segue.destinationViewController).delegate = self;
        ((PersonalChangeScreenNameController*)segue.destinationViewController).ori_screen_name = [self.dic_profile_details objectForKey:@"screen_name"];
    }
}

#pragma mark - uitableview delegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![[data objectAtIndex:indexPath.row] isEqualToString:@""];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self performSelector:functions[indexPath.row] withObject:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PersonalSettingCell preferredHeightWithImage:indexPath.row == 0];
}

#pragma mark -- uitableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    PersonalSettingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"personal setting cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PersonalSettingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell changeCellTitile:[data objectAtIndex:indexPath.row]];
    
    id content = [self.dic_profile_details objectForKey:[title objectAtIndex:indexPath.row]];
    if (content != nil) {
        if (indexPath.row == 0) {
            [cell changeCellImage:content];
        } else {
            [cell changeCellContent:content];
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row % 2 == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark -- change screen name
- (void)didChangeScreenName:(NSString *)name {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setObject:name forKey:@"screen_name"];
    [_delegate personalDetailChanged:[dic copy]];
    [_queryView reloadData];
}

#pragma mark -- functions 
- (void)phoneSelected {
    
}

- (void)screenNameSelected {
    [self performSegueWithIdentifier:@"addScreenName" sender:nil];
    
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
