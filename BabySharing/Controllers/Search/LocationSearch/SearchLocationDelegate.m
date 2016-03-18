//
//  SearchLocationDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 1/20/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "SearchLocationDelegate.h"
#import "SearchAddLocationDelegate.h"
//#import "SearchAddViewController.h"
#import "SearchAddController2.h"
#import "SearchViewController.h"

#import "FoundSearchHeader.h"
#import "FoundHotTagsCell.h"

#import "AppDelegate.h"
#import "FoundSearchModel.h"
#import "RecommandTag.h"
#import "LocalTag.h"
#import "Define.h"

#import "HomeTagsController.h"

@interface SearchLocationDelegate () <FoundHotTagsCellDelegate>

@property (nonatomic, weak, getter=getFoundTagModel) FoundSearchModel* fm;
@end

@implementation SearchLocationDelegate
@synthesize delegate = _delegate;
@synthesize actions = _actions;

@synthesize controller = _controller;

@synthesize fm = _fm;

- (FoundSearchModel*)getFoundTagModel {
    if (_fm == nil) {
        AppDelegate* app = [UIApplication sharedApplication].delegate;
        _fm = app.fm;
    }
    return _fm;
}

- (NSString*)getSearchPlaceHolder {
    return @"添加地点标签";
}

- (void)collectData {
    
}

- (void)setInitialSearchBarText:(NSString*)text {
    if (text.length > 0) {
        SearchAddLocationDelegate* sd = [[SearchAddLocationDelegate alloc]init];
        ((SearchViewController*)self.controller).delegate = sd;
        sd.delegate = self;
        sd.actions = self;
        
        NSMutableArray *localArr = [[NSMutableArray alloc] init];
        for (LocalTag *localTag in [[AppDelegate defaultAppDelegate].localTagManager enumLocalTagWithType:1]) {
            NSLog(@"%@ === %@", @"", localTag.tag_text);
            [localArr addObject:localTag.tag_text];
        }
        [sd pushExistingData:[localArr copy] withHeader:text];
        
        [((SearchViewController*)self.controller).queryView reloadData];
    }
}

#pragma mark -- table view delegate and datasource
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section != 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FoundHotTagsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"brand tags"];
    if (!cell) {
        cell = [[FoundHotTagsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"brand tags"];
    }
    
//    cell.isDarkTheme = YES;
//    [cell setHotTagsText:@[@"asos", @"brands"]];
    [cell setHotTags:self.fm.recommandsdata];
    cell.delegate = self;
    cell.isHiddenSepline = YES;
//    cell.backgroundColor = [UIColor colorWithRed:0.2039 green:0.2078 blue:0.2314 alpha:1.f];//[UIColor colorWithWhite:0.1882 alpha:1.f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FoundSearchHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"hot role header"];
    
    if (header == nil) {
        header = [[FoundSearchHeader alloc]initWithReuseIdentifier:@"hot role header"];
    }
    
    if (section == 0) {
        header.headLabell.text = @"热门品牌";
        header.headLabell.textColor = TextColor;
    } else {
        header.headLabell.text = @"已用品牌";
    }
    
    //    header.headLabell.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
//    header.headLabell.textColor = [UIColor whiteColor];
    header.headLabell.font = [UIFont systemFontOfSize:14.f];
    
//    header.backgroundView = [[UIImageView alloc] initWithImage:[SearchLocationDelegate imageWithColor:[UIColor colorWithWhite:0.1098 alpha:1.f] size:header.bounds.size alpha:1.0]];
    header.backgroundView = [[UIImageView alloc] initWithImage:[SearchLocationDelegate imageWithColor:[UIColor whiteColor] size:header.bounds.size alpha:1.0]];
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
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        SearchAddLocationDelegate* sd = [[SearchAddLocationDelegate alloc]init];
        ((SearchViewController*)self.controller).delegate = sd;
        sd.delegate = self;
        sd.actions = self;
        
        NSMutableArray *localArr = [[NSMutableArray alloc] init];
        for (LocalTag *localTag in [[AppDelegate defaultAppDelegate].localTagManager enumLocalTagWithType:1]) {
            NSLog(@"%@ === %@", @"", localTag.tag_text);
            [localArr addObject:localTag.tag_text];
        }
        [sd pushExistingData:[localArr copy] withHeader:searchText];
        
        [((SearchViewController*)self.controller).queryView reloadData];
    }
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

- (NSString*)getUserInputString {
    return [_delegate getUserInputString];
}

#pragma mark -- async query data
#define LOCATION  0
- (void)asyncQueryDataWithFinishCallback:(SearchCallback)block {
    [self.fm queryRecommandTagsWithType:LOCATION andFinishBlock:^(BOOL success, NSArray *arr_re_tags) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(success, arr_re_tags);
        });
    }];
}

#pragma mark -- Found Search Delegate
- (void)recommandTagBtnSelected:(NSString*)tag_name adnType:(NSInteger)tag_type {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    HomeTagsController* svc = [storyboard instantiateViewControllerWithIdentifier:@"TagSearch"];
//    svc.tag_name = tag_name;
//    svc.tag_type = tag_type;
//    
//    [_controller.navigationController setNavigationBarHidden:NO animated:YES];
//    [_controller.navigationController pushViewController:svc animated:YES];
    [self didSelectItem:tag_name];
}
@end
