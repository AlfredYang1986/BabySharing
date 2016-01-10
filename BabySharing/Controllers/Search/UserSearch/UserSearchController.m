//
//  UserSearchController.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "UserSearchController.h"
#import "UserSearchCell.h"
#import "UserSearchModel.h"

@interface UserSearchController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *queryView;
@end

@implementation UserSearchController

@synthesize um = _um;
@synthesize user_search_type = _user_search_type;

@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [_queryView registerNib:[UINib nibWithNibName:@"UserSearchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"user search cell"];
    [_queryView registerClass:[UserSearchCell class] forCellReuseIdentifier:@"user search cell"];
    
    _queryView.delegate = self;
    _queryView.dataSource = self;
    _queryView.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    UILabel* label = [[UILabel alloc]init];
    label.text = @"认识更多的朋友";
    label.textColor = [UIColor colorWithWhite:0.5059 alpha:1.f];
    label.font = [UIFont systemFontOfSize:16.f];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(-12, 0, 25, 25);
    //    layer.position = CGPointMake(barBtn.frame.size.width / 2, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
    [barBtn addTarget:self action:@selector(didPopViewControllerBtn) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    
    [self asyncQueryData];
}

- (void)didPopViewControllerBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)asyncQueryData {
    dispatch_queue_t ap = dispatch_queue_create("user query queue", nil);
    dispatch_async(ap, ^{
        [_um queryUserSearchWithFinishBlock:^(BOOL success, NSArray *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_queryView reloadData];
            });
        }];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _um.userSearchResult.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSearchCell* cell = [tableView dequeueReusableCellWithIdentifier:@"user search cell"];
    
    if (cell == nil) {
//        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UserSearchCell" owner:self options:nil];
//        cell = [nib firstObject];
        cell = [[UserSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"user search cell"];
    }
  
    NSDictionary* dic = [_um.userSearchResult objectAtIndex:indexPath.row];
   
    [cell setUserHeaderWithScreenName:[dic objectForKey:@"screen_name"] roleTag:[dic objectForKey:@"role_tag"] andScreenPhoto:[dic objectForKey:@"screen_photo"]];
    [cell setUserContentImages:[dic objectForKey:@"preview"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UserSearchCell preferredHeight];
}
@end
