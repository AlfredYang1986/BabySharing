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
#import "Tools.h"

//#define BASE_LINE_HEIGHT        115
#define BASE_LINE_HEIGHT        185
#define MARGIN_AFTER_BASE_LINE  8
#define BUTTON_WIDTH            90
#define BUTTON_HEIGHT           25
#define HEADER_BOTTOM_MARGIN    10
#define SPLIT_LINE_HEIGHT       2

#define ICE_HOT_ICON_WIDTH    20
#define ICE_HOT_ICON_HEIGHT   20
#define HOT_RIGHT_MARGIN       8

#define NAME_LABEL_FONT_SIZE                    14.f
#define ROLE_TAG_LABEL_FONT_SIZE                12.f
#define LOCATION_LABEL_FONT_SIZE                13.f

#define NAME_LABEL_2_SCREEN_PHOTO_MARGIN        50
#define ROLE_TAG_LABEL_2_SCREEN_PHOTO_MARGIN    9
#define NAME_LABEL_2_ROLE_TAG_LABEL_MARGIN      4.5
#define LOCATION_LABEL_2_SCREEN_PHOTO_MARGIN    70

#define LOCATION_ICON_WIDTH                     11
#define LOCATION_ICON_HEIGHT                    LOCATION_ICON_WIDTH

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

#define USER_PHOTO_WIDTH                        75
#define USER_PHOTO_HEIGHT                       USER_PHOTO_HEIGHT

@interface ProfileOverView ()

@property (strong, nonatomic) UIImageView *imgView;

@property (strong, nonatomic) OBShapedButton* userRoleTagBtn;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation ProfileOverView {
    UIView* hotTagView;
    OBShapedButton* relations_btn;
//    SearchSegView2* search_seg;
    
    UIView* white_area;
    UILabel* thumup;
}

@synthesize imgView = _imgView;

@synthesize locationLabel = _locationLabel;
@synthesize nameLabel = _nameLabel;

//@synthesize seg = _seg;
@synthesize userRoleTagBtn = _userRoleTagBtn;

- (void)awakeFromNib {
    [self setUpViews];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {

//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    /*************************************************************************************************************************/
    // split line
//    CALayer* layer = [CALayer layer];
//    layer.borderColor = [UIColor whiteColor].CGColor;
//    layer.borderWidth = 2.f;
//    layer.frame = CGRectMake(0, self.frame.size.height - SPLIT_LINE_HEIGHT /*- [SearchSegView2 preferredHeight]*/, width, SPLIT_LINE_HEIGHT);
//    [bkView.layer addSublayer:layer];
//    [self.layer addSublayer:layer];
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/
    // seg
//    search_seg = [[SearchSegView2 alloc]initWithFrame:CGRectMake(0, self.frame.size.height - [SearchSegView2 preferredHeight], width, [SearchSegView2 preferredHeight])];

    // seg background
//    UIImage* img_seg_bg = [UIImage imageNamed:[resourceBundle pathForResource:@"profile_seg_bg" ofType:@"png"]];
//    CALayer* seg_bg = [CALayer layer];
//    seg_bg.contents = (id)img_seg_bg.CGImage;
//    seg_bg.frame = CGRectMake(0, 0, SCREEN_WIDTH, [SearchSegView2 preferredHeight]);
//    [search_seg.layer addSublayer:seg_bg];
//    
//    [search_seg addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_grid" ofType:@"png"]] andSelectImage:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_grid_selected" ofType:@"png"]]];
//    [search_seg addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_tag" ofType:@"png"]] andSelectImage:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_tag_selected" ofType:@"png"]]];
//    [search_seg addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_forward" ofType:@"png"]] andSelectImage:[UIImage imageNamed:[resourceBundle pathForResource:@"profile_forward_selected" ofType:@"png"]]];
//   
//    search_seg.selectedIndex = 0;
//    search_seg.margin_between_items = 0.148 * SCREEN_WIDTH;
//    [bkView addSubview:search_seg];
    
//    CALayer* line0 = [CALayer layer];
//    line0.borderWidth = 1.5f;
//    line0.borderColor = [UIColor whiteColor].CGColor;
//    line0.frame = CGRectMake(SCREEN_WIDTH / 3, 11, 1, 22);
//    [search_seg.layer addSublayer:line0];
//    
//    CALayer* line1 = [CALayer layer];
//    line1.borderWidth = 1.5f;
//    line1.borderColor = [UIColor whiteColor].CGColor;
//    line1.frame = CGRectMake(SCREEN_WIDTH * 2 / 3, 11, 1, 22);
//    [search_seg.layer addSublayer:line1];
    
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/
    // location label
    _locationLabel = [[UILabel alloc]init];
    _locationLabel.textColor = [UIColor whiteColor];
    _locationLabel.font = [UIFont systemFontOfSize:LOCATION_LABEL_FONT_SIZE];
    [self addSubview:_locationLabel];
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/
    /**
     * white area
     */
#define MARGIN_LEFT                 10.5
#define MARGIN_REGIT                10.5
#define MARGIN_TOP                  80
#define MARGIN_BOTTN                5
#define WHITE_AREA_HEIGHT           98
    
#define WHITE_AREA_ORIGIN_Y         MARGIN_TOP
#define WHITE_AREA_TO_LOCATION      10.5
    white_area = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_LEFT, MARGIN_TOP, self.frame.size.width - MARGIN_LEFT - MARGIN_REGIT, WHITE_AREA_HEIGHT)];
    white_area.backgroundColor = [UIColor whiteColor];
    white_area.layer.cornerRadius = 4.f;
    [self addSubview:white_area];
//    [self bringSubviewToFront:white_area];
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/
    // image view
#define USER_PHOTO_WIDTH_2          72
#define USER_PHOTO_HEIGHT_2         USER_PHOTO_WIDTH_2
#define USER_PHOTO_BG_WIDTH_2       82
#define USER_PHOTO_BG_HEIGHT_2      USER_PHOTO_BG_WIDTH_2
#define IMG_OFFSET_X                64
#define IMG_OFFSET_Y                -10
#define IMG_BORDER_WIDTH            6
    
    UIView* bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, USER_PHOTO_BG_WIDTH_2, USER_PHOTO_BG_HEIGHT_2)];
    bg_view.center = CGPointMake(white_area.frame.origin.x + IMG_OFFSET_X, white_area.frame.origin.y + IMG_OFFSET_Y);
    bg_view.layer.cornerRadius = USER_PHOTO_BG_WIDTH_2 / 2;
    bg_view.clipsToBounds = YES;
    bg_view.backgroundColor = [UIColor whiteColor];
    [self addSubview:bg_view];
    [self bringSubviewToFront:bg_view];

    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, USER_PHOTO_WIDTH_2, USER_PHOTO_HEIGHT_2)];
    _imgView.center = CGPointMake(USER_PHOTO_BG_WIDTH_2 / 2,  USER_PHOTO_BG_HEIGHT_2 / 2);
    _imgView.layer.cornerRadius = USER_PHOTO_WIDTH_2 / 2;
//    _imgView.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.3].CGColor;
//    _imgView.layer.borderColor = [UIColor whiteColor].CGColor;
//    _imgView.layer.borderWidth = IMG_BORDER_WIDTH;
    _imgView.clipsToBounds = YES;
    [bg_view addSubview:_imgView];
    [bg_view bringSubviewToFront:_imgView];
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/
    // name label
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    _nameLabel.font = [UIFont systemFontOfSize:NAME_LABEL_FONT_SIZE];
    [white_area addSubview:_nameLabel];
    [white_area bringSubviewToFront:_nameLabel];
    /*************************************************************************************************************************/
    
    if (_userRoleTagBtn == nil) {
        _userRoleTagBtn = [[OBShapedButton alloc]init];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        [_userRoleTagBtn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"home_role_tag" ofType:@"png"]] forState:UIControlStateNormal];
        [white_area addSubview:_userRoleTagBtn];
        [white_area bringSubviewToFront:_userRoleTagBtn];
    }
    
    /*************************************************************************************************************************/
#define RELATION_BTN_WIDTH          69
#define RELATION_BTN_HEIGHT         25
    relations_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(white_area.frame.size.width - MARGIN_REGIT - RELATION_BTN_WIDTH, white_area.frame.size.height - MARGIN_REGIT - RELATION_BTN_HEIGHT, RELATION_BTN_WIDTH, RELATION_BTN_HEIGHT)];
    [relations_btn addTarget:self action:@selector(didSelectRelationBtn) forControlEvents:UIControlEventTouchUpInside];
    [white_area addSubview:relations_btn];
    [white_area bringSubviewToFront:relations_btn];
    /*************************************************************************************************************************/
    
//    hotTagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 25)];
//    [self addSubview:hotTagView];
    
//    hotTagView.center = CGPointMake(17.5 + 90 / 2, BASE_LINE_HEIGHT + MARGIN_AFTER_BASE_LINE + BUTTON_HEIGHT / 2 + 4);
//    relations_btn.center = CGPointMake(width - 10.5 - 69 / 2 , BASE_LINE_HEIGHT + MARGIN_AFTER_BASE_LINE + BUTTON_HEIGHT / 2);
    /*************************************************************************************************************************/
#define THUMSUP_DES_FONT_SIZE       13.f
    thumup = [[UILabel alloc]init];
    thumup.textColor = [UIColor colorWithWhite:0.6078 alpha:1.f];
    thumup.font = [UIFont systemFontOfSize:THUMSUP_DES_FONT_SIZE];
    [white_area addSubview:thumup];
    [white_area bringSubviewToFront:thumup];
}

- (void)setOwnerPhoto:(NSString*)photo_name {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
    
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

//- (void)setShareCount:(NSInteger)count {
//    
//    UIImageView* img = [hotTagView viewWithTag:-1];
//    if (img == nil) {
//        img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ICE_HOT_ICON_WIDTH, ICE_HOT_ICON_HEIGHT)];
//        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
//        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"home_fire_red"] ofType:@"png"];
//        img.image = [UIImage imageNamed:filePath];
//        img.tag = -1;
//        [hotTagView addSubview:img];
//    }
//    
//    UIFont* font = [UIFont systemFontOfSize:14.f];
//    UILabel* label = [hotTagView viewWithTag:-2];
//    if (label == nil) {
//        label = [[UILabel alloc]init];
//        label.textColor = [UIColor colorWithRed:0.6078 green:0.6078 blue:0.6078 alpha:1.f];
//        label.font = font;
//        label.tag = -2;
//        label.textAlignment = NSTextAlignmentCenter;
//        [hotTagView addSubview:label];
//    }
//    
//    label.text = [NSString stringWithFormat:@"%d", count];
//    CGSize sz = [label.text sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
//    label.frame = CGRectMake(ICE_HOT_ICON_WIDTH + 10, 0, sz.width, MAX(ICE_HOT_ICON_HEIGHT, sz.height));
//    
//    CGFloat width = self.frame.size.width;
//    CGFloat view_width = ICE_HOT_ICON_WIDTH + label.frame.size.width;
//    hotTagView.frame = CGRectMake(0, 0, view_width, label.frame.size.height);
    //    _hotCountView.center = CGPointMake(width - view_width / 2 - HOT_RIGHT_MARGIN, HEADER_HEIGHT / 2);
//    hotTagView.center = CGPointMake(width - view_width / 2 - HOT_RIGHT_MARGIN, 16);
//}

//- (void)setCycleCount:(NSInteger)count {
//    NSString* tmp = [NSString stringWithFormat:@"%ld", (long)count];
//    _cycleCountLabel.text = tmp;
//}

//- (void)setFriendsCount:(NSInteger)count {
//    NSString* tmp = [NSString stringWithFormat:@"%ld", (long)count];
//    _friendsCountLabel.text = tmp;
//}

- (void)setLoation:(NSString*)location {
    _locationLabel.text = location;
    [_locationLabel sizeToFit];
    
//    _locationLabel.center = CGPointMake(SCREEN_WIDTH / 2, _imgView.center.y + _imgView.frame.size.height / 2 + LOCATION_LABEL_2_SCREEN_PHOTO_MARGIN);
    _locationLabel.center = CGPointMake(SCREEN_WIDTH - _locationLabel.frame.size.width / 2 - MARGIN_REGIT * 2, WHITE_AREA_ORIGIN_Y - _locationLabel.frame.size.height / 2 - WHITE_AREA_TO_LOCATION);
}

- (void)setPersonalSign:(NSString*)sign_content {
//    _personalSignLabel.text = sign_content;
}

- (void)setNickName:(NSString*)nickName {
    _nameLabel.text = nickName;
    [_nameLabel sizeToFit];
#define NAME_MARGIN_TOP         37
    _nameLabel.center = CGPointMake(MARGIN_LEFT + _nameLabel.frame.size.width / 2, NAME_MARGIN_TOP + _nameLabel.frame.size.height / 2);
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
//    _userRoleTagBtn.center = CGPointMake(SCREEN_WIDTH / 2 + NAME_LABEL_2_ROLE_TAG_LABEL_MARGIN + _userRoleTagBtn.frame.size.width / 2, _imgView.center.y + _imgView.frame.size.height / 2 + NAME_LABEL_2_SCREEN_PHOTO_MARGIN);
    _userRoleTagBtn.center = CGPointMake(_nameLabel.center.x + _nameLabel.frame.size.width / 2 + _userRoleTagBtn.frame.size.width / 2 + 8, _nameLabel.center.y);
    
    if ([@"" isEqualToString:role_tag]) {
        _userRoleTagBtn.hidden = YES;
//        _nameLabel.center = CGPointMake(SCREEN_WIDTH / 2, _imgView.center.y + _imgView.frame.size.height / 2 + NAME_LABEL_2_SCREEN_PHOTO_MARGIN);
    }
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
    relations_btn.tag = 100 - relations;
}

//+ (CGFloat)preferredHeight {
//    return 225;
//    return BASE_LINE_HEIGHT + MARGIN_AFTER_BASE_LINE + BUTTON_HEIGHT + HEADER_BOTTOM_MARGIN + SPLIT_LINE_HEIGHT + [SearchSegView2 preferredHeight];
//    return 295;
//}

- (IBAction)editBtnSelected {
    [_deleagate editBtnSelected];
}

- (void)segControlValueChanged {
//    [_deleagate segControlValueChangedWithSelectedIndex:_seg.selectedSegmentIndex];
}

- (void)didSelectRelationBtn {
    if (relations_btn.tag == 100 - UserPostOwnerConnectionsSamePerson) {
        [_deleagate editBtnSelected];
    } else {
        [_deleagate followBtnSelected];
    }
}

- (void)setShareCount:(NSInteger)share_count andThumUpCount:(NSInteger)thumup_count andBeenThumupCount:(NSInteger)been_thumup_count {
    thumup.text = [NSString stringWithFormat:@"赞 %ld    被赞 %ld    被推 %ld", (long)thumup_count, (long)been_thumup_count, (long)share_count];
    [thumup sizeToFit];
    thumup.frame = CGRectMake(MARGIN_LEFT, NAME_MARGIN_TOP + thumup.frame.size.height + 18, thumup.frame.size.width, thumup.frame.size.height);
    thumup.center = CGPointMake(thumup.center.x, relations_btn.center.y);
}
@end
