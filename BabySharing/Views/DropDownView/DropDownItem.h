//
//  DropDownItem.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 4/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

@interface DropDownItem : UITableViewCell

@property (nonatomic, weak) ALAssetsGroup* group;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
