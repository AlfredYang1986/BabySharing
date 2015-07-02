//
//  PostGridCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 2/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumGridCell : UIImageView {
    CALayer * selectLayer;
    CATextLayer* durationLayer;
}

@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger col;

@property (nonatomic, setter=setCellViewSelected:) BOOL viewSelected;

- (void)setCellViewSelected:(BOOL)select;
- (void)setMovieDurationLayer:(id)duration;
@end
