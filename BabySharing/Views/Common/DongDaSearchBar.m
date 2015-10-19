//
//  DongDaSearchBar.m
//  BabySharing
//
//  Created by Alfred Yang on 15/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "DongDaSearchBar.h"

#define DONGDASEARCHBAR_HEIGHT      44

@interface DongDaSearchBar () <UITextFieldDelegate>

@end

@implementation DongDaSearchBar {
    UIView* inputContainer;
    CALayer* icon;
    UITextField* textField;
    UIButton* clearBtn;

    UIButton* cancelBtn;
}

@synthesize delegate = _delegate;
@synthesize hide_cancel_btn = _hide_cancel_btn;

- (id)init {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self = [super initWithFrame:CGRectMake(0, 0, width, DONGDASEARCHBAR_HEIGHT)];
    if (self) {
        [self setUpSubviewsWithFrame:CGRectMake(0, 0, width, DONGDASEARCHBAR_HEIGHT)];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        [self setUpSubviewsWithFrame:CGRectMake(0, 0, width, DONGDASEARCHBAR_HEIGHT)];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubviewsWithFrame:frame];
    }
    return self;   
}

- (void)setUpSubviewsWithFrame:(CGRect)frame {
    if (inputContainer == nil) {
        inputContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        inputContainer.layer.borderColor = [UIColor grayColor].CGColor;
        inputContainer.layer.borderWidth = 1.f;
        inputContainer.layer.cornerRadius = frame.size.height / 2;
        inputContainer.clipsToBounds = YES;
        inputContainer.backgroundColor = [UIColor colorWithRed:0.1373 green:0.1216 blue:0.1255 alpha:0.3];
        
        if (icon == nil) {
            icon = [CALayer layer];
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            icon.contents = (id)[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Explore"] ofType:@"png"]].CGImage;
            [inputContainer.layer addSublayer:icon];
        }
        
        if (textField == nil) {
            textField = [[UITextField alloc]init];
            textField.layer.borderWidth = 0.f;
//            [textField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventValueChanged];
            [textField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
            [inputContainer addSubview:textField];
        }
        
        if (clearBtn == nil) {
            clearBtn = [[UIButton alloc]init];
            NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
            NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
            [clearBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Cross" ofType:@"png"]] forState:UIControlStateNormal];
            [clearBtn addTarget:self action:@selector(clearBtnSelected) forControlEvents:UIControlEventTouchUpInside];
            [inputContainer addSubview:clearBtn];
//            clearBtn.hidden = YES;
        }
        
        [self addSubview:inputContainer];
    }
    
    if (cancelBtn == nil) {
        cancelBtn = [[UIButton alloc]init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnSelected) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        _hide_cancel_btn = NO;
    }
}

- (void)setCancelBtnHidden:(BOOL)h {
    _hide_cancel_btn = h;
    [self setNeedsLayout];
}

- (void)textChanged {
    [_delegate searchTextChanged:textField.text];
}

- (void)cancelBtnSelected {
    [_delegate cancelBtnSelected];
}

- (void)clearBtnSelected {
    textField.text = @"";
}

- (void)layoutSubviews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
  
    if (_hide_cancel_btn) {
        CGSize size = CGSizeMake(80, height);
        inputContainer.frame = CGRectMake(8, 0, width - 16, height);
        
        CGFloat offset_x = 8;
        icon.frame = CGRectMake(offset_x, (height - 30) / 2, 30, 30);
      
        offset_x += 30;
        textField.frame = CGRectMake(offset_x, 0, width - size.width - 30 * 2, height);
        
        offset_x = width - 30 - 32;
        clearBtn.frame = CGRectMake(offset_x, (height - 30) / 2, 30, 30);
        
    } else {
        
        CGSize size = CGSizeMake(80, height);
        
        inputContainer.frame = CGRectMake(8, 0, width - size.width, height);
        
        CGFloat offset_x = 8;
        icon.frame = CGRectMake(offset_x, (height - 30) / 2, 30, 30);
      
        offset_x += 30;
        textField.frame = CGRectMake(offset_x, 0, width - size.width - 30 * 2, height);
        
        offset_x = width - size.width - 30 - 8;
        clearBtn.frame = CGRectMake(offset_x, (height - 30) / 2, 30, 30);
        
        offset_x = width - size.width;
        cancelBtn.frame = CGRectMake(offset_x, 0, size.width, size.height);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSString*)getSearchText {
    return textField.text;
}

- (void)setSearchText:(NSString *)text {
    textField.text = text;
}

- (void)resignFirstResponder {
    [textField resignFirstResponder];
}

+ (CGFloat)preferredHeight {
    return DONGDASEARCHBAR_HEIGHT;
}

@end
