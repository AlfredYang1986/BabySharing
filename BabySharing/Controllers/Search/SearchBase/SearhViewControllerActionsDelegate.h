//
//  SearhViewControllerActionsDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#ifndef SearhViewControllerActionsDelegate_h
#define SearhViewControllerActionsDelegate_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SearchCallback)(BOOL success, NSArray* data);

@protocol SearchDataCollectionProtocol <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@optional
- (NSString*)getControllerTitle;
- (void)collectData;
- (void)pushExistingData:(NSArray*)data;
//- (void)dataWithCallBack:(SearchCallback)block;
- (NSArray*)enumedData;
- (NSArray*)enumedDataWithPredicate:(NSPredicate*)pred;
- (NSString*)enumedDataAtIndex:(NSInteger)index;

@optional
- (void)asyncQueryDataWithFinishCallback:(SearchCallback)block;
@end

@protocol SearchViewControllerProtocol <NSObject>
- (void)needToReloadData;

@optional
- (NSString*)getUserInputString;
- (NSString*)getAddSectionTitle;
@end

@protocol SearchActionsProtocol <NSObject>
- (void)didSelectItem:(NSString*)item;
- (void)addNewItem:(NSString*)item;
- (NSString*)getControllerTitle;
- (UINavigationController*)getViewController;
@end

#endif /* SearhViewControllerActionsDelegate_h */
