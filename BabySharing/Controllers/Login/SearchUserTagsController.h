//
//  SearchUserTagsController.h
//  BabySharing
//
//  Created by Alfred Yang on 17/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchUserTagControllerDelegate <NSObject>
- (void)didSelectTag:(NSString*)tags;
@end

@interface SearchUserTagsController : UIViewController

@property (nonatomic, weak) id<SearchUserTagControllerDelegate> delegate;
@end
