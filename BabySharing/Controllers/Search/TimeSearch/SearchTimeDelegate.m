//
//  SearchTimeDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 1/20/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "SearchTimeDelegate.h"
#import "SearchAddTimeDelegate.h"
//#import "SearchAddViewController.h"
#import "SearchAddController2.h"

#import "FoundSearchHeader.h"
#import "FoundHotTagsCell.h"

@implementation SearchTimeDelegate
@synthesize delegate = _delegate;
@synthesize actions = _actions;

- (void)collectData {
    
}

#pragma mark -- table view delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FoundHotTagsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"brand tags"];
    if (!cell) {
        cell = [[FoundHotTagsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"brand tags"];
    }
    
    cell.isDarkTheme = YES;
    [cell setHotTagsTest:@[@"asos", @"brands"]];
    cell.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FoundSearchHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"hot role header"];
    
    if (header == nil) {
        header = [[FoundSearchHeader alloc]initWithReuseIdentifier:@"hot role header"];
    }
    
    if (section == 0) {
        header.headLabell.text = @"使用过的品牌";
    } else {
        header.headLabell.text = @"已用品牌";
    }
    //    header.headLabell.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
    header.headLabell.textColor = [UIColor whiteColor];
    header.headLabell.font = [UIFont systemFontOfSize:14.f];
    
    header.backgroundView = [[UIImageView alloc] initWithImage:[SearchTimeDelegate imageWithColor:[UIColor colorWithWhite:0.1098 alpha:1.f] size:header.bounds.size alpha:1.0]];
    return header;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(float)alpha {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, alpha);
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark -- search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SearchViewController" bundle:nil];
//    SearchAddViewController* svc = [storyboard instantiateViewControllerWithIdentifier:@"SearchAdd"];
    SearchAddController2* svc = [storyboard instantiateViewControllerWithIdentifier:@"SearchAdd2"];
    SearchAddTimeDelegate* sd = [[SearchAddTimeDelegate alloc]init];
    sd.delegate = svc;
    sd.actions = self;
    [[_actions getViewController] pushViewController:svc animated:NO];
    svc.delegate = sd;
    [sd pushExistingData:@[@"abcde", @"time"]];
    return NO;
}

#pragma mark -- SearchViewControllerProtocol
- (void)needToReloadData {
    [_delegate needToReloadData];
}

#pragma mark -- search actions protocol
- (void)didSelectItem:(NSString*)item {
    [_actions didSelectItem:item];
}

- (void)addNewItem:(NSString*)item {
    [_actions addNewItem:item];
}

- (NSString*)getControllerTitle {
    return [_actions getControllerTitle];
}

- (UINavigationController*)getViewController {
    return [_actions getViewController];
}
@end
