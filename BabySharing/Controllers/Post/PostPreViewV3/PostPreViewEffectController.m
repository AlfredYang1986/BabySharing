//
//  PostPreViewEffectController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PostPreViewEffectController.h"
#import "PostEffectAdapter.h"
#import "PhotoAddTagController.h"
#import "INTUAnimationEngine.h"
#import "PhotoPublishController.h"

@interface PostPreViewEffectController () <PostEffectAdapterProtocol, addingTagsProtocol, UIAlertViewDelegate>

@end

@implementation PostPreViewEffectController {
    CGFloat aspectRatio;
    
    UIView* mainContentView;
    
    PostEffectAdapter* adapter;
    CALayer* img_layer;
    
    NSMutableDictionary* function_dic;
    
    NSMutableDictionary* tags;
    
    NSMutableArray* paste_img_arr;
    CGPoint point;
    UIView* cur_long_press;
    
    UIImage* result_img;
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
    
    function_dic = [[NSMutableDictionary alloc]init];
    [function_dic setValue:tmp forKey:@"滤镜"];
    
    [self.view addSubview:tmp];
    /***************************************************************************************/
    
    tags = [[NSMutableDictionary alloc]initWithCapacity:3];
    
    paste_img_arr = [[NSMutableArray alloc]init];
    
    result_img = _cutted_img;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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
    UIImage* final_img = [self mergePasteAndEffect:result_img];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoPreView" bundle:nil];
    PhotoPublishController* publishController = [storyboard instantiateViewControllerWithIdentifier:@"publishController"];
   
    publishController.preViewImg = final_img;
   
    NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:tags.count];
    for (int index = 0; index < tags.allValues.count; ++index) {
        PhotoTagView* view = [tags.allValues objectAtIndex:index];
        if (view) {
            PhotoTagView* tmp = [[PhotoTagView alloc]initWithTagName:view.content andType:view.type];
            tmp.offset_x = view.frame.origin.x;
            tmp.offset_y = view.frame.origin.y;
            [arr addObject:tmp];
        }
    }
    publishController.already_taged = [arr copy];
    [self.navigationController pushViewController:publishController animated:YES];
}

- (UIImage*)mergePasteAndEffect:(UIImage*)baseImg {
    CGImageRef baseImageRef = CGImageCreateWithImageInRect(baseImg.CGImage, CGRectMake(0, 0, baseImg.size.width, baseImg.size.height));
    CGRect baseBounds = CGRectMake(0, 0, CGImageGetWidth(baseImageRef), CGImageGetHeight(baseImageRef));
    
    CGFloat scale_x = _cutted_img.size.width / mainContentView.frame.size.width;
    CGFloat scale_y = _cutted_img.size.height / mainContentView.frame.size.height;
    
    UIGraphicsBeginImageContext(baseBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, baseBounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, baseBounds, baseImageRef);
    
    for (UIImageView* view in paste_img_arr) {
        
        CGImageRef subImgRef = CGImageCreateWithImageInRect(view.image.CGImage, CGRectMake(0, 0, view.image.size.width, view.image.size.height));
        CGRect rect = view.frame;
        
        CGFloat offset_x = rect.origin.x;
        CGFloat offset_y = mainContentView.frame.size.height - (rect.origin.y + rect.size.height);
        
        CGRect smallBounds = CGRectMake(offset_x * scale_x, offset_y * scale_y, rect.size.width * scale_x, rect.size.height * scale_y);
        CGContextDrawImage(context, smallBounds, subImgRef);
    }
    
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newImageRef];
    UIGraphicsEndImageContext();
    //
    return newImage;
}

- (void)didSelectFunctionBtn:(UIButton*)sender {
    NSString* title = sender.titleLabel.text;
    
    for (UIView* iter in function_dic.allValues) {
        [iter removeFromSuperview];
    }
    
    UIView* tmp = [function_dic objectForKey:title];
    if (!tmp) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = width * aspectRatio;
        CGFloat prefered_height = [UIScreen mainScreen].bounds.size.height - height - 44;
        tmp = [adapter getFunctionViewByTitle:title andType:_type andPreferedHeight:prefered_height];
        tmp.frame = CGRectMake(0, height + 44, tmp.frame.size.width, tmp.frame.size.height);
    }
    [self.view addSubview:tmp];
    
}

#pragma mark -- adding tag protocol
- (void)didSelectTag:(NSString *)tag andType:(TagType)type {
    // TODO: adding tag
    NSLog(@"adding tags: %@, %d", tag, (int)type);
    
    if ([tags.allKeys containsObject:[NSNumber numberWithInteger:type]]) {
        UIView* last = [tags objectForKey:[NSNumber numberWithInteger:type]];
        [last removeFromSuperview];
        [tags removeObjectForKey:[NSNumber numberWithInteger:type]];
    }
    
    PhotoTagView* tmp = [[PhotoTagView alloc]initWithTagName:tag andType:type];
    CGFloat width = mainContentView.frame.size.width;
    CGFloat height = mainContentView.frame.size.height;
    CGPoint point_tmp;
    switch (type) {
        case TagTypeLocation:
            point_tmp = CGPointMake(width / 4 - tmp.bounds.size.width / 2, height / 2);
            break;
        case TagTypeTime:
            point_tmp = CGPointMake(width / 2 - tmp.bounds.size.width / 2, height * 3 / 4);
            break;
        case TagTypeTags:
            point_tmp = CGPointMake(width * 3 / 4 - tmp.bounds.size.width / 2, height / 2);
        default:
            break;
    }
    tmp.frame = CGRectMake(point_tmp.x, point_tmp.y, tmp.bounds.size.width, tmp.bounds.size.height);
    [mainContentView addSubview:tmp];
    [mainContentView bringSubviewToFront:tmp];
    
    [tags setObject:tmp forKey:[NSNumber numberWithInteger:type]];
//    [already_taged_views setObject:tmp forKey:[NSNumber numberWithInt:type]];
//    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTagTapped:)];
//    [tmp addGestureRecognizer:tap];
//    
//    UILongPressGestureRecognizer* lg = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
//    [tmp addGestureRecognizer:lg];
//    
//    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleTagPan:)];
//    [tmp addGestureRecognizer:pan];
}

#pragma mark -- function button protocol
- (PostPreViewType)currentType {
    return _type;
}

- (UIImage*)originImage {
    return _cutted_img;
}

- (void)imageWithEffect:(UIImage *)img {
    result_img = img;
    img_layer.contents = (id)img.CGImage;
}

- (BOOL)canCreateNewTag:(TagType)tag_type {
//    return ![tags.allKeys containsObject:[NSNumber numberWithInteger:tag_type]];
    return YES;
}

- (void)tagView:(PhotoTagView*)view forTagType:(TagType)tag_type {
    [tags setObject:view forKey:[NSNumber numberWithInteger:tag_type]];
}

- (void)queryTagContetnWithTagType:(TagType)tag_type andImg:(UIImage*)tag_img {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoPreView" bundle:nil];
    PhotoAddTagController* addTagController = [storyboard instantiateViewControllerWithIdentifier:@"AddTags"];
    addTagController.tagImg = tag_img;
    addTagController.type = tag_type;
    addTagController.delegate = self;
    
    [self.navigationController pushViewController:addTagController animated:YES];
}

- (void)pasteWithImage:(UIImage*)img {
    UIImageView* tmp = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    tmp.center = CGPointMake(mainContentView.frame.size.width / 2, mainContentView.frame.size.height / 2);
    tmp.userInteractionEnabled = YES;
    tmp.contentMode = UIViewContentModeScaleToFill;
    tmp.image = img;
   
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePastePan:)];
    [tmp addGestureRecognizer:pan];
    UILongPressGestureRecognizer* lp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    [tmp addGestureRecognizer:lp];
    
    [mainContentView addSubview:tmp];
    [mainContentView bringSubviewToFront:tmp];
    
    [paste_img_arr addObject:tmp];
}

#pragma mark -- paste img pan handle
- (void)handlePastePan:(UIPanGestureRecognizer*)gesture {
    NSLog(@"pan gesture");
    UIView* tmp = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        point = [gesture translationInView:mainContentView];
        [mainContentView bringSubviewToFront:tmp];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end");
        point = CGPointMake(-1, -1);
        CGFloat move_x = [self distanceMoveHerWithView:tmp];
        CGFloat move_y = [self distanceMoveVerWithView:tmp];
        [self moveView:move_x and:move_y withView:tmp];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        CGPoint newPoint = [gesture translationInView:mainContentView];
        
        tmp.center = CGPointMake(tmp.center.x + (newPoint.x - point.x), tmp.center.y + (newPoint.y - point.y));
        point = newPoint;
    }
}

- (void)moveView:(float)move_x and:(float)move_y withView:(UIView*)view {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGPoint center = view.center;
    CGPoint newCenter = CGPointMake(view.center.x + move_x, view.center.y + move_y);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      view.center = INTUInterpolateCGPoint(center, newCenter, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

- (CGFloat)distanceMoveVerWithView:(UIView*)view {
    if (view.frame.origin.y < 0)
        return -view.frame.origin.y;
    else if (view.frame.origin.y + view.frame.size.height > mainContentView.frame.size.height)
        return -(view.frame.origin.y + view.frame.size.height - mainContentView.frame.size.height);
    else return 0;
}

- (CGFloat)distanceMoveHerWithView:(UIView*)view {
    
    if (view.frame.origin.x < 0)
        return -view.frame.origin.x;
    else if (view.frame.origin.x + view.frame.size.width > mainContentView.frame.size.width)
        return -(view.frame.origin.x + view.frame.size.width - mainContentView.frame.size.width);
    else return 0;
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture {
    NSLog(@"long gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        
        cur_long_press = gesture.view;
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"delect" message:@"remove paste image" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"yes", nil];
        [view show];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        
    }
}

#pragma mark -- alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index at %ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        [cur_long_press removeFromSuperview];
        [paste_img_arr removeObject:cur_long_press];
    }
    cur_long_press = nil;
}
@end
