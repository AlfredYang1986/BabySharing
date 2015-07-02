//
//  SecretViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 24/04/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "SecretViewController.h"


@interface SecretViewController ()
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@end

@implementation SecretViewController

@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(dismissSecretController:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Setting" style:UIBarButtonItemStyleDone target:self action:@selector(didSelectSettingBtn:)];
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

#pragma mark -- table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger total = [self tableView:tableView numberOfRowsInSection:indexPath.section];
//    if (indexPath.row == 0 || indexPath.row == total - 1) return 44;
//    else return [QueryCell preferredHeight];
//}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
        
    cell.textLabel.text = @"athena";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

#pragma mark -- scroll refresh

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 假设偏移表格高度的20%进行刷新
//    if (!_isLoading) { // 判断是否处于刷新状态，刷新中就不执行
        // 取内容的高度：
        // 如果内容高度大于UITableView高度，就取TableView高度
        // 如果内容高度小于UITableView高度，就取内容的实际高度
        float height = scrollView.contentSize.height > _queryView.frame.size.height ?_queryView.frame.size.height : scrollView.contentSize.height;
        if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2) { // 调用上拉刷新方

        }
        
        if (- scrollView.contentOffset.y / _queryView.frame.size.height > 0.2) { // 调用下拉刷新方法

        }
//    } 
}

#pragma mark -- buttons
- (void)dismissSecretController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectSettingBtn:(id)sender {
    [self performSegueWithIdentifier:@"SecretSetting" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
@end
