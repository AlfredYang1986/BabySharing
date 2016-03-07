//
//  PersonalCentreTmpViewController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/1/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "PersonalCentreTmpViewController.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "TmpFileStorageModel.h"
#import "ProfileDetailController.h"

#import "PersonalCenterOwnerDelegate.h"

#import "RemoteInstance.h"
#import "ModelDefines.h"

#import "ProfileSettingController.h"
#import "OwnerQueryModel.h"
#import "OwnerQueryPushModel.h"
#import "ConnectionModel.h"
#import "CollectionQueryModel.h"

#import "UserChatController.h"
#import "HomeViewController.h"
#import "UserHomeViewDataDelegate.h"
#import "PersonalSettingController.h"

#import "ProfileOverView.h"
#import "SearchSegView2.h"

#import "UINavigationController+Retro.h"

#define STATUS_BAR_HEIGHT       20
#define FAKE_BAR_HEIGHT        44

#define QUERY_VIEW_MARGIN_LEFT      10.5
#define QUERY_VIEW_MARGIN_RIGHT     QUERY_VIEW_MARGIN_LEFT
#define QUERY_VIEW_MARGIN_UP        STATUS_BAR_HEIGHT
#define QUERY_VIEW_MARGIN_BOTTOM    0

#define HEADER_VIEW_HEIGHT          183

#define MARGIN_LEFT                 10.5
#define MARGIN_RIGHT                10.5

#define SEG_CTR_HEIGHT              49

@interface PersonalCentreTmpViewController () <PersonalCenterProtocol, ProfileViewDelegate, AlbumTableCellDelegate, personalDetailChanged, SearchSegViewDelegate>
@property (weak, nonatomic, readonly) NSString* current_user_id;
@property (weak, nonatomic, readonly) NSString* current_auth_token;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@property (weak, nonatomic, readonly) OwnerQueryModel* om;
@property (weak, nonatomic, readonly) OwnerQueryPushModel* opm;
@property (weak, nonatomic, readonly) ConnectionModel* cm;
@property (weak, nonatomic, readonly) CollectionQueryModel* cqm;
@end

@implementation PersonalCentreTmpViewController {
    NSDictionary* dic_profile_details;
    NSInteger current_seg_index;
    
    ProfileOverView* head_view;
    SearchSegView2* search_seg;
    
    
    dispatch_semaphore_t semaphore_om;
    dispatch_semaphore_t semaphore_opm;
    dispatch_semaphore_t semaphore_user_info;
}

@synthesize current_auth_token = _current_auth_token;
@synthesize current_user_id = _current_user_id;
@synthesize queryView = _queryView;

@synthesize om = _om;
@synthesize opm = _opm;
@synthesize cm = _cm;
@synthesize cqm = _cqm;

@synthesize current_delegate = _current_delegate;
@synthesize owner_id = _owner_id;

@synthesize isPushed = _isPushed;

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _current_user_id = delegate.lm.current_user_id;
    _current_auth_token = delegate.lm.current_auth_token;
    
    _om = delegate.om;
    _cm = delegate.cm;
    _cqm = delegate.cqm;
    _opm = delegate.opm;

    /**
     * Profile Header Cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"ProfileUserHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Profile Header Cell"];
    [_queryView registerNib:[UINib nibWithNibName:@"ProfileOverView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"Profile Overview"];
    
    if (!_current_delegate) {
        self.current_delegate = [[PersonalCenterOwnerDelegate alloc] init];
    }

    _queryView.showsVerticalScrollIndicator = FALSE;
    _queryView.showsHorizontalScrollIndicator = FALSE;
    _queryView.delegate = _current_delegate;
    _queryView.dataSource = _current_delegate;
    
    if (!_owner_id || [_owner_id isEqualToString:@""]) {
        _owner_id = _current_user_id;
    }
    
    [self createHeadView];
    [self createSegamentCtr];
    [self createFakeNaviBar];
    
    _queryView.frame = CGRectMake(QUERY_VIEW_MARGIN_LEFT, QUERY_VIEW_MARGIN_UP + HEADER_VIEW_HEIGHT + SEG_CTR_HEIGHT - 2, [UIScreen mainScreen].bounds.size.width - QUERY_VIEW_MARGIN_LEFT - QUERY_VIEW_MARGIN_RIGHT, [UIScreen mainScreen].bounds.size.height - QUERY_VIEW_MARGIN_UP - QUERY_VIEW_MARGIN_BOTTOM - HEADER_VIEW_HEIGHT - 100);
    _queryView.backgroundColor = [UIColor whiteColor];
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view bringSubviewToFront:_queryView];
    
    current_seg_index = 0;
    
    UILabel* label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"用户信息";
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)createSegamentCtr {
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

//    UIImage* img_seg_bg = [UIImage imageNamed:[resourceBundle pathForResource:@"profile_seg_bg" ofType:@"png"]];
//    CALayer* seg_bg = [CALayer layer];
//    seg_bg.contents = (id)img_seg_bg.CGImage;
//    seg_bg.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [SearchSegView2 preferredHeight]);
//    [search_seg.layer addSublayer:seg_bg];

    search_seg = [[SearchSegView2 alloc]initWithFrame:CGRectMake(MARGIN_LEFT, QUERY_VIEW_MARGIN_UP + HEADER_VIEW_HEIGHT, [UIScreen mainScreen].bounds.size.width - MARGIN_LEFT - MARGIN_RIGHT, SEG_CTR_HEIGHT)];
   
    search_seg.backgroundColor = [UIColor whiteColor];
    search_seg.layer.cornerRadius = 4.f;
    [self.view addSubview:search_seg];
    [self.view bringSubviewToFront:search_seg];

    [search_seg addItemWithTitle:@"0" andSubTitle:@"发布"];
    [search_seg addItemWithTitle:@"0" andSubTitle:@"推出"];
    search_seg.delegate = self;
    search_seg.isLayerHidden = YES;

    search_seg.selectedIndex = 0;
    search_seg.margin_between_items = 0.40 * [UIScreen mainScreen].bounds.size.width;
    
    semaphore_om = dispatch_semaphore_create(0);
    semaphore_opm = dispatch_semaphore_create(0);
    semaphore_user_info = dispatch_semaphore_create(0);
}

- (void)createHeadView {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    head_view = [[ProfileOverView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, width, HEADER_VIEW_HEIGHT)];
    head_view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:head_view];
    [self.view bringSubviewToFront:head_view];
    head_view.deleagate = self;
   
    /**
     * reset data
     */
    [self resetProfileData];
}

- (void)resetProfileData {
    [head_view setOwnerPhoto:[self getPhotoName]];
    [head_view setLoation:[self getLocation]];
    [head_view setPersonalSign:[self getSign]];
    [head_view setNickName:[self getNickName]];
    [head_view setRoleTag:[self getRoleTag]];
    [head_view setRelations:[self getRelations]];
    [head_view setShareCount:[self getSharedCount] andThumUpCount:[self getSharedCount] andBeenThumupCount:[self getSharedCount]];
}

- (void)createFakeNaviBar {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    UIView* fake_bar = [[UIView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, FAKE_BAR_HEIGHT)];
    fake_bar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:fake_bar];
    [self.view bringSubviewToFront:fake_bar];
    
    if (self.navigationController.viewControllers.count > 1) {
        UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 25)];
        NSString* filepath = [resourceBundle pathForResource:@"dongda_back" ofType:@"png"];
        CALayer * layer = [CALayer layer];
        layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
        layer.frame = CGRectMake(10, 10, 25, 25);
        [barBtn.layer addSublayer:layer];
        [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
        [fake_bar addSubview:barBtn];
        
    } else {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - 15 - 30, 0, 30, 25)];
        NSString* filepath = [resourceBundle pathForResource:@"profile_setting_dark" ofType:@"png"];
        CALayer * layer = [CALayer layer];
        layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
        layer.frame = CGRectMake(0, 10, 25, 25);
        [barBtn.layer addSublayer:layer];
        [barBtn addTarget:self action:@selector(didSelectSettingBtn) forControlEvents:UIControlEventTouchDown];
        [fake_bar addSubview:barBtn];
    }
}

#pragma mark -- life cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    dispatch_queue_t q1 = dispatch_queue_create("om queue", nil);
    dispatch_async(q1, ^{
        [_om queryContentsByUser:_current_user_id withToken:_current_auth_token andOwner:_owner_id withStartIndex:0 finishedBlock:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_queryView reloadData];
                [self resetProfileData];
                [search_seg refreshItemTitle:[NSString stringWithFormat:@"%d", _om.querydata.count] atIndex:0];
            });
        }];
        dispatch_semaphore_signal(semaphore_om);
    });
    
    //    dispatch_semaphore_wait(semaphore_opm, DISPATCH_TIME_FOREVER);
    dispatch_queue_t q2 = dispatch_queue_create("opm queue", nil);
    dispatch_async(q2, ^{
        [_opm queryContentsByUser:_current_user_id withToken:_current_auth_token andOwner:_owner_id withStartIndex:0 finishedBlock:^(BOOL success) {
            [_queryView reloadData];
            [self resetProfileData];
            [search_seg refreshItemTitle:[NSString stringWithFormat:@"%d", _opm.querydata.count] atIndex:1];
        }];
        dispatch_semaphore_signal(semaphore_opm);
    });
   
    [self updateProfileDetails];
    
    dispatch_semaphore_wait(semaphore_om, DISPATCH_TIME_FOREVER);
    dispatch_semaphore_wait(semaphore_opm, DISPATCH_TIME_FOREVER);
    dispatch_semaphore_wait(semaphore_user_info, DISPATCH_TIME_FOREVER);
}

#pragma mark -- actions
- (void)didPopControllerSelected {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
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
                 [self resetProfileData];
//                self.navigationItem.title = [dic_profile_details objectForKey:@"screen_name"];
            });
            
        } else {
            NSDictionary* reError = [result objectForKey:@"error"];
            NSString* msg = [reError objectForKey:@"message"];
            
            NSLog(@"query user profile failed");
            NSLog(@"%@", msg);
        }
        dispatch_semaphore_signal(semaphore_user_info);
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

- (NSInteger)getRelations {
    return ((NSNumber*)[dic_profile_details objectForKey:@"relations"]).integerValue;
}

- (OwnerQueryModel*)getOM {
    return _om;
}

- (OwnerQueryPushModel*)getOPM {
    return _opm;
}

- (NSArray*)getQueryData {
    return search_seg.selectedIndex == 0 ? _om.querydata : _opm.querydata;
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
            [_cm followOneUser:follow_user_id withFinishBlock:^(BOOL success, NSString *message, UserPostOwnerConnections new_connections) {
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
            [_cm unfollowOneUser:follow_user_id withFinishBlock:^(BOOL success, NSString *message, UserPostOwnerConnections new_connections) {
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
    return NO;
}

- (BOOL)isAllowMultipleSelected {
    return NO;
}

- (void)didSelectOneImageAtIndex:(NSInteger)index {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController* hv = [storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    hv.isPushed = YES;
    hv.delegate = [[UserHomeViewDataDelegate alloc]init];
    [hv.delegate pushExistingData:[self getOM].querydata];
    [hv.delegate setSelectIndex:index];
    hv.nav_title = [self getNickName];
    hv.current_index = index;
    [self.navigationController pushViewControllerRetro:hv];
}

#pragma mark -- change date
- (void)personalDetailChanged:(NSDictionary *)dic {
    for (NSString* key in dic.allKeys) {
        [dic_profile_details setValue:[dic objectForKey:key] forKey:key];
    }
}

#pragma mark -- search seg view delegate
- (void)segValueChanged2:(SearchSegView2*)seg {
    [_queryView reloadData];
}

@end