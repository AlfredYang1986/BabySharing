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

@interface AddingFriendsController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;

@property (weak, nonatomic, setter=setCurrentDelegate:) id<UITableViewDataSource, UITableViewDelegate, AddingFriendsProtocol> current_delegate;
@end

@implementation AddingFriendsController {
    AddressBookDelegate* ab;
}

@synthesize queryView = _queryView;
@synthesize searchBar = _searchBar;
@synthesize seg = _seg;

@synthesize current_delegate = _current_delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _seg.selectedSegmentIndex = 0;
    [_seg addTarget:self action:@selector(segValueChanged) forControlEvents:UIControlEventValueChanged];
   
    _searchBar.delegate = self;
    
    ab = [[AddressBookDelegate alloc]init];
    if ([ab isAddressDelegateReady]) {
        self.current_delegate = ab;
    }
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

#pragma mark -- segement controll
- (void)segValueChanged {
    if (_seg.selectedSegmentIndex == 0) {
        if ([ab isAddressDelegateReady]) {
            self.current_delegate = ab;
            [_queryView reloadData];
        }
    } else {
        self.current_delegate = nil;
        [_queryView reloadData];
    }
}

#pragma mark -- search bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_current_delegate filterFriendsWithString:searchText];
    [_queryView reloadData];
}
@end
