//
//  SearchAddDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchAddRoleTagDelegate.h"
#import "searchDefines.h"

@implementation SearchAddRoleTagDelegate {
    NSArray* exist_data;
    NSArray* showing_data;
}

@synthesize delegate = _delegate;
//@synthesize controller = _controller;

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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[_actions getViewController] popViewControllerAnimated:NO];
}

#pragma mark -- table view delegate

- (SearchStatus)status {
   
    NSString* input = [_delegate getUserInputString];
    if (input.length == 0) return SearchStatusNoInput;
    else if (input.length > 0 && showing_data.count == 0) return SearchStatusInputWithNoResult;
    else if (input.length > 0 && showing_data.count > 0) return SearchStatusInputWithResult;
    else return SearchStatusUnknow;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    SearchStatus status = [self status];
   
    switch (status) {
        case SearchStatusNoInput:
            return 1;
           
        case SearchStatusInputWithNoResult:
            return 1;
       
        case SearchStatusInputWithResult:
            return 2;
            
        default:
            NSLog(@"error with status");
            return 0;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    SearchStatus status = [self status];
    
    switch (status) {
        case SearchStatusNoInput:
            return @"";
            
        case SearchStatusInputWithNoResult:
            return @"添加新角色";
            
        case SearchStatusInputWithResult: {
            if (section == 0) {
                return @"添加新角色";
            } else {
                return @"搜索结果";
            }
        }
        default:
            NSLog(@"error with status");
            return @"";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SearchStatus status = [self status];
    
    switch (status) {
        case SearchStatusNoInput:
            return 0;
            
        case SearchStatusInputWithNoResult:
            return 22;
            
        case SearchStatusInputWithResult:
            return 22;
            
        default:
            NSLog(@"error with status");
            return 0;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SearchStatus status = [self status];
    
    switch (status) {
        case SearchStatusNoInput:
            [_actions didSelectItem:[showing_data objectAtIndex:indexPath.row]];
            break;
            
        case SearchStatusInputWithNoResult:
            [_actions addNewItem:[_delegate getUserInputString]];
            break;
            
        case SearchStatusInputWithResult: {
            if (indexPath.section == 0) {
                [_actions addNewItem:[_delegate getUserInputString]];
            } else {
                [_actions didSelectItem:[showing_data objectAtIndex:indexPath.row]];
            }
            }
            break;
            
        default:
            NSLog(@"error with status");
    }
}

#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    SearchStatus status = [self status];
    
    switch (status) {
        case SearchStatusNoInput:
            return showing_data.count;
            
        case SearchStatusInputWithNoResult:
            return 1;
            
        case SearchStatusInputWithResult: {
            if (section == 0) {
                return 1;
            } else {
                return MAX(showing_data.count, 1);
            }
        }
            
        default:
            NSLog(@"error with status");
            return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }

    SearchStatus status = [self status];
    
    switch (status) {
        case SearchStatusNoInput:
            cell.textLabel.text = [showing_data objectAtIndex:indexPath.row];
            break;
            
        case SearchStatusInputWithNoResult:
            cell.textLabel.text = [_delegate getUserInputString];
            break;
            
        case SearchStatusInputWithResult: {
            if (indexPath.section == 0) {
                cell.textLabel.text = [_delegate getUserInputString];
            } else {
                cell.textLabel.text = [showing_data objectAtIndex:indexPath.row];
            }
            }
            break;
            
        default:
            NSLog(@"error with status");
            return 0;
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.f];
//    cell.textLabel.textColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
//    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

- (NSString*)getControllerTitle {
    return @"添加你的角色";
}
@end
