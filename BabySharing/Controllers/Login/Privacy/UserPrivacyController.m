//
//  UserPrivacyController.m
//  BabySharing
//
//  Created by Alfred Yang on 19/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "UserPrivacyController.h"
#import "ModelDefines.h"
#import "RemoteInstance.h"
#import "SGActionView.h"

@interface UserPrivacyController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UITextView *privacyView;

@end

@implementation UserPrivacyController

@synthesize bottomLabel = _bottomLabel;
@synthesize privacyView = _privacyView;

- (void)loadView {
    [super loadView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        [[UINavigationBar appearance] setShadowImage:[self imageWithColor:[UIColor colorWithWhite:0.5922 alpha:0.25] size:CGSizeMake(width, 1)]];
        [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(width, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bottomLabel.layer.borderColor = [UIColor blackColor].CGColor;
    _bottomLabel.layer.borderWidth = 1.f;
    _bottomLabel.layer.cornerRadius = 8.f;
    _bottomLabel.clipsToBounds = YES;
 
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

    NSString * bundlePath_dongda = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle_dongda = [NSBundle bundleWithPath:bundlePath_dongda];
    
    NSString* filepath2 = [resourceBundle pathForResource:@"More" ofType:@"png"];
    UIButton* barBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    [barBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CALayer * layer2 = [CALayer layer];
    layer2.contents = (id)[UIImage imageNamed:filepath2].CGImage;
    layer2.frame = CGRectMake(0, 0, 13, 20);
    layer2.position = CGPointMake(10, barBtn2.frame.size.height / 2);
    [barBtn2.layer addSublayer:layer2];
    [barBtn2 addTarget:self action:@selector(menuBtnSelected) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn2];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送邮件" style:UIBarButtonItemStylePlain target:self action:@selector(sendEmailBtnSelected)];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"咚哒用户协议";
    label.textColor = [UIColor colorWithWhite:0.5059 alpha:1.f];
    [label sizeToFit];
    self.navigationItem.titleView = label;
   
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 25, 25)];
    NSString* filepath = [resourceBundle_dongda pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(-7, 0, 25, 25);
//    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
//    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
//    [barBtn setImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    
    CALayer* line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
    line.frame = CGRectMake(0, 73, [UIScreen mainScreen].bounds.size.width, 1);
    [self.view.layer addSublayer:line];
}

- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [_privacyView setContentOffset:CGPointZero];
}

- (void)menuBtnSelected {
    [SGActionView showSheetWithTitle:@"" itemTitles:@[@"发送协议", @"以邮件的形式发送", @"复制全文", @"取消"] selectedIndex:-1 selectedHandle:^(NSInteger index) {
        switch (index) {
            case 0:
                break;
            case 1:
                [self sendEmailBtnSelected];
                break;
            case 2:
                break;
            default:
                break;
        }
    }];
}

- (void)sendEmailBtnSelected {
    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"输入你的邮件" message:@"" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"do it", nil];
    view.alertViewStyle = UIAlertViewStylePlainTextInput;
    [view show];
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:email];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField* tf = [alertView textFieldAtIndex:0];
    NSString* email = tf.text;
    
    if ([self isValidateEmail:email]) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setObject:email forKey:@"email"];
        
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];

        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:EMAIL_SENDPRIVACY]];
     
        if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
            NSLog(@"send email success");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"success" message:@"send email success" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];

        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"send email failed" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"not validate email address" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
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
