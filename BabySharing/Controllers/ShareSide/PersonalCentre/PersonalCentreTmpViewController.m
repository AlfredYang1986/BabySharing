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
#import "PersonalCenterDefines.h"

#import "RemoteInstance.h"
#import "ModelDefines.h"

#import "ProfileSettingController.h"
#import "OwnerQueryModel.h"
#import "ConnectionModel.h"
#import "CollectionQueryModel.h"

#import "UserChatController.h"
//#import "HomeDetailViewController.h"
#import "HomeViewController.h"
#import "UserHomeViewDataDelegate.h"
#import "PersonalSettingController.h"

#import "ProfileOverView.h"

#define STATUS_BAR_HEIGHT       20

@interface PersonalCentreTmpViewController () <PersonalCenterProtocol, ProfileViewDelegate, AlbumTableCellDelegate, personalDetailChanged>
@property (weak, nonatomic, readonly) NSString* current_user_id;
@property (weak, nonatomic, readonly) NSString* current_auth_token;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@property (weak, nonatomic, readonly) OwnerQueryModel* om;
@property (weak, nonatomic, readonly) ConnectionModel* cm;
@property (weak, nonatomic, readonly) CollectionQueryModel* cqm;
@end

#define TITLE 0
#define IMAGE 1

@implementation PersonalCentreTmpViewController {
    NSArray* section_content;
    UIImage* next_indicator;
    
    NSDictionary* dic_profile_details;
    
    NSInteger current_seg_index;
    
    UIView* bkView;
}

@synthesize current_auth_token = _current_auth_token;
@synthesize current_user_id = _current_user_id;
@synthesize queryView = _queryView;

@synthesize om = _om;
@synthesize cm = _cm;
@synthesize cqm = _cqm;

@synthesize current_delegate = _current_delegate;
@synthesize owner_id = _owner_id;

@synthesize isPushed = _isPushed;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f]];
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _current_user_id = delegate.lm.current_user_id;
    _current_auth_token = delegate.lm.current_auth_token;
 
    _om = delegate.om;
    _cm = delegate.cm;
    _cqm = delegate.cqm;
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
    _queryView.backgroundColor = [UIColor whiteColor];

//    if ([_owner_id isEqualToString:_current_user_id]) {
//        UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
//        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//        NSString* filepath = [resourceBundle pathForResource:@"DongDa_Plus" ofType:@"png"];
//        CALayer * layer = [CALayer layer];
//        layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
//        layer.frame = CGRectMake(0, 0, 25, 25);
//        layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
//        [barBtn.layer addSublayer:layer];
//        [barBtn addTarget:self action:@selector(didSelectSettingBtn) forControlEvents:UIControlEventTouchDown];
//        
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
//    }
    
    current_seg_index = 0;
    
    UILabel* label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"用户信息";
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    if (self.navigationController.viewControllers.count > 1) {
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
    } else {
        UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString* filepath = [resourceBundle pathForResource:@"DongDa_Plus" ofType:@"png"];
        CALayer * layer = [CALayer layer];
        layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
        layer.frame = CGRectMake(0, 0, 25, 25);
        layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
        [barBtn.layer addSublayer:layer];
        [barBtn addTarget:self action:@selector(didSelectSettingBtn) forControlEvents:UIControlEventTouchDown];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    }
    
    bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, STATUS_BAR_HEIGHT)];
    bkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bkView];
}

- (void)didPopControllerSelected {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateProfileDetails];
    [_om queryContentsByUser:_current_user_id withToken:_current_auth_token andOwner:_owner_id withStartIndex:0 finishedBlock:^(BOOL success) {
        [_queryView reloadData];
    }];
    
//    dispatch_queue_t cq = dispatch_queue_create("query collections", nil);
//    dispatch_async(cq, ^{
//        [_cqm queryCollectionContentsByUser:_current_user_id withToken:_current_user_id andOwner:_owner_id withStartIndex:0 finishedBlock:^(BOOL success) {
//            if (((ProfileOverView*)[_queryView headerViewForSection:0]).seg.selectedSegmentIndex == 3) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_queryView reloadData];
//                });
//            }
//        }];
//    });
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"MoreSetting"]) {
        ((ProfileSettingController*)segue.destinationViewController).current_user_id = self.current_user_id;
        ((ProfileSettingController*)segue.destinationViewController).current_auth_token = self.current_auth_token;
        ((ProfileSettingController*)segue.destinationViewController).dic_profile_details = dic_profile_details;
        ((ProfileSettingController*)segue.destinationViewController).delegate = self;
    } else if ([segue.identifier isEqualToString:@"PersonalSetting"]) {
        ((PersonalSettingController*)segue.destinationViewController).current_user_id = self.current_user_id;
        ((PersonalSettingController*)segue.destinationViewController).current_auth_token = self.current_auth_token;
        ((PersonalSettingController*)segue.destinationViewController).dic_profile_details = dic_profile_details;
        ((PersonalSettingController*)segue.destinationViewController).delegate = self;
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
//                self.navigationItem.title = [dic_profile_details objectForKey:@"screen_name"];
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
//    return @"Not Implemented";
    return @"北京 东城区";
}

- (NSString*)getNickName {
    return [dic_profile_details objectForKey:@"screen_name"];
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
//                return @"取消关注";
                return @"-取关";
            default:
                return nil;
    }} else return nil;
}

- (OwnerQueryModel*)getOM {
    return _om;
}

- (CollectionQueryModel*)getCQM {
    return _cqm;
}

- (NSInteger)getCurrentSegIndex {
    return current_seg_index;
}

#pragma mark -- profile view delegate
- (void)editBtnSelected {
    [self performSegueWithIdentifier:@"PersonalSetting" sender:nil];
}

- (void)chatBtnSelected {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserChatController* chat = [storyboard instantiateViewControllerWithIdentifier:@"userChatController"];
    chat.hidesBottomBarWhenPushed = YES;
    chat.chat_user_id = _owner_id;
    chat.chat_user_name = [dic_profile_details objectForKey:@"screen_name"];
    chat.chat_user_photo = [self getPhotoName];
    
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)followBtnSelected {
    NSLog(@"follow button selected");
    
    NSString* follow_user_id = _owner_id;
    NSNumber* relations = [dic_profile_details objectForKey:@"relations"];
 
    switch (relations.integerValue) {
        case UserPostOwnerConnectionsSamePerson:
            // my own post, do nothing
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed: {
            [_cm followOneUser:follow_user_id withFinishBlock:^(BOOL success, NSString *message) {
                if (success) {
                    NSLog(@"follow success");
                    if (relations.integerValue == UserPostOwnerConnectionsNone) {
                        [dic_profile_details setValue:[NSNumber numberWithInteger:UserPostOwnerConnectionsFollowing] forKey:@"relations"];
                    } else {
                        [dic_profile_details setValue:[NSNumber numberWithInteger:UserPostOwnerConnectionsFriends] forKey:@"relations"];
                        [dic_profile_details setValue:[NSNumber numberWithInteger:[self getFriendsCount] + 1] forKey:@"friends_count"];
                    }
                    [_queryView reloadData];
            
                } else {
                    NSLog(@"follow error, %@", message);
                }
            }];}
            break;
        case UserPostOwnerConnectionsFollowing:
        case UserPostOwnerConnectionsFriends: {
            [_cm unfollowOneUser:follow_user_id withFinishBlock:^(BOOL success, NSString *message) {
                if (success) {
                    NSLog(@"unfollow success");
                    if (relations.integerValue == UserPostOwnerConnectionsFollowing) {
                        [dic_profile_details setValue:[NSNumber numberWithInteger:UserPostOwnerConnectionsNone] forKey:@"relations"];
                    } else {
                        [dic_profile_details setValue:[NSNumber numberWithInteger:UserPostOwnerConnectionsFollowed] forKey:@"relations"];
                        [dic_profile_details setValue:[NSNumber numberWithInteger:[self getFriendsCount] - 1] forKey:@"friends_count"];
                    }
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

- (void)segControlValueChangedWithSelectedIndex:(NSInteger)index {
    current_seg_index = index;
    [_queryView reloadData];
}

#pragma mark -- album cell delegate
- (NSInteger)getViewsCount {
    return PHOTO_PER_LINE;
}

- (NSInteger)indexByRow:(NSInteger)row andCol:(NSInteger)col {
    return row * PHOTO_PER_LINE + col;
}

- (BOOL)isSelectedAtIndex:(NSInteger)index {
    return false;
}

- (void)didSelectOneImageAtIndex:(NSInteger)index {
//    OwnerQueryModel* om = [self getOM];
//    QueryContent* tmp = [om.querydata objectAtIndex:index];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    HomeDetailViewController* detail = [storyboard instantiateViewControllerWithIdentifier:@"DetailContent"];
//    detail.hidesBottomBarWhenPushed = YES;
//    
//    AppDelegate * app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    detail.qm = app.qm;
//    detail.current_content = tmp;
//    detail.current_user_id = _current_user_id;
//    detail.current_auth_token = _current_auth_token;
//    
//    [self.navigationController pushViewController:detail animated:YES];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController* hv = [storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    hv.isPushed = YES;
    hv.delegate = [[UserHomeViewDataDelegate alloc]init];
    [hv.delegate pushExistingData:[self getOM].querydata];
    [hv.delegate setSelectIndex:index];
    hv.nav_title = [self getNickName];
    hv.current_index = index;
    [self.navigationController pushViewController:hv animated:YES];
}

#pragma mark -- change date
- (void)personalDetailChanged:(NSDictionary *)dic {
    for (NSString* key in dic.allKeys) {
        [dic_profile_details setValue:[dic objectForKey:key] forKey:key];
    }
}
@end