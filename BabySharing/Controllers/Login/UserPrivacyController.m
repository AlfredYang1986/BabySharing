//
//  UserPrivacyController.m
//  BabySharing
//
//  Created by Alfred Yang on 19/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "UserPrivacyController.h"

@interface UserPrivacyController ()
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UITextView *privacyView;

@end

@implementation UserPrivacyController

@synthesize bottomLabel = _bottomLabel;
@synthesize privacyView = _privacyView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bottomLabel.layer.borderColor = [UIColor blackColor].CGColor;
    _bottomLabel.layer.borderWidth = 1.f;
    _bottomLabel.layer.cornerRadius = 8.f;
    _bottomLabel.clipsToBounds = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [_privacyView setContentOffset:CGPointZero];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
