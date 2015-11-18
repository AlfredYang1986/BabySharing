//
//  HomeDataDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 18/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#ifndef HomeDataDelegate_h
#define HomeDataDelegate_h

#import <foundation/foundation.h>
#import <UIKit/UIKit.h>

@class QueryContent;

typedef void(^AsyncDataCallBack)(NSArray* data);
typedef void(^SyncDataCallBack)(NSArray* data);
typedef void(^currentIndexBlock)(NSInteger index);

@protocol HomeViewControllerDataDelegate <NSObject>

@required
- (void)rigisterViewController:(UIViewController*)parent;
- (BOOL)collectData:(SyncDataCallBack)block;
- (BOOL)appendData:(SyncDataCallBack)block;
- (void)AsyncCollectData:(AsyncDataCallBack)block;
- (void)AsyncAppendData:(AsyncDataCallBack)block;
- (NSInteger)count;
- (QueryContent*)queryItemAtIndex:(NSInteger)index;
- (NSArray*)data; // TODO: need to delete

@optional
- (void)pushExistingData:(NSArray*)ed;
- (void)setSelectIndex:(NSInteger)index;
- (void)currentSelectIndexWithBlock:(currentIndexBlock)block;
@end

#endif /* HomeDataDelegate_h */
