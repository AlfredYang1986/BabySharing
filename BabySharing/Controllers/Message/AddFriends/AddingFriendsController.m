//
//  AddingFriendsController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AddingFriendsController.h"
#import "AddressBookDelegate.h"

@interface AddingFriendsController ()
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;

@end

@implementation AddingFriendsController {
    AddressBookDelegate* ab;
}

@synthesize queryView = _queryView;
@synthesize searchBar = _searchBar;
@synthesize seg = _seg;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _seg.selectedSegmentIndex = 0;
    [_seg addTarget:self action:@selector(segValueChanged) forControlEvents:UIControlEventValueChanged];
    
    ab = [[AddressBookDelegate alloc]init];
    if ([ab isAddressDelegateReady]) {
        _queryView.delegate = ab;
        _queryView.dataSource = ab;
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

- (void)segValueChanged {
    
}
@end
