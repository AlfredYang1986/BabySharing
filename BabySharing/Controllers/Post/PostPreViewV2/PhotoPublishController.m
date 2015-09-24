//
//  PhotoPublishController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 13/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PhotoPublishController.h"
#import "AppDelegate.h"
#import "QueryModel.h"
#import "PhototagView.h"
#import "TmpFileStorageModel.h"

//#define LOCATION        0
//#define TIME            1
//#define TAGS            2
//
//#define TAGS_COUNT      3

@interface PhotoPublishController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UISwitch *weiboSwitch;
@property (weak, nonatomic) IBOutlet UILabel *weiboLabel;

@property (weak, nonatomic) IBOutlet UIView *inputContainer;


@property (weak, nonatomic) IBOutlet UIButton *locBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn;
@end

@implementation PhotoPublishController

@synthesize preViewImg = _preViewImg;
@synthesize already_taged = _already_taged;
@synthesize imgView = _imgView;
@synthesize descriptionView = _descriptionView;
@synthesize tagLabel = _tagLabel;

@synthesize movie_url = _movie_url;
@synthesize type = _type;

@synthesize weiboSwitch = _weiboSwitch;
@synthesize weiboLabel = _weiboLabel;

@synthesize inputContainer = _inputContainer;

@synthesize locBtn = _locBtn;
@synthesize timeBtn = _timeBtn;
@synthesize tagBtn = _tagBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString* filepath = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:filepath] style:UIBarButtonItemStylePlain target:self action:@selector(didSelectBackBtn:)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 15, 25);
    [btn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(didSelectBackBtn:) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

//    NSString* postpath = [resourceBundle pathForResource:@"Post" ofType:@"png"];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:postpath] style:UIBarButtonItemStylePlain target:self action:@selector(didSelectPostBtn:)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectPostBtn:)];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"发布" forState:UIControlStateNormal];
    [btn2 sizeToFit];
    [btn2 addTarget: self action: @selector(didSelectPostBtn:) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn2];
    
    _imgView.image = _preViewImg;
   
    for (UIView * view in _already_taged) {
        [self.view addSubview:view];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPostViewController) name:@"post success" object:nil];
    
    _weiboSwitch.on = NO;
    _inputContainer.backgroundColor = [UIColor colorWithRed:0.9020 green:0.9059 blue:0.9098 alpha:1.f];
    _descriptionView.backgroundColor = [UIColor clearColor];
    
    [_locBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Location_Publish" ofType:@"png"]] forState:UIControlStateNormal];
    [_timeBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Time_Publish" ofType:@"png"]] forState:UIControlStateNormal];
    [_tagBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Tag_Publish" ofType:@"png"]] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLayoutSubviews {
    CGFloat offset_x = 0;
    CGFloat offset_y = _tagLabel.frame.origin.y + _tagLabel.frame.size.height + 8;
    CGFloat width_limit = [UIScreen mainScreen].bounds.size.width;
    
    for (UIView * view in _already_taged) {
        if (offset_x + view.bounds.size.width > width_limit) {
            offset_x = 0;
            offset_y += view.bounds.size.height + 8;
        }
        view.center = CGPointMake(offset_x + view.bounds.size.width / 2, offset_y + view.bounds.size.height / 2);
        offset_x += view.bounds.size.width + 8;
        // TODO: Layout tag view
        view.hidden = YES;
    }
    
    _weiboSwitch.frame = CGRectMake(_weiboSwitch.frame.origin.x, _weiboSwitch.frame.origin.y, 25, 15);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissPostViewController {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Post Success");
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden {
    return NO; //返回NO表示要显示，返回YES将hiden
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- segue and actions
- (void)didSelectBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectPostBtn:(id)sender {
    NSLog(@"Post Content");
   
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (_weiboSwitch.on == YES) {
        [delegate.lm postContentOnWeiboWithText:_descriptionView.text andImage:_preViewImg];
    }
    
    PostModel* pm = delegate.pm;

    if (_type == PostPreViewPhote) {
        /**
         * create tag dictionary
         */
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (PhotoTagView* view in _already_taged) {
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[NSNumber numberWithInt:view.type] forKey:@"type"];
            [dic setObject:view.content forKey:@"content"];
            [dic setObject:[NSNumber numberWithFloat:view.offset_x] forKey:@"offsetX"];
            [dic setObject:[NSNumber numberWithFloat:view.offset_y] forKey:@"offsetY"];
            
            [arr addObject:[dic copy]];
        }
        [pm postJsonContentToServieWithTags:[arr copy] andDescription:_descriptionView.text andPhotos:[[NSArray alloc]initWithObjects:_preViewImg, nil]];
    
    } else if (_type == PostPreViewMovie) {

        NSString* filename = [_movie_url path];
        if ([filename containsString:@"assert"]) {
            [pm postJsonContentWithFileURL:_movie_url withMessage:_descriptionView.text];
        } else {
            [pm postJsonContentWithFileName:filename withMessage:_descriptionView.text];
        }
    }
}
@end
