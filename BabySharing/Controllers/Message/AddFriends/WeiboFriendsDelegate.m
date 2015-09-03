//
//  WeiboFriendsDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 3/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "WeiboFriendsDelegate.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "WeiboUser.h"

@interface WeiboFriendsDelegate () <UIAlertViewDelegate>
@end

@implementation WeiboFriendsDelegate {
    BOOL isSync;
    NSArray* people_all;
    NSMutableArray* people;
}

- (id)init {
    self = [super init];
    if (self) {
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [app.lm loadWeiboUsersWithCurrentUserWithFinishBlock:^(BOOL success, NSArray *friends) {
            if (success) {
                isSync = YES;
                people_all = friends;
                people = [people_all mutableCopy];
                [_delegate asyncDelegateIsReady:self];
            }
        }];
    }
    return self;
}

- (BOOL)isDelegateReady {
    return isSync;
}

- (void)filterFriendsWithString:(NSString*)searchText {

    [people removeAllObjects];
    for (WeiboUser *tmpPerson in people_all) {
        NSString* name = tmpPerson.screenName;
      
        NSString* filter = name;
       
        NSString* regex = @"[^x00-xff]+";
        NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        if ([p evaluateWithObject:searchText]) {

            NSString *regex2 = [NSString stringWithFormat:@"^[%@]\\w*", searchText];
            NSPredicate* p2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
           
            if ([p2 evaluateWithObject:filter]) {
                [people addObject:tmpPerson];
            }
        } else {
            
            NSString *regex2 = [NSString stringWithFormat:@"^%@\\w*", [searchText lowercaseString]];
            NSPredicate* p2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
           
            if ([p2 evaluateWithObject:[filter lowercaseString]]) {
                [people addObject:tmpPerson];
            }
        }
    }
}

#pragma mark -- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"send weibo message" message:@"Send weibo message to invite person" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"do it", nil];
    view.delegate = self;
    view.tag = indexPath.row;
    [view show];
}


#pragma mark -- tableview datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
  
    @try {
        WeiboUser* tmp = [people objectAtIndex:indexPath.row];
        cell.textLabel.text = tmp.screenName;
    }
    @catch (NSException *exception) {
        cell.textLabel.text = @"more friends";
    }
  
//  NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:user.profileImageUrl]];
//  UIImage* img = [UIImage imageWithData:data];
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return people.count + 1;
}

#pragma mark -- alert view 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    AppDelegate * app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    @try {
        WeiboUser* tmp = [people objectAtIndex:alertView.tag];
        [app.lm inviteFriendWithWeibo:tmp];
    }
    @catch (NSException *exception) {
        [app.lm inviteFriendWithWeibo:nil];
    }
}
@end
