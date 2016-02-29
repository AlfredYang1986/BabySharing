//
//  DropDownItem.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 4/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface DropDownItem : UITableViewCell

@property (nonatomic, weak) ALAssetsGroup* group;
@property (nonatomic, weak) NSObject *album;//包含了相册中相册的容器对象
@property (nonatomic, weak) PHCollection *collection;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setTitle:(NSString *)title;
@end
