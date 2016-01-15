//
//  ProfileOverView.m
//  BabySharing
//
//  Created by Alfred Yang on 1/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "ProfileOverView.h"
#import "TmpFileStorageModel.h"
#import "OBShapedButton.h"
#import "SearchSegView2.h"

#define BASE_LINE_HEIGHT        115
#define MARGIN_AFTER_BASE_LINE  8
#define BUTTON_WIDTH            90
#define BUTTON_HEIGHT           25
#define HEADER_BOTTOM_MARGIN    10
#define SPLIT_LINE_HEIGHT       2

#define ICE_HOT_ICON_WIDTH    15
#define ICE_HOT_ICON_HEIGHT   15
#define HOT_RIGHT_MARGIN       8

#define NAME_LABEL_FONT_SIZE                    14.f
#define ROLE_TAG_LABEL_FONT_SIZE                12.f
#define LOCATION_LABEL_FONT_SIZE                12.f

#define NAME_LABEL_2_SCREEN_PHOTO_MARGIN        15
#define ROLE_TAG_LABEL_2_SCREEN_PHOTO_MARGIN    9
#define NAME_LABEL_2_ROLE_TAG_LABEL_MARGIN      4.5
#define LOCATION_LABEL_2_SCREEN_PHOTO_MARGIN    35

#define LOCATION_ICON_WIDTH                     11
#define LOCATION_ICON_HEIGHT                    LOCATION_ICON_WIDTH

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

@interface ProfileOverView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet OBShapedButton* userRoleTagBtn;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ProfileOverView {
    UIView* hotTagView;
    OBShapedButton* relations_btn;
    SearchSegView2* search_seg;
}

@synthesize imgView = _imgView;

@synthesize locationLabel = _locationLabel;
@synthesize nameLabel = _nameLabel;

//@synthesize seg = _seg;
@synthesize userRoleTagBtn = _userRoleTagBtn;

- (void)awakeFromNib {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    /*************************************************************************************************************************/
    // name label
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = [UIColor lightGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:NAME_LABEL_FONT_SIZE];
    [self addSubview:_nameLabel];
    /*************************************************************************************************************************/

    /*************************************************************************************************************************/
    // location label
    _locationLabel = [[UILabel alloc]init];
    _locationLabel.textColor = [UIColor lightGrayColor];
    _locationLabel.font = [UIFont systemFontOfSize:LOCATION_LABEL_FONT_SIZE];
    [self addSubview:_locationLabel];
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/
    // background view
    UIView* bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, [ProfileOverView preferredHeight])];
//    bkView.backgroundColor = [UIColor whiteColor];
    bkView.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    bkView.tag = -1;
    [self addSubview:bkView];
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/
    // image view
    _imgView.layer.cornerRadius = 25.f;
    _imgView.clipsToBounds = YES;
    
    hotTagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 25)];
    [self addSubview:hotTagView];
    
    relations_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(0, 0, 69, 25)];
    [self addSubview:relations_btn];
   
    hotTagView.center = CGPointMake(17.5 + 90 / 2, BASE_LINE_HEIGHT + MARGIN_AFTER_BASE_LINE + BUTTON_HEIGHT / 2 + 4);
    relations_btn.center = CGPointMake(width - 10.5 - 69 / 2 , BASE_LINE_HEIGHT + MARGIN_AFTER_BASE_LINE + BUTTON_HEIGHT / 2);
    /*************************************************************************************************************************/
   
    for (UIView* iter in self.subviews) {
        if (iter.tag != -1) {
            [self bringSubviewToFront:iter];
        }
    }
    
    /*************************************************************************************************************************/
    // split line
    CALayer* layer = [CALayer layer];
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 2.f;
    layer.frame = CGRectMake(0, bkView.frame.size.height - SPLIT_LINE_HEIGHT /*- [SearchSegView2 preferredHeight]*/, width, SPLIT_LINE_HEIGHT);
    [bkView.layer addSublayer:layer];
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/
    // seg
    search_seg = [[SearchSegView2 alloc]initWithFrame:CGRectMake(0, bkView.frame.size.height - [SearchSegView2 preferredHeight], width, [SearchSegView2 preferredHeight])];

    // seg background
    UIImage* img_seg_bg = [UIImage imageNamed:[resourceBundle pathForResource:@"profile_seg_bg" ofType:@"png"]];
    CALayer* seg_bg = [CALayer layer];
    seg_bg.contents = (id)img_seg_bg.CGImage;
    seg_bg.frame = CGRectMake(0, 0, SCREEN_WIDTH, [SearchSegView2 preferredHeight]);
    [search_seg.layer addSublayer:seg_bg];
    
    [search_seg addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_grid" ofType:@"png"]] andSelectImage:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_grid_selected" ofType:@"png"]]];
    [search_seg addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_tag" ofType:@"png"]] andSelectImage:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_tag_selected" ofType:@"png"]]];
    [search_seg addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_forward" ofType:@"png"]] andSelectImage:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_forward_selected" ofType:@"png"]]];
   
    search_seg.selectedIndex = 0;
    search_seg.margin_between_items = 30;
    [bkView addSubview:search_seg];
    /*************************************************************************************************************************/
    
    if (_userRoleTagBtn == nil) {
        _userRoleTagBtn = [[OBShapedButton alloc]init];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        [_userRoleTagBtn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"home_role_tag" ofType:@"png"]] forState:UIControlStateNormal];
        [self addSubview:_userRoleTagBtn];
    }
}

- (void)setOwnerPhoto:(NSString*)photo_name {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
    
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    self.imgView.image = user_img;
                    NSLog(@"owner img download success");
                }
            });
        } else {
            NSLog(@"down load owner image %@ failed", photo_name);
        }
    }];
    
    if (userImg == nil) {
        userImg = [UIImage imageNamed:filePath];
    }
    [self.imgView setImage:userImg];
}

- (void)setShareCount:(NSInteger)count {
    
    UIImageView* img = [hotTagView viewWithTag:-1];
    if (img == nil) {
        img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ICE_HOT_ICON_WIDTH, ICE_HOT_ICON_HEIGHT)];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"home_fire_red"] ofType:@"png"];
        img.image = [UIImage imageNamed:filePath];
        img.tag = -1;
        [hotTagView addSubview:img];
    }
    
    UIFont* font = [UIFont systemFontOfSize:14.f];
    UILabel* label = [hotTagView viewWithTag:-2];
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithRed:0.6078 green:0.6078 blue:0.6078 alpha:1.f];
        label.font = font;
        label.tag = -2;
        label.textAlignment = NSTextAlignmentCenter;
        [hotTagView addSubview:label];
    }
    
    label.text = [NSString stringWithFormat:@"%d", count];
    CGSize sz = [label.text sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    label.frame = CGRectMake(ICE_HOT_ICON_WIDTH + 10, 0, sz.width, MAX(ICE_HOT_ICON_HEIGHT, sz.height));
    
//    CGFloat width = self.frame.size.width;
//    CGFloat view_width = ICE_HOT_ICON_WIDTH + label.frame.size.width;
//    hotTagView.frame = CGRectMake(0, 0, view_width, label.frame.size.height);
    //    _hotCountView.center = CGPointMake(width - view_width / 2 - HOT_RIGHT_MARGIN, HEADER_HEIGHT / 2);
//    hotTagView.center = CGPointMake(width - view_width / 2 - HOT_RIGHT_MARGIN, 16);
}

- (void)setCycleCount:(NSInteger)count {
//    NSString* tmp = [NSString stringWithFormat:@"%ld", (long)count];
//    _cycleCountLabel.text = tmp;
}

- (void)setFriendsCount:(NSInteger)count {
//    NSString* tmp = [NSString stringWithFormat:@"%ld", (long)count];
//    _friendsCountLabel.text = tmp;
}

- (void)setLoation:(NSString*)location {
    _locationLabel.text = location;
    [_locationLabel sizeToFit];
    
    _locationLabel.center = CGPointMake(SCREEN_WIDTH / 2, _imgView.center.y + _imgView.frame.size.height / 2 + LOCATION_LABEL_2_SCREEN_PHOTO_MARGIN);
}

- (void)setPersonalSign:(NSString*)sign_content {
//    _personalSignLabel.text = sign_content;
}

- (void)setRoleTag:(NSString*)role_tag {
//    [_roleTagBtn setTitle:role_tag forState:UIControlStateNormal];
    _userRoleTagBtn.hidden = NO;
    UILabel* label = [_userRoleTagBtn viewWithTag:-1];
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:ROLE_TAG_LABEL_FONT_SIZE];
        label.textColor = [UIColor whiteColor];
        label.tag = -1;
        [_userRoleTagBtn addSubview:label];
    }
    
#define ROLE_TAG_MARGIN             2
#define ROLETAG_LEFT_MARGIN         ROLE_TAG_MARGIN
    
    label.text = role_tag;
    [label sizeToFit];
    label.center = CGPointMake(ROLETAG_LEFT_MARGIN + label.frame.size.width / 2, ROLE_TAG_MARGIN + label.frame.size.height / 2);
   
    CGFloat width = self.frame.size.width;
    _userRoleTagBtn.frame = CGRectMake(width / 2 + ROLETAG_LEFT_MARGIN, 8, label.frame.size.width + ROLE_TAG_MARGIN + ROLE_TAG_MARGIN, label.frame.size.height + 2 * ROLE_TAG_MARGIN);
    _userRoleTagBtn.center = CGPointMake(SCREEN_WIDTH / 2 + NAME_LABEL_2_ROLE_TAG_LABEL_MARGIN + _userRoleTagBtn.frame.size.width / 2, _imgView.center.y + _imgView.frame.size.height / 2 + NAME_LABEL_2_SCREEN_PHOTO_MARGIN);
    
    if ([@"" isEqualToString:role_tag]) {
        _userRoleTagBtn.hidden = YES;
        _nameLabel.center = CGPointMake(SCREEN_WIDTH / 2, _imgView.center.y + _imgView.frame.size.height / 2 + NAME_LABEL_2_SCREEN_PHOTO_MARGIN);
    }
}

- (void)setNickName:(NSString*)nickName {
    _nameLabel.text = nickName;
    [_nameLabel sizeToFit];
    _nameLabel.center = CGPointMake(SCREEN_WIDTH / 2 - NAME_LABEL_2_ROLE_TAG_LABEL_MARGIN - _nameLabel.frame.size.width / 2, _imgView.center.y + _imgView.frame.size.height / 2 + NAME_LABEL_2_SCREEN_PHOTO_MARGIN);
}

- (void)setRelations:(UserPostOwnerConnections)relations {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    switch (relations) {
        case UserPostOwnerConnectionsSamePerson:
            // my own post, do nothing
            [relations_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"friend_relation_myself"] ofType:@"png"]] forState:UIControlStateNormal];
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed:
            [relations_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"friend_relation_follow"] ofType:@"png"]] forState:UIControlStateNormal];
            
            break;
            //            return @"+关注";
        case UserPostOwnerConnectionsFollowing:
            [relations_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"friend_relation_following"] ofType:@"png"]] forState:UIControlStateNormal];
            break;
        case UserPostOwnerConnectionsFriends:
            [relations_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"friend_relation_muture_follow"] ofType:@"png"]] forState:UIControlStateNormal];
            //                return @"取消关注";
            break;
            //            return @"-取关";
        default:
            break;
    }
}

+ (CGFloat)preferredHeight {
//    return 225;
    return BASE_LINE_HEIGHT + MARGIN_AFTER_BASE_LINE + BUTTON_HEIGHT + HEADER_BOTTOM_MARGIN + SPLIT_LINE_HEIGHT + [SearchSegView2 preferredHeight];
}

- (IBAction)editBtnSelected {
    [_deleagate editBtnSelected];
}

- (void)segControlValueChanged {
//    [_deleagate segControlValueChangedWithSelectedIndex:_seg.selectedSegmentIndex];
}
@end
