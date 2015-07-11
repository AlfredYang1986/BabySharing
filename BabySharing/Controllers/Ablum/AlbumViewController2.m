//
//  AlbumViewController2.m
//  BabySharing
//
//  Created by Alfred Yang on 11/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AlbumViewController2.h"
#import "AlbumModule.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "INTUAnimationEngine.h"

@interface AlbumViewController2 () 

@end

@implementation AlbumViewController2 {
    UIView* mainContentView;
    UIView* f_bar;
    UITableView* albumView;
    
    CGFloat aspectRatio;
}

@synthesize type = _type;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = UIColor.blackColor;

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    aspectRatio = 4.0 / 3.0;
    
    CGFloat img_height = width * aspectRatio;
   
    /***************************************************************************************/
    /**
     * main content view
     */
    mainContentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, img_height)];
    mainContentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainContentView];
   
    /***************************************************************************************/
    /**
     * fake navigation bar
     */
    UIView * bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 49)];
    bar.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
    [self.view addSubview:bar];
    [self.view bringSubviewToFront:bar];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 15, 25, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* filepath = [resourceBundle pathForResource:@"Previous_blue" ofType:@"png"];
    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    [bar addSubview:barBtn];

    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(width - 13 - 25, 15, 25, 25)];
    NSString* filepath_right = [resourceBundle pathForResource:@"Next_blue" ofType:@"png"];
    [bar_right_btn setBackgroundImage:[UIImage imageNamed:filepath_right] forState:UIControlStateNormal];
    [bar_right_btn addTarget:self action:@selector(didNextBtnSelected) forControlEvents:UIControlEventTouchDown];
    [bar addSubview:bar_right_btn];
    /***************************************************************************************/
    
    /***************************************************************************************/
    /**
     * funciton bar
     */
    CGFloat height = width * aspectRatio;
    f_bar = [[UIView alloc]initWithFrame:CGRectMake(0, height - 44, width, 44)];
    f_bar.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [self.view addSubview:f_bar];
    [self.view bringSubviewToFront:f_bar];

    /**
     * gradient layer for gradient background,
     */
    CAGradientLayer* gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, f_bar.frame.size.width, f_bar.frame.size.height);
    gl.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor darkGrayColor] CGColor], nil];
    gl.startPoint = CGPointMake(0.5, 0.5);
    gl.endPoint = CGPointMake(0.5, 1.0);
    [f_bar.layer addSublayer:gl];
    
    /**
     * button layer for function bar
     */
    CALayer* round_bottom = [CALayer layer];
    round_bottom.frame = CGRectMake(0, 0, width * 0.1, 6);
    round_bottom.cornerRadius = 3.f;
    round_bottom.masksToBounds = YES;
    round_bottom.borderWidth = 1.f;
    round_bottom.borderColor = [UIColor blackColor].CGColor;
    round_bottom.backgroundColor = [UIColor blackColor].CGColor;
    round_bottom.position = CGPointMake(f_bar.frame.size.width / 2, f_bar.frame.size.height * 3 / 4);
    [f_bar.layer addSublayer:round_bottom];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapFunctionBar:)];
    [f_bar addGestureRecognizer:tap];
    /***************************************************************************************/
    
    CGFloat tab_bar_height_offset = [UIScreen mainScreen].bounds.size.height - 44;
    /***************************************************************************************/
    /**
     * grid photos
     */
    albumView = [[UITableView alloc]initWithFrame:CGRectMake(0, height, width, tab_bar_height_offset - height)];
    albumView.dataSource = self;
    albumView.delegate = self;
    [self.view addSubview:albumView];
    
    /***************************************************************************************/
    
    /***************************************************************************************/
    /**
     * bottom function area
     */
    UIView* tab_bar = [[UIView alloc]initWithFrame:CGRectMake(0, tab_bar_height_offset, width, 44)];
    tab_bar.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [self.view addSubview:tab_bar];
   
    if (_type == AlbumControllerTypePhoto) {
        [self createButtonsForView:tab_bar inRect:CGRectMake(0, 0, width / 3, 44) andTitle:@"相机胶卷"];
        [self createButtonsForView:tab_bar inRect:CGRectMake(width / 3, 0, width / 3, 44) andTitle:@"面孔"];
        [self createButtonsForView:tab_bar inRect:CGRectMake(width * 2 / 3, 0, width / 3, 44) andTitle:@"地点"];
    } else {
        [self createButtonsForView:tab_bar inRect:CGRectMake(0, 0, width, 44) andTitle:@"视频"];
    }
    /***************************************************************************************/
}

- (void)createButtonsForView:(UIView*)tab_bar inRect:(CGRect)rc andTitle:(NSString*)title{
    UIButton* btn = [[UIButton alloc]initWithFrame:rc];
//    btn.layer.borderColor = [UIColor blueColor].CGColor;
//    btn.layer.borderWidth = 1.f;
    btn.layer.cornerRadius = 4.f;
    btn.clipsToBounds = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didSelectTabBtn:) forControlEvents:UIControlEventTouchDown];
    [tab_bar addSubview:btn];   
}

- (void)changeMainContentWithAsset:(ALAsset*)asset {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
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

#pragma mark -- button actions
- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didNextBtnSelected {
    
}

- (void)didTapFunctionBar:(UITapGestureRecognizer*)gesture {
    
}

- (void)didSelectTabBtn:(UIButton*)sender {
    
}

#pragma mark -- table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
    //    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    cell.textLabel.text = @"alfred test...";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

@end
