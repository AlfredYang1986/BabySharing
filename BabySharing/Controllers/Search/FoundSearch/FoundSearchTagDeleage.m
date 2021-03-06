//
//  FoundSearchTagDeleage.m
//  BabySharing
//
//  Created by Alfred Yang on 2/18/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "FoundSearchTagDeleage.h"
#import "FoundSearchResultCell.h"
#import "FoundSearchModel.h"
#import "FoundSearchHeader.h"
#import "FoundHotTagsCell.h"
#import "FoundSearchResultCell.h"
#import "HomeTagsController.h"
#import "UserSearchController.h"
#import "FoundSearchController.h"

@implementation FoundSearchTagDeleage

@synthesize fm = _fm;
@synthesize controller = _controller;
@synthesize current_search = _current_search;

#pragma mark -- table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_fm.previewDic.count == 0) {
        return 1;
    } else {
        return _fm.previewDic.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_fm.previewDic.count == 0) {
        return [self queryHotTagCellInTableView:tableView];
    } else {
        FoundSearchResultCell *cell = (FoundSearchResultCell *)[self querySearchResultInTableView:tableView atIndex:indexPath.row type:SearchSige];
        return cell;
//        return [self querySearchResultInTableView:tableView atIndex:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_fm.previewDic.count == 0) {
        return [FoundHotTagsCell preferredHeight];
    } else {
        return [FoundSearchResultCell preferredHeight];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return _fm.previewDic.count > 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FoundSearchResultCell* cell = [tableView cellForRowAtIndexPath:indexPath];
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeTagsController *svc = [storyboard instantiateViewControllerWithIdentifier:@"TagSearch"];
    svc.tag_name = cell.tag_name;
    svc.tag_type = cell.tag_type.integerValue;
        
    [_controller.navigationController pushViewController:svc animated:YES];
//    [_controller.navigationController pushViewControllerRetro:svc];
}

- (UITableViewCell*)queryHotTagCellInTableView:(UITableView*)tableView {
    FoundHotTagsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Hot Tag Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[FoundHotTagsCell alloc] init];
    }
    
    [cell setHotTags:_fm.recommandsdata];
    cell.delegate = _controller;
    return cell;
}

- (UITableViewCell*)querySearchResultInTableView:(UITableView*)tableView atIndex:(NSInteger)index type:(SearchType)type{
    FoundSearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Search Result"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"FoundSearchResultCell" owner:self options:nil];
        cell = [nib firstObject];
    }
    //    [cell setSearchResultCount:188];
    cell.type = type;
    NSDictionary* dic = [_fm.previewDic objectAtIndex:index];
    [cell setSearchTag:[dic objectForKey:@"tag_name"] andType:[dic objectForKey:@"type"]];
    [cell setUserContentImages:[dic objectForKey:@"content"]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return _fm.previewDic.count == 0 ? 1 : 2;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 8;
//}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FoundSearchHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"found header"];
    
    if (header == nil) {
        header = [[FoundSearchHeader alloc] initWithReuseIdentifier:@"found header"];
    }
    
    if ([tableView numberOfRowsInSection:section] > 1) {
        header.line.hidden = NO;
    } else {
        header.line.hidden = YES;
    }
    
    if (_fm.previewDic.count == 0) {
        header.headLabell.text = @"热门标签";
        header.headLabell.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
        header.headLabell.font = [UIFont systemFontOfSize:14.f];
    } else {
        header.headLabell.text = @"搜索结果";
        header.headLabell.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
        header.headLabell.font = [UIFont systemFontOfSize:14.f];
    }
    
    header.backgroundView = [[UIImageView alloc] initWithImage:[FoundSearchTagDeleage imageWithColor:[UIColor whiteColor] size:header.bounds.size alpha:1.0]];
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

#pragma mark -- public mothed
- (void)asyncQueryFoundSearchDataWithFinishBlock:(asyncFoundSearchBlock)block {
    dispatch_queue_t ap = dispatch_queue_create("found search init", nil);
    dispatch_async(ap, ^{
        [_fm queryRecommandTagsWithFinishBlock:^(BOOL success, NSArray* arr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }];
    });
}

- (void)resetCurrentSearchDataWithInput:(NSString *)input {
    if (![_current_search isEqualToString:input]) {
//        _current_search = input;
        if ([input isEqualToString:@""]) {
            _fm.previewDic = [NSArray array];
            [_controller.queryView reloadData];
        } else {
            [self queryFoundTagSearchWithInput:input andFinishBlock:^(BOOL success, NSDictionary *preview) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_controller.queryView reloadData];
                });
            }];
        }
    }
}

- (void)queryFoundTagSearchWithInput:(NSString*)input andFinishBlock:(FoundSearchFinishBlock)block {
    _current_search = input;
    [_fm queryFoundTagSearchWithInput:input andFinishBlock:^(BOOL success, NSDictionary *preview) {
        block(success, preview);
    }];
}

// 滚动收回键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideKeyBoard" object:nil];
}
@end
