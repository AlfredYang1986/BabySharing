//
//  ProfileOverView.m
//  BabySharing
//
//  Created by Alfred Yang on 1/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "ProfileOthersOverView.h"
#import "TmpFileStorageModel.h"
#import "OBShapedButton.h"
#import "SearchSegView2.h"

#define BASE_LINE_HEIGHT        115
#define MARGIN_AFTER_BASE_LINE  8
#define BUTTON_WIDTH            90
#define BUTTON_HEIGHT           25
#define HEADER_BOTTOM_MARGIN    10
#define SPLIT_LINE_HEIGHT       4

#define ICE_HOT_ICON_WIDTH    15
#define ICE_HOT_ICON_HEIGHT   25
#define HOT_RIGHT_MARGIN       8

@interface ProfileOthersOverView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

//@property (weak, nonatomic) IBOutlet UIView *countContainer;
@property (weak, nonatomic) IBOutlet UILabel *shareCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cycleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (strong, nonatomic) IBOutlet OBShapedButton* userRoleTagBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;


//@property (weak, nonatomic) IBOutlet UIView *buttomContainer;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
//@property (weak, nonatomic) IBOutlet UILabel *personalSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@end

@implementation ProfileOthersOverView {
    UIView* hotTagView;
    OBShapedButton* relations_btn;
    SearchSegView2* search_seg;
}

@synthesize imgView = _imgView;

//@synthesize countContainer = _countContainer;
@synthesize shareCountLabel = _shareCountLabel;
@synthesize cycleCountLabel = _cycleCountLabel;
@synthesize friendsCountLabel = _friendsCountLabel;

@synthesize followBtn = _followBtn;
//@synthesize roleTagBtn = _roleTagBtn;
@synthesize chatBtn = _chatBtn;

//@synthesize buttomContainer = _buttomContainer;
@synthesize locationLabel = _locationLabel;
//@synthesize personalSignLabel = _personalSignLabel;
@synthesize nameLabel = _nameLabel;

@synthesize seg = _seg;

@synthesize deleagate = _deleagate;
@synthesize userRoleTagBtn = _userRoleTagBtn;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
//    _roleTagBtn.layer.borderColor = [UIColor blueColor].CGColor;
//    _roleTagBtn.layer.borderWidth = 1.f;
//    _roleTagBtn.layer.cornerRadius = 8.f;
//    _roleTagBtn.clipsToBounds = YES;

//    _followBtn.layer.borderWidth = 1.f;
    _followBtn.layer.cornerRadius = 25.f;
    _followBtn.clipsToBounds = YES;
    [_followBtn setBackgroundColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f]];
    [_followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_followBtn addTarget:_deleagate action:@selector(followBtnSelected) forControlEvents:UIControlEventTouchDown];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    _seg.backgroundColor = [UIColor whiteColor];
    [_seg setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Grid"] ofType:@"png"]] forSegmentAtIndex:0];
    [_seg setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Tag"] ofType:@"png"]] forSegmentAtIndex:1];
    [_seg setImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Location"] ofType:@"png"]] forSegmentAtIndex:2];
    
    _chatBtn.layer.cornerRadius = 25.f;
    _chatBtn.clipsToBounds = YES;
    [_chatBtn setBackgroundColor:[UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f]];
    [_chatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_chatBtn addTarget:_deleagate action:@selector(chatBtnSelected) forControlEvents:UIControlEventTouchDown];

    [_seg addTarget:_deleagate action:@selector(segControlValueChangedWithSelectedIndex:) forControlEvents:UIControlEventValueChanged];
    
    _imgView.layer.cornerRadius = 25.f;
    _imgView.clipsToBounds = YES;
    
    hotTagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 25)];
    [self addSubview:hotTagView];
    
    relations_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(0, 0, 90, 25)];
    [self addSubview:relations_btn];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    hotTagView.center = CGPointMake(width / 2 - BUTTON_WIDTH / 2, BASE_LINE_HEIGHT + MARGIN_AFTER_BASE_LINE + BUTTON_HEIGHT / 2);
    relations_btn.center = CGPointMake(width / 2 + BUTTON_WIDTH / 2, BASE_LINE_HEIGHT + MARGIN_AFTER_BASE_LINE + BUTTON_HEIGHT / 2);
    
    UIView* bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, [ProfileOthersOverView preferredHeight])];
    bkView.backgroundColor = [UIColor whiteColor];
    bkView.tag = -1;
    [self addSubview:bkView];
    
    for (UIView* iter in self.subviews) {
        if (iter.tag != -1) {
            [self bringSubviewToFront:iter];
        }
    }
    
    _nameLabel.textColor = [UIColor lightGrayColor];
    
    CALayer* layer = [CALayer layer];
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer.borderWidth = 2.f;
    layer.frame = CGRectMake(0, bkView.frame.size.height - SPLIT_LINE_HEIGHT - [SearchSegView2 preferredHeight], width, SPLIT_LINE_HEIGHT);
    [bkView.layer addSublayer:layer];
    
    search_seg = [[SearchSegView2 alloc]initWithFrame:CGRectMake(0, bkView.frame.size.height - [SearchSegView2 preferredHeight], width, [SearchSegView2 preferredHeight])];
    [search_seg addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:@"profile-grid" ofType:@"png"]] andSelectImage:[UIImage imageNamed:[resourceBundle pathForResource:@"profile-grid-selected" ofType:@"png"]]];
    [search_seg addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:@"profile-timeline" ofType:@"png"]] andSelectImage:[UIImage imageNamed:[resourceBundle pathForResource:@"profile-timeline-selected" ofType:@"png"]]];
    [search_seg addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:@"profile-tag" ofType:@"png"]] andSelectImage:[UIImage imageNamed:[resourceBundle pathForResource:@"profile-tag-selected" ofType:@"png"]]];
    
    search_seg.selectedIndex = 0;
    search_seg.margin_between_items = 30;
    [bkView addSubview:search_seg];
    
    if (_userRoleTagBtn == nil) {
        _userRoleTagBtn = [[OBShapedButton alloc]init];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        [_userRoleTagBtn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"home-tag" ofType:@"png"]] forState:UIControlStateNormal];
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
//    NSString* tmp = [NSString stringWithFormat:@"%ld", (long)count];
//    _shareCountLabel.text = tmp;
    
    UIImageView* img = [hotTagView viewWithTag:-1];
    if (img == nil) {
        img = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, ICE_HOT_ICON_WIDTH, ICE_HOT_ICON_HEIGHT)];
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"home-hot-icon"] ofType:@"png"];
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
    label.frame = CGRectMake(ICE_HOT_ICON_WIDTH + 30, 0, sz.width, MAX(ICE_HOT_ICON_HEIGHT, sz.height));
}

- (void)setCycleCount:(NSInteger)count {
    NSString* tmp = [NSString stringWithFormat:@"%ld", (long)count];
    _cycleCountLabel.text = tmp;
}

- (void)setFriendsCount:(NSInteger)count {
    NSString* tmp = [NSString stringWithFormat:@"%ld", (long)count];
    _friendsCountLabel.text = tmp;
}

- (void)setLoation:(NSString*)location {
    _locationLabel.text = location;
}

- (void)setPersonalSign:(NSString*)sign_content {
//    _personalSignLabel.text = sign_content;
    
}

//- (void)setRelations:(NSString*)relations {
//    [_followBtn setTitle:relations forState:UIControlStateNormal];
//}

- (void)setRelations:(UserPostOwnerConnections)relations {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    switch (relations) {
        case UserPostOwnerConnectionsSamePerson:
            // my own post, do nothing
            [relations_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"relations-myself"] ofType:@"png"]] forState:UIControlStateNormal];
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed:
            [relations_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"relations-unfollowed"] ofType:@"png"]] forState:UIControlStateNormal];
            
            break;
            //            return @"+关注";
        case UserPostOwnerConnectionsFollowing:
            [relations_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"relations-followed"] ofType:@"png"]] forState:UIControlStateNormal];
            break;
        case UserPostOwnerConnectionsFriends:
            [relations_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"relations-friends"] ofType:@"png"]] forState:UIControlStateNormal];
            //                return @"取消关注";
            break;
            //            return @"-取关";
        default:
            break;
    }
}

- (void)setRoleTag:(NSString*)role_tag {
//    [_roleTagBtn setTitle:role_tag forState:UIControlStateNormal];
    _userRoleTagBtn.hidden = NO;
    UILabel* label = [_userRoleTagBtn viewWithTag:-1];
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor whiteColor];
        label.tag = -1;
        [_userRoleTagBtn addSubview:label];
    }
    
#define ROLE_TAG_MARGIN 2
    
    label.text = role_tag;
    [label sizeToFit];
    label.center = CGPointMake(10 + label.frame.size.width / 2, ROLE_TAG_MARGIN + label.frame.size.height / 2);
    
    //    CGFloat width = self.frame.size.width;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _userRoleTagBtn.frame = CGRectMake(width / 2 + 10, 8, label.frame.size.width + 10 + ROLE_TAG_MARGIN, label.frame.size.height + 2 * ROLE_TAG_MARGIN);
    
    if ([@"" isEqualToString:role_tag]) {
        _userRoleTagBtn.hidden = YES;
    }
}

- (void)setPersonalNickName:(NSString*)nickName {
    _nameLabel.text = nickName;
    [_nameLabel sizeToFit];
}

+ (CGFloat)preferredHeight {
    return BASE_LINE_HEIGHT + MARGIN_AFTER_BASE_LINE + BUTTON_HEIGHT + HEADER_BOTTOM_MARGIN + SPLIT_LINE_HEIGHT + [SearchSegView2 preferredHeight];
}
@end
