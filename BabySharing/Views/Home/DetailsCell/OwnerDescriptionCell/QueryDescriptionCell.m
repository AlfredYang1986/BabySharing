//
//  QueryDescriptionCellTableViewCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 5/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "QueryDescriptionCell.h"

#define MARGIN 8

@interface QueryDescriptionCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabelView;

@end

@implementation QueryDescriptionCell {
    UITextView* descriptionView;
}

@synthesize timeLabel = _timeLabel;
@synthesize tagsLabelView = _tagsLabelView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)preferHeightWithUserDescription:(NSString*)description {
    if ([description isEqualToString:@""]) {
        return 75;
    }
    
    return 75 + 2 * MARGIN + [self getSizeBaseOnDescription:description].height;
}

+ (CGSize)getSizeBaseOnDescription:(NSString*)description {
    UIFont* font = [UIFont systemFontOfSize:14.f];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    return [description sizeWithFont:font constrainedToSize:CGSizeMake(width - MARGIN * 2, FLT_MAX)];
}

#pragma mark -- set values
- (void)setTime:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.formatterBehavior = NSDateFormatterBehavior10_4;
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *result = [formatter stringForObjectValue:date];
    _timeLabel.text = result;
}

- (void)setTags:(NSString*)tags {
    _tagsLabelView.text = tags;
}

- (void)setDescription:(NSString*)description {
    if (descriptionView == nil) {
        descriptionView = [[UITextView alloc]init];
        [self addSubview:descriptionView];
        descriptionView.scrollEnabled = NO;
        descriptionView.editable = NO;
    }
    
    CGSize size = [QueryDescriptionCell getSizeBaseOnDescription:description];
    descriptionView.frame = CGRectMake(MARGIN, MARGIN, [UIScreen mainScreen].bounds.size.width - MARGIN * 2, size.height);
    descriptionView.text = description;
    [descriptionView sizeToFit];
}
@end
