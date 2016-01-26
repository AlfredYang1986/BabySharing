//
//  PhotoAddTagController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 13/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "PhotoAddTagController.h"
#import "FoundSearchHeader.h"
#import "FoundHotTagsCell.h"

@interface PhotoAddTagController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputView;
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgView;

@property (weak, nonatomic) IBOutlet UIView *f_bar;
@property (weak, nonatomic) IBOutlet UIView *inputContainer;
@end

@implementation PhotoAddTagController {
    UIView * tag_attr;
    UITableView* editView;
}

@synthesize tagImgView = _tagImgView;
@synthesize inputView = _inputView;
@synthesize type = _type;
@synthesize delegate = _delegate;
@synthesize tagImg = _tagImg;

@synthesize queryView = _queryView;
@synthesize confirmBtn = _confirmBtn;
@synthesize f_bar = _f_bar;
@synthesize inputContainer = _inputContainer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    self.view.backgroundColor = [UIColor blackColor];
    _inputView.delegate = self;
    [_inputView becomeFirstResponder];
    
    _tagImgView.image = _tagImg;
   
    _inputView.backgroundColor = [UIColor colorWithRed:0.8196 green:0.8275 blue:0.8314 alpha:1.f];
    _inputView.layer.cornerRadius = 12.f;
    _inputView.clipsToBounds = YES;
    _inputView.placeholder = @"输入照片上的时刻和地点";
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
//    NSString* filepath = [resourceBundle pathForResource:@"Previous" ofType:@"png"];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:filepath] style:UIBarButtonItemStylePlain target:self action:@selector(didSelectBackBtn:)];
    
    tag_attr = [[UIView alloc]init];
    [self.view addSubview:tag_attr];

//    tag_attr.backgroundColor = [UIColor redColor];
    
    _confirmBtn.backgroundColor = [UIColor orangeColor];
    _confirmBtn.layer.cornerRadius = 4.f;
    _confirmBtn.clipsToBounds = YES;
    [_confirmBtn addTarget:self action:@selector(didSelectCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _queryView.backgroundColor = [UIColor blackColor];
    _queryView.delegate = self;
    _queryView.dataSource = self;
    _queryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    barBtn.center = CGPointMake(30 / 2 + 16, 49 / 2);
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:[resourceBundle pathForResource:@"Previous_simple" ofType:@"png"]].CGImage;
    layer.frame = CGRectMake(0, 0, 15, 21);
    layer.position = CGPointMake(30 / 2, 30 / 2);
    [barBtn.layer addSublayer:layer];
    [barBtn addTarget:self action:@selector(didPopControllerSelected) forControlEvents:UIControlEventTouchDown];
    [_f_bar addSubview:barBtn];
    
    UILabel* titleView = [[UILabel alloc]init];
    titleView.tag = -1;
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"添加标签";
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, 49 / 2);
    [_f_bar addSubview:titleView];
   
    [_queryView registerNib:[UINib nibWithNibName:@"FoundSearchHeader" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"found header"];
    [_queryView registerClass:[FoundHotTagsCell class] forCellReuseIdentifier:@"Hot Tag Cell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    editView = [[UITableView alloc]init];
    editView.hidden = YES;
    [self.view addSubview:editView];
}

- (void)viewDidLayoutSubviews {
    editView.frame = _queryView.frame;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didSelectBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offset = _inputView.frame.origin.y + _inputView.frame.size.height + 8;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - offset;
    tag_attr.frame = CGRectMake(0, offset, width, height);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}

- (void)didPopControllerSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate didSelectTag:textField.text andType:_type];
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)searchTextChanged {
    if (_inputView.text.length < 1) {
        editView.hidden = YES;
    } else {
        editView.hidden = NO;
    }
}

#pragma mark -- cancel btn
- (IBAction)didSelectCancelBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- uitable view delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FoundSearchHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"found header"];
   
    if (header == nil) {
        header = [[FoundSearchHeader alloc]initWithReuseIdentifier:@"found header"];
    }
   
    if (section == 0) {
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString* filepath = [resourceBundle pathForResource:@"found-hot-tag" ofType:@"png"];
        UIImage* img = [UIImage imageNamed:filepath];
        header.headImg.image = img;
        header.headImg.frame = CGRectMake(header.headImg.frame.origin.x, header.headImg.frame.origin.y, 25, 25);
        header.headImg.contentMode = UIViewContentModeScaleAspectFit;
        header.headLabell.text = @"使用过的标签";
        header.headLabell.textColor = [UIColor whiteColor];
        
    } else {
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString* filepath = [resourceBundle pathForResource:@"found-hot-tag" ofType:@"png"];
        UIImage* img = [UIImage imageNamed:filepath];
        header.headImg.image = img;
        header.headImg.frame = CGRectMake(header.headImg.frame.origin.x, header.headImg.frame.origin.y, 25, 25);
        header.headImg.contentMode = UIViewContentModeScaleAspectFit;
        header.headLabell.text = @"推荐标签";
        header.headLabell.textColor = [UIColor whiteColor];
    }
    
    header.backgroundView = [[UIImageView alloc] initWithImage:[PhotoAddTagController imageWithColor:[UIColor blackColor] size:header.bounds.size alpha:1.0]];
    return header;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(float)alpha {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, alpha);
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [FoundSearchHeader prefferredHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FoundHotTagsCell preferredHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoundHotTagsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Hot Tag Cell"];
    
    if (cell == nil) {
        cell = [[FoundHotTagsCell alloc]init];
    }
    
    cell.isDarkTheme = YES;
    [cell setHotTagsTest:@[@"abc", @"123"]];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}
@end
