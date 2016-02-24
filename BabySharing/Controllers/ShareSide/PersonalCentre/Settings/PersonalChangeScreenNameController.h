//
//  PersonalChangeScreenNameController.h
//  BabySharing
//
//  Created by Alfred Yang on 29/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chanageScreenNameProtocol <NSObject>

- (void)didChangeScreenName:(NSString*)name;

@end

@interface PersonalChangeScreenNameController : UIViewController

@property (weak, nonatomic) id<chanageScreenNameProtocol> delegate;
@property (weak, nonatomic) NSString* ori_screen_name;

@end
