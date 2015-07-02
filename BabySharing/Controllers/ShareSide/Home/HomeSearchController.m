//
//  HomeSearchController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 1/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "HomeSearchController.h"
#import "INTUAnimationEngine.h"

@interface HomeSearchController ()
@property (weak, nonatomic) IBOutlet UITextField *searchBarField;

@end

@implementation HomeSearchController

@synthesize searchBarField = _searchBarField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [_searchBarField becomeFirstResponder];
    
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
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag==0) {
        [self moveView:-210];
    }
    if (textField.tag==1) {
        [self moveView:-600];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // TODO: go search process
    return NO;
}

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
@end
