//
//  CreateChatController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 7/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "CreateChatController.h"
#import "AppDelegate.h"
//#import "GroupModel.h"

@interface CreateChatController ()

@end

@implementation CreateChatController

@synthesize current_group = _current_group;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didSelectCreateChatRoomBtn:)];
}

- (void)didSelectCreateChatRoomBtn:(id)sender {
    NSLog(@"Creating a chat room");
  
//    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    GroupModel* gm = delegate.gm;
    
//    [_delegate didCreateSubGroup:[gm createSubGroup:@"alfred Test" inGroup:_current_group]];
    [self.navigationController popViewControllerAnimated:YES];
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

@end
