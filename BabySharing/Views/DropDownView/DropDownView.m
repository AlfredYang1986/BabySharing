//
//  DropDownView.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 4/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "DropDownView.h"
#import "DropDownItem.h"

@implementation DropDownView

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
