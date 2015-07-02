//
//  UserHeadView.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "UserHeadView.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"
#import "AppDelegate.h"
#import "ModelDefines.h"

@interface UserHeadView ()
@property (nonatomic, strong, setter=setPhotoFile:) NSString* user_photo;
@end

@implementation UserHeadView {

}

@synthesize user_id = _user_id;
@synthesize user_photo = _user_photo;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setUser:(NSString *)user {
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:delegate.lm.current_auth_token forKey:@"query_auth_token"];
    [dic setValue:delegate.lm.current_user_id forKey:@"query_user_id"];
    [dic setValue:user forKey:@"owner_user_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
//    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN_SENDBOX stringByAppendingString:PROFILE_QUERY_DETAILS]]];
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:[PROFILE_HOST_DOMAIN stringByAppendingString:PROFILE_QUERY_DETAILS]]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSDictionary* reVal = [result objectForKey:@"result"];
        self.user_photo = [reVal objectForKey:@"screen_photo"];
        _user_id = user;
        
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        [alert show];
        NSLog(@"query user profile failed");
        NSLog(@"%@", msg);
    }
}

- (void)setPhotoFile:(NSString *)photo {
    _user_photo = photo;
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:self.user_photo withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = user_img;
                NSLog(@"owner img download success");
            });
        } else {
            NSLog(@"down load owner image %@ failed", self.user_photo);
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
            UIImage *image = [UIImage imageNamed:filePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
            });
        }
    }];
    self.image = userImg;
}
@end
