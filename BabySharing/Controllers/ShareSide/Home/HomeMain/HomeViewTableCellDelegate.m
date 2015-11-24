//
//  HomeViewTableCellDelelage.m
//  BabySharing
//
//  Created by Alfred Yang on 23/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "HomeViewTableCellDelegate.h"
#import "HomeViewController.h"
#import "QueryCell.h"
#import "QueryHeader.h"
#import "QueryContent.h"
#import "QueryContentItem.h"
#import "TmpFileStorageModel.h"

@implementation HomeViewTableCellDelegate

@synthesize delegate = _delegate;
@synthesize trait = _trait;
@synthesize controller = _controller;

@synthesize current_index = _current_index;

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QueryContent* tmp = [_delegate queryItemAtIndex:tableView.tag];
    if (tmp == nil) {
        tableView.hidden = YES;
    }
    return [QueryCell preferredHeightWithDescription:tmp.content_description];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[QueryCell class]]) {
        QueryCell* qc = (QueryCell*)cell;
        if (qc.movieURL) {
            [qc movieContentWithURL:qc.movieURL withTriat:self.trait];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[QueryCell class]]) {
        QueryCell* qc = (QueryCell*)cell;
        [qc stopMovie];
        [qc disappearFuncView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [QueryHeader preferredHeight];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    QueryHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"query header"];
    
    if (header == nil) {
        header = [[QueryHeader alloc]initWithReuseIdentifier:@"query header"];
    }
    
    [header setUpSubviews];
    QueryContent* tmp = [_delegate queryItemAtIndex:tableView.tag];
    [header setUserPhoto:tmp.owner_photo];
    [header setUserName:tmp.owner_name];
    //        [header setTimeText:@"金融/旅行/90后"];
    [header setTime:tmp.content_post_date];
    [header setRoleTag:@"role tag"];
    [header setPushTimes:[NSString stringWithFormat:@"%d", tmp.likes_count.intValue]];
    
    header.delegate = _controller;
    header.content = tmp;
    
    return header;
}

#pragma mark -- table view datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QueryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"query cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QueryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    QueryContent* tmp = [_delegate queryItemAtIndex:tableView.tag];
    QueryContentItem* tmp_item = [tmp.items.objectEnumerator nextObject];
    if (tmp_item.item_type.unsignedIntegerValue == PostPreViewPhote) {
        NSLog(@"photo field");
        NSLog(@"%@", tmp_item.item_name);
        UIImage* img =[TmpFileStorageModel enumImageWithName:tmp_item.item_name withDownLoadFinishBolck:^(BOOL success, UIImage* download_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (cell) {
                        cell.imgView.image = download_img;
                        NSLog(@"change img success");
                    }
                });
            } else {
                NSLog(@"down load image %@ failed", tmp_item.item_name);
            }
        }];
        
        [cell.imgView setImage:img];
        
    } else if (tmp_item.item_type.unsignedIntegerValue == PostPreViewMovie) {
        NSLog(@"movie field");
        NSLog(@"%@", tmp_item.item_name);
        NSString* fullpath =[[TmpFileStorageModel BMTmpMovieDir]stringByAppendingPathComponent:tmp_item.item_name];
        NSURL* url = [TmpFileStorageModel enumFileWithName:tmp_item.item_name andType:tmp_item.item_type.unsignedIntegerValue withDownLoadFinishBlock:^(BOOL success, NSURL *path) {
            if (success) {
                NSLog(@"down load movie %@ success", tmp_item.item_name);
                [cell movieContentWithURL:path withTriat:self.trait];
                //                    [cell playMovie];
                AVAsset* asset = [AVAsset assetWithURL:path];
                [asset loadValuesAsynchronouslyForKeys:@[@"duration"] completionHandler:^{
                    NSError* error = nil;
                    switch ([asset statusOfValueForKey:@"duration" error:&error]) {
                        case AVKeyValueStatusLoaded: {
                            AVAssetImageGenerator* gen = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
                            CMTime time = asset.duration;
                            time.value = 0.8 * time.timescale;
                            NSError* error = nil;
                            UIImage* download_img = [UIImage imageWithCGImage:[gen copyCGImageAtTime:time actualTime:&time error:&error]];
                            if (error) {
                                NSLog(@"get thumbnails error: %@", error.description);
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    cell.imgView.image = download_img;
                                    NSLog(@"change img success");
                                });
                            }}
                            break;
                            
                        default: {
                            NSLog(@"load asset error: %@", error.description);
                            if ([[NSFileManager defaultManager] fileExistsAtPath:fullpath]) {
                                NSLog(@"somethine wrong with the file you download, need to download again");
                                [[NSFileManager defaultManager]removeItemAtPath:fullpath error:nil];
                            }}
                            break;
                    }
                }];
                
            } else {
                NSLog(@"down load movie %@ failed", tmp_item.item_name);
            }
        }];
        if (url) {
            [cell movieContentWithURL:[NSURL fileURLWithPath:fullpath] withTriat:self.trait];
            //                [cell playMovie];
            AVAsset* asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:fullpath]];
            AVAssetImageGenerator* gen = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
            CMTime time = asset.duration;
            time.value = 0.8 * time.timescale;
            NSError* error = nil;
            UIImage* download_img = [UIImage imageWithCGImage:[gen copyCGImageAtTime:time actualTime:&time error:&error]];
            if (error) {
                NSLog(@"get thumbnails error: %@", error.description);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imgView.image = download_img;
                    NSLog(@"change img success");
                });
            }
            
        }
        
    } else {
        NSLog(@"text field");
    }
    
    cell.delegate = self.controller;
    cell.content = tmp;
    [cell setDescription:tmp.content_description];
    
    [cell setTime:tmp.content_post_date];
    [cell setTags:@"安全，海淘"];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {     // Default is 1 if not implemented
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
@end
