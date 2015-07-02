//
//  UserHeadView.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeadView : UIImageView

@property (nonatomic, strong, setter=setUser:) NSString* user_id;

- (void)setUser:(NSString*)user;
- (void)setPhotoFile:(NSString*)photo;
@end
