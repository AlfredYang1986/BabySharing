//
//  UserAddNewTagDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 2/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol addNewTagProtocol <NSObject>

- (NSString*)getInputTagName;
- (void)addNewTag:(NSString*)tag_name;
@end

@interface UserAddNewTagDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<addNewTagProtocol> delegate;
@end
