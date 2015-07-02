//
//  CreateChatController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 7/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@protocol SubGroupOpt
- (void)didCreateSubGroup:(Group*)g;
@end

@interface CreateChatController : UIViewController

@property (nonatomic, weak) Group* current_group;
@property (nonatomic, weak) id<SubGroupOpt> delegate;
@end
