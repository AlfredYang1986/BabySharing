//
//  DongDaSearchBar2.m
//  BabySharing
//
//  Created by Alfred Yang on 1/21/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "DongDaSearchBar2.h"

@implementation DongDaSearchBar2 {
    CGSize sz;
}

@synthesize textField = _textField;
@synthesize cancleBtn = _cancleBtn;
@synthesize sb_bg = _sb_bg;

- (void)setSearchBarBackgroundColor:(UIColor *)sb_bg {
    if ([self viewWithTag:-1] == nil) {
        UIImageView* iv = [[UIImageView alloc] initWithImage:[DongDaSearchBar2 imageWithColor:[UIColor colorWithWhite:0.1098 alpha:1.f] size:CGSizeMake(self.bounds.size.width, self.bounds.size.height)]];
        iv.tag = -1;
        [self insertSubview:iv atIndex:1];
    } else {
        UIImageView* iv = [self viewWithTag:-1];
        iv.image = [DongDaSearchBar2 imageWithColor:sb_bg size:self.bounds.size];
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1.f);
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UITextField*)getTextFiled {
    
    if (_textField == nil) {
        for (UIView* v in self.subviews.firstObject.subviews) {
            if ( [v isKindOfClass: [UITextField class]] ) {
                _textField = (UITextField*)v;
                break;
            }
        }
    }
    
    return _textField;
}

- (UIButton*)getCancelBtn {
    if (_cancleBtn == nil) {
        for (UIView* v in self.subviews.firstObject.subviews) {
            if ( [v isKindOfClass: [UIButton class]] ) {
                _cancleBtn = (UIButton*)v;
                break;
            }
        }
    }
    
    return _cancleBtn;
}

- (void)setPostLayoutSize:(CGSize)cancel_btn_sz {
    sz = cancel_btn_sz;
}

- (void)layoutSubviews {
    [super layoutSubviews];
   
#define CONTENT_MARGIN                  10.5
#define TEXTFIELD_BTN_MARGIN_BETWEEN    13.5
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
   
    CGFloat ver_margin = (height - sz.height) / 2;
    CGFloat textfield_width = width - CONTENT_MARGIN * 2 - TEXTFIELD_BTN_MARGIN_BETWEEN - sz.width;

    self.textField.frame = CGRectMake(CONTENT_MARGIN, ver_margin, textfield_width, sz.height);
    self.cancleBtn.frame = CGRectMake(CONTENT_MARGIN + textfield_width + TEXTFIELD_BTN_MARGIN_BETWEEN, ver_margin, sz.width, sz.height);
}
@end
