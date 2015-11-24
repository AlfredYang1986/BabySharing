//
//  UserHomeViewDataDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 18/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "UserHomeViewDataDelegate.h"

@interface UserHomeViewDataDelegate ()
@property (weak, nonatomic) NSString* user_id;
@property (weak, nonatomic) NSString* auth_token;
@property (weak, nonatomic) UIViewController* parent;
@end

@implementation UserHomeViewDataDelegate {
    NSArray* data;
    NSInteger current_select_index;
}

@synthesize user_id = _user_id;
@synthesize auth_token = _auth_token;
@synthesize parent = _parent;

- (void)rigisterViewController:(UIViewController*)parent {
    _parent = parent;
}

- (BOOL)collectData:(SyncDataCallBack)block {
    return NO;
}

- (BOOL)appendData:(SyncDataCallBack)block {
    return NO;
}

- (void)AsyncCollectData:(AsyncDataCallBack)block {
    
}

- (void)AsyncAppendData:(AsyncDataCallBack)block {
    
}

- (NSInteger)count {
    return data.count;
}

- (QueryContent*)queryItemAtIndex:(NSInteger)index {
    QueryContent* reVal = nil;
    @try {
        reVal = [data objectAtIndex:index];
    }
    @catch (NSException *exception) {
   
    }
    return reVal;
}

- (NSArray*)data {
    return data;
}

- (void)pushExistingData:(NSArray*)ed {
    data = ed;
}

- (void)setSelectIndex:(NSInteger)index {
    current_select_index = index;
}

- (void)currentSelectIndexWithBlock:(currentIndexBlock)block {
    block(current_select_index);
}
@end
