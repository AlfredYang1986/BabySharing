//
//  DropDownMnue.m
//  BabySharing
//
//  Created by Alfred Yang on 12/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "DropDownMenu.h"

#define MENU_ITME_HEIGHT        44

@interface DropDownMenu ()

@end

@implementation DropDownMenu {
    NSArray* contents;
}

@synthesize dropdownDelegate = _dropdownDelegate;

- (void)setMenuText:(NSArray*)text_arr {
    contents = text_arr;
    [self setPreferredContentSize:CGSizeMake(120, MENU_ITME_HEIGHT * contents.count)];
}

#pragma mark -- data delegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    [_dropdownDelegate dropDownMenu:self didSelectMuneItemAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MENU_ITME_HEIGHT;
}

#pragma mark -- data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defalut"];
    }
    
    cell.textLabel.text = [contents objectAtIndex:indexPath.row];
    
    return cell;
}

/**
 Thanks to Paul Solt for supplying these background images and container view properties
 */
- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
    
    WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] init];
    NSString *bgImageName = nil;
    CGFloat bgMargin = 0.0;
    CGFloat bgCapSize = 0.0;
    CGFloat contentMargin = 4.0;
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    bgImageName = [resourceBundle pathForResource:@"popoverBg" ofType:@"png"];
    
    // These constants are determined by the popoverBg.png image file and are image dependent
    bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13
    bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
    
    props.leftBgMargin = bgMargin;
    props.rightBgMargin = bgMargin;
    props.topBgMargin = bgMargin;
    props.bottomBgMargin = bgMargin;
    props.leftBgCapSize = bgCapSize;
    props.topBgCapSize = bgCapSize;
    props.bgImageName = bgImageName;
    props.leftContentMargin = contentMargin;
    props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
    props.topContentMargin = contentMargin;
    props.bottomContentMargin = contentMargin;
    
    props.arrowMargin = 4.0;
    
    props.upArrowImageName = [resourceBundle pathForResource:@"popoverArrowUp" ofType:@"png"];
    props.downArrowImageName = [resourceBundle pathForResource:@"popoverArrowDown" ofType:@"png"];
    props.leftArrowImageName = [resourceBundle pathForResource:@"popoverArrowLeft" ofType:@"png"];
    props.rightArrowImageName = [resourceBundle pathForResource:@"popoverArrowRight" ofType:@"png"];
    return props;	
}
@end
