//
//  SearchAddDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchAddRoleTagDelegate.h"
#import "searchDefines.h"
#import "Tools.h"
#import "SearchViewController.h"

@implementation SearchAddRoleTagDelegate {
    NSArray* exist_data;
    NSArray* showing_data;
}

@synthesize delegate = _delegate;
@synthesize controller = _controller;

- (void)pushExistingData:(NSArray *)data withHeader:(NSString *)header {
    exist_data = data;
    showing_data = exist_data;
}

#pragma mark -- search bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    if ([searchText isEqualToString:@""]) {
        ((SearchViewController*)self.controller).delegate = (id<SearchDataCollectionProtocol, SearchActionsProtocol, SearchViewControllerProtocol>)_delegate;
        [((SearchViewController*)self.controller).queryView reloadData];
        return;
    } else {
        if (searchText.length > 0) {
            showing_data = [[Tools sortWithArr:exist_data headStr:searchText] copy];
            [_delegate needToReloadData];
        }
    }
    
//    if ([searchText isEqualToString:@""]) {
//        showing_data = exist_data;
//        
//    } else {
//        //        NSString *regex = [NSString stringWithFormat:@"^[%@]\\w*", searchText];
//        NSString *regex = [NSString stringWithFormat:@"^%@\\w*", searchText];
//        NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//        
//        NSMutableArray* tmp = [[NSMutableArray alloc]initWithCapacity:exist_data.count];
//        for (NSString* iter in exist_data) {
//            if ([p evaluateWithObject:iter]) {
//                [tmp addObject:iter];
//            }
//        }
//        showing_data = [tmp copy];
//    }
//    
//    [_delegate needToReloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [[_actions getViewController] popViewControllerAnimated:NO];
    SearchStatus status = [self status];
    
    switch (status) {
        case SearchStatusNoInput:
//            [_actions didSelectItem:[showing_data objectAtIndex:indexPath.row]];
            break;
            
        case SearchStatusInputWithNoResult:
            [_actions addNewItem:[_delegate getUserInputString]];
            break;
            
        case SearchStatusInputWithResult: {
//            if (indexPath.section == 0) {
                [_actions addNewItem:[_delegate getUserInputString]];
//            } else {
//                [_actions didSelectItem:[showing_data objectAtIndex:indexPath.row]];
//            }
        }
            break;
            
        default:
            NSLog(@"error with status");
    }
}

#pragma mark -- table view delegate

- (SearchStatus)status {
   
//    NSString* input = [_delegate getUserInputString];
//    if (input.length == 0) return SearchStatusNoInput;
//    else if (input.length > 0 && showing_data.count == 0) return SearchStatusInputWithNoResult;
//    else if (input.length > 0 && showing_data.count > 0) return SearchStatusInputWithResult;
//    else return SearchStatusUnknow;
    
    return SearchStatusInputWithNoResult;
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

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    SearchStatus status = [self status];
//    
//    switch (status) {
//        case SearchStatusNoInput:
//            return @"解锁新角色:";
//            
//        case SearchStatusInputWithNoResult:
//            return @"解锁新角色:";
//            
//        case SearchStatusInputWithResult: {
//            if (section == 0) {
//                return @"解锁新角色:";
//            } else {
//                return @"搜索结果";
//            }
//        }
//        default:
//            NSLog(@"error with status");
//            return @"";
//    }
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    SearchStatus status = [self status];
//    
//    switch (status) {
//        case SearchStatusNoInput:
//            return 0;
//            
//        case SearchStatusInputWithNoResult:
//            if (section == 0) {
//                return 0;
//            } else {
//                return 22;
//            }
//        case SearchStatusInputWithResult:
//            if (section == 0) {
//                return 0;
//            } else {
//                return 22;
//            }
//        default:
//            NSLog(@"error with status");
//            return 0;
//    }
//}

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_delegate keyboardHide];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width - 10, 43)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [Tools colorWithRED:74.0 GREEN:74.0 BLUE:74.0 ALPHA:1.0];
        label.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2 + 10, 21);
        [cell.contentView addSubview:label];
        label.tag = 1111;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 1)];
        line.backgroundColor = [Tools colorWithRED:242 GREEN:242 BLUE:242 ALPHA:1.0];
        [cell.contentView addSubview:line];
    }

    SearchStatus status = [self status];
    UILabel *label = [cell.contentView viewWithTag:1111];
    switch (status) {
        case SearchStatusNoInput:
//            if (indexPath.row == 0 && indexPath.section == 0) {
//                label.text =  [showing_data objectAtIndex:indexPath.row]];
//            } else {
                label.text =  [showing_data objectAtIndex:indexPath.row];
//            }
            break;
        case SearchStatusInputWithNoResult:
            if (indexPath.row == 0 && indexPath.section == 0) {
                label.text =  [NSString stringWithFormat:@"解锁新角色：%@",  label.text = [_delegate getUserInputString]];
            } else {
                label.text = [_delegate getUserInputString];
            }
            break;
        case SearchStatusInputWithResult: {
                if (indexPath.section == 0) {
                    if (indexPath.row) {
                        label.text =  [NSString stringWithFormat:@"解锁新角色：%@", [_delegate getUserInputString]];
                    } else {
                        label.text = [_delegate getUserInputString];
                    }
                } else {
                    label.text = [showing_data objectAtIndex:indexPath.row];
                }
            }
            break;
        default:
            NSLog(@"error with status");
            return 0;
    }
//    switch (status) {
//        case SearchStatusNoInput:
//            cell.textLabel.text = [showing_data objectAtIndex:indexPath.row];
//            break;
//            
//        case SearchStatusInputWithNoResult:
//            cell.textLabel.text = [_delegate getUserInputString];
//            break;
//            
//        case SearchStatusInputWithResult: {
//            if (indexPath.section == 0) {
//                cell.textLabel.text = [_delegate getUserInputString];
//            } else {
//                cell.textLabel.text = [showing_data objectAtIndex:indexPath.row];
//            }
//            }
//            break;
//            
//        default:
//            NSLog(@"error with status");
//            return 0;
//    }
//    
//    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.f];
    
////    cell.textLabel.textColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
////    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

- (NSString*)getControllerTitle {
    return @"添加角色";
}
@end
