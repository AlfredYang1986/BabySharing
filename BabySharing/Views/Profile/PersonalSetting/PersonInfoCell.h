//
//  PersonInfoCell.h
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RoleLable.h"

typedef NS_ENUM(NSInteger, PersonalSettingCellType) {
    //以下是枚举成员
    HeadViewType = 0,
    NickNameType = 1,
    RoleType = 2,
};
@interface PersonInfoCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nickTextFiled;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *titleLable;;
@property (nonatomic, strong) UILabel *roleLable;
@property (nonatomic, weak) NSArray<RoleLable *> *arr;
@property (nonatomic) PersonalSettingCellType type;

@property (nonatomic, strong) UIImageView *arrowImageView;


- (instancetype)initWithCellType:(PersonalSettingCellType)cellType;

- (void)changeCellWithNickName:(NSString *)content;
- (void)changeCellWithImageName:(NSString *)imageName;
- (void)changeCellRoleArr:(NSArray<NSString *> *)roleArr;
- (void)changeCellRoleRoleStr:(NSString *)roleStr;

@end
