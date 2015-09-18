//
//  HomeSearchController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 1/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "HomeSearchController.h"
#import "INTUAnimationEngine.h"

#import "DongDaSearchBar.h"
#import "SearchSegView.h"

@interface HomeSearchController () <DongDaSearchBarDelegate, SearchSegViewDelegate>

@end

@implementation HomeSearchController {
    DongDaSearchBar* searchBar;
    SearchSegView* seg;
    
    UIImageView* contents;// for further user
    
    NSArray* contents_BKG;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 44;
    searchBar = [[DongDaSearchBar alloc]initWithFrame:CGRectMake(0, 20, width, height)];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    CGFloat offset_y = 20 + 44 + 8;
    seg = [[SearchSegView alloc]initWithFrame:CGRectMake(0, offset_y, width, [SearchSegView preferredHeight])];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
   
    [seg addItemWithTitle:@"标签" andImg:[UIImage imageNamed:[resourceBundle pathForResource:@"TagSearchUnselected" ofType:@"png"]] andSelectedImg:[UIImage imageNamed:[resourceBundle pathForResource:@"TagSearchSelected" ofType:@"png"]]];
    [seg addItemWithTitle:@"地点" andImg:[UIImage imageNamed:[resourceBundle pathForResource:@"LocationSearchUnselected" ofType:@"png"]] andSelectedImg:[UIImage imageNamed:[resourceBundle pathForResource:@"LocationSearchSelected" ofType:@"png"]]];
    [seg addItemWithTitle:@"用户" andImg:[UIImage imageNamed:[resourceBundle pathForResource:@"UserSearchUnselected" ofType:@"png"]] andSelectedImg:[UIImage imageNamed:[resourceBundle pathForResource:@"UserSearchSelected" ofType:@"png"]]];
   
    seg.delegate = self;
    [self.view addSubview:seg];
   
    contents_BKG = @[[UIImage imageNamed:[resourceBundle pathForResource:@"SearchTagBKG" ofType:@"png"]],
                     [UIImage imageNamed:[resourceBundle pathForResource:@"SearchLocationBKG" ofType:@"png"]],
                     [UIImage imageNamed:[resourceBundle pathForResource:@"SearchUserBKG" ofType:@"png"]]];
    
    offset_y += [SearchSegView preferredHeight];
    contents = [[UIImageView alloc]initWithFrame:CGRectMake(0, offset_y, width, [UIScreen mainScreen].bounds.size.height - offset_y)];
    contents.contentMode = UIViewContentModeCenter;
    contents.image = [contents_BKG firstObject];
    [self.view addSubview:contents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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

#pragma mark -- search bar delegate
- (void)cancelBtnSelected {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchTextChanged:(NSString*)searchText {
    
}

#pragma mark -- seg delegate
- (void)segValueChanged:(SearchSegView *)seg {
    contents.image = [contents_BKG objectAtIndex:seg.selectedIndex];
}
@end
