//
//  FonndSearchModel.h
//  BabySharing
//
//  Created by Alfred Yang on 14/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AppDelegate;

typedef void(^queryRecommondTagFinishBlock)(BOOL success, NSArray* arr_re_tags);
typedef void(^queryFoundTagSearchFinishBlock)(BOOL success, NSDictionary* preview);

@interface FoundSearchModel : NSObject

@property (strong, nonatomic) UIManagedDocument* doc;
@property (strong, nonatomic) NSArray* recommandsdata;
@property (strong, nonatomic) NSArray* previewDic;
@property (weak, nonatomic, readonly) AppDelegate* delegate;

- (id)initWithDelegate:(AppDelegate*)app;

- (void)enumRecommandTagsLocal;
- (void)queryRecommandTagsWithFinishBlock:(queryRecommondTagFinishBlock)block;

- (void)queryFoundTagSearchWithInput:(NSString*)input andFinishBlock:(queryFoundTagSearchFinishBlock)block;
@end
