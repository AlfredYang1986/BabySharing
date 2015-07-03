//
//  MessageViewCell.m
//  BabySharing
//
//  Created by Alfred Yang on 3/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "MessageViewCell.h"
#import "INTUAnimationEngine.h"

@interface MessageViewCell ()
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation MessageViewCell {
    BOOL isEditing;
    
    CGPoint point;
}

@synthesize deleteBtn = _deleteBtn;
@synthesize cancelBtn = _cancelBtn;
@synthesize imageView = _imageView;
@synthesize currentIndex = _currentIndex;

+ (CGFloat)getPreferredHeight {
    return 66;
}

- (void)awakeFromNib {
    // Initialization code
    CGRect rc = [self startRect];
    _deleteBtn = [[UIButton alloc]initWithFrame:rc];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.hidden = YES;
    _deleteBtn.backgroundColor = [UIColor redColor];
    [self addSubview:_deleteBtn];
    [_deleteBtn addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchDown];
    
    _cancelBtn = [[UIButton alloc]initWithFrame:rc];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.hidden = YES;
    _cancelBtn.backgroundColor = [UIColor grayColor];
    [self addSubview:_cancelBtn];
    [_cancelBtn addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchDown];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"User"] ofType:@"png"];
    _imgView.image = [UIImage imageNamed:filePath];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
    
    isEditing = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- handle pan
- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    NSLog(@"pan gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        point = [gesture translationInView:self];
            
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint newPos = [gesture translationInView:self];
        
        if (newPos.x - point.x > 50) {
            if (isEditing) {
                NSLog(@"right gesture");
                [self hiddenButtons];
            }
        } else if (newPos.x - point.x < 50) {
            if (!isEditing) {
                NSLog(@"left gesture");
                [self showButtons];
            }
        }
    }
}

- (CGRect)cancelBtnRect {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [MessageViewCell getPreferredHeight];
    return CGRectMake(width - height, 0, height, height);
}

- (CGRect)delectBtnRect {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [MessageViewCell getPreferredHeight];
    return CGRectMake(width - 2 * height, 0, height, height);
}

- (CGRect)startRect {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [MessageViewCell getPreferredHeight];
    return CGRectMake(width, 0, 0, height);
}

- (void)showButtons {
    _cancelBtn.hidden = NO;
    _deleteBtn.hidden = NO;
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGRect cancelRc = [self cancelBtnRect];
    CGRect deleteRc = [self delectBtnRect];
    CGRect rc = [self startRect];
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      _deleteBtn.frame = INTUInterpolateCGRect(rc, deleteRc, progress);
                                      _cancelBtn.frame = INTUInterpolateCGRect(rc, cancelRc, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

- (void)hiddenButtons {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGRect cancelRc = [self cancelBtnRect];
    CGRect deleteRc = [self delectBtnRect];
    CGRect rc = [self startRect];
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      _deleteBtn.frame = INTUInterpolateCGRect(deleteRc, rc, progress);
                                      _cancelBtn.frame = INTUInterpolateCGRect(cancelRc, rc, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                      _cancelBtn.hidden = YES;
                                      _deleteBtn.hidden = YES;
                                  }];
}

- (void)didSelectButton:(UIButton*)btn {
    if (btn == _deleteBtn) {
        NSLog(@"delete button selected");
    } else if (btn == _cancelBtn) {
        NSLog(@"cancel button selected");
        [self hiddenButtons];
    }
}
@end
