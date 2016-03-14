//
//  MainHomeViewDataDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 18/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "MainHomeViewDataDelegate.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "QueryModel.h"
#import "QueryContent.h"

@interface MainHomeViewDataDelegate ()

@property (weak, nonatomic) LoginModel* lm;
@property (weak, nonatomic) QueryModel* qm;
@property (weak, nonatomic, readonly) UIViewController* parent;
@end

@implementation MainHomeViewDataDelegate {
    NSArray* data;
}

@synthesize lm = _lm;
@synthesize qm = _qm;
@synthesize parent = _parent;

- (id)init {
    self = [super init];
    if (self) {
        AppDelegate* app = [UIApplication sharedApplication].delegate;
        _lm = app.lm;
        _qm = app.qm;
    }
    
    return self;
}

- (void)rigisterViewController:(UIViewController*)parent {
    _parent = parent;
}

- (BOOL)collectData:(SyncDataCallBack)block {
    data = nil;
    [_qm refreshQueryDataByUser:_lm.current_user_id withToken:_lm.current_auth_token withFinishBlock:^{
//        block(self.data);
        block(_qm.querydata);
    }];
    return YES;
}

- (BOOL)appendData:(SyncDataCallBack)block {
    [_qm appendQueryDataByUser:_lm.current_user_id withToken:_lm.current_auth_token andBeginIndex:_qm.querydata.count];
    block(_qm.querydata);
    return YES;
}

- (void)AsyncCollectData:(AsyncDataCallBack)block {
    
}

- (void)AsyncAppendData:(AsyncDataCallBack)block {
    
}

- (NSInteger)count {
    return self.data.count;
}

- (QueryContent *)queryItemAtIndex:(NSInteger)index {
    QueryContent *reVal = nil;
    @try {
        reVal = [self.data objectAtIndex:index];
    } @catch (NSException *exception) {
    
    }
    return reVal;
}

- (NSArray*)data {// TODO: need to delete
    if (data == nil) {
        data = _qm.querydata;
    }
    return data;
}
@end
