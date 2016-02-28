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
#import "MessageFriendsCell.h"

#import "RemoteInstance.h"

#import <Contacts/CNContact.h>
#import <Contacts/CNContactStore.h>
#import <Contacts/CNContactFetchRequest.h>

@implementation AddressBookDelegate {
//    ABAddressBookRef tmpAddressBook;
    CNContactStore* tmpAddressBook;
    
    NSArray* people_all;
    NSMutableArray* people;
    
    NSArray* friend_profile_lst;
    NSArray* friend_lst;
    NSArray* none_friend_lst;
}

@synthesize delegate = _delegate;

- (id)init {
    self = [super init];
    if (self) {
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
//            tmpAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
//            dispatch_semaphore_t sema = dispatch_semaphore_create(1);
//            ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
//                dispatch_semaphore_signal(sema);
//            });
//            
//            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        } else {
//            tmpAddressBook = ABAddressBookCreate();
//        }
        tmpAddressBook = [[CNContactStore alloc]init];
        people = [[NSMutableArray alloc]init];
    }
    
    if (tmpAddressBook) {
        CNContactFetchRequest* req = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]];
        req.predicate = nil;
        NSError* err = nil;
        if ([tmpAddressBook enumerateContactsWithFetchRequest:req error:&err usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            *stop = NO;
            [people addObject:contact];
        }]) {
            none_friend_lst = people;
            people_all = [people copy];
        } else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:[err.userInfo objectForKey:NSLocalizedDescriptionKey] message:[err.userInfo objectForKey:NSLocalizedFailureReasonErrorKey] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
//        people_all = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(tmpAddressBook));
//        people = [people_all mutableCopy];
    }
    
    return self;
}

- (BOOL)isDelegateReady {
    return tmpAddressBook != nil;
}

- (void)filterFriendsWithString:(NSString*)searchText {

    [people removeAllObjects];
    for (CNContact* tmpPerson in people_all) {
        NSString* tmpFirstName = tmpPerson.givenName; //CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonFirstNameProperty));
        NSString* tmpLastName = tmpPerson.familyName; //CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonLastNameProperty));
      
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

//            NSString *regex2 = [NSString stringWithFormat:@"^[%@]\\w*", searchText];
            NSString *regex2 = [NSString stringWithFormat:@"^%@\\w*", searchText];
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
        
        CNContact* tmpPerson = [people objectAtIndex:alertView.tag];
      
        NSArray<CNLabeledValue<CNPhoneNumber*>*>* phoneNos = tmpPerson.phoneNumbers;
//        ABMultiValueRef phoneNos = ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
//        ABMultiValueGetCount(phoneNos);
        
        if (phoneNos.count > 0) {
            NSString* phoneNo = [phoneNos objectAtIndex:0].value.stringValue; //CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNos, 0));
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
    
    MessageFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"friend cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageFriendsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
//    id tmpPerson = [people objectAtIndex:indexPath.row];
    BOOL isFriends = NO;
    CNContact* tmpPerson = nil;
    @try {
        tmpPerson = [friend_lst objectAtIndex:indexPath.row];
        isFriends = YES;
    }
    @catch (NSException *exception) {
        tmpPerson = [none_friend_lst objectAtIndex:indexPath.row - friend_lst.count];
    }
    @finally {
    
    }
   
    if (isFriends) {
        NSDictionary* tmp = [friend_profile_lst objectAtIndex:indexPath.row];
//        cell.delegate = self;
        cell.user_id = [tmp objectForKey:@"user_id"];
        [cell setUserScreenPhoto:[tmp objectForKey:@"screen_photo"]];
        [cell setRelationship:((NSNumber*)[tmp objectForKey:@"relations"]).integerValue];
        [cell setUserScreenName:[tmp objectForKey:@"screen_name"]];
        [cell setUserRoleTag:[tmp objectForKey:@"role_tag"]];
        
    } else {
        NSString* tmpFirstName = tmpPerson.givenName; //CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonFirstNameProperty));
        NSString* tmpLastName = tmpPerson.familyName; //CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonLastNameProperty));
        
        if (tmpLastName && tmpFirstName) {
            [cell setUserScreenName:[tmpFirstName stringByAppendingString:tmpLastName]];
        } else if (tmpFirstName) {
            [cell setUserScreenName:tmpFirstName];
        } else if (tmpLastName) {
            [cell setUserScreenName:tmpLastName];
        } else {
            
        }
        
        [cell setUserScreenPhoto:@""];
        [cell setRelationship:-1];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return people.count;
    return friend_lst.count + none_friend_lst.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MessageFriendsCell preferredHeight];
}

- (NSArray*)getAllPhones {
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    for (CNContact* tmpPerson in people) {
//        ABMultiValueRef phones = ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
        NSArray<CNLabeledValue<CNPhoneNumber*>*>* phones = tmpPerson.phoneNumbers; //ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
//        CFIndex count = ABMultiValueGetCount(phones);
        for (int index = 0; index < phones.count; ++index) {
            NSString* phoneNo = [phones objectAtIndex:index].value.stringValue; //CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, index));
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [arr addObject:phoneNo];
        }
    }
    return [arr copy];
}

- (void)splitWithFriends:(NSArray*)lst {
    NSPredicate* p = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        CNContact* tmpPerson = evaluatedObject;
        NSArray<CNLabeledValue<CNPhoneNumber*>*>* phones = tmpPerson.phoneNumbers; //ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
        for (int index = 0; index < phones.count; ++index) {
            NSString* phoneNo = [phones objectAtIndex:index].value.stringValue; //CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, index));
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            NSPredicate* p_match = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                NSDictionary* iter = (NSDictionary*)evaluatedObject;
                return [[iter objectForKey:@"phoneNo"] isEqualToString:phoneNo];
            }];
            
            if ([lst filteredArrayUsingPredicate:p_match].count > 0) return YES;
        }
        return NO;
    }];
    
    friend_lst = [people filteredArrayUsingPredicate:p];
    friend_profile_lst = lst;
  
    NSPredicate* p_not = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        CNContact* tmpPerson = evaluatedObject;
        NSArray<CNLabeledValue<CNPhoneNumber*>*>* phones = tmpPerson.phoneNumbers; //ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
        for (int index = 0; index < phones.count; ++index) {
            NSString* phoneNo = [phones objectAtIndex:index].value.stringValue; //CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, index));
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            NSPredicate* p_match = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                NSDictionary* iter = (NSDictionary*)evaluatedObject;
                return [[iter objectForKey:@"phoneNo"] isEqualToString:phoneNo];
            }];
           
            if ([lst filteredArrayUsingPredicate:p_match].count == 0) return YES;
        }
        return NO;
    }];
    
    none_friend_lst = [people filteredArrayUsingPredicate:p_not];
}
@end
