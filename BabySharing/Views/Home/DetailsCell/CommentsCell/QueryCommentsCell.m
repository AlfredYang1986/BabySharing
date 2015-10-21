//
//  QueryCommonsCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "QueryCommentsCell.h"
#import "QueryComments.h"
#import "TmpFileStorageModel.h"

#define MARGIN 8

@interface QueryCommentsCell ()
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *roleTagBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *dateLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation QueryCommentsCell {
    UITextView* commentView;
}

@synthesize delegate = _delegate;
@synthesize current_comments = _current_comments;

@synthesize roleTagBtn = _roleTagBtn;
@synthesize dateLabel = _dateLabel;
@synthesize nameLabel = _nameLabel;
@synthesize imgView = _imgView;

- (void)awakeFromNib {
    _imgView.layer.cornerRadius = _imgView.frame.size.width / 2;
    _imgView.clipsToBounds = YES;
    
    _roleTagBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)preferredHeightWithComment:(NSString*)comment {
    if ([comment isEqualToString:@""]) {
        return 54;
    }
    
//    return 21 + MARGIN + [self getSizeBaseOnDescription:comment].height;
    return MAX(54, 21 + MARGIN + [self getSizeBaseOnDescription:comment].height);
}

+ (CGSize)getSizeBaseOnDescription:(NSString*)comment {
    UIFont* font = [UIFont systemFontOfSize:16.f];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
//    return [comment sizeWithFont:font constrainedToSize:CGSizeMake(width - MARGIN * 2, FLT_MAX)];
    return [comment sizeWithFont:font constrainedToSize:CGSizeMake(width - MARGIN * 3 - 36, FLT_MAX)];
}

- (void)setTime:(NSDate*)date {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.formatterBehavior = NSDateFormatterBehavior10_4;
//    formatter.dateStyle = NSDateFormatterShortStyle;
//    formatter.timeStyle = NSDateFormatterShortStyle;
//    NSString *result = [formatter stringForObjectValue:date];
//    _dateLabel.text = result;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSTimeInterval now_time = [NSDate date].timeIntervalSince1970;
    if (now_time - date.timeIntervalSince1970 > 24 * 60 * 60) {
        [formatter setDateFormat:@"MM-dd"];
    } else {
        [formatter setDateFormat:@"hh:mm"];
    }
    
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:_message.date];
    _dateLabel.text = [formatter stringFromDate:date];
}

- (void)setTags:(NSString*)tags {
    [_roleTagBtn setTitle:tags forState:UIControlStateNormal];
}

- (void)setComments:(NSString *)comment {
    if (commentView == nil) {
        commentView = [[UITextView alloc]init];
        [self addSubview:commentView];
        commentView.editable = NO;
        commentView.scrollEnabled = NO;
    }
    
    CGSize size = [QueryCommentsCell getSizeBaseOnDescription:comment];
//    commentView.frame = CGRectMake(MARGIN, _imgView.frame.origin.y + _imgView.frame.size.height + MARGIN, [UIScreen mainScreen].bounds.size.width - MARGIN * 2, size.height);
    commentView.frame = CGRectMake(MARGIN + 36 + MARGIN / 2, _nameLabel.frame.origin.y + _nameLabel.frame.size.height /*+ MARGIN*/, [UIScreen mainScreen].bounds.size.width - MARGIN * 2, size.height);
    commentView.text = comment;
    commentView.font = [UIFont systemFontOfSize:16.f];
    [commentView sizeToFit];
}

- (void)setCommentOwnerName:(NSString*)name {
    _nameLabel.text = name;
}

- (void)setCommentOwnerPhoto:(NSString*)photo {
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
    
    UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    self.imgView.image = user_img;
                    NSLog(@"owner img download success");
                }
            });
        } else {
            NSLog(@"down load owner image %@ failed", photo);
        }
    }];
    
    if (userImg == nil) {
        userImg = [UIImage imageNamed:filePath];
    }
    [self.imgView setImage:userImg];
}
@end
