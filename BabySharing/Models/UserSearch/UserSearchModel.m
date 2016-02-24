//
//  UserSearchModel.m
//  BabySharing
//
//  Created by Alfred Yang on 15/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "UserSearchModel.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "RemoteInstance.h"

@implementation UserSearchModel

@synthesize delegate = _delegate;
@synthesize userSearchPreviewResult = _userSearchPreviewResult;
@synthesize lastSearchScreenNameResult = _lastSearchScreenNameResult;

- (id)initWithDelegate:(AppDelegate*)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)queryUserSearchWithFinishBlock:(userSearchFinishBlock)block {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:_delegate.lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:_delegate.lm.current_user_id forKey:@"user_id"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:USER_SEARCH_RECOMMAND_USERS]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [result objectForKey:@"recommandUsers"];
        NSLog(@"search result: %@", reVal);
        _userSearchPreviewResult = reVal;
        block(YES, nil);
        
    } else {
        block(NO, nil);
    }
}

- (void)queryUserSearchWithRoleTag:(NSString*)role_tag andFinishBlock:(userSearchFinishBlock)block {
    
}

- (void)queryUserSearchWithScreenName:(NSString*)screen_name andFinishBlock:(userSearchPostFinishBlock)block {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:_delegate.lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:_delegate.lm.current_user_id forKey:@"user_id"];
    [dic setValue:screen_name forKey:@"screen_name"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];

    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:USER_SEARCH_SCREEN_NAME]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray* reVal = [result objectForKey:@"result"];
        NSLog(@"search result: %@", reVal);
        _lastSearchScreenNameResult = reVal;
        block(YES, nil);
        
    } else {
        block(NO, nil);
    }
}

- (BOOL)changeRelationsInMemory:(NSString*)user_id andConnections:(UserPostOwnerConnections)connections {
    NSPredicate* p = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        NSDictionary* iter = evaluatedObject;
        return [[iter objectForKey:@"user_id"] isEqualToString:user_id];
    }];
    NSArray* match = [_lastSearchScreenNameResult filteredArrayUsingPredicate:p];
    
    if (match.count == 1) {
        NSDictionary* iter = match.firstObject;
        [iter setValue:[NSNumber numberWithInteger:connections] forKey:@"relations"];
        return YES;
    
    } else {
        NSLog(@"Some thing error and do nothing");
        return NO;
    }
}
@end
