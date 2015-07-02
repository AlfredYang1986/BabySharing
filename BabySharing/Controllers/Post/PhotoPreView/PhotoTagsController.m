//
//  PhotoTagsController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 12/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PhotoTagsController.h"
#import "PhotoTagControlView.h"
#import "SGActionView.h"
#import "PhotoTagView.h"
#import "INTUAnimationEngine.h"
#import "PhotoPublishController.h"

#define LOCATION        0
#define TIME            1
#define TAGS            2

#define TAGS_COUNT      3

@interface PhotoTagsController ()
@property (weak, nonatomic) IBOutlet PhotoTagControlView *hitView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation PhotoTagsController {
    CGFloat screen_width;
    CGFloat screen_height;
    CGFloat control_pane_height;
    
    CGFloat top_margin;
    
    NSArray* tags_arr;
    
    CGPoint point;
    
    NSMutableDictionary* already_taged_views;       // photo tag view
    PhotoTagView* cur_long_press;
}

@synthesize hitView = _hitView;
@synthesize imgView = _imgView;
@synthesize taging_img = _taging_img;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imgView.userInteractionEnabled = YES;
    _imgView.contentMode = UIViewContentModeScaleToFill;
    _imgView.image = _taging_img;
    UITapGestureRecognizer* lg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleShortPress:)];
    [_imgView addGestureRecognizer:lg];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString* filepath = [resourceBundle pathForResource:@"Previous" ofType:@"png"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:filepath] style:UIBarButtonItemStylePlain target:self action:@selector(didSelectBackBtn:)];
    
    NSString* nextPath = [resourceBundle pathForResource:@"Next" ofType:@"png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:nextPath] style:UIBarButtonItemStylePlain target:self action:@selector(didSelectNextBtn:)];
   
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:TAGS_COUNT];
   
    [tmp insertObject:[UIImage imageNamed:[resourceBundle pathForResource:@"Location" ofType:@"png"]] atIndex:LOCATION];
    [tmp insertObject:[UIImage imageNamed:[resourceBundle pathForResource:@"Time" ofType:@"png"]] atIndex:TIME];
    [tmp insertObject:[UIImage imageNamed:[resourceBundle pathForResource:@"Tag" ofType:@"png"]] atIndex:TAGS];
    
    tags_arr = [tmp copy];
    
    already_taged_views = [[NSMutableDictionary alloc]initWithCapacity:TAGS_COUNT];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [_hitView layoutMySelf];
    
    top_margin = self.navigationController.navigationBar.frame.size.height;
    screen_width = [UIScreen mainScreen].bounds.size.width;
    screen_height = [UIScreen mainScreen].bounds.size.height;
    control_pane_height = screen_width / 2;
    
    _imgView.frame = CGRectMake(0, top_margin,  screen_width, screen_height - control_pane_height - top_margin);
    _hitView.hitLabel.frame = CGRectMake(0, 0, 100, 100);
}

#pragma mark -- long press
- (void)handleShortPress:(UITapGestureRecognizer*)gesture {
    NSLog(@"tap gesture");
    point = [gesture locationInView:_imgView];
    [SGActionView showGridMenuWithTitle:@"Choose Tag Types"
                             itemTitles:@[ @"Location", @"Time", @"Tags"]
                                 images:tags_arr
                         selectedHandle:^(NSInteger index){
                             NSLog(@"select index: %ld", (long)index);
                             if (index > 0) {
                                 [self performSegueWithIdentifier:@"addTags" sender:[NSNumber numberWithInteger:index - 1]];
                             }
                         }];
}

#pragma mark -- segue
- (void)didSelectBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectNextBtn:(id)sender {
    [self performSegueWithIdentifier:@"publicSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"publicSegue"]) {
        ((PhotoPublishController*)segue.destinationViewController).preViewImg = _taging_img;
       
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (int index = LOCATION; index < TAGS_COUNT; ++index) {
            PhotoTagView* view = [self queryTagViewByType:index];
            if (view) {
                PhotoTagView* tmp = [[PhotoTagView alloc]initWithTagName:view.content andType:index];
                tmp.offset_x = view.frame.origin.x;
                tmp.offset_y = view.frame.origin.y;
                [arr addObject:tmp];
            }
        }
        ((PhotoPublishController*)segue.destinationViewController).already_taged = [arr copy];
        
    } else if ([segue.identifier isEqualToString:@"addTags"]) {
        NSNumber* index = (NSNumber*)sender;
        ((PhotoAddTagController*)segue.destinationViewController).tagImg = [tags_arr objectAtIndex:index.integerValue];
        ((PhotoAddTagController*)segue.destinationViewController).type = index.integerValue;
        ((PhotoAddTagController*)segue.destinationViewController).delegate = self;
    }
}

#pragma mark -- adding tag protocol
- (void)didSelectTag:(NSString *)tag andType:(TagType)type {
    // TODO: adding tag
    NSLog(@"adding tags: %@, %d", tag, (int)type);
  
    PhotoTagView* view = [self queryTagViewByType:type];
    if (view) {
        [view removeFromSuperview];
    }
    
    PhotoTagView* tmp = [[PhotoTagView alloc]initWithTagName:tag andType:type];
    tmp.frame = CGRectMake(point.x, point.y, tmp.bounds.size.width, tmp.bounds.size.height);
    [_imgView addSubview:tmp];
    [_imgView bringSubviewToFront:tmp];
    [already_taged_views setObject:tmp forKey:[NSNumber numberWithInt:type]];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTagTapped:)];
    [tmp addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer* lg = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    [tmp addGestureRecognizer:lg];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleTagPan:)];
    [tmp addGestureRecognizer:pan];
}

- (PhotoTagView*)queryTagViewByType:(TagType)type {
    return [already_taged_views objectForKey:[NSNumber numberWithInt:type]];
}

#pragma mark -- tag gesture
- (void)handleTagTapped:(UITapGestureRecognizer*)gesture {
    // TODO: change to tag search
    NSLog(@"short gesture");
    NSLog(@"TODO: show tag search controller!");
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture {
    NSLog(@"long gesture");
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        
        cur_long_press = (PhotoTagView*)gesture.view;
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"delect" message:@"remove paste image" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"yes", nil];
        [view show];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        
    }
}

- (void)handleTagPan:(UIPanGestureRecognizer*)gesture {
    NSLog(@"pan gesture");
    UIView* tmp = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        point = [gesture translationInView:_imgView];
        [_imgView bringSubviewToFront:tmp];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"end");
        point = CGPointMake(-1, -1);
        CGFloat move_x = [self distanceMoveHerWithView:tmp];
        CGFloat move_y = [self distanceMoveVerWithView:tmp];
        [self moveView:move_x and:move_y withView:tmp];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changeed");
        CGPoint newPoint = [gesture translationInView:_imgView];
        
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
    else if (view.frame.origin.y + view.frame.size.height > _imgView.frame.size.height)
        return -(view.frame.origin.y + view.frame.size.height - _imgView.frame.size.height);
    else return 0;
}

- (CGFloat)distanceMoveHerWithView:(UIView*)view {
    
    if (view.frame.origin.x < 0)
        return -view.frame.origin.x;
    else if (view.frame.origin.x + view.frame.size.width > _imgView.frame.size.width)
        return -(view.frame.origin.x + view.frame.size.width - _imgView.frame.size.width);
    else return 0;
}

#pragma mark -- alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index at %ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        [already_taged_views removeObjectForKey:[NSNumber numberWithInt:cur_long_press.type]];
        [cur_long_press removeFromSuperview];
    }
    cur_long_press = nil;
}
@end
