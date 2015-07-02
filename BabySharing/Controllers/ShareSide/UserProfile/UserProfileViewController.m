//
//  UserProfileViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 23/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *user_photo_img_view;
@property (weak, nonatomic) IBOutlet UILabel *user_name_label;
@property (weak, nonatomic) IBOutlet UILabel *user_region_label;

@end

@implementation UserProfileViewController

@synthesize user_photo_img_view = _user_photo_img_view;
@synthesize user_name_label = _user_name_label;
@synthesize user_region_label = _user_region_label;
@synthesize onwer_id = _onwer_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"user id is %@", _onwer_id);
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

- (IBAction)didSelectHBtn {
    NSLog(@"say hi");
}

@end
