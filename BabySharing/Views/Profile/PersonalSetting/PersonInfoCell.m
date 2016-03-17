//
//  PersonInfoCell.m
//  BabySharing
//
//  Created by monkeyheng on 16/2/23.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "PersonInfoCell.h"
#import "TmpFileStorageModel.h"
#import "Tools.h"

@interface PersonInfoCell()

@end;

@implementation PersonInfoCell

- (instancetype)initWithCellType:(PersonalSettingCellType)cellType {
    NSString *identifier = cellType == HeadViewType ? @"HeadViewType" : (cellType == NickNameType ? @"NickNameType" : @"RoleType");
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCancel) name:@"hideCancel" object:nil];
        self.type = cellType;
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.text = cellType == HeadViewType ? @"头像" : (cellType == NickNameType ? @"昵称" : @"角色");
        self.titleLable.font = [UIFont systemFontOfSize:14];
        [self.titleLable sizeToFit];
        if (self.type == HeadViewType) {
            if (self.headView == nil) {
                self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
            }
        }
        if (self.type == NickNameType) {
            if (self.nickTextFiled == nil) {
                self.nickTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            }
            if (self.cancelBtn == nil) {
                self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            self.cancelBtn.hidden = YES;
            [self.cancelBtn setBackgroundImage:[UIImage imageNamed:[resourceBundle pathForResource:@"cancel_circle" ofType:@"png"]] forState:UIControlStateNormal];
            [self.cancelBtn addTarget:self action:@selector(deleleNickName) forControlEvents:UIControlEventTouchUpInside];
            self.nickTextFiled.font = [UIFont systemFontOfSize:12];
            self.nickTextFiled.textAlignment = NSTextAlignmentRight;
            self.nickTextFiled.delegate  = self;
            
        }
        if (self.type == RoleType) {
            if (self.roleLable == nil) {
                self.roleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            }
        }
        
        [self.contentView addSubview:self.titleLable];
        if (self.headView) [self.contentView addSubview:self.headView];
        if (self.nickTextFiled) {
           [self.contentView addSubview:self.nickTextFiled];
            [self.contentView addSubview:self.cancelBtn];
            self.nickTextFiled.placeholder = @"4-18个字节，限中英文，数字，表情符号";
            self.nickTextFiled.delegate = self;
        }
        if (self.roleLable) {
            self.roleLable.font = [UIFont systemFontOfSize:13];
            [self.contentView addSubview:self.roleLable];
        }
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[NSBundle bundleWithPath:[[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"]] pathForResource:[NSString stringWithFormat:@"common_icon_arrow@2x"] ofType:@"png"]]];
        [self.arrowImageView sizeToFit];
        [self.contentView addSubview:self.arrowImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLable.center = CGPointMake(CGRectGetWidth(self.titleLable.frame) / 2 + 10, CGRectGetHeight(self.frame) / 2);
    if (self.type == HeadViewType) {
        self.headView.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.headView.frame) / 2 - 30, CGRectGetHeight(self.frame) / 2);
        self.headView.clipsToBounds = YES;
        self.headView.layer.cornerRadius = CGRectGetWidth(self.headView.frame) / 2;
    }
    self.nickTextFiled.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) - 150, CGRectGetHeight(self.frame));
//    [self.nickTextFiled sizeToFit];
    if (self.type == NickNameType) {
        self.nickTextFiled.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.nickTextFiled.frame) / 2 - 30 - 12, CGRectGetHeight(self.frame) / 2);
        self.cancelBtn.frame = CGRectMake(0, 0, 13, 13);
        self.cancelBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 25, 22);
    }
    [self.roleLable sizeToFit];
    
    if (self.type == RoleType) self.roleLable.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.roleLable.frame) / 2 - 30, CGRectGetHeight(self.frame) / 2);
    self.arrowImageView.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.arrowImageView.frame) / 2 - 10, CGRectGetHeight(self.frame) / 2);
}

- (void)changeCellWithNickName:(NSString *)content {
    self.nickTextFiled.text = [Tools subStringWithByte:18 str:content];
}
- (void)changeCellWithImageName:(NSString *)photo_name {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"default_user"] ofType:@"png"];
    
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    self.headView.image = user_img;
                    NSLog(@"owner img download success");
                }
            });
        } else {
            NSLog(@"down load owner image %@ failed", photo_name);
        }
    }];
    
    if (userImg == nil) {
        userImg = [UIImage imageNamed:filePath];
    }
    [self.headView setImage:userImg];
}

- (void)changeCellRoleRoleStr:(NSString *)roleStr {
    self.roleLable.text = roleStr;
}

- (void)changeCellRoleArr:(NSArray<NSString *> *)roleArr {
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.cancelBtn.hidden = NO;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([Tools bityWithStr:textField.text] >= 18) {
        return NO;
    } else {
        return YES;
    }
}

- (void)deleleNickName {
    self.nickTextFiled.text = @"";
}

- (void)hideCancel{
    [self.nickTextFiled resignFirstResponder];
    self.cancelBtn.hidden = YES;
}

@end
