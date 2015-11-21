//
//  SearchAddDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchAddRoleTagDelegate.h"

@implementation SearchAddRoleTagDelegate {
    NSArray* exist_data;
    NSArray* showing_data;
}

@synthesize delegate = _delegate;

- (void)pushExistingData:(NSArray *)data {
    exist_data = data;
    showing_data = exist_data;
}

#pragma mark -- search bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

//    if (!isSync) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"cannot edit until sync" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    
    if ([searchText isEqualToString:@""]) {
        showing_data = exist_data;
//        self.current_delegate = self;
//        [_searchBar resignFirstResponder];
        
    } else {
        //        NSString *regex = [NSString stringWithFormat:@"^[%@]\\w*", searchText];
        NSString *regex = [NSString stringWithFormat:@"^%@\\w*", searchText];
        NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        NSMutableArray* tmp = [[NSMutableArray alloc]initWithCapacity:exist_data.count];
        for (NSString* iter in exist_data) {
            if ([p evaluateWithObject:iter]) {
                [tmp addObject:iter];
            }
        }
        showing_data = [tmp copy];
        
//        if (final_tag_arr.count == 0) self.current_delegate = add_delegate;
//        else self.current_delegate = self;
    }
    
//    [_queryView reloadData];
    [_delegate needToReloadData];
}

#pragma mark -- table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"添加新角色";
//    return [_delegate getAddSectionTitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (showing_data.count == 0) {
        return 22;
    } else {
        return 0;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [_delegate addNewTag:[_delegate getUserInputString]];
}

#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX(showing_data.count, 1);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
   
    if (showing_data.count == 0) {
        cell.textLabel.text = [_delegate getUserInputString];
    } else {
        cell.textLabel.text = [showing_data objectAtIndex:indexPath.row];
    }
    return cell;
}
@end
