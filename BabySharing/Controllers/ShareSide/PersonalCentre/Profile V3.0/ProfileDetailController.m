//
//  ProfileDetailController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 14/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "ProfileDetailController.h"
#import "ProfileDetailUserHeaderCell.h"
#import "ProfileDetailPostCell.h"
#import "TmpFileStorageModel.h"
#import "profileDetailTagsCell.h"
#import "ProfileDetailLocationCell.h"
#import "ProfileDetailChatGroupCell.h"
#import "ProfileDetailSNCell.h"

@interface ProfileDetailController ()
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *blockBtn;

@end

@implementation ProfileDetailController {
    UIImage* backgroudImg;
}

@synthesize queryView = _queryView;
@synthesize chatBtn = _chatBtn;
@synthesize followBtn = _followBtn;
@synthesize blockBtn = _blockBtn;

@synthesize current_user_id = _current_user_id;
@synthesize current_auth_token = _current_auth_token;
@synthesize query_user_id = _query_user_id;
@synthesize query_screen_name = _query_screen_name;
@synthesize query_screen_photo = _query_screen_photo;
@synthesize followers_count = _followers_count;
@synthesize followings_count = _followerings_count;
@synthesize posts_count = _posts_count;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    [_chatBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"StartChat"] ofType:@"png"]] forState:UIControlStateNormal];
    [_followBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Plus2"] ofType:@"png"]] forState:UIControlStateNormal];
    [_blockBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Forbidden"] ofType:@"png"]] forState:UIControlStateNormal];
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Previous"] ofType:@"png"]] style:UIBarButtonItemStylePlain target:self action:@selector(dismissProfileDetailController:)];
    
    /**
     * Profile Header Cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"ProfileDetailUserHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Profile Detail Header Cell"];

    /**
     * Profile Post Cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"ProfileDetailPostCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Profile Detail Post Cell"];
    
    /**
     * Profile Tags Cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"ProfileDetailTagsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Profile Detail Tags Cell"];
    
    /**
     * Profile Location Cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"ProfileDetailLocationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Profile Detail Location Cell"];

    /**
     * Profile Location Cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"ProfileDetailChatGroupCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Profile Detail Chat Group Cell"];

    /**
     * Profile Location Cell
     */
    [_queryView registerNib:[UINib nibWithNibName:@"ProfileDetailSNCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Profile Detail SN Cell"];
    
    
    backgroudImg = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"ProfileDetialBacgroud"] ofType:@"png"]];
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

#pragma mark -- life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)dismissProfileDetailController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didSelectStartChatBtn {
}

- (IBAction)didSelectFollowBtn {
}

- (IBAction)didSelectBlockBtn {
}


#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 271;
    else if (indexPath.row == 1)
        return 75;
    else if (indexPath.row == 2)
        return 62;
    else if (indexPath.row == 3)
        return 59;
    else if (indexPath.row == 4)
        return [ProfileDetailChatGroupCell getPerferHeight];
    else if (indexPath.row == 5)
        return 46;
    else
        return 44;
}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.row == 0)
        return [self queryDetailUerHeaderCellInTableView:tableView];
    else if (indexPath.row == 1)
        return [self queryPostCellInTableView:tableView];
    else if (indexPath.row == 2)
        return [self queryDetailTagsCellInTableView:tableView];
    else if (indexPath.row == 3)
        return [self queryDetailLocationCellInTableView:tableView];
    else if (indexPath.row == 4)
        return [self queryDetailChatGroupCellInTabelView:tableView];
    else if (indexPath.row == 5)
        return [self queryDetailSNCellInTabelView:tableView];
    else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
            
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
            
        cell.textLabel.text = @"alfred ..";
            
        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (ProfileDetailPostCell*)queryPostCellInTableView:(UITableView*)tableView {
    ProfileDetailPostCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Profile Detail Post Cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileDetailPostCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    UIImage* userImg = [TmpFileStorageModel enumImageWithName:_query_screen_photo withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
//        if (success) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                cell.screenPhotoImgView.image = user_img;
//                NSLog(@"owner img download success");
//            });
//        } else {
//            NSLog(@"down load owner image %@ failed", _query_screen_photo);
//            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//            NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
//            UIImage *image = [UIImage imageNamed:filePath];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                cell.screenPhotoImgView.image = image;
//            });
//        }
//    }];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
    UIImage *image = [UIImage imageNamed:filePath];
    cell.screenPhotoImgView.image = image;
    return cell;
}

- (ProfileDetailUserHeaderCell*)queryDetailUerHeaderCellInTableView:(UITableView*)tableView {
    
    ProfileDetailUserHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Profile Detail Header Cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileDetailUserHeaderCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.userBackgroudView.image = backgroudImg;
    cell.friendNumLabel.text = [NSString stringWithFormat:@"%ld", (long)_followerings_count];
    cell.pushNumLabel.text = [NSString stringWithFormat:@"%ld", (long)_posts_count];
    cell.thumsupNumLabel.text = [NSString stringWithFormat:@"%ld", (long)_followers_count];
   
    return cell;
}

- (ProfileDetailTagsCell*)queryDetailTagsCellInTableView:(UITableView*)tableView {
    ProfileDetailTagsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Profile Detail Tags Cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileDetailTagsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (ProfileDetailLocationCell*)queryDetailLocationCellInTableView:(UITableView*)tableView {
    ProfileDetailLocationCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Profile Detail Location Cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileDetailLocationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    return cell;
}

- (ProfileDetailChatGroupCell*)queryDetailChatGroupCellInTabelView:(UITableView*)tableView {
    ProfileDetailChatGroupCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Profile Detail Chat Group Cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileDetailChatGroupCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    return cell;
}

- (ProfileDetailSNCell*)queryDetailSNCellInTabelView:(UITableView*)tableView {
    ProfileDetailSNCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Profile Detail SN Cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileDetailSNCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
  
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    [cell resetSNImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"weibo"] ofType:@"png"]]];
    return cell;
}
@end
