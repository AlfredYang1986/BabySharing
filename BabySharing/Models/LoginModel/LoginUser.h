//
//  LoginUser.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoginUser : NSObject

@property (nonatomic, strong) NSString* screen_name;
@property (nonatomic, strong) UIImage* screen_photo;

- (id)init;
- (id)initWithName:(NSString*)name andPhote:(UIImage*)image;

@end
