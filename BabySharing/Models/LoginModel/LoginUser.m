//
//  LoginUser.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "LoginUser.h"

@implementation LoginUser

@synthesize screen_name = _screen_name;
@synthesize screen_photo = _screen_photo;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithName:(NSString*)name andPhote:(UIImage*)image {
    self = [super init];
    if (self) {
        self.screen_name = name;
        self.screen_photo = image;
    }
    return self;
}
@end
