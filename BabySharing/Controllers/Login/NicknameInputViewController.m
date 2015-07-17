//
//  NicknameInputViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "NicknameInputViewController.h"
#import "LoginToken+ContextOpt.h"
#import "INTUAnimationEngine.h"
#import "SearchUserTagsController.h"
#import "NickNameInputView.h"

@interface NicknameInputViewController () <SearchUserTagControllerDelegate, NickNameInputViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation NicknameInputViewController {
    NickNameInputView* inputView;
}

@synthesize loginImgBtn = _loginImgBtn;
@synthesize nextBtn = _nextBtn;

@synthesize lm = _lm;
@synthesize login_attr = _login_attr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    inputView = [[NickNameInputView alloc]init];
    CGSize s = [inputView getPreferredBounds];
    inputView.bounds = CGRectMake(0, 0, s.width, s.height);
    inputView.delegate = self;
    
    [self.view addSubview:inputView];
   
    
    _loginImgBtn.clipsToBounds = YES;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage* img = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Plus_Big"] ofType:@"png"]];
    [_loginImgBtn setBackgroundImage:img forState:UIControlStateNormal];
    _loginImgBtn.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLayoutSubviews {
    /**
     * layout subview then layout input view
     */
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
    CGFloat height = [UIScreen mainScreen].bounds.size.height / 2 + inputView.bounds.size.height / 2;
    inputView.center = CGPointMake(width, height);

    _loginImgBtn.layer.cornerRadius = _loginImgBtn.frame.size.width / 2;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didConfirm {

    NSString* auth_token = [_login_attr objectForKey:@"auth_token"];
    NSString* user_id = [_login_attr objectForKey:@"user_id"];
    if ([_lm sendScreenName:[inputView getInputName] forToken:auth_token andUserID:user_id]) {
//    if ([_lm sendScreenName:@"alfred" forToken:auth_token andUserID:user_id]) {
        NSString* phoneNo = (NSString*)[_login_attr objectForKey:@"phoneNo"];
        [LoginToken unbindTokenInContext:_lm.doc.managedObjectContext WithPhoneNum:phoneNo];
        LoginToken* token = [LoginToken createTokenInContext:_lm.doc.managedObjectContext withUserID:user_id andAttrs:_login_attr];
        [_lm setCurrentUser:token];
        [_lm.doc.managedObjectContext save:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login success" object:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"set nick name error" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)didSelectAddPicBtn {
    NSLog(@"Get Fucking IMG");
}

#pragma mark -- NickNameInputView Delegate
- (void)didStartInputName {
    NSLog(@"start input name");
    [self moveView:-210];
}

- (void)didEndInputName {
    NSLog(@"End input name");
    [self moveView:210];
}

- (void)didStartInputTags {
    NSLog(@"Start input tags");
    [self performSegueWithIdentifier:@"SeachRoleTags" sender:nil];
}

#pragma mark -- segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SeachRoleTags"]) {
        ((SearchUserTagsController*)segue.destinationViewController).delegate = self;
    }
}

#pragma mark -- Search tags delegate
- (void)didSelectTag:(NSString*)tags {
    [inputView resetTags:tags];
}

- (void)moveView:(float)move {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGRect rc_start = self.view.frame;
    CGRect rc_end = CGRectMake(rc_start.origin.x, rc_start.origin.y + move, self.view.frame.size.width, self.view.frame.size.height);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      self.view.frame = INTUInterpolateCGRect(rc_start, rc_end, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}
@end
