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
@synthesize userSearchResult = _userSearchResult;

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
        _userSearchResult = reVal;
        block(YES, nil);
        
    } else {
        block(NO, nil);
    }
}

- (void)queryUserSearchWithRoleTag:(NSString*)role_tag andFinishBlock:(userSearchFinishBlock)block {
    
}
@end
