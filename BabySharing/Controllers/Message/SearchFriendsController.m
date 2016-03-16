//
//  SearchFriendsController.m
//  BabySharing
//
//  Created by Alfred Yang on 1/6/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "SearchFriendsController.h"
#import "MessageFriendsCell.h"

#import "AppDelegate.h"
#import "UserSearchModel.h"
#import "ConnectionModel.h"

#import "PersonalCentreTmpViewController.h"
#import "PersonalCentreOthersDelegate.h"

@interface SearchFriendsController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, MessageFriendsCellDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@property (weak, nonatomic) UserSearchModel* um;
@property (weak, nonatomic) ConnectionModel* cm;
@end

@implementation SearchFriendsController {
    NSArray* arr_section_title;
}

@synthesize searchBar = _searchBar;
@synthesize queryView = _queryView;

@synthesize um = _um;
@synthesize cm = _cm;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    _um = app.um;
    _cm = app.cm;
    
    _searchBar.showsCancelButton = YES;
    _searchBar.placeholder = @"搜索好友";
    _searchBar.backgroundColor = [UIColor clearColor];
    UIImageView* iv = [[UIImageView alloc] initWithImage:[self imageWithColor:[UIColor whiteColor] size:_searchBar.bounds.size]];
    [_searchBar insertSubview:iv atIndex:1];
//    [_searchBar setSearchFieldBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:_searchBar.bounds.size] forState:UIControlStateNormal];
    for (UIView* v in _searchBar.subviews.firstObject.subviews) {
        if ( [v isKindOfClass: [UITextField class]] ) {
            UITextField *tf = (UITextField *)v;
            tf.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
            tf.borderStyle = UITextBorderStyleRoundedRect;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        } else if ([v isKindOfClass:[UIButton class]]) {
            UIButton* cancel_btn = (UIButton*)v;
//            [cancel_btn setTitle:@"test" forState:UIControlStateNormal];
            [cancel_btn setTitleColor:[UIColor colorWithWhite:0.4667 alpha:1.f] forState:UIControlStateNormal];
            [cancel_btn setTitleColor:[UIColor colorWithWhite:0.4667 alpha:1.f] forState:UIControlStateDisabled];
        }
//        else if ([v isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//            v.backgroundColor = [UIColor whiteColor];
//        }
    }
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    line.borderWidth = 1.f;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    line.frame = CGRectMake(0, 64, width, 1);
    [self.view.layer addSublayer:line];
    
    _searchBar.delegate = self;
    
    _queryView.delegate = self;
    _queryView.dataSource = self;
    _queryView.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_queryView registerNib:[UINib nibWithNibName:@"MessageFriendsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"friend cell"];
    
    arr_section_title = @[@"好友", @"可能认识的人", @"相关用户"];
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

#pragma mark -- search bat delegate 
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_um queryUserSearchWithScreenName:searchBar.text andFinishBlock:^(BOOL success, NSDictionary *result) {
        [_queryView reloadData];
    }];
}

#pragma mark -- table view 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    UIView* reVal = [[UIView alloc]init];
    reVal.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
#define HEARDER_OFFSET      0
#define LEFT_MARGIN         10.5
#define TOP_MARGIN          14
    UIView* content = [[UIView alloc]initWithFrame:CGRectMake(0, HEARDER_OFFSET, width, 36 - HEARDER_OFFSET)];
    content.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN + (section == 0 ? 5 : 0), TOP_MARGIN, 1, 1)];
    label.text = [arr_section_title objectAtIndex:section];
    label.textColor = [UIColor colorWithWhite:0.4667 alpha:1.f];
    label.font = [UIFont systemFontOfSize:14.f];
    [label sizeToFit];
    [content addSubview:label];
    
    [reVal addSubview:content];
    
    CALayer* line_up = [CALayer layer];
    line_up.borderWidth = 1.f;
    line_up.borderColor = [UIColor colorWithWhite:0.4667 alpha:0.10].CGColor;
    line_up.frame = CGRectMake(0, HEARDER_OFFSET, width + 10, 1);
    [reVal.layer addSublayer:line_up];
    
    return reVal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MessageFriendsCell preferredHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? [_um.lastSearchScreenNameResult count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"friend cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageFriendsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
    if (indexPath.section == 0) {
        NSDictionary* tmp = [_um.lastSearchScreenNameResult objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.user_id = [tmp objectForKey:@"user_id"];
        [cell setUserScreenPhoto:[tmp objectForKey:@"screen_photo"]];
        [cell setRelationship:((NSNumber*)[tmp objectForKey:@"relations"]).integerValue];
        [cell setUserScreenName:[tmp objectForKey:@"screen_name"]];
        [cell setUserRoleTag:[tmp objectForKey:@"role_tag"]];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark -- Message friend cell delegate
- (void)didSelectedScreenPhoto:(NSString*)user_id {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalCentreTmpViewController* pc = [storyboard instantiateViewControllerWithIdentifier:@"PersonalCenter"];
    PersonalCentreOthersDelegate* delegate = [[PersonalCentreOthersDelegate alloc]init];
    pc.current_delegate = delegate;
    pc.owner_id = user_id;
    pc.isPushed = YES;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:pc animated:YES];
}

- (void)didSelectedRelationBtn:(NSString*)user_id andCurrentRelation:(UserPostOwnerConnections)connections {
    NSLog(@"follow button selected");
    
    NSString* follow_user_id = user_id;
    NSNumber* relations = [NSNumber numberWithInteger:connections];
    
    switch (relations.integerValue) {
        case UserPostOwnerConnectionsSamePerson:
            // my own post, do nothing
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed: {
            [_cm followOneUser:follow_user_id withFinishBlock:^(BOOL success, NSString *message, UserPostOwnerConnections new_connections) {
                if (success && [_um changeRelationsInMemory:follow_user_id andConnections:new_connections]) {
                    NSLog(@"follow success");
                    [_queryView reloadData];
                    
                } else {
                    NSLog(@"follow error, %@", message);
                }
            }];}
            break;
        case UserPostOwnerConnectionsFollowing:
        case UserPostOwnerConnectionsFriends: {
            [_cm unfollowOneUser:follow_user_id withFinishBlock:^(BOOL success, NSString *message, UserPostOwnerConnections new_connections) {
                if (success && [_um changeRelationsInMemory:follow_user_id andConnections:new_connections]) {
                    NSLog(@"unfollow success");
                    [_queryView reloadData];
                    
                } else {
                    NSLog(@"follow error, %@", message);
                }
            }];}
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}
@end
