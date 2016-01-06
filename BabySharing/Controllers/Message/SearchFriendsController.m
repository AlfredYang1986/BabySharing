//
//  SearchFriendsController.m
//  BabySharing
//
//  Created by Alfred Yang on 1/6/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "SearchFriendsController.h"
#import "MessageFriendsCell.h"

@interface SearchFriendsController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@end

@implementation SearchFriendsController {
    NSArray* arr_section_title;
}

@synthesize searchBar = _searchBar;
@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _searchBar.showsCancelButton = YES;
    _searchBar.placeholder = @"搜索好友";
    _searchBar.backgroundColor = [UIColor clearColor];
    UIImageView* iv = [[UIImageView alloc] initWithImage:[self imageWithColor:[UIColor whiteColor] size:_searchBar.bounds.size]];
    [_searchBar insertSubview:iv atIndex:1];
//    [_searchBar setSearchFieldBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:_searchBar.bounds.size] forState:UIControlStateNormal];
    for (UIView* v in _searchBar.subviews.firstObject.subviews) {
        if ( [v isKindOfClass: [UITextField class]] ) {
            UITextField *tf = (UITextField *)v;
            tf.backgroundColor = [UIColor lightGrayColor];
            tf.borderStyle = UITextBorderStyleRoundedRect;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        } else if ([v isKindOfClass:[UIButton class]]) {
            UIButton* cancel_btn = (UIButton*)v;
//            [cancel_btn setTitle:@"test" forState:UIControlStateNormal];
            [cancel_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [cancel_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        }
//        else if ([v isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//            v.backgroundColor = [UIColor whiteColor];
//        }
    }
    
    _searchBar.delegate = self;
    
    _queryView.delegate = self;
    _queryView.dataSource = self;
    [_queryView registerNib:[UINib nibWithNibName:@"MessageFriendsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"friend cell"];
    
    arr_section_title = @[@"好友", @"可能认识的人", @"相关用户"];
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- search bat delegate 
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- table view 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    UIView* reVal = [[UIView alloc]init];
    reVal.backgroundColor = [UIColor lightGrayColor];
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
#define HEARDER_OFFSET      5
#define LEFT_MARGIN         10.5
#define TOP_MARGIN          14
    UIView* content = [[UIView alloc]initWithFrame:CGRectMake(0, HEARDER_OFFSET, width, 44 - HEARDER_OFFSET)];
    content.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_MARGIN, TOP_MARGIN, 1, 1)];
    label.text = [arr_section_title objectAtIndex:section];
    label.textColor = [UIColor colorWithRed:0.847 green:0.847 blue:0.847 alpha:1.f];
    label.font = [UIFont systemFontOfSize:14.f];
    [label sizeToFit];
    [content addSubview:label];
    
    [reVal addSubview:content];
   
    return reVal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MessageFriendsCell preferredHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"friend cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageFriendsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    NSDictionary* tmp = [data_arr objectAtIndex:indexPath.row];
    [cell setUserScreenPhoto:@""];
    [cell setRelationship:2];
    [cell setUserScreenName:@"user name"];
    [cell setUserRoleTag:@"role tag"];
    
    return cell;
}
@end
