//
//  AddressBookDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 7/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AddressBookDelegate.h"
#import <AddressBook/AddressBook.h>

@implementation AddressBookDelegate {
    ABAddressBookRef tmpAddressBook;
    NSArray* people;
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
        people = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(tmpAddressBook));
    }
    return self;
}

- (BOOL)isAddressDelegateReady {
    return tmpAddressBook != nil;
}

#pragma mark -- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"send SMS" message:@"TODO: Send SMS to invite person" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"do it", nil];
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
