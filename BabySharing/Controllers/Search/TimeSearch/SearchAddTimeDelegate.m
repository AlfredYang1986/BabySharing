//
//  SearchAddTimeDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 1/20/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "SearchAddTimeDelegate.h"

#import "AppDelegate.h"
#import "FoundSearchModel.h"

@interface SearchAddTimeDelegate ()

@property (nonatomic, weak, getter=getFoundSearchModel) FoundSearchModel* fm;
@end

@implementation SearchAddTimeDelegate {
    NSArray* exist_data;
    NSArray* showing_data;
}

@synthesize delegate = _delegate;
@synthesize actions = _actions;

@synthesize fm = _fm;

- (void)pushExistingData:(NSArray *)data {
    exist_data = data;
    showing_data = exist_data;
}

- (FoundSearchModel*)getFoundSearchModel {
    if (_fm == nil) {
        AppDelegate* app = [UIApplication sharedApplication].delegate;
        _fm = app.fm;
    }
    return _fm;
}

#pragma mark -- search bar delegate
#define TIME 1
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.fm queryFoundTagSearchWithInput:searchText andType:TIME andFinishBlock:^(BOOL success, NSDictionary *preview) {
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:self.fm.tagSearchResult.count];
        for (NSDictionary* iter in self.fm.tagSearchResult) {
            [arr addObject:[iter objectForKey:@"tag_name"]];
        }
        showing_data = [arr copy];
        [_delegate needToReloadData];
    }];
}

#pragma mark -- search bar delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[_actions getViewController] popViewControllerAnimated:NO];
}

#pragma mark -- table view datasource
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (showing_data.count == 0) {
        [_actions addNewItem:[_delegate getUserInputString]];
    } else {
        [_actions didSelectItem:[showing_data objectAtIndex:indexPath.row]];
    }
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
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
    //    cell.backgroundColor = [UIColor colorWithRed:0.2039 green:0.2078 blue:0.2314 alpha:1.f];//[UIColor colorWithWhite:0.1882 alpha:1.f];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (cell.layer.sublayers.count == 1) {
        CALayer* line = [CALayer layer];
        line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.30].CGColor;
        line.borderWidth = 1.f;
        line.frame = CGRectMake(10.5, 44 - 1, [UIScreen mainScreen].bounds.size.width - 10.5 * 2 + 8, 1);
        [cell.layer addSublayer:line];
    }
    cell.contentView.backgroundColor = [UIColor redColor];
    return cell;
}

- (NSString*)getControllerTitle {
    return [_actions getControllerTitle];
}
@end
