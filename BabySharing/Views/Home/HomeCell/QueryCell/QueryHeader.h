//
//  QueryHeader.h
//  BabySharing
//
//  Created by Alfred Yang on 30/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryCellDelegate.h"

@interface QueryHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) UIImageView* userImg;
@property (nonatomic, strong) UIButton* userRoleTagBtn;
@property (nonatomic, strong) UILabel* userNameLabel;
@property (nonatomic, strong) UILabel* pushTimesLabel;
@property (nonatomic, strong) UIButton* pushBtn;

@property (nonatomic, strong) UILabel* tagLabel;

@property (weak, nonatomic) id<QueryCellActionProtocol> delegate;
@property (weak, nonatomic) id content;

- (void)setUpSubviews;

- (void)setUserPhoto:(NSString*)photo_name;
- (void)setUserName:(NSString*)name;
- (void)setTagText:(NSString*)location;
- (void)setRoleTag:(NSString*)role_tag;
- (void)setTimes:(NSString*)times;
@end
