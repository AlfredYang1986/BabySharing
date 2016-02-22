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
@property (weak, nonatomic, readonly) AppDelegate* delegate;

#pragma mark -- Found Search Tags Property
@property (strong, nonatomic) NSArray* recommandsdata;
@property (strong, nonatomic) NSArray* previewDic;

#pragma mark -- Found Search Role Tags Property
@property (strong, nonatomic) NSArray* recommandsRoleTag;
@property (strong, nonatomic) NSArray* previewRoleDic;

- (id)initWithDelegate:(AppDelegate*)app;

#pragma mark -- Found Search Tags Method
- (void)enumRecommandTagsLocal;
- (void)queryRecommandTagsWithFinishBlock:(queryRecommondTagFinishBlock)block;
- (void)queryFoundTagSearchWithInput:(NSString*)input andFinishBlock:(queryFoundTagSearchFinishBlock)block;

#pragma mark -- Found Search Tags Method
- (void)enumRecommandRoleTagsLocal;
- (void)queryRecommandRoleTagsWithFinishBlock:(queryRecommondTagFinishBlock)block;
- (void)queryFoundRoleTagSearchWithInput:(NSString*)input andFinishBlock:(queryFoundTagSearchFinishBlock)block;

#pragma mark -- Found Search Brand Tag Method
- (void)queryRecommandTagsWithType:(NSInteger)tag_type andFinishBlock:(queryRecommondTagFinishBlock)block;
- (void)queryFoundTagSearchWithInput:(NSString*)input andType:(NSInteger)tage_type andFinishBlock:(queryFoundTagSearchFinishBlock)block;     // for search
@end
