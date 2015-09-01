//
//  AddressBookDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 7/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AddressBookDelegate.h"
#import <AddressBook/AddressBook.h>

#import "AppDelegate.h"
#import "LoginModel.h"
#import "CurrentToken.h"
#import "LoginToken.h"

#import "RemoteInstance.h"

@implementation AddressBookDelegate {
    ABAddressBookRef tmpAddressBook;
    NSArray* people_all;
    NSMutableArray* people;
}

- (id)init {
    self = [super init];
    if (self) {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
            tmpAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
                dispatch_semaphore_signal(sema);
            });
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        } else {
            tmpAddressBook = ABAddressBookCreate();
        }
    }
    
    if (tmpAddressBook) {
        people_all = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(tmpAddressBook));
        people = [people_all mutableCopy];
    }
    return self;
}

- (BOOL)isAddressDelegateReady {
    return tmpAddressBook != nil;
}

- (void)filterFriendsWithString:(NSString*)searchText {

    [people removeAllObjects];
    for (id tmpPerson in people_all) {
        NSString* tmpFirstName = CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonFirstNameProperty));
        NSString* tmpLastName = CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonLastNameProperty));
      
        NSString* filter = nil;
        if (tmpLastName && tmpFirstName) {
            filter = [tmpFirstName stringByAppendingString:tmpLastName];
        } else if (tmpFirstName) {
            filter = tmpFirstName;
        } else if (tmpLastName) {
            filter = tmpLastName;
        } else {
            
        }
       
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

#pragma mark -- alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        CurrentToken* tmp = [app.lm getCurrentUser];
        
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setObject:tmp.who.user_id forKey:@"user_id"];
        [dic setObject:tmp.who.auth_token forKey:@"auth_token"];
        
        [dic setObject:tmp.who.screen_name forKey:@"screen_name"];
        
        id tmpPerson = [people objectAtIndex:alertView.tag];
        
        ABMultiValueRef phoneNos = ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
        int count = ABMultiValueGetCount(phoneNos);
        
        if (count > 0) {
            NSString* phoneNo = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNos, 0));
            [dic setObject:phoneNo forKey:@"phoneNo"];
            NSError * error = nil;
            NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
        
            NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:RELATIONSHIP_SMS_INVITATION]];
        
            if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
                NSString* reVal = [result objectForKey:@"result"];
                NSLog(@"send invitation result: %@", reVal);
            } else {
                NSDictionary* reError = [result objectForKey:@"error"];
                NSString* msg = [reError objectForKey:@"message"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"no phone number" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }
    }
}

#pragma mark -- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"send SMS" message:@"Send SMS to invite person" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"do it", nil];
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
  
    id tmpPerson = [people objectAtIndex:indexPath.row];
    NSString* tmpFirstName = CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonFirstNameProperty));
    
    NSString* tmpLastName = CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonLastNameProperty));
   
    if (tmpLastName && tmpFirstName) {
        cell.textLabel.text = [tmpFirstName stringByAppendingString:tmpLastName];
    } else if (tmpFirstName) {
        cell.textLabel.text = tmpFirstName;
    } else if (tmpLastName) {
        cell.textLabel.text = tmpLastName;
    } else {
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return people.count;
}
@end
