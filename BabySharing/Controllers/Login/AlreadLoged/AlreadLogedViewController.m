//
//  AlreadLogedViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 26/12/2014.
//  Copyright (c) 2014 YY. All rights reserved.
//

#import "AlreadLogedViewController.h"
#import "NicknameInputViewController.h"
#import "loginToken+ContextOpt.h"

@interface AlreadLogedViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginImgBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTagLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
@end

@implementation AlreadLogedViewController

@synthesize lm = _lm;
@synthesize login_attr = _login_attr;

@synthesize loginImgBtn = _loginImgBtn;
@synthesize nickNameLabel = _nickNameLabel;
@synthesize currentTagLabel = _currentTagLabel;
@synthesize yesBtn = _yesBtn;
@synthesize noBtn = _noBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    /**
     * round img button
     */
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage* img = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"User_Big"] ofType:@"png"]];
    [_loginImgBtn setBackgroundImage:img forState:UIControlStateNormal];
    _loginImgBtn.layer.cornerRadius = _loginImgBtn.frame.size.width / 2;
    _loginImgBtn.clipsToBounds = YES;
    _loginImgBtn.backgroundColor = [UIColor clearColor];

    /**
     * add under line for nick name label
     */
    NSString* name = [_login_attr objectForKey:@"screen_name"];
    if (!name || [name isEqualToString:@""]) {
        name = [_login_attr objectForKey:@"phoneNo"];
    }
    
//    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:name];
//    NSRange contentRange = {0, [content length]};
//    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    
//    _nickNameLabel.text = @"";
//    _nickNameLabel.attributedText = content;
    _nickNameLabel.text = name;
   
    /**
     * border for role tags
     */
    NSString* tag =[_login_attr objectForKey:@"role_tag"];
    if (!tag || [tag isEqualToString:@""]) {
        tag = @"请添加一个标签";
    }
    _currentTagLabel.text = tag;
    _currentTagLabel.textColor = [UIColor whiteColor];
    _currentTagLabel.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
//    _currentTagLabel.layer.borderWidth = 1.f;
//    _currentTagLabel.layer.borderColor = [UIColor blueColor].CGColor;
//    _currentTagLabel.font = [UIFont systemFontOfSize:24.f];
    [_currentTagLabel sizeToFit];
    _currentTagLabel.font = [UIFont systemFontOfSize:15.f];
    _currentTagLabel.textAlignment = NSTextAlignmentCenter;
//    _currentTagLabel.layer.cornerRadius = 10.5;
    _currentTagLabel.clipsToBounds = YES;
    
    /**
     * border for yes btn and no btn
     */
//    _yesBtn.layer.borderWidth = 1.f;
//    _yesBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _yesBtn.layer.cornerRadius = 25.f;
    _yesBtn.clipsToBounds = YES;
    _yesBtn.backgroundColor = [UIColor colorWithRed:0.3126 green:0.8529 blue:0.7941 alpha:1.f];
    [_yesBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:0.8] forState:UIControlStateNormal];

//    _noBtn.layer.borderWidth = 1.f;
//    _noBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _noBtn.layer.cornerRadius = 25.f;
    _noBtn.clipsToBounds = YES;
    _noBtn.backgroundColor = [UIColor colorWithRed:0.3126 green:0.8529 blue:0.7941 alpha:1.f];
    [_noBtn setTitleColor:[UIColor colorWithWhite:1.f alpha:0.8] forState:UIControlStateNormal];
   
//    UILabel* label_t = [[UILabel alloc]init];
//    label_t.text = @"圈子";
//    label_t.textColor = [UIColor whiteColor];
//    [label_t sizeToFit];
    UIImageView* title_img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 25)];
    title_img.image = [UIImage imageNamed:[resourceBundle pathForResource:@"DongDaHeaderLogo" ofType:@"png"]];
    self.navigationItem.titleView = title_img;
   
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString* filepath = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, 13, 20);
    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
    [barBtn addTarget:self action:@selector(didPopViewController) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
}

- (void)didPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews {
    CGPoint ori = _currentTagLabel.center;
    
    _currentTagLabel.bounds = CGRectMake(0, 0, _currentTagLabel.bounds.size.width + 16, _currentTagLabel.bounds.size.height + 8);
    _currentTagLabel.center = ori;
    
    _currentTagLabel.layer.cornerRadius = _currentTagLabel.bounds.size.height / 2;
    
//    CGFloat offset_y = _yesBtn.center.y;
//    CGFloat offset_x = [UIScreen mainScreen].bounds.size.width / 2;
//    
//    _yesBtn.center = CGPointMake(offset_x , offset_y);
//    _noBtn.center = CGPointMake(offset_x - 100, offset_y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- 
- (IBAction)didSelectMeButton {

    NSString* user_id = (NSString*)[_login_attr objectForKey:@"user_id"];
    NSString* phoneNo = (NSString*)[_login_attr objectForKey:@"phoneNo"];
    [LoginToken removeTokenInContext:_lm.doc.managedObjectContext WithPhoneNum:phoneNo];
    LoginToken* token = [LoginToken createTokenInContext:_lm.doc.managedObjectContext withUserID:user_id andAttrs:_login_attr];
    
    [_lm setCurrentUser:token];
    [_lm.doc.managedObjectContext save:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login success" object:nil];
//    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
//        NSLog(@"Login success");
//        [_lm reloadDataFromLocalDB];
//    }];
}

- (IBAction)didSelectCreateNewAccount {
    NSDictionary* tmp = [[NSDictionary alloc]init];
    if ([_lm sendCreateNewUserWithPhone:[_login_attr objectForKey:@"phoneNo"] toResult:&tmp]) {
        [self performSegueWithIdentifier:@"bindNewAccountSegue" sender:tmp];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"bindNewAccountSegue"]){
        ((NicknameInputViewController*)segue.destinationViewController).login_attr = (NSDictionary*)sender;
        ((NicknameInputViewController*)segue.destinationViewController).lm = _lm;
    }
}

@end
