//
//  PostPreViewEffectController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PostPreViewEffectController.h"
#import "PostEffectAdapter.h"

@interface PostPreViewEffectController () <PostEffectAdapterProtocol>

@end

@implementation PostPreViewEffectController {
    CGFloat aspectRatio;
    
    UIView* mainContentView;
    
    PostEffectAdapter* adapter;
    CALayer* img_layer;
}

@synthesize type = _type;
@synthesize cutted_img = _cutted_img;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    mainContentView.userInteractionEnabled = YES;
    [self.view addSubview:mainContentView];
//    mainContentView.backgroundColor = [UIColor redColor];
    img_layer = [CALayer layer];
    img_layer.frame = mainContentView.bounds;
    img_layer.contents = (id)_cutted_img.CGImage;
    [mainContentView.layer addSublayer:img_layer];
    
    /***************************************************************************************/
    /**
     * fake navigation bar
     */
    UIView* bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 49)];
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
    UIView* f_bar = [[UIView alloc]initWithFrame:CGRectMake(0, height, width, 44)];
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
     * function bar button
     */
    if (_type == PostPreViewPhote) {
        UIButton* f_btn_0 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width / 4, f_bar.frame.size.height)];
        [f_btn_0 setTitle:@"滤镜" forState:UIControlStateNormal];
        [f_btn_0 addTarget:self action:@selector(didSelectFunctionBtn:) forControlEvents:UIControlEventTouchDown];
        f_btn_0.center = CGPointMake(f_btn_0.frame.size.width / 2, f_btn_0.frame.size.height / 2);
        [f_bar addSubview:f_btn_0];
        
        UIButton* f_btn_1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width / 4, f_bar.frame.size.height)];
        [f_btn_1 setTitle:@"标签" forState:UIControlStateNormal];
        [f_btn_1 addTarget:self action:@selector(didSelectFunctionBtn:) forControlEvents:UIControlEventTouchDown];
        f_btn_1.center = CGPointMake(f_btn_1.frame.size.width / 2 * 3, f_btn_1.frame.size.height / 2);
        [f_bar addSubview:f_btn_1];
        
        UIButton* f_btn_2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width / 4, f_bar.frame.size.height)];
        [f_btn_2 setTitle:@"贴图" forState:UIControlStateNormal];
        [f_btn_2 addTarget:self action:@selector(didSelectFunctionBtn:) forControlEvents:UIControlEventTouchDown];
        f_btn_2.center = CGPointMake(f_btn_2.frame.size.width / 2 * 5, f_btn_2.frame.size.height / 2);
        [f_bar addSubview:f_btn_2];
        
        UIButton* f_btn_3 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width / 4, f_bar.frame.size.height)];
        [f_btn_3 setTitle:@"工具" forState:UIControlStateNormal];
        [f_btn_3 addTarget:self action:@selector(didSelectFunctionBtn:) forControlEvents:UIControlEventTouchDown];
        f_btn_3.center = CGPointMake(f_btn_3.frame.size.width / 2 * 7, f_btn_3.frame.size.height / 2);
        [f_bar addSubview:f_btn_3];
        
        
    } else if (_type == PostPreViewMovie) {
        
    } else {
        // error
    }   
    /***************************************************************************************/
    
    /***************************************************************************************/
    /**
     * function area
     */
    adapter = [[PostEffectAdapter alloc]init];
    adapter.delegate = self;
    CGFloat prefered_height = [UIScreen mainScreen].bounds.size.height - height - 44;
   
    UIView* tmp = [adapter getFunctionViewByTitle:@"滤镜" andType:_type andPreferedHeight:prefered_height];
    tmp.frame = CGRectMake(0, height + 44, tmp.frame.size.width, tmp.frame.size.height);
    [self.view addSubview:tmp];
    /***************************************************************************************/
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

- (void)didSelectFunctionBtn:(UIButton*)sender {
    
}

#pragma mark -- function button protocol
- (UIImage*)originImage {
    return _cutted_img;
}

- (void)imageWithEffect:(UIImage *)img {
    img_layer.contents = (id)img.CGImage;
}

@end
