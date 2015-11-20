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
//- (void)dataWithCallBack:(SearchCallback)block;
- (NSArray*)enumedData;
- (NSString*)enumedDataAtIndex:(NSInteger)index;
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
@end

#endif /* SearhViewControllerActionsDelegate_h */
