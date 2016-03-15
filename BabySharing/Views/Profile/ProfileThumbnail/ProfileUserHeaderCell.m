//
//  ProfileUserHeaderCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 14/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "ProfileUserHeaderCell.h"
#import "LoginModel.h"
#import "RemoteInstance.h"
#import "ModelDefines.h"
#import "TmpFileStorageModel.h"

@interface ProfileUserHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *thumsupNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *pushNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIView *containerView;

//@property (nonatomic, weak) LoginModel* lm;
@end

@implementation ProfileUserHeaderCell {
    BOOL isUpdate;
}

@synthesize imgView = _imgView;
@synthesize nameLabel = _nameLabel;
@synthesize thumsupNumLabel = _thumsupNumLabel;
@synthesize pushNumLabel = _pushNumLabel;
@synthesize friendNumLabel = _friendNumLabel;
@synthesize detailBtn = _detailBtn;
@synthesize containerView = _containerView;

@synthesize current_auth_token = _current_auth_token;
@synthesize current_user_id = _current_user_id;

//@synthesize lm = _lm;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    // Initialization code
    isUpdate = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSelectDetialBtn {
    NSLog(@"Select detail profile");
    [_delegate didSelectDetailProfileBtn];
}

- (void)updateHeaderView {
    if (!isUpdate) {
        _containerView.layer.borderWidth = 1.f;
        _containerView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.8].CGColor;
        _containerView.layer.cornerRadius = 8.f;
        
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString * filePath = [resourceBundle pathForResource:@"Next" ofType:@"png"];
        UIImage *image = [UIImage imageNamed:filePath];

        [_detailBtn setImage:image forState:UIControlStateNormal];
        
 
        dispatch_queue_t up = dispatch_queue_create("update profile header view", nil);
        dispatch_async(up, ^{

            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//            [dic setValue:_current_auth_token forKey:@"query_auth_token"];
//            [dic setValue:_current_user_id forKey:@"query_user_id"];
            [dic setValue:_current_auth_token forKey:@"auth_token"];
            [dic setValue:_current_user_id forKey:@"user_id"];
            [dic setValue:_current_user_id forKey:@"owner_user_id"];
    
            NSError * error = nil;
            NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
            
            //    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN_SENDBOX stringByAppendingString:PROFILE_QUERY_DETAILS]]];
            NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_QUERY_DETAILS]]];
            
            if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
                isUpdate = YES;
                NSDictionary* reVal = [result objectForKey:@"result"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self changeUserPhotoWithName:[reVal objectForKey:@"screen_photo"]];
                    _nameLabel.text = [reVal objectForKey:@"screen_name"];
                    _pushNumLabel.text = ((NSNumber*)[reVal objectForKey:@"posts_count"]).stringValue;
                    _friendNumLabel.text = ((NSNumber*)[reVal objectForKey:@"followers_count"]).stringValue;
                    _thumsupNumLabel.text = ((NSNumber*)[reVal objectForKey:@"followings_count"]).stringValue;
                });
                
            } else {
                NSDictionary* reError = [result objectForKey:@"error"];
                NSString* msg = [reError objectForKey:@"message"];
                
                NSLog(@"query user profile failed");
                NSLog(@"%@", msg);
            }
        });
    }
}

- (void)changeUserPhotoWithName:(NSString*)photo_name {
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _imgView.image = user_img;
                NSLog(@"owner img download success");
            });
        } else {
            NSLog(@"down load owner image %@ failed", photo_name);
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
            UIImage *image = [UIImage imageNamed:filePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                _imgView.image = image;
            });
        }
    }];
    _imgView.image = userImg;
}
@end
