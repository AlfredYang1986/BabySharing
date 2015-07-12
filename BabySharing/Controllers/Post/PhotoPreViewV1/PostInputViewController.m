//
//  PostInputViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 4/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PostInputViewController.h"
#import "LoginModel.h"
#import "RemoteInstance.h"
#import "AppDelegate.h"
#import "PostModel.h"


@interface PostInputViewController ()

@end

@implementation PostInputViewController

@synthesize photos = _photos;
@synthesize messageInput = _messageInput;
@synthesize type = _type;
@synthesize filename = _filename;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItem)UIBarButtonSystemItemCancel target:self action:@selector(dismissPosrViewController:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(didPostContent:)];
    
    _messageInput.text = @"alfred post test";
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


#pragma mark -- table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Location";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Add Labels";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"@@Somone";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"Privacy";
    } else {
        
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)dismissPosrViewController:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



- (void)didPostContent:(id)sender {
    NSLog(@"Post Content");
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    PostModel* pm = delegate.pm;
    
    /**
     * create file fold for one post
     */
   
    /**
     * create png file for the post and put then in the file fold
     */
    if (_type == PostPreViewPhote || _type == PostPreViewText) {
        [pm postJsonContentToServieWithTags:nil andDescription:_messageInput.text andPhotos:_photos];
//        [pm postJsonContentToServieInPath:@"" withMessage:_messageInput.text andPhotos:_photos];
    } else {
        [pm postJsonContentWithFileName:_filename withMessage:_messageInput.text];
    }
    
    /**
     * post json file to the servie
     */
    
    /**
     * post image to image service
     */
    
}
@end
