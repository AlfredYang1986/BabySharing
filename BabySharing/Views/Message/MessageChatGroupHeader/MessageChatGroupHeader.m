//
//  MessageChatGroupHeader.m
//  BabySharing
//
//  Created by Alfred Yang on 20/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "MessageChatGroupHeader.h"
#import "TmpFileStorageModel.h"
#import "ModelDefines.h"

@interface MessageChatGroupHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *founder_name_label;
@property (weak, nonatomic) IBOutlet UIButton *founder_role_tag_btn;
@property (weak, nonatomic) IBOutlet UILabel *online_count_label;
@property (weak, nonatomic) IBOutlet UIButton *relations;
@property (weak, nonatomic) IBOutlet UILabel *group_name_label;
@property (weak, nonatomic) IBOutlet UIButton *timeTagBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationTagBtn;
@property (weak, nonatomic) IBOutlet UIButton *tagsBtn;
@property (weak, nonatomic) IBOutlet UIView *user_list_view;

@end

@implementation MessageChatGroupHeader

// founder
@synthesize imgView = _imgView;
@synthesize founder_name_label = _founder_name_label;
@synthesize founder_role_tag_btn = _founder_role_tag_btn;
@synthesize relations = _relations;

// online number
@synthesize online_count_label = _online_count_label;

// user_list
@synthesize user_list_view = _user_list_view;

// group
@synthesize group_name_label = _group_name_label;
@synthesize locationTagBtn = _locationTagBtn;
@synthesize timeTagBtn = _timeTagBtn;
@synthesize tagsBtn = _tagsBtn;

+ (CGFloat)preferredHeight {
    return 164;
}

- (void)awakeFromNib {
    
    // round image
    _imgView.layer.cornerRadius = 25;
    _imgView.clipsToBounds = YES;
    
    // relationship btn
    _relations.layer.borderColor = [UIColor blueColor].CGColor;
    _relations.layer.borderWidth = 1.f;
    _relations.layer.cornerRadius = 8.f;
    _relations.clipsToBounds = YES;
    
    // theme btn
    _group_name_label.layer.borderColor = [UIColor blueColor].CGColor;
    _group_name_label.layer.borderWidth = 1.f;
    _group_name_label.layer.cornerRadius = 8.f;
    _group_name_label.clipsToBounds = YES;
   
    // tags btn
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    [_timeTagBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Time" ofType:@"png"]] forState:UIControlStateNormal];
    [_locationTagBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Location" ofType:@"png"]] forState:UIControlStateNormal];
    [_tagsBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Tag" ofType:@"png"]] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setFounderScreenName:(NSString*)name {
    _founder_name_label.text = name;
    [_founder_name_label sizeToFit];
}

- (void)setFounderScreenPhoto:(NSString *)photo_name {
   
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

- (void)setFounderRelations:(NSNumber*)relation {

    switch (relation.intValue) {
        case UserPostOwnerConnectionsSamePerson:
            // my own post, do nothing
            [_relations setTitle:@"我创建的" forState:UIControlStateNormal];
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed:
            [_relations setTitle:@"+关注" forState:UIControlStateNormal];
            break;
        case UserPostOwnerConnectionsFollowing:
        case UserPostOwnerConnectionsFriends:
            [_relations setTitle:@"取消关注" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)setFounderRoleTag:(NSString*)role_tag {
    [_founder_role_tag_btn setTitle:role_tag forState:UIControlStateNormal];
}

- (void)setChatGroupThemeTitle:(NSString*)title {
    _group_name_label.text = title;
    [_group_name_label sizeToFit];
}

- (void)setCHatGroupJoinerNumber:(NSNumber*)number {
    _online_count_label.text = [NSString stringWithFormat:@"%d 人", number.integerValue];
}

- (void)setChatGroupUserList:(NSArray*)user_lst {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (UIView* view in _user_list_view.subviews) {
            [view removeFromSuperview];
        }
        
        CGFloat offset = 8;
        for (int index = 0; index < MIN(user_lst.count, 6); ++index) {
            NSDictionary* user_dic = [user_lst objectAtIndex:index];
            UIButton* tmp = [[UIButton alloc]initWithFrame:CGRectMake(offset, offset / 2, 30, 30)];
            tmp.layer.cornerRadius = 15.f;
            tmp.clipsToBounds = YES;
           
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
           
            NSString* photo_name = [user_dic objectForKey:@"screen_photo"];
            UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self) {
                            [tmp setBackgroundImage:user_img forState:UIControlStateNormal];
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
            [tmp setBackgroundImage:userImg forState:UIControlStateNormal];
            [_user_list_view addSubview:tmp];
            
            offset += 38;
        }
    });
}
@end
