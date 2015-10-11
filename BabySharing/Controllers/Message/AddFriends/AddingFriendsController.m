//
//  AddingFriendsController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AddingFriendsController.h"
#import "AddressBookDelegate.h"
#import "AddingFriendsProtocol.h"
#import "WeiboFriendsDelegate.h"

#import "DongDaSearchBar.h"
#import "SearchSegView.h"

@interface AddingFriendsController () <UISearchBarDelegate, AsyncDelegateProtocol, SearchSegViewDelegate, DongDaSearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet DongDaSearchBar* searchBar;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (weak, nonatomic) IBOutlet SearchSegView *seg;

@property (weak, nonatomic, setter=setCurrentDelegate:) id<UITableViewDataSource, UITableViewDelegate, AddingFriendsProtocol> current_delegate;
@end

@implementation AddingFriendsController {
    AddressBookDelegate* ab;
    WeiboFriendsDelegate* wb;
}

@synthesize queryView = _queryView;
@synthesize searchBar = _searchBar;
@synthesize seg = _seg;

@synthesize current_delegate = _current_delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_seg addItemWithTitle:@"通讯录" andImg:nil andSelectedImg:nil];
    [_seg addItemWithTitle:@"微博" andImg:nil andSelectedImg:nil];
    [_seg addItemWithTitle:@"微信" andImg:nil andSelectedImg:nil];
    [_seg addItemWithTitle:@"QQ" andImg:nil andSelectedImg:nil];
    
//    _seg.selectedIndex = 0;
//    [_seg addTarget:self action:@selector(segValueChanged) forControlEvents:UIControlEventValueChanged];
    
    _searchBar.delegate = self;
    
    ab = [[AddressBookDelegate alloc]init];
//    if ([ab isDelegateReady]) {
        self.current_delegate = ab;
//    }
    
    wb = [[WeiboFriendsDelegate alloc]init];
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

- (void)setCurrentDelegate:(id<UITableViewDataSource,UITableViewDelegate,AddingFriendsProtocol>)current_delegate {
    _current_delegate = current_delegate;
    _queryView.delegate = _current_delegate;
    _queryView.dataSource = _current_delegate;
}

- (void)asyncDelegateIsReady:(id<UITableViewDataSource, UITableViewDelegate, AddingFriendsProtocol>)delegate {
    if (_current_delegate == delegate) {
        [_queryView reloadData];
    }
}

#pragma mark -- segement controll
- (void)segValueChanged {
//    if (_seg.selectedSegmentIndex == 0) {
    if (_seg.selectedIndex == 0) {
//        if ([ab isDelegateReady]) {
            self.current_delegate = ab;
            [_queryView reloadData];
//        }
    } else if (_seg.selectedIndex == 1) {
        self.current_delegate = wb;
    } else {
        self.current_delegate = nil;
    }

    if ([self.current_delegate isDelegateReady]) {
        [_queryView reloadData];
    }
}

#pragma mark -- search bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_current_delegate filterFriendsWithString:searchText];
    [_queryView reloadData];
}

#pragma mark -- seg delegate
- (void)segValueChanged:(SearchSegView*)seg {
    [self segValueChanged];
}

- (void)cancelBtnSelected {
    
}

- (void)searchTextChanged:(NSString*)searchText {
    
}
@end
