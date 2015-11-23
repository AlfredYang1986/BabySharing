//
//  HomeViewTableCellDelelage.m
//  BabySharing
//
//  Created by Alfred Yang on 23/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "HomeViewTableCellDelelage.h"
#import "HomeViewController.h"
#import "QueryCell.h"
#import "QueryHeader.h"
#import "QueryContent.h"
#import "QueryContentItem.h"
#import "TmpFileStorageModel.h"

@implementation HomeViewTableCellDelelage

@synthesize delegate = _delegate;
@synthesize trait = _trait;
@synthesize controller = _controller;

#pragma mark -- table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:indexPath];
    
    //    QueryContent* cur = [_qm.querydata objectAtIndex:indexPath.row - 1];
    //    [self performSegueWithIdentifier:@"HomeDetailSegue" sender:cur];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
    //    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSInteger total = [self tableView:tableView numberOfRowsInSection:indexPath.section];
//    NSInteger total = [self numberOfSectionsInTableView:tableView];
//    if (indexPath.section == 0 || indexPath.section == total - 1) return 44;
//    else {
    
//        QueryContent* tmp = [_delegate queryItemAtIndex:indexPath.section - 1];
        QueryContent* tmp = [_delegate queryItemAtIndex:indexPath.section];
        //        QueryContent* tmp = [self.qm.querydata objectAtIndex:indexPath.section - 1];
        return [QueryCell preferredHeightWithDescription:tmp.content_description];
//    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
//        NSInteger total = [self numberOfSectionsInTableView:tableView];
//        if (section == 0 || section == total - 1) {
//            CAGradientLayer *layer = [CAGradientLayer layer];
//            layer.frame = view.bounds;
//            layer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0.0157 green:0.6235 blue:0.5373 alpha:1.f].CGColor
//                            , (id)[UIColor colorWithRed:0.0353 green:0.5020 blue:0.3961 alpha:1.f].CGColor, nil];
//            layer.startPoint = CGPointMake(0, 0);
//            layer.endPoint = CGPointMake(1, 1);
//            [((UITableViewHeaderFooterView*)view).backgroundView.layer addSublayer:layer];
//            
//            //        } else ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
//        } else
            ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor whiteColor];
//    }
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
        //        [trait AvailableForPlayer:qc.player];
        //        qc.player = nil;
        
        [qc disappearFuncView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSInteger total = [self numberOfSectionsInTableView:tableView];
//    if (section == 0) {
//        
//        UITableViewHeaderFooterView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"default header first"];
//        
//        if (view == nil) {
//            view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"default header first"];
//        }
//        
//        
//        if ([view viewWithTag:-99] == nil) {
//            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//            NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"Refresh2"] ofType:@"png"];
//            
//            UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 36)];
//            iv.contentMode = UIViewContentModeScaleToFill;
//            iv.image = [UIImage imageNamed:filePath];
//            CGFloat width = [UIScreen mainScreen].bounds.size.width;
//            CGFloat height = 44;
//            iv.center = CGPointMake(width / 2, height / 2);
//            iv.tag = -99;
//            [view addSubview:iv];
//        }
//        
//        return view;
//        
//    } else if (section == total - 1) {
//        
//        UITableViewHeaderFooterView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"default header last"];
//        
//        if (view == nil) {
//            view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"default header last"];
//        }
//        
//        view.textLabel.text = @"there is no more content";
//        
//        return view;
//        
//    } else {
    
        QueryHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"query header"];
        
        if (header == nil) {
            header = [[QueryHeader alloc]initWithReuseIdentifier:@"query header"];
        }
        
        [header setUpSubviews];
        //        QueryContent* tmp = [self.qm.querydata objectAtIndex:section - 1];
//        QueryContent* tmp = [_delegate queryItemAtIndex:section - 1];
        QueryContent* tmp = [_delegate queryItemAtIndex:section];
        [header setUserPhoto:tmp.owner_photo];
        [header setUserName:tmp.owner_name];
        //        [header setTimeText:@"金融/旅行/90后"];
        [header setTime:tmp.content_post_date];
        [header setRoleTag:@"role tag"];
        [header setPushTimes:[NSString stringWithFormat:@"%d", tmp.likes_count.intValue]];
        
        header.delegate = _controller;
        header.content = tmp;
        
        return header;
//    }
}

#pragma mark -- table view datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    NSInteger total = [self tableView:tableView numberOfRowsInSection:indexPath.section];
//    NSInteger total = [self numberOfSectionsInTableView:tableView];
//    //    if (indexPath.row == 0) {
//    if (indexPath.section == 0) {
//        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
//        
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
//        }
//        
//        cell.textLabel.text = @"refreshing...";
//        return cell;
//        
//        //    } else if (indexPath.row == total - 1){
//    } else if (indexPath.section == total - 1){
//        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
//        
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
//        }
//        
//        cell.textLabel.text = @"athena";
//        return cell;
//    } else {
        QueryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"query cell"];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QueryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        //        QueryContent* tmp = [self.qm.querydata objectAtIndex:indexPath.section - 1];
//        QueryContent* tmp = [_delegate queryItemAtIndex:indexPath.section - 1];
        QueryContent* tmp = [_delegate queryItemAtIndex:indexPath.section];
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
        cell.content = tmp; //[_qm.querydata objectAtIndex:indexPath.section - 1];
        //        cell.content = [_qm.querydata objectAtIndex:indexPath.row - 1];
        [cell setDescription:tmp.content_description];
        
        [cell setTime:tmp.content_post_date];
        [cell setTags:@"安全，海淘"];
        
        return cell;
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {     // Default is 1 if not implemented
    //    return 2 + self.qm.querydata.count;
//    return 2 + [_delegate count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSInteger total = [self numberOfSectionsInTableView:tableView];
//    if (section == 0 || section == total - 1) {
//        return 0;
//    } else {
//        return 1;
//    }
//    return 2 + self.qm.querydata.count;
    return 1;
}
@end
