//
//  FoundSearchController.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "FoundSearchController.h"
#import "SearchSegView2.h"
#import "FoundSearchHeader.h"
#import "FoundHotTagsCell.h"
#import "FoundSearchResultCell.h"

#import "AppDelegate.h"
#import "FoundSearchModel.h"

#import "HomeTagsController.h"

#define SEARCH_BAR_HEIGHT   44
#define SEG_BAR_HEIGHT      44
#define MARGIN              8

#define STATUS_BAR_HEIGHT   20
#define TAB_BAR_HEIGHT      49

@interface FoundSearchController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (strong, nonatomic) SearchSegView2* seg;
@property (weak, nonatomic) FoundSearchModel* fm;
@property (weak, nonatomic) IBOutlet UITextField *inputArea;
@end

@implementation FoundSearchController {
    UIView* bkView;
}

@synthesize inputView = _inputView;
@synthesize queryView = _queryView;
@synthesize seg = _seg;
@synthesize fm = _fm;
@synthesize inputArea = _inputArea;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _queryView.delegate = self;
    _queryView.dataSource = self;
    
    _seg = [[SearchSegView2 alloc]initWithFrame:CGRectMake(0, 0, 100, 200)];
    [_seg addItemWithTitle:@"标签"];
    [_seg addItemWithTitle:@"角色"];
    _seg.selectedIndex = 0;
    _seg.margin_between_items = 30;
    [self.view addSubview:_seg];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _seg.frame = CGRectMake(0, 0, width, SEG_BAR_HEIGHT);
    _seg.backgroundColor = [UIColor whiteColor];
    
    _inputView.backgroundColor = [UIColor whiteColor];
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    NSString* search_filepath = [resourceBundle pathForResource:@"found-search-explore" ofType:@"png"];
    ((UIImageView*)[_inputView viewWithTag:-1]).image = [UIImage imageNamed:search_filepath];
    
    UIButton* tmp = (UIButton*)[_inputView viewWithTag:-2];
    tmp.backgroundColor = [UIColor orangeColor];
    [tmp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tmp setTitle:@"取消" forState:UIControlStateNormal];
    tmp.layer.cornerRadius = 4.f;
    tmp.clipsToBounds = YES;
    
    [tmp addTarget:self action:@selector(cancelSearchSelected) forControlEvents:UIControlEventTouchUpInside];
    
    _queryView.scrollEnabled = NO;
    _queryView.backgroundColor = [UIColor lightGrayColor];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [_queryView registerNib:[UINib nibWithNibName:@"FoundSearchHeader" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"found header"];
    [_queryView registerClass:[FoundHotTagsCell class] forCellReuseIdentifier:@"Hot Tag Cell"];
    [_queryView registerNib:[UINib nibWithNibName:@"FoundSearchResultCell" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"Search Result"];
    
    bkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    //    bkView.backgroundColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    bkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bkView];
    [self.view bringSubviewToFront:bkView];

    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _fm = app.fm;
    
    [self asyncQueryFoundSearchData];
    _inputArea.delegate = self;
}

- (void)asyncQueryFoundSearchData {
    dispatch_queue_t ap = dispatch_queue_create("found search init", nil);
    dispatch_async(ap, ^{
        [_fm queryRecommandTagsWithFinishBlock:^(BOOL success, NSArray* arr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_queryView reloadData];
            });

        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat offset_y = STATUS_BAR_HEIGHT;
//    _inputView.frame = CGRectMake(0, offset_y, width, SEARCH_BAR_HEIGHT);
  
    offset_y += SEARCH_BAR_HEIGHT;
    _seg.frame = CGRectMake(0, offset_y, width, SEG_BAR_HEIGHT);
    
    offset_y += SEG_BAR_HEIGHT + MARGIN;
    _queryView.frame = CGRectMake(0, offset_y, width, height - offset_y - TAB_BAR_HEIGHT);
}

- (void)cancelSearchSelected {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return _fm.previewDic.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self queryHotTagCellInTableView:tableView];
    } else {
        return [self querySearchResultInTableView:tableView atIndex:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [FoundHotTagsCell preferredHeight];
    } else {
        return [FoundSearchResultCell preferredHeight];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
      
        FoundSearchResultCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeTagsController* svc = [storyboard instantiateViewControllerWithIdentifier:@"TagSearch"];
        svc.tag_name = cell.tag_name;
        svc.tag_type = cell.tag_type.integerValue;
        
        [self.navigationController pushViewController:svc animated:YES];
        
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell*)queryHotTagCellInTableView:(UITableView*)tableView {
    FoundHotTagsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Hot Tag Cell"];
    
    if (cell == nil) {
        cell = [[FoundHotTagsCell alloc]init];
    }
   
    [cell setHotTags:_fm.recommandsdata];
    return cell;
}

- (UITableViewCell*)querySearchResultInTableView:(UITableView*)tableView atIndex:(NSInteger)index {
    FoundSearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Search Result"];
    
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"FoundSearchResultCell" owner:self options:nil];
        cell = [nib firstObject];
    }
//    [cell setSearchResultCount:188];
    NSDictionary* dic = [_fm.previewDic objectAtIndex:index];
    [cell setSearchTag:[dic objectForKey:@"tag_name"] andType:[dic objectForKey:@"type"]];
    [cell setUserContentImages:[dic objectForKey:@"content"]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _fm.previewDic.count == 0 ? 1 : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FoundSearchHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"found header"];
   
    if (section == 0) {
        NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSString* filepath = [resourceBundle pathForResource:@"found-hot-tag" ofType:@"png"];
        UIImage* img = [UIImage imageNamed:filepath];
        header.headImg.image = img;
        header.headImg.frame = CGRectMake(header.headImg.frame.origin.x, header.headImg.frame.origin.y, 25, 25);
        header.headImg.contentMode = UIViewContentModeScaleAspectFit;
        header.headLabell.text = @"热门标签";
        
    } else {
        header.headLabell.text = @"搜索结果";
    }

    header.backgroundView = [[UIImageView alloc] initWithImage:[FoundSearchController imageWithColor:[UIColor whiteColor] size:header.bounds.size alpha:1.0]];
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

#pragma mark -- text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_fm queryFoundTagSearchWithInput:textField.text andFinishBlock:^(BOOL success, NSDictionary *preview) {
        [_queryView reloadData];
    }];
    
    [textField resignFirstResponder];
    return YES;
}
@end
