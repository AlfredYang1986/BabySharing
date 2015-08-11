//
//  PersonalCentreTmpViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 23/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PersonalCentreTmpViewController.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "TmpFileStorageModel.h"
#import "ProfileDetailController.h"

#import "PersonalCenterOwnerDelegate.h"
#import "ProfileUserHeaderCell.h"

#import "RemoteInstance.h"
#import "ModelDefines.h"

#import "ProfileSettingController.h"
#import "OwnerQueryModel.h"

#import "UserChatController.h"

@interface PersonalCentreTmpViewController () <PersonalCenterProtocol, ProfileViewDelegate>
@property (weak, nonatomic, readonly) NSString* current_user_id;
@property (weak, nonatomic, readonly) NSString* current_auth_token;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@property (weak, nonatomic, readonly) OwnerQueryModel* om;
@end

#define TITLE 0
#define IMAGE 1

@implementation PersonalCentreTmpViewController {
    NSArray* section_content;
    UIImage* next_indicator;
    
    NSDictionary* dic_profile_details;
}

@synthesize current_auth_token = _current_auth_token;
@synthesize current_user_id = _current_user_id;
@synthesize queryView = _queryView;

@synthesize om = _om;

@synthesize current_delegate = _current_delegate;
@synthesize owner_id = _owner_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _current_user_id = delegate.lm.current_user_id;
    _current_auth_token = delegate.lm.current_auth_token;
 
    _om = delegate.om;
    /**
     * Profile Header Cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"ProfileUserHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Profile Header Cell"];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image0 = [UIImage imageNamed:[resourceBundle pathForResource:@"Share" ofType:@"png"]];
    UIImage *image1 = [UIImage imageNamed:[resourceBundle pathForResource:@"Tag" ofType:@"png"]];
    UIImage *image2 = [UIImage imageNamed:[resourceBundle pathForResource:@"Like" ofType:@"png"]];
    UIImage *image3 = [UIImage imageNamed:[resourceBundle pathForResource:@"Dropbox" ofType:@"png"]];
    UIImage *image4 = [UIImage imageNamed:[resourceBundle pathForResource:@"Info" ofType:@"png"]];
    UIImage *image5 = [UIImage imageNamed:[resourceBundle pathForResource:@"Setting" ofType:@"png"]];

    next_indicator = [UIImage imageNamed:[resourceBundle pathForResource:@"Next2" ofType:@"png"]];
    
    section_content = @[@[@[@"分享", @"标签", @"收集", @"讨论组"], @[image0, image1, image2, image3]], @[@[@"反馈信息中心", @"设置"], @[image4, image5]]];
    
   
    [_queryView registerNib:[UINib nibWithNibName:@"ProfileOverView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"Profile Overview"];
    [_queryView registerNib:[UINib nibWithNibName:@"ProfileOthersOverView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"Profile Others Overview"];
  
    if (!_current_delegate) {
        self.current_delegate = [[PersonalCenterOwnerDelegate alloc]init];
    }
    
    _queryView.delegate = _current_delegate;
    _queryView.dataSource = _current_delegate;
    
    if (!_owner_id || [_owner_id isEqualToString:@""]) {
        _owner_id = _current_user_id;
    }
    
    _queryView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Setting" ofType:@"png"]] style:UIBarButtonItemStylePlain target:self action:@selector(didSelectSettingBtn)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateProfileDetails];
    [_om queryContentsByUser:_current_user_id withToken:_current_auth_token andOwner:_owner_id withStartIndex:0 finishedBlock:^(BOOL success) {
        [_queryView reloadData];
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"MoreSetting"]) {
        ((ProfileSettingController*)segue.destinationViewController).current_user_id = self.current_user_id;
        ((ProfileSettingController*)segue.destinationViewController).current_auth_token = self.current_auth_token;
    }
}

- (void)didSelectSettingBtn {
    [self performSegueWithIdentifier:@"MoreSetting" sender:nil];
}

//- (IBAction)didSelectSignOutBtn {
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"current user sign out" object:nil];
//}

- (void)updateProfileDetails {
    dispatch_queue_t up = dispatch_queue_create("Get Profile Details", nil);
    dispatch_async(up, ^{
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:_current_auth_token forKey:@"query_auth_token"];
        [dic setValue:_current_user_id forKey:@"query_user_id"];
        [dic setValue:_owner_id forKey:@"owner_user_id"];
        
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_QUERY_DETAILS]]];
        
        if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
            dic_profile_details = [result objectForKey:@"result"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_queryView reloadData];
                self.navigationItem.title = [dic_profile_details objectForKey:@"screen_name"];
            });
            
        } else {
            NSDictionary* reError = [result objectForKey:@"error"];
            NSString* msg = [reError objectForKey:@"message"];
            
            NSLog(@"query user profile failed");
            NSLog(@"%@", msg);
        }
    });
}

- (void)setProfileDelegate:(id<UITableViewDelegate, UITableViewDataSource, PersonalCenterCallBack>)delegate {
    _current_delegate = delegate;
    [_current_delegate setDelegate:self];
}

#pragma mark -- personaal center overview delegate
- (NSString*)getPhotoName {
    if (dic_profile_details) {
        return [dic_profile_details objectForKey:@"screen_photo"];
    } else return nil;
}

- (NSInteger)getSharedCount {
    if (dic_profile_details) {
        return ((NSNumber*)[dic_profile_details objectForKey:@"posts_count"]).integerValue;
    } else return 0;
}

- (NSInteger)getFriendsCount {
    if (dic_profile_details) {
        return ((NSNumber*)[dic_profile_details objectForKey:@"friends_count"]).integerValue;
    } else return 0;
}

- (NSInteger)getCycleCount {
    if (dic_profile_details) {
        return ((NSNumber*)[dic_profile_details objectForKey:@"cycle_count"]).integerValue;
    } else return 0;
}

- (NSString*)getLocation {
    return @"Not Implemented";
}

- (NSString*)getSign {
    return @"Not Implemented";
}

- (NSString*)getRoleTag {
    if (dic_profile_details) {
        return [dic_profile_details objectForKey:@"role_tag"];
    } else return nil;
}

- (NSString*)getRelations {
    if (dic_profile_details) {
        switch (((NSNumber*)[dic_profile_details objectForKey:@"relations"]).integerValue) {
            case UserPostOwnerConnectionsSamePerson:
                // my own post, do nothing
                return nil;
            case UserPostOwnerConnectionsNone:
            case UserPostOwnerConnectionsFollowed:
                return @"+关注";
            case UserPostOwnerConnectionsFollowing:
            case UserPostOwnerConnectionsFriends:
                return @"取消关注";
            default:
                return nil;
    }} else return nil;
}

- (OwnerQueryModel*)getOM {
    return _om;
}

#pragma mark -- profile view delegate
- (void)chatBtnSelected {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserChatController* chat = [storyboard instantiateViewControllerWithIdentifier:@"userChatController"];
    chat.hidesBottomBarWhenPushed = YES;
    chat.chat_user_id = _owner_id;
    chat.chat_user_name = [dic_profile_details objectForKey:@"screen_name"];
    chat.chat_user_photo = [self getPhotoName];
    
    [self.navigationController pushViewController:chat animated:YES];
}
@end