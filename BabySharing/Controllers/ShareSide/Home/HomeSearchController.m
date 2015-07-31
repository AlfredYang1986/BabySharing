//
//  HomeSearchController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 1/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "HomeSearchController.h"
#import "INTUAnimationEngine.h"

@interface HomeSearchController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@end

@implementation HomeSearchController

@synthesize searchBar = _searchBar;
@synthesize segmentControl = _segmentControl;
@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    for (UIView* v in _searchBar.subviews)
    {
        if ( [v isKindOfClass: [UITextField class]] )
        {
            UITextField *tf = (UITextField *)v;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            break;
        }
    }
    
    _queryView.delegate = self;
    _queryView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didSelectCancelBtn {
//    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- ui text field delegate

- (void)moveView:(float)move
{
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGRect frame = self.view.frame;
    //    CGRect frameNew = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + move);
    CGRect frameNew = CGRectMake(0, 0, frame.size.width, frame.size.height + move);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      self.view.frame = INTUInterpolateCGRect(frame, frameNew, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

#pragma mark -- table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = @"alfred ...";
    
    return cell;
}


#pragma mark -- table view delegate

#pragma mark -- search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Start search");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
