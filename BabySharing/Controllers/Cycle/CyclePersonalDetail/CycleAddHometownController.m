//
//  CycleAddHometownController.m
//  BabySharing
//
//  Created by Alfred Yang on 28/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleAddHometownController.h"

@interface CycleAddHometownController ()
@property (weak, nonatomic) IBOutlet UITextField *hometownTF;

@end

@implementation CycleAddHometownController

@synthesize hometownTF = _hometownTF;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneHomeDownEditing)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneHomeDownEditing {
    
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
