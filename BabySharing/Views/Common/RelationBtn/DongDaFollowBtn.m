//
//  DongDaFollowBtn.m
//  BabySharing
//
//  Created by Alfred Yang on 16/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "DongDaFollowBtn.h"

#define IMG_WIDTH   30
#define IMG_HEIGHT  IMG_WIDTH
#define MARGIN      4

@implementation DongDaFollowBtn {
    UILabel* label;
    UIImageView* icon;
    
    NSMutableDictionary* icon_imgs;
}

@synthesize relations = _relations;
@synthesize delegate = _delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    self = [super initWithFrame:[DongDaFollowBtn preferredRect]];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    
    UIFont* font = [UIFont systemFontOfSize:11.f];
    label = [[UILabel alloc]init];
    label.textColor = [UIColor colorWithRed:0.1373 green:0.1216 blue:0.1255 alpha:1.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"加关注";
    label.font = font;
    [self addSubview:label];
    
    icon = [[UIImageView alloc]init];
    icon.contentMode = UIViewContentModeCenter;

    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    icon_imgs = [[NSMutableDictionary alloc]init];
    [icon_imgs setObject:[UIImage imageNamed:[resourceBundle pathForResource:@"FollowBtnIcon" ofType:@"png"]] forKey:kUserPostOwnerConnectionsNone];
    [icon_imgs setObject:[UIImage imageNamed:[resourceBundle pathForResource:@"FollowBtnIcon" ofType:@"png"]] forKey:kUserPostOwnerConnectionsFollowed];

    
    icon.image = [icon_imgs objectForKey:kUserPostOwnerConnectionsNone];
    [self addSubview:icon];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnSelected)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    UIFont* font = [UIFont systemFontOfSize:11.f];
    CGSize s = [@"我靠尼玛" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
//    CGSize s = [DongDaFollowBtn preferredSize];
    icon.frame = CGRectMake(0, MARGIN, width, height - s.height - MARGIN);
   
    CGFloat offset = height - s.height;
    label.frame = CGRectMake(0, offset, width, s.height);
}

+ (CGSize)preferredSize {
   
    UIFont* font = [UIFont systemFontOfSize:11.f];
    CGSize s = [@"我靠尼玛" sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    
    return CGSizeMake(MAX(IMG_WIDTH, s.width) + MARGIN, s.height + IMG_HEIGHT + MARGIN);
}

+ (CGRect)preferredRect {
    CGSize s = [self preferredSize];
    return CGRectMake(0, 0, s.width, s.height);
}

- (void)changeRelations:(UserPostOwnerConnections)relations {
    _relations = relations;
    
    switch (_relations) {
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed:
            label.text = @"加关注";
            break;
        case UserPostOwnerConnectionsFollowing:
        case UserPostOwnerConnectionsFriends:
            label.text = @"取消关注";
            break;
        case UserPostOwnerConnectionsSamePerson:
            label.text = @"我发的";
            break;
        default:
            break;
    }
}

- (void)btnSelected {
    [_delegate btnSelected];
}
@end
