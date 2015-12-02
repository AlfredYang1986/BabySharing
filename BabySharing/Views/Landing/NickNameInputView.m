//
//  NickNameInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 17/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "NickNameInputView.h"

#define IMG_WIDTH       30
#define IMG_HEIGHT      30

#define MARGIN          8

@implementation NickNameInputView {
    UITextField* name_text_field;
    UITextField* tag_text_field;
   
    UIButton* tag_text_btn;
    
    BOOL isSNSLogin;
}

@synthesize delegate = _delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithSNSLogin:(BOOL)sns_login {
    self = [super init];
    if (self) {
        isSNSLogin = sns_login;
        [self setUpViews];
    }
    return self;
}

- (CGSize)getPreferredBounds {
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.6;
//    CGFloat height = (MARGIN + IMG_HEIGHT) * 4 + MARGIN;
    CGFloat height = (MARGIN + IMG_HEIGHT)  // name
                    + 44 + MARGIN           // role tag
                    + 100 + MARGIN * 2;          // gender button
    
    return CGSizeMake(width, height);
}

- (void)setUpViews {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage* img_0 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"login-nickname-icon"] ofType:@"png"]];
    UIImage* img_1 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"login-role-tag-icon"] ofType:@"png"]];
    UIImage* img_2 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"gender-mom"] ofType:@"png"]];
    UIImage* img_3 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"gender-dad"] ofType:@"png"]];
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.6;
    
    if (isSNSLogin) {
        CGSize sz = [self getPreferredBounds];
        CGRect rc = CGRectMake(0, 0, sz.width, 44);
        UIView* role_tag = [self inputBorderLineWithTitle:@"添加你的角色描述" andImage:img_1 inRect:rc];
        role_tag.center = CGPointMake(sz.width / 2, sz.height / 2);
        [self addSubview:role_tag];
        
//        tag_text_field = [[UITextField alloc]init];
//        tag_text_field.delegate = self;
//        [self addSubview:[self inputLineWithImage:img_1 andPlaceHolder:@"添加你的角色" andInjectView:tag_text_field inRect:CGRectMake(0, MARGIN + IMG_HEIGHT, width, MARGIN + IMG_HEIGHT) isNeedUnderLine:YES]];
    } else {
        name_text_field = [[UITextField alloc]init];
        name_text_field.delegate = self;
        name_text_field.textColor = [UIColor whiteColor];
        
        [self addSubview:[self inputLineWithImage:img_0 andPlaceHolder:@"为你的咚哒起个名字" andInjectView:name_text_field inRect:CGRectMake(0, 0, width, MARGIN + IMG_HEIGHT) isNeedUnderLine:YES]];
       
        CGSize sz = [self getPreferredBounds];
        UIView* mom = [self genderBtnWithTitle:@"妈咪" subTitle:@"要够辣" andImage:img_2];
        mom.center = CGPointMake(sz.width / 4, sz.height / 2);
        [self addSubview:mom];
        
        UIView* dad = [self genderBtnWithTitle:@"爸比" subTitle:@"要靠谱" andImage:img_3];
        dad.center = CGPointMake(sz.width / 4 * 3, sz.height / 2);
        [self addSubview:dad];
        
        CGRect rc = CGRectMake(0, 0, sz.width, 32);
        UIView* role_tag = [self inputBorderLineWithTitle:@"添加你的角色描述" andImage:img_1 inRect:rc];
        role_tag.center = CGPointMake(sz.width / 2, mom.center.y + mom.frame.size.height / 2 + MARGIN + role_tag.frame.size.height / 2);
        [self addSubview:role_tag];
        
//        tag_text_field = [[UITextField alloc]init];
//        tag_text_field.delegate = self;
//        [self addSubview:[self inputLineWithImage:img_1 andPlaceHolder:@"添加你的角色" andInjectView:tag_text_field inRect:CGRectMake(0, MARGIN + IMG_HEIGHT, width, MARGIN + IMG_HEIGHT) isNeedUnderLine:YES]];
//        [self addSubview:[self inputLineWithImage:img_2 andPlaceHolder:@"只为妈咪" andInjectView:[[UILabel alloc]init] inRect:CGRectMake(0, 2 * (MARGIN + IMG_HEIGHT), width, MARGIN + IMG_HEIGHT) isNeedUnderLine:NO]];
//        [self addSubview:[self inputLineWithImage:nil andPlaceHolder:@"爸比暂时靠边站" andInjectView:[[UILabel alloc]init] inRect:CGRectMake(0, 3 * (MARGIN + IMG_HEIGHT), width, MARGIN + IMG_HEIGHT) isNeedUnderLine:NO]];
    }
}

- (UIView*)genderBtnWithTitle:(NSString*)title subTitle:(NSString*)sub_title andImage:(UIImage*)img {
    
    CGSize sz = [self getPreferredBounds];
    UIView* gender = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sz.width / 2 - 2, 100)];
   
    UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    iv.center = CGPointMake(gender.frame.size.width / 2, MARGIN + iv.frame.size.height / 2);
    iv.layer.cornerRadius = 15.f;
    iv.clipsToBounds = YES;
    iv.layer.borderColor = [UIColor whiteColor].CGColor;
    iv.layer.borderWidth = 1.f;
    iv.image = img;
    [gender addSubview:iv];
    
    UILabel* tl = [[UILabel alloc]init];
    tl.textColor = [UIColor lightGrayColor];
    tl.font = [UIFont systemFontOfSize:14.f];
    tl.text = title;
    [tl sizeToFit];
    tl.center = CGPointMake(iv.center.x, iv.center.y + MARGIN + iv.frame.size.height / 2 + tl.frame.size.height / 2);
    [gender addSubview:tl];

    UILabel* stl = [[UILabel alloc]init];
    stl.textColor = [UIColor lightGrayColor];
    stl.font = [UIFont systemFontOfSize:14.f];
    stl.text = sub_title;
    [stl sizeToFit];
    stl.center = CGPointMake(tl.center.x, tl.center.y + MARGIN + tl.frame.size.height / 2 + stl.frame.size.height / 2);
    [gender addSubview:stl];
    
    return gender;
}

- (UIView*)inputBorderLineWithTitle:(NSString*)title andImage:(UIImage*)icon inRect:(CGRect)rc {
    tag_text_btn = [[UIButton alloc]initWithFrame:rc];
    tag_text_btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tag_text_btn.layer.borderWidth = 1.f;
    tag_text_btn.layer.cornerRadius = tag_text_btn.frame.size.height / 2;
    [tag_text_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [tag_text_btn setTitle:title forState:UIControlStateNormal];
    [tag_text_btn setImage:icon forState:UIControlStateNormal];
    [tag_text_btn addTarget:self action:@selector(didSelectRoleTagBtn) forControlEvents:UIControlEventTouchUpInside];
    tag_text_btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    
    return tag_text_btn;
}

- (void)didSelectRoleTagBtn {
    [_delegate didStartInputTags];
}

- (UIView*)inputLineWithImage:(UIImage*)img andPlaceHolder:(NSString*)place_holder andInjectView:(UIView*)inject_view inRect:(CGRect)rc isNeedUnderLine:(BOOL)bUnderLine {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.6;
    CGFloat height = MARGIN + IMG_HEIGHT;
    UIView* container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
   
    if (img) {
        UIImageView* img_view = [[UIImageView alloc]initWithImage:img];
        img_view.frame = CGRectMake(MARGIN, MARGIN, IMG_WIDTH - 2, IMG_HEIGHT - 2);
        img_view.backgroundColor = [UIColor clearColor];
        [container addSubview:img_view];
    }
   
    inject_view.frame = CGRectMake(MARGIN + IMG_WIDTH + MARGIN, MARGIN, width - MARGIN - IMG_WIDTH - MARGIN, IMG_HEIGHT);
    if ([inject_view isKindOfClass:[UITextField class]]) {
        UITextField* tf = (UITextField*)inject_view;
        tf.font = [UIFont systemFontOfSize:15.f];
        tf.borderStyle = UITextBorderStyleNone;
        tf.placeholder = place_holder;
        [tf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    } else if ([inject_view isKindOfClass:[UILabel class]]) {
        UILabel* label = (UILabel*)inject_view;
        label.font = [UIFont systemFontOfSize:15.f];
        label.text = place_holder;
        [label sizeToFit];
    }
    
    if (bUnderLine) {
        CALayer* border_layer = [CALayer layer];
//        border_layer.frame = CGRectMake(rc.origin.x + MARGIN + IMG_WIDTH + MARGIN, rc.origin.y + height - 1, width - MARGIN - IMG_WIDTH - MARGIN, 1);
        border_layer.frame = CGRectMake(rc.origin.x + MARGIN + IMG_WIDTH + MARGIN, rc.origin.y + height, width - MARGIN - IMG_WIDTH - MARGIN, 1);
        border_layer.borderWidth = 1.f;
        border_layer.borderColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:border_layer];
    }
    
    [container addSubview:inject_view];
    container.frame = rc;
    
    return container;
}

//- (void)phoneTextFieldChanged:(NSNotification*)notify {
//    
//}

- (void)didSelectTextField {
    NSLog(@"Click Text Field");
}

#pragma mark -- text delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == tag_text_field) {
        [_delegate didStartInputTags];
        return NO;
    } else if (textField == name_text_field) {
        [_delegate didStartInputName];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {              // called when 'return' key pressed. return NO to ignore.
    [_delegate didEndInputName];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- public
- (void)resetTags:(NSString*)tags {
//    tag_text_field.text = tags;
    [tag_text_btn setTitle:tags forState:UIControlStateNormal];
}

- (NSString*)getInputName {
    return name_text_field.text;
}
- (NSString*)getInputTags {
    return tag_text_field.text;
}

- (void)endInputName {
    [name_text_field resignFirstResponder];
}
@end
