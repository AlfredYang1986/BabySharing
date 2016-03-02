//
//  TabBarController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 20/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "TabBarController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/UTType.h>
#import <MobileCoreServices/UTCoreTypes.h>

#import "ShareSideBaseController.h"
//#import "MovingButton.h"

//#import "AlbumViewController.h"
#import "CVMovieController.h"
#import "CVViewController2.h"
#import "WebSearchController.h"

#import "UserChatController.h"
#import "MessageViewController.h"

#import "DongDaTabBar.h"

#import "HomeNavigationController.h"
#import "AlbumViewController2.h"

//#define MOVING_DISTANCE     90
//#define MOVING_BASE         20
//#define MOVING_ANGLE        0.6

@interface TabBarController ()

@end

@implementation TabBarController {
//    MovingButton* photoBtn;
//    MovingButton* movieBtn;
//    MovingButton* compareBtn;
    
    UIView* backView;
    
    DongDaTabBar* dongda_tabbar;
}

@synthesize lm = _lm;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
  
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

    [self setUpMovingButtonsWithBoundle:resourceBundle];

    [self unReadMessageCountChanged:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unReadMessageCountChanged:) name:@"unRead Message Changed" object:nil];
    
    dongda_tabbar = [[DongDaTabBar alloc]initWithBar:self];
    [dongda_tabbar addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"tab_home"] ofType:@"png"]] andSelectedImg:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"tab_home_selected"] ofType:@"png"]]];
    [dongda_tabbar addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"tab_found"] ofType:@"png"]] andSelectedImg:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"tab_found_selected"] ofType:@"png"]]];
    [dongda_tabbar addMidItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"tab_publish"] ofType:@"png"]]];
    [dongda_tabbar addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"tab_friends"] ofType:@"png"]] andSelectedImg:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"tab_friends_selected"] ofType:@"png"]]];
    [dongda_tabbar addItemWithImg:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"tab_profile"] ofType:@"png"]] andSelectedImg:[UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"tab_profile_selected"] ofType:@"png"]]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        [[UITabBar appearance] setShadowImage:[UIImage new]];
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    }
}

- (void)setUpMovingButtonsWithBoundle:(NSBundle*)bundle {
    CGRect rc = [UIScreen mainScreen].bounds;
    CGRect rc_tb = self.tabBar.bounds;
    backView = [[UIView alloc]initWithFrame:CGRectMake(rc.origin.x, rc.origin.y, rc.size.width, rc.size.height - rc_tb.size.height)];
    backView.backgroundColor =  [UIColor colorWithWhite:0.0 alpha:0.0];
    [self.view addSubview:backView];
    
    [self.view bringSubviewToFront:backView];
    backView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma marks - change to side B
- (void)showSecretSideOnController:(UIViewController*)parent {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecretNib" bundle:nil];
    UIViewController* SecretNav = [storyboard instantiateViewControllerWithIdentifier:@"SecretNav"];
    [parent presentViewController:SecretNav animated:YES completion: ^(void){
        NSLog(@"Secret running ...");
    }];
}

#pragma marks - tabBar delegate

- (void)showCameraControllerOnController:(UIViewController*)parent {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CameraNib2" bundle:nil];
    CVViewController2* cameraNav = [storyboard instantiateViewControllerWithIdentifier:@"cameraNav"];
    cameraNav.delegate = self;
//    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:cameraNav];
    HomeNavigationController * nav = [[HomeNavigationController alloc]initWithRootViewController:cameraNav];
//    [parent presentViewController:cameraNav animated:YES completion: ^(void){
    [nav setNavigationBarHidden:YES];
    [parent presentViewController:nav animated:YES completion: ^(void){
        NSLog(@"camera running ...");
    }];
}

- (void)showMovieControllerOnController:(UIViewController*)parent {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MovieNib" bundle:nil];
    CVMovieController* cameraNav = [storyboard instantiateViewControllerWithIdentifier:@"MovieNib"];
    cameraNav.delegate = self;
//    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:cameraNav];
    HomeNavigationController * nav = [[HomeNavigationController alloc]initWithRootViewController:cameraNav];
    [nav setNavigationBarHidden:YES];
//    [parent presentViewController:cameraNav animated:YES completion: ^(void){
    [parent presentViewController:nav animated:YES completion: ^(void){
        NSLog(@"movie running ...");
    }];
}

- (void)showNetControllerOnController:(UIViewController*)parent {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"webNab" bundle:nil];
    WebSearchController* cameraNav = [storyboard instantiateViewControllerWithIdentifier:@"webNab"];
//    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:cameraNav];
    HomeNavigationController * nav = [[HomeNavigationController alloc]initWithRootViewController:cameraNav];
    [nav setNavigationBarHidden:YES];
    //    [parent presentViewController:cameraNav animated:YES completion: ^(void){
    [parent presentViewController:nav animated:YES completion: ^(void){
        NSLog(@"movie running ...");
    }];
}

- (void)showAblumCameraController:(UIViewController*)parent andType:(AlbumControllerType)type {
    AlbumViewController2* distination = [[AlbumViewController2 alloc]init];
    distination.delegate = self;
    HomeNavigationController * nav = [[HomeNavigationController alloc]initWithRootViewController:distination];
    [parent presentViewController:nav animated:YES completion: ^(void){
        NSLog(@"Ablum controller running ...");
    }];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"select tab %@", item.title);
   
    if ([item.title isEqualToString:@"Post"]) {
        [self showCameraControllerOnController:self];
    }
}

- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray *)items {
    NSLog(@"customzing items ...");
}


#pragma marks - tabbar controller delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController.tabBar.selectedItem.title isEqualToString:@"Post"]) {
        return NO;
    }
    
    if (backView.hidden == NO) {
        return NO;
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {
    for (UIViewController * iter in viewControllers) {
        NSLog(@"%@", iter.title);
    }
}

#pragma mark -- Post Action Delegate
- (void)didCameraBtn: (UIViewController*)pv {
    [pv dismissViewControllerAnimated:YES completion:^{
        [self showCameraControllerOnController:self];
    }];
}

- (void)didMovieBtn:(UIViewController *)pv {
    [pv dismissViewControllerAnimated:YES completion:^{
        [self showMovieControllerOnController:self];
    }];
}

- (void)didCompareBtn: (UIViewController*)pv {
    [pv dismissViewControllerAnimated:YES completion:^{
        [self showNetControllerOnController:self];
    }];   
}

- (void)postViewController:(UIViewController*)pv didPostSueecss:(BOOL)success {
    if (success) {
        [pv dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -- camera action protocol
- (void)didSelectAlbumBtn:(UIViewController*)cur andCurrentType:(AlbumControllerType)type {
    [cur dismissViewControllerAnimated:YES completion:^{
        [self showAblumCameraController:self andType:type];
    }];
}

- (void)didSelectMovieBtn2:(UIViewController*)cur {
    [cur dismissViewControllerAnimated:YES completion:^{
        [self showMovieControllerOnController:self];
    }];
}

- (void)didSelectCameraBtn2:(UIViewController*)cur {
    [cur dismissViewControllerAnimated:YES completion:^{
        [self showCameraControllerOnController:self];
    }];
}

- (void)didSelectAlbumBtn2:(UIViewController*)cur {
    
}

#pragma mark -- notifications
- (void)unReadMessageCountChanged:(id)sender {
    
    if (self.selectedIndex == 3) {
        UIViewController* cv = self.selectedViewController.childViewControllers.lastObject;
        if ([cv isKindOfClass:[MessageViewController class]]) {
            [((MessageViewController*)cv).queryView reloadData];
        } else if ([cv isKindOfClass:[UserChatController class]]) {
            [((UserChatController*)cv).queryView reloadData];
        }
        
    } else {
        NSInteger unReadCount = [_mm unReadNotificationCount] + [_mm getAllUnreadMessageCount];
        if (unReadCount != 0) {
            ((UITabBarItem*)[self.tabBar.items objectAtIndex:3]).badgeValue = [NSString stringWithFormat:@"%ld", (long)unReadCount];
        } else {
            ((UITabBarItem*)[self.tabBar.items objectAtIndex:3]).badgeValue = nil;
        }
    }
}

// 获取当前处于activity状态的view controller
- (UIViewController *)activityViewController {
    UIViewController* activityViewController = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if(tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0) {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]]) {
            activityViewController = nextResponder;
        }
        else {
            activityViewController = window.rootViewController;
        }
    }
    return activityViewController;
}
@end
