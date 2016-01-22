//
//  SearchBrandsDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 1/20/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "SearchBrandsDelegate.h"
#import "SearchAddBrandsDelegate.h"
//#import "SearchAddViewController.h"
#import "SearchAddController2.h"

#import "FoundSearchHeader.h"
#import "FoundHotTagsCell.h"

@implementation SearchBrandsDelegate

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
    
    cell.ver_margin = 5;
    cell.isDarkTheme = YES;
    [cell setHotTagsTest:@[@"asos", @"brands"]];
    cell.isHiddenSepline = YES;
    cell.backgroundColor = [UIColor colorWithRed:0.2039 green:0.2078 blue:0.2314 alpha:1.f];//[UIColor colorWithWhite:0.1882 alpha:1.f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [FoundSearchHeader prefferredHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FoundSearchHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"hot role header"];
    
    if (header == nil) {
        header = [[FoundSearchHeader alloc]initWithReuseIdentifier:@"hot role header"];
    }

    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
   
    if (section == 0) {
        
        NSString* filepath = [resourceBundle pathForResource:@"post_resent_tag" ofType:@"png"];
        
        header.headImg.image = [UIImage imageNamed:filepath];
        header.headLabell.text = @"使用过的品牌";
    } else {

        NSString* filepath = [resourceBundle pathForResource:@"post_recommand_brand" ofType:@"png"];
        
        header.headImg.image = [UIImage imageNamed:filepath];
        header.headLabell.text = @"推荐品牌";
    }
    //    header.headLabell.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
    header.headLabell.textColor = [UIColor whiteColor];
    header.headLabell.font = [UIFont systemFontOfSize:14.f];
    
    header.backgroundView = [[UIImageView alloc] initWithImage:[SearchBrandsDelegate imageWithColor:[UIColor colorWithRed:0.2039 green:0.2078 blue:0.2314 alpha:1.f] size:header.bounds.size alpha:1.0]];
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
    SearchAddController2* svc = [storyboard instantiateViewControllerWithIdentifier:@"SearchAdd2"];
    SearchAddBrandsDelegate* sd = [[SearchAddBrandsDelegate alloc]init];
    sd.delegate = svc;
    sd.actions = self;
    [[_actions getViewController] pushViewController:svc animated:NO];
    svc.delegate = sd;
    [sd pushExistingData:@[@"abcde", @"brand"]];
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
