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
    CGFloat height = (MARGIN + IMG_HEIGHT) * 4 + MARGIN;
    
    return CGSizeMake(width, height);
}

- (void)setUpViews {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage* img_0 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"]];
    UIImage* img_1 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Tag"] ofType:@"png"]];
    UIImage* img_2 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Female"] ofType:@"png"]];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.6;
    
    if (isSNSLogin) {
        tag_text_field = [[UITextField alloc]init];
        tag_text_field.delegate = self;
        [self addSubview:[self inputLineWithImage:img_1 andPlaceHolder:@"添加你的角色" andInjectView:tag_text_field inRect:CGRectMake(0, MARGIN + IMG_HEIGHT, width, MARGIN + IMG_HEIGHT) isNeedUnderLine:YES]];
    } else {
        name_text_field = [[UITextField alloc]init];
        name_text_field.delegate = self;
        
        [self addSubview:[self inputLineWithImage:img_0 andPlaceHolder:@"为你的咚哒起个名字" andInjectView:name_text_field inRect:CGRectMake(0, 0, width, MARGIN + IMG_HEIGHT) isNeedUnderLine:YES]];
        
        tag_text_field = [[UITextField alloc]init];
        tag_text_field.delegate = self;
        [self addSubview:[self inputLineWithImage:img_1 andPlaceHolder:@"添加你的角色" andInjectView:tag_text_field inRect:CGRectMake(0, MARGIN + IMG_HEIGHT, width, MARGIN + IMG_HEIGHT) isNeedUnderLine:YES]];
        [self addSubview:[self inputLineWithImage:img_2 andPlaceHolder:@"只为妈咪" andInjectView:[[UILabel alloc]init] inRect:CGRectMake(0, 2 * (MARGIN + IMG_HEIGHT), width, MARGIN + IMG_HEIGHT) isNeedUnderLine:NO]];
        [self addSubview:[self inputLineWithImage:nil andPlaceHolder:@"爸比暂时靠边站" andInjectView:[[UILabel alloc]init] inRect:CGRectMake(0, 3 * (MARGIN + IMG_HEIGHT), width, MARGIN + IMG_HEIGHT) isNeedUnderLine:NO]];
    }
}

- (UIView*)inputLineWithImage:(UIImage*)img andPlaceHolder:(NSString*)place_holder andInjectView:(UIView*)inject_view inRect:(CGRect)rc isNeedUnderLine:(BOOL)bUnderLine {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.6;
    CGFloat height = MARGIN + IMG_HEIGHT;
    UIView* container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
   
    if (img) {
        UIImageView* img_view = [[UIImageView alloc]initWithImage:img];
        img_view.frame = CGRectMake(MARGIN, MARGIN, IMG_WIDTH - 2, IMG_HEIGHT - 2);
        [container addSubview:img_view];
    }
   
    inject_view.frame = CGRectMake(MARGIN + IMG_WIDTH + MARGIN, MARGIN, width - MARGIN - IMG_WIDTH - MARGIN, IMG_HEIGHT);
    if ([inject_view isKindOfClass:[UITextField class]]) {
        UITextField* tf = (UITextField*)inject_view;
        tf.font = [UIFont systemFontOfSize:15.f];
        tf.borderStyle = UITextBorderStyleNone;
        tf.placeholder = place_holder;

    } else if ([inject_view isKindOfClass:[UILabel class]]) {
        UILabel* label = (UILabel*)inject_view;
        label.font = [UIFont systemFontOfSize:15.f];
        label.text = place_holder;
        [label sizeToFit];
    }
    
    if (bUnderLine) {
        CALayer* border_layer = [CALayer layer];
        border_layer.frame = CGRectMake(rc.origin.x + MARGIN + IMG_WIDTH + MARGIN, rc.origin.y + height - 1, width - MARGIN - IMG_WIDTH - MARGIN, 1);
        border_layer.borderWidth = 1.f;
        border_layer.backgroundColor = [UIColor blackColor].CGColor;
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
    tag_text_field.text = tags;
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
