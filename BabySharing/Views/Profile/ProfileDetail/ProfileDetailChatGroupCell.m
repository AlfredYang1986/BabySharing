//
//  ProfileDetailChatGroupCell.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 19/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "ProfileDetailChatGroupCell.h"

@interface ProfileDetailChatGroupCell ()
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@end

@implementation ProfileDetailChatGroupCell

@synthesize numLabel = _numLabel;
@synthesize queryView = _queryView;

- (void)awakeFromNib {
    // Initialization code
    _queryView.scrollEnabled = NO;
    _queryView.dataSource = self;
    _queryView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getPerferHeight {
    return MAX(44 * 2 + 8 + 8, 62);
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    cell.imageView.image = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Chat"] ofType:@"png"]];
    cell.textLabel.text = @"Group Name";
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
@end
