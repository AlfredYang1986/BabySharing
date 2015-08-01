//
//  ProfileOverView.m
//  BabySharing
//
//  Created by Alfred Yang on 1/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "ProfileOverView.h"
#import "TmpFileStorageModel.h"

@interface ProfileOverView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIView *countContainer;
@property (weak, nonatomic) IBOutlet UILabel *shareCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cycleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *roleTagBtn;


@property (weak, nonatomic) IBOutlet UIView *buttomContainer;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalSignLabel;
@end

@implementation ProfileOverView

@synthesize imgView = _imgView;

@synthesize countContainer = _countContainer;
@synthesize shareCountLabel = _shareCountLabel;
@synthesize cycleCountLabel = _cycleCountLabel;
@synthesize friendsCountLabel = _friendsCountLabel;

@synthesize editBtn = _editBtn;
@synthesize roleTagBtn = _roleTagBtn;

@synthesize buttomContainer = _buttomContainer;
@synthesize locationLabel = _locationLabel;
@synthesize personalSignLabel = _personalSignLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    _roleTagBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _roleTagBtn.layer.borderWidth = 1.f;
    _roleTagBtn.layer.cornerRadius = 8.f;
    _roleTagBtn.clipsToBounds = YES;

    _editBtn.layer.borderWidth = 1.f;
    _editBtn.layer.cornerRadius = 8.f;
    _editBtn.clipsToBounds = YES;
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
    NSString* tmp = [NSString stringWithFormat:@"%d", count];
    _shareCountLabel.text = tmp;
}

- (void)setCycleCount:(NSInteger)count {
    NSString* tmp = [NSString stringWithFormat:@"%d", count];
    _cycleCountLabel.text = tmp;
}

- (void)setFriendsCount:(NSInteger)count {
    NSString* tmp = [NSString stringWithFormat:@"%d", count];
    _friendsCountLabel.text = tmp;
}

- (void)setLoation:(NSString*)location {
    _locationLabel.text = location;
}

- (void)setPersonalSign:(NSString*)sign_content {
    _personalSignLabel.text = sign_content;
}

- (void)setRoleTag:(NSString*)role_tag {
    [_roleTagBtn setTitle:role_tag forState:UIControlStateNormal];
}
@end
