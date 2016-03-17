//
//  UserSearchController.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "UserSearchController.h"
#import "UserSearchCell.h"
#import "UserSearchModel.h"

#import "HomeViewController.h"
#import "UserHomeViewDataDelegate.h"
#import "AppDelegate.h"
#import "FoundHotTagsCell.h"
#import "PersonalCentreTmpViewController.h"
#import "PersonalCentreOthersDelegate.h"

@interface UserSearchController () <UITableViewDataSource, UITableViewDelegate, UserSearchCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *queryView;
@end

@implementation UserSearchController

@synthesize um = _um;
@synthesize user_search_type = _user_search_type;
@synthesize role_tag = _role_tag;

@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [_queryView registerNib:[UINib nibWithNibName:@"UserSearchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"user search cell"];
    [_queryView registerClass:[UserSearchCell class] forCellReuseIdentifier:@"user search cell"];
    
    _queryView.delegate = self;
    _queryView.dataSource = self;
    _queryView.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    UILabel* label = [[UILabel alloc]init];
    label.text = _role_tag == nil ? @"认识更多的朋友" : _role_tag;
    label.textColor = [UIColor colorWithWhite:0.5059 alpha:1.f];
    label.font = [UIFont systemFontOfSize:16.f];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, 25, 25);
    //    layer.position = CGPointMake(barBtn.frame.size.width / 2, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
    [barBtn addTarget:self action:@selector(didPopViewControllerBtn) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
   
    if (_user_search_type == UserSearchTypeMoreFriends) {
        [self asyncQueryData];
    } else {
        [self asyncQueryDataWithRoleTag];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didPopViewControllerBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)asyncQueryData {
    dispatch_queue_t ap = dispatch_queue_create("user query queue", nil);
    dispatch_async(ap, ^{
        [_um queryUserSearchWithFinishBlock:^(BOOL success, NSArray *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_queryView reloadData];
            });
        }];
    });
}

- (void)asyncQueryDataWithRoleTag {
    dispatch_queue_t ap = dispatch_queue_create("user query queue", nil);
    dispatch_async(ap, ^{
        [_um queryUserSearchWithRoleTag:_role_tag andFinishBlock:^(BOOL success, NSArray *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_queryView reloadData];
            });
        }];
    });
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
    return _um.userSearchPreviewResult.count + 20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSearchCell* cell = [tableView dequeueReusableCellWithIdentifier:@"user search cell"];
    
    if (cell == nil) {
        cell = [[UserSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"user search cell"];
    }
//    NSDictionary* dic = [_um.userSearchPreviewResult objectAtIndex:indexPath.row];
    NSDictionary* dic = [_um.userSearchPreviewResult objectAtIndex:0];
    cell.delegate = self;
    cell.user_id = [dic objectForKey:@"user_id"];
    cell.screen_name = [dic objectForKey:@"screen_name"];
    cell.connections = ((NSNumber*)[dic objectForKey:@"relations"]).integerValue;
    [cell setUserHeaderWithScreenName:[dic objectForKey:@"screen_name"] roleTag:[dic objectForKey:@"role_tag"] andScreenPhoto:[dic objectForKey:@"screen_photo"]];
    [cell setUserContentImages:[dic objectForKey:@"preview"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UserSearchCell preferredHeight];
}

#pragma mark -- user search cell delegate
- (void)didSelectedUserScreenPhoto:(NSString*)user_id {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalCentreTmpViewController* pc = [storyboard instantiateViewControllerWithIdentifier:@"PersonalCenter"];
    PersonalCentreOthersDelegate* delegate = [[PersonalCentreOthersDelegate alloc]init];
    pc.current_delegate = delegate;
    pc.owner_id = user_id;
    pc.isPushed = YES;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:pc animated:YES];
}

- (void)didSelectedUserRelationsUserID:(NSString *)user_id andCurrentConnection:(UserPostOwnerConnections)connections {
    NSLog(@"follow button selected");
   
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    ConnectionModel* cm = app.cm;
    
    NSString* follow_user_id = user_id;
    NSNumber* relations = [NSNumber numberWithInteger:connections];
    
    switch (relations.integerValue) {
        case UserPostOwnerConnectionsSamePerson:
            // my own post, do nothing
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed: {
            [cm followOneUser:follow_user_id withFinishBlock:^(BOOL success, NSString *message, UserPostOwnerConnections new_connections) {
                if (success && [self changeArrWithUserID:follow_user_id andConnections:new_connections]) {
                    NSLog(@"follow success");
                    [_queryView reloadData];
                    
                } else {
                    NSLog(@"follow error, %@", message);
                }
            }];}
            break;
        case UserPostOwnerConnectionsFollowing:
        case UserPostOwnerConnectionsFriends: {
            [cm unfollowOneUser:follow_user_id withFinishBlock:^(BOOL success, NSString *message, UserPostOwnerConnections new_connections) {
                if (success && [self changeArrWithUserID:follow_user_id andConnections:new_connections]) {
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

- (BOOL)changeArrWithUserID:(NSString*)user_id andConnections:(UserPostOwnerConnections)new_connections {
    NSInteger index = [_um.userSearchPreviewResult indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        *stop = NO;
        NSDictionary* dic = (NSDictionary*)obj;
        if ([[dic objectForKey:@"user_id"] isEqualToString:user_id]) {
            *stop = YES;
            return YES;
        } else return NO;
    }];
    
    if (index > -1) {
        NSDictionary* dic = [_um.userSearchPreviewResult objectAtIndex:index];
        [dic setValue:[NSNumber numberWithInteger:new_connections] forKey:@"relations"];
        return YES;
    } else {
        NSLog(@"nothing to be chenged");
        return NO;
    }
}

- (void)didSelectedUserContentImages:(NSInteger)index andUserID:(NSString*)user_id andUserScreenName:(NSString*)screen_name {

    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.om queryContentsByUser:app.lm.current_user_id withToken:app.lm.current_auth_token andOwner:user_id withStartIndex:index finishedBlock:^(BOOL success) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController* hv = [storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
        hv.isPushed = YES;
        hv.delegate = [[UserHomeViewDataDelegate alloc]init];
        [hv.delegate pushExistingData:app.om.querydata];
        [hv.delegate setSelectIndex:index];
        hv.nav_title = screen_name;
        //    hv.nav_title = @"Mother's Choice";
        [self.navigationController pushViewController:hv animated:YES];
    }];
}
@end