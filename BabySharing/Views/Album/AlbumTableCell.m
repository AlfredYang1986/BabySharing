//
//  PostTableCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 1/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "AlbumTableCell.h"
#import "AlbumGridCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation AlbumTableCell

@synthesize delegate = _delegate;

- (AlbumGridCell*)queryGridCellByIndex:(NSInteger)index {
    return (AlbumGridCell*)[image_view objectAtIndex:index % 3];
}

- (void)setUpContentViewWithImageURLs:(NSArray*)image_arr atLine:(NSInteger)row andType:(AlbumControllerType)type {
    views_count = [_delegate getViewsCount];
    if (image_view == nil) {
        image_view = [[NSMutableArray alloc]initWithCapacity:views_count];
    }
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    CGFloat step_width = screen_width / views_count;
//      CGFloat height = rc.size.height;
    CGFloat height = [self prefferCellHeight];

    for (int index = 0; index < image_view.count; ++index) {
        [((UIView*)[image_view objectAtIndex:index]) removeFromSuperview];
    }
    [image_view removeAllObjects];
        
    for (int index = 0; index < views_count; ++index) {
        
        if (row == 0 && index == 0) {
            UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(index * step_width, 0, step_width, height)];
            
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            if (type == AlbumControllerTypePhoto) {
                UIImage *image = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Camera"] ofType:@"png"]];
                [btn setBackgroundImage:image forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(didSelectCameraBtn) forControlEvents:UIControlEventTouchDown];
            } else if (type == AlbumControllerTypeMovie) {
                UIImage *image = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Movie"] ofType:@"png"]];
                [btn setBackgroundImage:image forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(didSelectMovieBtn) forControlEvents:UIControlEventTouchDown];
            } else if (type == AlbumControllerTypeCompire) {
                 UIImage *image = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Explore"] ofType:@"png"]];
                [btn setBackgroundImage:image forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(didSelectCompareBtn) forControlEvents:UIControlEventTouchDown];
            } else {
                
            }
            
            [image_view addObject:btn];
            [self addSubview:btn];
        
        }  else if (row == 0 && index != 0) {

            if (index > image_arr.count)
                continue;
            
            ALAsset* at = [image_arr objectAtIndex:index - 1];
            UIImage* img = [UIImage imageWithCGImage:[at thumbnail]];
            AlbumGridCell* tmp = [[AlbumGridCell alloc]initWithFrame:CGRectMake(index * step_width, 0, step_width, height)];
            if ([[at valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                id duration = [at valueForProperty:ALAssetPropertyDuration];
                [tmp setMovieDurationLayer:duration];
            }
            tmp.userInteractionEnabled = YES;
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageSubViewTaped:)];
            tap.numberOfTapsRequired = 1;
            [tmp addGestureRecognizer:tap];
            
            tmp.image = img;
            tmp.row = row;
            tmp.col = index;
           
            NSInteger iter = [_delegate indexByRow:row andCol:index];
            if ([_delegate isSelectedAtIndex:iter]) {
                tmp.viewSelected = YES;
            }
            
            [image_view addObject:tmp];
            [self addSubview:tmp];
            
        }else {

            if (index > image_arr.count)
                continue;
            
            ALAsset* at = [image_arr objectAtIndex:index];
            UIImage* img = [UIImage imageWithCGImage:[at thumbnail]];
            AlbumGridCell* tmp = [[AlbumGridCell alloc]initWithFrame:CGRectMake(index * step_width, 0, step_width, height)];
            if ([[at valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                NSNumber* duration = [at valueForProperty:ALAssetPropertyDuration];
                [tmp setMovieDurationLayer:duration];
            }
            tmp.userInteractionEnabled = YES;

            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageSubViewTaped:)];
            tap.numberOfTapsRequired = 1;
            [tmp addGestureRecognizer:tap];
            
            tmp.image = img;
            tmp.row = row;
            tmp.col = index;
            
            NSInteger iter = [_delegate indexByRow:row andCol:index];
            if ([_delegate isSelectedAtIndex:iter]) {
                tmp.viewSelected = YES;
            }
            
            [image_view addObject:tmp];
            [self addSubview:tmp];
        }
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    NSLog(@"dequeue table cell");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self != nil) {
//        [self setUpContentViewWithImageURLs:nil];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"awake from nib");
//    [self setUpContentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)prefferCellHeight {
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
//    return 96;
    return screen_width / 3;
}

#pragma mark -- tap actions

- (void)didSelectCameraBtn {
    [_delegate didSelectCameraBtn];
}

- (void)didSelectMovieBtn {
    [_delegate didSelectMovieBtn];
}

- (void)didSelectCompareBtn {
    [_delegate didSelectCompareBtn];
}

- (void)imageSubViewTaped:(id)sender {
    UITapGestureRecognizer* tap = (UITapGestureRecognizer*)sender;
    AlbumGridCell* ck = (AlbumGridCell*)(tap.view);
    NSInteger index = [_delegate indexByRow:ck.row andCol:ck.col];
    
    if (ck.viewSelected) {
        [_delegate didUnSelectOneImageAtIndex:index];
        ck.viewSelected = NO;
    } else {
        [_delegate didSelectOneImageAtIndex:index];
        ck.viewSelected = YES;
    }
}
@end
