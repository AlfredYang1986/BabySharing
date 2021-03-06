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

@property (weak, nonatomic) UIViewController* controller;

@optional
- (NSString*)getControllerTitle;
- (void)collectData;
- (void)pushExistingData:(NSArray*)data withHeader:(NSString*)header;
//- (void)dataWithCallBack:(SearchCallback)block;
- (NSArray*)enumedData;
- (NSArray*)enumedDataWithPredicate:(NSPredicate*)pred;
- (NSString*)enumedDataAtIndex:(NSInteger)index;
- (NSString*)getSearchPlaceHolder;

- (void)setInitialSearchBarText:(NSString*)text;

@optional
- (void)asyncQueryDataWithFinishCallback:(SearchCallback)block;
@end

@protocol SearchViewControllerProtocol <NSObject>
- (void)needToReloadData;
@optional
- (void)keyboardHide;
- (NSString*)getUserInputString;
- (NSString*)getAddSectionTitle;
@end

@protocol SearchActionsProtocol <NSObject>
- (void)didSelectItem:(NSString*)item;
- (void)addNewItem:(NSString*)item;
- (NSString *)getControllerTitle;
- (UINavigationController*)getViewController;
@optional
- (NSString *)getPlaceHolder;
@end

#endif /* SearhViewControllerActionsDelegate_h */
