//
//  HomeTagsController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 19/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "HomeTagsController.h"
#import "AppDelegate.h"
#import "QueryModel.h"
#import "QueryContent.h"
#import "TagQueryCell.h"

@interface HomeTagsController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@property (weak, nonatomic) IBOutlet UIButton *contentBtn;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@end

@implementation HomeTagsController {
    NSArray* content_arr;
}

@synthesize tag_name = _tag_name;
@synthesize tag_type = _tag_type;

@synthesize imgView = _imgView;
@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentBtn.layer.borderWidth = 1.f;
    _contentBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _contentBtn.layer.cornerRadius = 8.f;
    _contentBtn.layer.masksToBounds = YES;
    
    _userBtn.layer.borderWidth = 1.f;
    _userBtn.layer.borderColor = [UIColor blueColor].CGColor;
    _userBtn.layer.cornerRadius = 8.f;
    _userBtn.layer.masksToBounds = YES;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString * filePath = nil;
    switch (_tag_type) {
        case 0:
            filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"Location"] ofType:@"png"];
            break;
        case 1:
            filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"Time"] ofType:@"png"];
            break;
        case 2:
            filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"Tag"] ofType:@"png"];
            break;
            
        default:
            filePath = [resourceBundle pathForResource:[NSString stringWithFormat:@"Tag"] ofType:@"png"];
            break;
    }
    _imgView.backgroundColor = [UIColor clearColor];
    _imgView.image = [UIImage imageNamed:filePath];
    
   
    dispatch_queue_t aq = dispatch_queue_create("query tag content queue", nil);
    dispatch_async(aq, ^{
        [self refreshTagData];
    });
   
    /**
     * comments header and footer
     */
    [_queryView registerClass:[TagQueryCell class] forCellReuseIdentifier:@"tag cell"];
    
    UILabel* label_t = [[UILabel alloc]init];
    label_t.text = @"tags";
    label_t.textColor = [UIColor whiteColor];
    [label_t sizeToFit];
    self.navigationItem.titleView = label_t;
   
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    NSString* filepath = [resourceBundle pathForResource:@"Previous_blue" ofType:@"png"];
    NSString* filepath = [resourceBundle pathForResource:@"Previous_simple" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(0, 0, 25, 25);
    layer.position = CGPointMake(10, barBtn.frame.size.height / 2);
    [barBtn.layer addSublayer:layer];
//    [barBtn setBackgroundImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
//    [barBtn setImage:[UIImage imageNamed:filepath] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didPopControllerBtnSelected) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barBtn];
}

- (void)didPopControllerBtnSelected {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- query tag content
- (void)refreshTagData {
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.tm queryTagContentsByUser:app.lm.current_user_id withToken:app.lm.current_auth_token andTagType:_tag_type andTagName:_tag_name withStartIndex:0 finishedBlock:^(BOOL success){
        if (success) {
            content_arr = app.tm.querydata;
            dispatch_async(dispatch_get_main_queue(), ^{
                content_arr = app.tm.querydata;
                [_queryView reloadData];
            });
        }
    }];
}

- (void)appendTagData {
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSInteger cur_total = content_arr.count;
    [app.tm appendTagContentsByUser:app.lm.current_user_id withToken:app.lm.current_auth_token andTagType:_tag_type andTagName:_tag_name withStartIndex:cur_total finishedBlock:^(BOOL success){
        if (success) {
            content_arr = app.tm.querydata;
            dispatch_async(dispatch_get_main_queue(), ^{
                content_arr = app.tm.querydata;
                [_queryView reloadData];
            });
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selet row");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TagQueryCell getPreferHeight];
}

#pragma mark -- table view datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TagQueryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tag cell"];
    
    if (cell == nil) {
        cell = [[TagQueryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tag cell"];
    }
   
    NSInteger line = [TagQueryCell getRowItemCount];
    NSArray* arr_content = [content_arr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row * line, MIN(line- 1, content_arr.count ))]];
    [cell setRangeContent:arr_content];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return content_arr.count == 0 ? 0 : content_arr.count / [TagQueryCell getRowItemCount] + 1;
}

#pragma mark -- button action
- (IBAction)didSelectContentBtn {
    
    if (_contentBtn.highlighted == YES) {
        return;
    }
    
    _contentBtn.highlighted = YES;
    _userBtn.highlighted = NO;
}

- (IBAction)didSelectUserBtn {

    if (_userBtn.highlighted == YES) {
        return;
    }
    _contentBtn.highlighted = NO;
    _userBtn.highlighted = YES;
}
@end
