//
//  GroupModel.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 7/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Group;
@class SubGroup;
@class UIManagedDocument;
@class AppDelegate;

@interface GroupModel : NSObject

@property (strong, nonatomic) UIManagedDocument* doc;
@property (strong, nonatomic, readonly) NSArray* groupdata;

@property (weak, nonatomic, readonly) AppDelegate* delegate;

#pragma mark -- constractor
- (id)initWithDelegate:(AppDelegate*)app;

#pragma mark -- query for service
- (void)refreshGroups;

#pragma mark -- create a new sub group
- (Group*)createSubGroup:(NSString*)sub_group_name inGroup:(Group*)g;
@end
