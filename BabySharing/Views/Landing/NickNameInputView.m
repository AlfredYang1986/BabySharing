//
//  NickNameInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 17/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "NickNameInputView.h"
#import "OBShapedButton.h"
#import "Tools.h"
#import "LoginModel.h"

#define IMG_WIDTH       30
#define IMG_HEIGHT      30

#define MARGIN          8

#define BASICMARGIN                         8

#define SNS_TOP_MARGIN                      130

#define AREA_CODE_WIDTH                     66
#define INPUT_TEXT_FIELD_HEIGHT             45.5
#define INPUT_MARGIN                        10.5 //32.5

#define TEXT_FIELD_LEFT_PADDING             10
#define LINE_MARGIN                         5
#define CODE_BTN_WIDTH                      80

#define LOGIN_BTN_TOP_MARGIN                66
#define LOGIN_BTN_HEIGHT                    37
#define LOGIN_BTN_BOTTOM_MARGIN             40

@implementation NickNameInputView {
    UITextField* name_text_field;
    UITextField* tag_text_field;
   
//    UIButton* tag_text_btn;
    
    BOOL isSNSLogin;
    
    UIButton* clear_btn;
}

@synthesize delegate = _delegate;

//- (id)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setUpWithFrame:frame];
//    }
//    return self;
//}

- (void)createLabelInRect:(CGRect)rect andTitle:(NSString*)title andTopMargin:(CGFloat)top {
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    
    UIFont* font = [UIFont systemFontOfSize:14.f];
    
//    UIButton* tmp = [[UIButton alloc]initWithFrame:CGRectMake(INPUT_MARGIN, BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN, AREA_CODE_WIDTH, INPUT_TEXT_FIELD_HEIGHT)];
    UIButton* tmp = [[UIButton alloc]initWithFrame:CGRectMake(INPUT_MARGIN, top, AREA_CODE_WIDTH, INPUT_TEXT_FIELD_HEIGHT)];
    
    [tmp setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_input_left" ofType:@"png"]] forState:UIControlStateNormal];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = title;
    label.font = font;
    label.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    [label sizeToFit];
    label.center = CGPointMake(AREA_CODE_WIDTH / 2, INPUT_TEXT_FIELD_HEIGHT / 2);
    label.tag = -1;
    [tmp addSubview:label];
    
    [self addSubview:tmp];
}

- (void)createColorfulLabelInRect:(CGRect)rect andTopMargin:(CGFloat)top {
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    
    UIFont* font = [UIFont systemFontOfSize:14.f];
    CGFloat width = rect.size.width;
    CGFloat first_line_start_margin = INPUT_MARGIN;
    first_line_start_margin = INPUT_MARGIN + AREA_CODE_WIDTH;
    
    //    UIButton* tmp = [[UIButton alloc]initWithFrame:CGRectMake(INPUT_MARGIN, BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN, AREA_CODE_WIDTH, INPUT_TEXT_FIELD_HEIGHT)];
    UIButton* tmp = [[UIButton alloc]initWithFrame:CGRectMake(first_line_start_margin, top, width - AREA_CODE_WIDTH - 2 * INPUT_MARGIN, INPUT_TEXT_FIELD_HEIGHT)];
    
    [tmp setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_input_right" ofType:@"png"]] forState:UIControlStateNormal];
   
#define GENDER_ICON_WIDTH       18
#define GENDER_ICON_HEIGHT      GENDER_ICON_WIDTH
    
    UILabel* label0 = [[UILabel alloc]init];
    NSMutableAttributedString* str0 = [[NSMutableAttributedString alloc]initWithString:@"妈咪"];
    [str0 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.f green:0.4745 blue:0.4863 alpha:1.f] range:NSMakeRange(0, str0.length)];
    label0.attributedText = str0;
    label0.font = font;
//    label.textColor = [UIColor whiteColor];
    [label0 sizeToFit];
    label0.center = CGPointMake(TEXT_FIELD_LEFT_PADDING + GENDER_ICON_WIDTH + label0.frame.size.width / 2, INPUT_TEXT_FIELD_HEIGHT / 2);
    label0.tag = -1;
    [tmp addSubview:label0];
    
    UIImage* female = [UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_female" ofType:@"png"]];
    CALayer* layer0 = [CALayer layer];
    layer0.contents = (id)female.CGImage;
    layer0.frame = CGRectMake(TEXT_FIELD_LEFT_PADDING, (INPUT_TEXT_FIELD_HEIGHT - GENDER_ICON_HEIGHT) / 2, GENDER_ICON_WIDTH, GENDER_ICON_HEIGHT);
    [tmp.layer addSublayer:layer0];

    UILabel* label1 = [[UILabel alloc]init];
    NSMutableAttributedString* str1 = [[NSMutableAttributedString alloc]initWithString:@"爸比暂不开放"];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.6078 alpha:1.f] range:NSMakeRange(0, str1.length)];
    label1.attributedText = str1;
    label1.font = font;
//    label.textColor = [UIColor whiteColor];
    [label1 sizeToFit];
    label1.center = CGPointMake(TEXT_FIELD_LEFT_PADDING + GENDER_ICON_WIDTH + label1.frame.size.width / 2 + 42 + label0.frame.size.width + GENDER_ICON_WIDTH, INPUT_TEXT_FIELD_HEIGHT / 2);
    label1.tag = -1;
    [tmp addSubview:label1];

    UIImage* male = [UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_male" ofType:@"png"]];
    CALayer* layer1 = [CALayer layer];
    layer1.contents = (id)male.CGImage;
    layer1.frame = CGRectMake(TEXT_FIELD_LEFT_PADDING + GENDER_ICON_WIDTH + 42 + layer0.frame.size.width, (INPUT_TEXT_FIELD_HEIGHT - GENDER_ICON_HEIGHT) / 2, GENDER_ICON_WIDTH, GENDER_ICON_HEIGHT);
    [tmp.layer addSublayer:layer1];

    [self addSubview:tmp];
}

- (UITextField *)createInputAreaInRect:(CGRect)rect andTopMargin:(CGFloat)top andPlaceholder:(NSString*)placeholder andPreString:(NSString*)defaultString andRightImage:(UIImage*)img andCallback:(SEL)cb andCancelBtn:(BOOL)bCancel {
    CGFloat width = rect.size.width;
    CGFloat first_line_start_margin = INPUT_MARGIN;
    first_line_start_margin = INPUT_MARGIN + AREA_CODE_WIDTH;
    
    UIFont *font = [UIFont systemFontOfSize:14.f];
    NSString *bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    
    UITextField *phone_area = [[UITextField alloc]initWithFrame:CGRectMake(first_line_start_margin, top, width - AREA_CODE_WIDTH - 2 * INPUT_MARGIN, INPUT_TEXT_FIELD_HEIGHT)];
    [phone_area setBackground:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_input_right" ofType:@"png"]]];
    phone_area.font = font;
    
    CGRect frame = phone_area.frame;
    frame.size.width = TEXT_FIELD_LEFT_PADDING;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    phone_area.leftViewMode = UITextFieldViewModeAlways;
    phone_area.leftView = leftview;
    phone_area.text = defaultString;
    
    phone_area.placeholder = placeholder;
    [phone_area setValue:[UIColor colorWithWhite:0.6078 alpha:0.50] forKeyPath:@"_placeholderLabel.textColor"];
    phone_area.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    phone_area.delegate = self;
    phone_area.clearButtonMode = UITextFieldViewModeWhileEditing;
   
    if (bCancel) {
        clear_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, phone_area.frame.size.height)];
        clear_btn.center = CGPointMake(phone_area.frame.size.width - 25 / 2, phone_area.frame.size.height / 2);
        [phone_area addSubview:clear_btn];
        
        CALayer* layer = [CALayer layer];
        layer.contents = (id)[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_input_clear_btn" ofType:@"png"]].CGImage;
        layer.frame = CGRectMake(0, 0, 12, 12);
        layer.position = CGPointMake(10, phone_area.frame.size.height / 2 - 1);
        [clear_btn.layer addSublayer:layer];
        
        clear_btn.hidden = YES;
    }
    
#define TEXT_FIELD_RIGHT_PADDING        25
#define DONGDA_NEXT_ICON_WIDTH          12
    if (img) {
        CGRect frame = phone_area.frame;
        frame.size.width = TEXT_FIELD_RIGHT_PADDING;
        UIView *rightview = [[UIView alloc] initWithFrame:frame];
        CALayer* layer = [CALayer layer];
        layer.contents = (id)img.CGImage;
        layer.frame = CGRectMake(0, (INPUT_TEXT_FIELD_HEIGHT - DONGDA_NEXT_ICON_WIDTH) / 2, DONGDA_NEXT_ICON_WIDTH, DONGDA_NEXT_ICON_WIDTH);
        [rightview.layer addSublayer:layer];
        
        phone_area.rightViewMode = UITextFieldViewModeAlways;
        phone_area.rightView = rightview;
    }
    
    [self addSubview:phone_area];
    return phone_area;
}

- (void)createNextBtnInRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    
    UIButton* next_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(INPUT_MARGIN, BASICMARGIN + 2 * (INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN) + INPUT_TEXT_FIELD_HEIGHT + LOGIN_BTN_TOP_MARGIN, width - 2 * INPUT_MARGIN, LOGIN_BTN_HEIGHT)];
    [next_btn addTarget:_delegate action:@selector(didClickNextBtn) forControlEvents:UIControlEventTouchDown];
    next_btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [next_btn setTitle:@"进入咚哒" forState:UIControlStateNormal];
    [next_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    next_btn.clipsToBounds = YES;
    [next_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"login_btn_bg" ofType:@"png"]] forState:UIControlStateNormal];
    [next_btn addTarget:_delegate action:@selector(didClickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:next_btn];
}

- (void)setUpWithFrame:(CGRect)rect {
    CGFloat width = rect.size.width;
    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    
    [self createLabelInRect:rect andTitle:@"昵称" andTopMargin:BASICMARGIN];
    name_text_field = [self createInputAreaInRect:rect andTopMargin:BASICMARGIN andPlaceholder:@"4-18个字节，限中英文，数字，表情符号" andPreString:[_delegate getPreScreenName] andRightImage:nil andCallback:@selector(textFieldChanged:) andCancelBtn:YES];
    name_text_field.font = [UIFont systemFontOfSize:12];
    name_text_field.delegate = self;
    
    [self createLabelInRect:rect andTitle:@"性别" andTopMargin:BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN];
    [self createColorfulLabelInRect:rect andTopMargin:BASICMARGIN + INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN];
    
    [self createLabelInRect:rect andTitle:@"角色" andTopMargin:BASICMARGIN + 2 * (INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN)];
    tag_text_field = [self createInputAreaInRect:rect andTopMargin:BASICMARGIN + 2 * (INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN) andPlaceholder:@"填写你的角色标签" andPreString:[_delegate getPreRoleTag] andRightImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"dongda_next" ofType:@"png"]] andCallback:@selector(textFieldChanged:) andCancelBtn:NO];
    [self createNextBtnInRect:rect];

    CGFloat height = BASICMARGIN + 2 * (INPUT_TEXT_FIELD_HEIGHT + LINE_MARGIN) + INPUT_TEXT_FIELD_HEIGHT + LOGIN_BTN_TOP_MARGIN + LOGIN_BTN_HEIGHT + BASICMARGIN;
    self.bounds = CGRectMake(0, 0, width, height);
}

- (void)didSelectRoleTagBtn {
    [_delegate didEditRoleTag];
}

- (void)textFieldChanged:(NSNotification*)notify {
    UITextField* tf = notify.object;
    if (![tf.text isEqualToString:@""]) {
        clear_btn.hidden = NO;
    } else {
        clear_btn.hidden = YES;
    }
}

#pragma mark -- text delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == tag_text_field) {
        [_delegate didEditRoleTag];
        return NO;
    } else if (textField == name_text_field) {
        [_delegate didStartEditingScreenName];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {              // called when 'return' key pressed. return NO to ignore.
    [_delegate didEndEditingScreenName];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([Tools bityWithStr:textField.text] >= 14) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark -- public
- (void)setScreenName:(NSString*)name {
    name_text_field.text = name;
}
- (NSString*)getScreenName {
    return name_text_field.text;
}

- (void)setRoleTag:(NSString*)rt {
    tag_text_field.text = rt;
}
- (NSString*)getRoleTag {
    return tag_text_field.text;
}

- (void)endInputName {
    [name_text_field resignFirstResponder];
    [_delegate didEndEditingScreenName];
}
@end
