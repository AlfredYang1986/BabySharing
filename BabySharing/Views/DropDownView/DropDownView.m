//
//  DropDownView.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 4/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "DropDownView.h"
#import "DropDownItem.h"

#define DROP_DOWN_WIDTH         20
#define DROP_DOWN_HEIGHT        20
#define DROP_DOWN_ICON_MARGIN   5

@implementation DropDownView {
    CALayer* drop_down_layer;
    BOOL isDroped;
}

@synthesize datasource = _datasource;
@synthesize delegate = _delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)clickHandler:(id)sender {
    NSLog(@"show list");
    if (!isDroped) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        NSInteger count = [self tableView:items numberOfRowsInSection:0];
        items.bounds = CGRectMake(0, 0, width, 80 * count);
        
        [_delegate showContentsTableView:items];
        isDroped = !isDroped;
    } else {
        [self dismissListFromSuper];
    }
}

- (void)dismissListFromSuper {

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        items.frame = CGRectMake(0, 64 - items.frame.size.height, items.frame.size.width, items.frame.size.height);
    } completion:^(BOOL finished) {
        [items removeFromSuperview];
    }];
    isDroped = NO;
}

- (void)setMessageHandler {
   
    isDroped = NO;
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    drop_down_layer.delegate = self;
    drop_down_layer = [CALayer layer];
    drop_down_layer.contents = (id)[UIImage imageNamed:[resourceBundle pathForResource:@"post_drop_down" ofType:@"png"]].CGImage;
    drop_down_layer.frame = CGRectMake(0, 0, DROP_DOWN_WIDTH, DROP_DOWN_HEIGHT);
    [self.layer addSublayer:drop_down_layer];
    
    
    [self addTarget:self action:@selector(clickHandler:) forControlEvents:UIControlEventTouchDown];
    items = [[UITableView alloc]init];
    items.delegate = self;
    items.dataSource = self;
    items.scrollEnabled = NO;
    items.separatorStyle = UITableViewCellSeparatorStyleNone;
    [items registerClass:[DropDownItem class] forCellReuseIdentifier:@"drop item"];
}

- (id)init {
    self = [super init];
    if (self != nil) {
        [self setMessageHandler];
    }
    return self;   
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setMessageHandler];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setMessageHandler];
    }
    return self;
}

- (void)sizeToFit {
    [super sizeToFit];
    CGRect bounds = self.bounds;
    CGPoint ct = self.center;
    self.bounds = CGRectMake(0, 0, bounds.size.width + DROP_DOWN_WIDTH + 2 * DROP_DOWN_ICON_MARGIN, bounds.size.height);
    self.center = ct;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UILabel *label = self.titleLabel;
    [label sizeToFit];
    CGRect frame = label.frame;
    CGPoint center = self.center;
    
    self.frame = CGRectMake(0, 0, frame.size.width + 30, self.frame.size.height);
    label.frame = CGRectMake(0, 0, label.frame.size.width, self.frame.size.height);
    self.layer.delegate = self;
    self.center = center;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (layer == self.layer) {
        CGRect bounds = self.bounds;
        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        drop_down_layer.frame = CGRectMake(0, 0, DROP_DOWN_WIDTH, DROP_DOWN_HEIGHT);
        drop_down_layer.position = CGPointMake(bounds.size.width - DROP_DOWN_ICON_MARGIN - DROP_DOWN_WIDTH / 2, bounds.size.height / 2);
        [CATransaction commit];
    }
}

#pragma mark -- table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [self setTitle:[_datasource titleForCellAtRow:indexPath.row inTableView:tableView] forState:UIControlStateNormal];
    [_delegate didSelectCell:[tableView cellForRowAtIndexPath:indexPath]];
    [self dismissListFromSuper];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark -- table view datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [_datasource cellForRow:indexPath.row inTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datasource itemCount];
}

- (void)removeTableView {
//    [items removeFromSuperview];
}
@end
