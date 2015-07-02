//
//  WebSearchController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 19/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "WebSearchController.h"

@interface WebSearchController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebSearchController

@synthesize searchBar = _searchBar;
@synthesize webView = _webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchBar.delegate = self;
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

#pragma mark -- UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {                     // called when cancel button pressed
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
