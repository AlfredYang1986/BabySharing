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
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSInteger count = [self tableView:items numberOfRowsInSection:0];
    items.bounds = CGRectMake(0, 0, width, 44 * count);
    
    [_delegate showContentsTableView:items];
}

- (void)setMessageHandler {
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    drop_down_layer = [CALayer layer];
    drop_down_layer.contents = (id)[UIImage imageNamed:[resourceBundle pathForResource:@"post_drop_down" ofType:@"png"]].CGImage;
    drop_down_layer.frame = CGRectMake(0, 0, DROP_DOWN_WIDTH, DROP_DOWN_HEIGHT);
    [self.layer addSublayer:drop_down_layer];
    
    [self addTarget:self action:@selector(clickHandler:) forControlEvents:UIControlEventTouchDown];
    
    items = [[UITableView alloc]init];
    items.delegate = self;
    items.dataSource = self;
    items.scrollEnabled = NO;
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
    UILabel* label = self.titleLabel;
    CGPoint ct = label.center;
    label.center = CGPointMake(ct.x - DROP_DOWN_WIDTH / 2 - DROP_DOWN_ICON_MARGIN, ct.y - 2);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (layer == self.layer) {
        CGRect bounds = self.bounds;
        drop_down_layer.frame = CGRectMake(0, 0, DROP_DOWN_WIDTH, DROP_DOWN_HEIGHT);
        drop_down_layer.position = CGPointMake(bounds.size.width - DROP_DOWN_ICON_MARGIN - DROP_DOWN_WIDTH / 2, bounds.size.height / 2);
    }
}

#pragma mark -- table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [self setTitle:[_datasource titleForCellAtRow:indexPath.row inTableView:tableView] forState:UIControlStateNormal];
    [_delegate didSelectCell:[tableView cellForRowAtIndexPath:indexPath]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark -- table view datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [_datasource cellForRow:indexPath.row inTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datasource itemCount];
}

- (void)removeTableView {
    [items removeFromSuperview];
}
@end
