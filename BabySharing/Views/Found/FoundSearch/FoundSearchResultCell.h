//
//  FoundSearchResultCell.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundSearchResultCell : UITableViewCell

@property (strong, nonatomic) NSString* tag_name;
@property (strong, nonatomic) NSNumber* tag_type;

+ (CGFloat)preferredHeight;
- (void)setUserContentImages:(NSArray*)img_arr;
//- (void)setSearchTag:(NSString*)title andImage:(UIImage*)img;
- (void)setSearchTag:(NSString*)title andType:(NSNumber*)type;
- (void)setSearchResultCount:(NSInteger)count;
@end