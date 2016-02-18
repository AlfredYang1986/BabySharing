//
//  FoundSearchRoleTagDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 2/18/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "FoundSearchRoleTagDelegate.h"

#import "FoundSearchModel.h"
#import "FoundSearchHeader.h"
#import "FoundHotTagsCell.h"
#import "FoundSearchResultCell.h"
#import "HomeTagsController.h"
#import "FoundSearchController.h"

#import "FoundSearchTagDeleage.h"

@implementation FoundSearchRoleTagDelegate

@synthesize fm = _fm;
@synthesize controller = _controller;

#pragma mark -- table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_fm.previewRoleDic.count == 0) {
        return 1;
    } else {
        return _fm.previewRoleDic.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_fm.previewRoleDic.count == 0) {
        return [self queryHotTagCellInTableView:tableView];
    } else {
        return [self querySearchResultInTableView:tableView atIndex:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_fm.previewRoleDic.count == 0) {
        return [FoundHotTagsCell preferredHeight];
    } else {
        return [FoundSearchResultCell preferredHeight];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return _fm.previewRoleDic.count > 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FoundSearchResultCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeTagsController* svc = [storyboard instantiateViewControllerWithIdentifier:@"TagSearch"];
    svc.tag_name = cell.tag_name;
    svc.tag_type = cell.tag_type.integerValue;
    
    //    [self.navigationController pushViewController:svc animated:YES];
    [_controller.navigationController pushViewController:svc animated:YES];
}

- (UITableViewCell*)queryHotTagCellInTableView:(UITableView*)tableView {
    FoundHotTagsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Hot Tag Cell"];
    
    if (cell == nil) {
        cell = [[FoundHotTagsCell alloc]init];
    }
    
    [cell setHotTagsTest:_fm.recommandsRoleTag];
    cell.delegate = _controller;
    return cell;
}

- (UITableViewCell*)querySearchResultInTableView:(UITableView*)tableView atIndex:(NSInteger)index {
    FoundSearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Search Result"];
    
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"FoundSearchResultCell" owner:self options:nil];
        cell = [nib firstObject];
    }
    //    [cell setSearchResultCount:188];
    NSDictionary* dic = [_fm.previewRoleDic objectAtIndex:index];
    [cell setSearchTag:[dic objectForKey:@"role_tag"] andType:[NSNumber numberWithInt:-1]];
    [cell setUserPhotoImage:[dic objectForKey:@"content"]];
    
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
        header = [[FoundSearchHeader alloc]initWithReuseIdentifier:@"found header"];
    }
    
    //    if (section == 0) {
    if (_fm.previewDic.count == 0) {
        //        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
        //        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        //        NSString* filepath = [resourceBundle pathForResource:@"found_hot_tag" ofType:@"png"];
        //        UIImage* img = [UIImage imageNamed:filepath];
        //        header.headImg.image = img;
        //        header.headImg.frame = CGRectMake(header.headImg.frame.origin.x, header.headImg.frame.origin.y, 25, 25);
        //        header.headImg.contentMode = UIViewContentModeScaleAspectFit;
        header.headLabell.text = @"热门标签";
        header.headLabell.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
        header.headLabell.font = [UIFont systemFontOfSize:14.f];
        
    } else {
        header.headLabell.text = @"搜索结果";
        header.headLabell.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
        header.headLabell.font = [UIFont systemFontOfSize:14.f];
    }
    
    header.backgroundView = [[UIImageView alloc] initWithImage:[FoundSearchRoleTagDelegate imageWithColor:[UIColor whiteColor] size:header.bounds.size alpha:1.0]];
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
        [_fm queryRecommandRoleTagsWithFinishBlock:^(BOOL success, NSArray* arr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }];
    });
}

- (void)resetCurrentSearchData {
    _fm.previewRoleDic = nil;
}

- (void)queryFoundTagSearchWithInput:(NSString*)input andFinishBlock:(FoundSearchFinishBlock)block {
    [_fm queryFoundRoleTagSearchWithInput:input andFinishBlock:^(BOOL success, NSDictionary *preview) {
        block(success, preview);
    }];
}
@end
