//
//  ChatGroupUserInfoTableDelegateAndDatasource.h
//  BabySharing
//
//  Created by Alfred Yang on 1/28/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol userInfoPaneDelegate <NSObject>

- (NSString*)getFounderScreenName;
- (NSString*)getFounderScreenPhoto;
- (NSString*)getFounderRoleTag;
- (NSInteger)getFounderRelations;

- (NSNumber*)getGroupJoinNumber;
- (NSArray*)getGroupJoinNumberList;
@end

@interface ChatGroupUserInfoTableDelegateAndDatasource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<userInfoPaneDelegate> delegate;
@end
