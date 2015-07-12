//
//  PostPreViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 4/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PostPreViewController.h"
#import "PostInputViewController.h"
#import "MoviePlayTrait.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PostPreViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *preView;
@property (strong, nonatomic) MPMoviePlayerController *movie;
@end

@implementation PostPreViewController {
//    GPUImageOutput<GPUImageInput> *filter;
//    GPUImageMovie *movieReader;
//    GPUImageView* filterView;
//    
    CGFloat aspectRatio;
}

@synthesize preView = _preView;
@synthesize postArray = _postArray;
@synthesize type = _type;
@synthesize movieURL = _movieURL;
@synthesize movie = _movie;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_type == PostPreViewPhote) {
        curImage = 0;
        _preView.image = [_postArray firstObject];
    
        UISwipeGestureRecognizer* ges_right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipeImagePreview:)];
        [_preView addGestureRecognizer:ges_right];
        UISwipeGestureRecognizer* ges_left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipeImagePreview:)];
        [ges_left setDirection:UISwipeGestureRecognizerDirectionLeft];
        [_preView addGestureRecognizer:ges_left];
    } else if (_type == PostPreViewMovie) {
        //视频播放对象
        _movie = [MoviePlayTrait createPlayerControllerInRect:CGRectMake(0, 0, 0, 0) andParentView:_preView andContentUrl:_movieURL];
        // 注册一个播放结束的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:_movie];
        
        aspectRatio = 4.0 / 3.0;

//        movieReader = [[GPUImageMovie alloc]initWithURL:_movieURL];
//        filter = [[GPUImageFilter alloc]init];
//        [movieReader addTarget:filter];
//        
//        filterView = [[GPUImageView alloc]initWithFrame:_preView.bounds];
//        [filter addTarget:filterView];
//        
//        [_preView addSubview:filterView];
        
    } else {
        NSLog(@"text do nothing");
    }
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image_cancel = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Previous"] ofType:@"png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image_cancel style:UIBarButtonItemStylePlain target:self action:@selector(didSelectPreviousBtn)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (_type == PostPreViewMovie) {
        float width = [UIScreen mainScreen].bounds.size.width - 32;
        float height = _preView.frame.size.height;
        [_movie.view setFrame:CGRectMake(0, 0, width, height)];
        [_movie play];
    }
//    filterView.frame = _preView.bounds;
//    [movieReader startProcessing];
}

- (void)movieFinishedCallback:(NSNotification*)notify {
    NSNumber *reason = [notify.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if (reason != nil){
        NSInteger reasonAsInteger = [reason integerValue];
        switch (reasonAsInteger){
            case MPMovieFinishReasonPlaybackEnded:{
                /* The movie ended normally */
                break; }
            case MPMovieFinishReasonPlaybackError:{
                /* An error happened and the movie ended */
                break;
            }
            case MPMovieFinishReasonUserExited:{
                /* The user exited the player */
                break;
            }
        }
        NSLog(@"Finish Reason = %ld", (long)reasonAsInteger);
    }
    
     //视频播放对象
     MPMoviePlayerController* theMovie = [notify object];
     //销毁播放通知
     [[NSNotificationCenter defaultCenter] removeObserver:self
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:theMovie];
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

- (void)didSwipeImagePreview:(UISwipeGestureRecognizer*)sender {
    NSLog(@"swipe gesture");
    if (sender.direction == UISwipeGestureRecognizerDirectionRight && curImage > 0) {
        curImage -= 1;
        _preView.image = [_postArray objectAtIndex:curImage];
    } else if (sender.direction == UISwipeGestureRecognizerDirectionLeft && curImage < _postArray.count - 1) {
        curImage += 1;
        _preView.image = [_postArray objectAtIndex:curImage];
    } else {
        
    }
}

- (void)dismissPosrViewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPostSegue {
    [self performSegueWithIdentifier:@"PostInputSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PostInputSegue"]) {
        ((PostInputViewController*)segue.destinationViewController).photos = self.postArray;
        ((PostInputViewController*)segue.destinationViewController).type = self.type;
        if (_type == PostPreViewMovie) {
            ((PostInputViewController*)segue.destinationViewController).filename = [self.movieURL absoluteString];
        }
    }
}

- (IBAction)didSelectPreviousBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
