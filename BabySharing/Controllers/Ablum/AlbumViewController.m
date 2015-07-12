//
//  PostViewController.m
//  YYBabyAndMother
//
//  Created by Alfred Yang on 1/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumTableCell.h"
#import "AlbumGridCell.h"
#import "DropDownView.h"
#import "DropDownItem.h"
//#import "PostPreViewController.h"
#import "PhotoPreViewController.h"

#import "AlbumModule.h"

#define PHONE_PER_LINE 3

@interface AlbumViewController ()
@property (weak, nonatomic) IBOutlet UITableView *photoTableView;

@end

@implementation AlbumViewController {
    NSArray* images_arr;
    NSMutableArray* images_select_arr;
    NSArray* album_name_arr;
    //    ALAssetsLibrary* assetsLibrary;
    
    //    UIBarButtonItem* doneBtn;
    //    UIBarButtonItem* selectBtn;
   
    BOOL bLoadData;
    DropDownView* dp;
    
    AlbumModule* am;
}

@synthesize delegate = _delegate;
@synthesize photoTableView = _photoTableView;
@synthesize isEditing = _isEditing;
@synthesize actionType = _actionType;

@synthesize allowMutiSelection = _allowMutiSelection;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image_cancel = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Cancel"] ofType:@"png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image_cancel style:UIBarButtonItemStylePlain target:self action:@selector(dismissPosrViewController:)];
 
    UIImage *image_earse = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Clear"] ofType:@"png"]];
    UIBarButtonItem* btn_1 = [[UIBarButtonItem alloc]initWithImage:image_earse style:UIBarButtonItemStylePlain target:self action:@selector(didSelectClearBtn:)];

    UIImage *image_next = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Next"] ofType:@"png"]];
    UIBarButtonItem* btn_2 = [[UIBarButtonItem alloc]initWithImage:image_next style:UIBarButtonItemStylePlain target:self action:@selector(didSelectPreView:)];
    self.navigationItem.rightBarButtonItems = @[btn_2,btn_1];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItem)UIBarButtonSystemItemCompose target:self action:@selector(didSelectClearBtn:)];
   
    images_arr = [[NSMutableArray alloc]init];
    images_select_arr = [[NSMutableArray alloc]init];
    album_name_arr = [[NSMutableArray alloc]init];
   
    [_photoTableView registerClass:[AlbumTableCell class] forCellReuseIdentifier:@"AlbumTableViewCell"];
   
    bLoadData = NO;
    am = [[AlbumModule alloc]init];
    
    /**
     * set drop down list view
     */
    dp = [[DropDownView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    dp.backgroundColor = [UIColor greenColor];
    [dp setTitle:@"Camera Roll" forState:UIControlStateNormal];
    self.navigationItem.titleView = dp;
    
    dp.datasource = self;
    dp.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPosrViewController:) name:@"post success" object:nil];
    
    _allowMutiSelection = NO;
}

- (void)setActionType:(AlbumControllerType)actionType {
    if (actionType == AlbumControllerTypePhoto || actionType == AlbumControllerTypeCompire) {
        [self enumPhoteAlumName];
//        [self enumAllSavedPhotes];
    } else if (actionType == AlbumControllerTypeMovie) {
        [dp setTitle:@"videos" forState:UIControlStateNormal];
        [self enumAllAssetWithProprty:ALAssetTypeVideo];
    }
    _actionType = actionType;
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

#pragma mark -- actions

- (void)dismissPosrViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectCameraBtn:(id)sender {
    [_delegate didCameraBtn:self];
}

#pragma mark -- table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [self performSegueWithIdentifier:@"DetailEvent" sender:indexPath];
    NSLog(@"selet row");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PostTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postTableViewCell"];
//    if (cell == nil) return 96;
//    else return [cell prefferCellHeight];
    if (indexPath.row == 0) {
        return 96;
    } else {
        CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
        return screen_width / 3;
    }
}

#pragma mark -- table view datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell"];
    
    if (cell == nil) {
        cell = [[AlbumTableCell alloc]init];
    }
    
    if (indexPath.row == 0) {
        cell.delegate = nil;
        [cell setUpContentViewWithImageURLs:[[NSArray alloc]init] atLine:-1 andType:_actionType];
    }

    else { //if (indexPath.row != 0) {
        cell.delegate = self;
        NSInteger row = indexPath.row - 1;
        if (row == 0) {
            NSArray* arr_content = [images_arr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHONE_PER_LINE, PHONE_PER_LINE - 1)]];
            [cell setUpContentViewWithImageURLs:arr_content atLine:row andType:_actionType];
        } else {
            NSArray* arr_content = [images_arr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * PHONE_PER_LINE - 1, PHONE_PER_LINE)]];
            [cell setUpContentViewWithImageURLs:arr_content atLine:row andType:_actionType];
        }
    }
  
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (bLoadData) return ((images_arr.count+ 1) / PHONE_PER_LINE) + 1;
    else return 0;
//    else return 5;
}

#pragma mark -- PostTableCellDelegate

- (void)didSelectOneImageAtIndex:(NSInteger)index {
    NSLog(@"select index %ld", (long)index);
    
    if (!_allowMutiSelection) {
        for (NSNumber* index in images_select_arr) {
            AlbumGridCell* tmp = [self queryCellByIndex:index.integerValue];
            [tmp setCellViewSelected:NO];
            [self didUnSelectOneImageAtIndex:index.integerValue];
            
        }
    }
    
    [images_select_arr addObject:[NSNumber numberWithInteger:index]];
}

- (void)didUnSelectOneImageAtIndex:(NSInteger)index {
    NSLog(@"unselect index %ld", (long)index);
    for (int i = 0; i < images_select_arr.count; ++i) {
        if (((NSNumber*)[images_select_arr objectAtIndex:i]).integerValue == index)
            [images_select_arr removeObjectAtIndex:i];
    }
}

- (AlbumGridCell*)queryCellByIndex:(NSInteger)index {
//    NSIndexPath* i = [NSIndexPath indexPathWithIndex:(index + 1) / 3 + 1];
    NSIndexPath* i = [NSIndexPath indexPathForRow:(index + 1) / 3 + 1 inSection:0];
//    AlbumTableCell* cell = [_photoTableView dequeueReusableCellWithIdentifier:@"AlbumTableViewCell" forIndexPath:i];
    AlbumTableCell* cell = (AlbumTableCell*)[_photoTableView cellForRowAtIndexPath:i];
   
    return [cell queryGridCellByIndex:(index + 1) % 3];
}

- (NSInteger)indexByRow:(NSInteger)row andCol:(NSInteger)col {
    return row * PHONE_PER_LINE + col - 1;
}

- (NSInteger)getViewsCount {
    return PHONE_PER_LINE;
}

- (void)didSelectCameraBtn {
    [_delegate didCameraBtn:self];
}
- (void)didSelectMovieBtn {
    [_delegate didMovieBtn:self];
}
- (void)didSelectCompareBtn {
    [_delegate didCompareBtn:self];
}

- (BOOL)isSelectedAtIndex:(NSInteger)index {
    for (int i = 0; i < images_select_arr.count; ++i) {
        if (((NSNumber*)[images_select_arr objectAtIndex:i]).integerValue == index)
            return YES;
    }
    return NO;
}

#pragma mark -- photo ablum access
- (void)enumPhoteAlumName {
    [am enumPhoteAlumNameWithBlock:^(NSArray *result) {
        album_name_arr = result;
    }];
    [self enumAllAssetWithProprty:ALAssetTypePhoto];
}

- (void)enumAllAssetWithProprty:(NSString*)type {
    bLoadData = NO;
    [am enumAllAssetWithProprty:type finishBlock:^(NSArray *result) {
        bLoadData = YES;
        images_arr = result;
        [_photoTableView reloadData];
    }];
}

//- (void)enumPhotoAblumByAlbumName:(NSString*)album_name {
- (void)enumPhotoAblumByAlbumName:(ALAssetsGroup*)group {
    bLoadData = NO;
    [am enumPhotoAblumByAlbumName:group finishBlock:^(NSArray *result) {
        bLoadData = YES;
        images_arr = result;
        [_photoTableView reloadData];
    }];
}

- (void)didSelectEidtBtn:(id)sender {
    if (_isEditing == NO) {
        _isEditing = YES;
    } else {
        _isEditing = NO;
        [_photoTableView reloadData];
    }
}

- (void)didSelectClearBtn:(id)sender {
    NSLog(@"clear button");
    [images_select_arr removeAllObjects];
    [_photoTableView reloadData];
}

#pragma mark -- DropDownDatasource

- (NSInteger)itemCount {
    return album_name_arr.count + 1;
}

- (UITableViewCell*)cellForRow:(NSInteger)row inTableView:(UITableView*)tableview {
    DropDownItem* cell = [tableview dequeueReusableCellWithIdentifier:@"drop item"];
    
    if (cell == nil) {
        cell = [[DropDownItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"drop item"];
    }
    
    if (row != 0) {
        ALAssetsGroup* group = [album_name_arr objectAtIndex:row - 1];
        NSString* album_name = [group valueForProperty:ALAssetsGroupPropertyName];
        cell.textLabel.text = album_name;
        cell.group = group;
    }

    return cell;
}

#pragma mark -- DropDownDelegate

- (void)didSelectCell:(UITableViewCell*)cell {
    DropDownItem* tmp = (DropDownItem*)cell;
    [self enumPhotoAblumByAlbumName:tmp.group];
    
    [dp removeTableView];
}

- (void)showContentsTableView:(UITableView*)tableview {
    NSInteger width = self.view.frame.size.width;
    NSInteger height = self.view.frame.size.height / 2;
    tableview.frame = CGRectMake(0, 44, width, height);
    
    [self.view addSubview:tableview];
}

#pragma mark -- PostPreView

- (IBAction)didSelectPreView:(id)sender {
//    [self performSegueWithIdentifier:@"PostPreView" sender:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PhotoPreView" bundle:nil];
    PhotoPreViewController* postNav = [storyboard instantiateViewControllerWithIdentifier:@"PhotoPreView"];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PostPreView" bundle:nil];
//    PostPreViewController* postNav = [storyboard instantiateViewControllerWithIdentifier:@"PostPreView"];
    
    NSMutableArray* ns = [[NSMutableArray alloc]init];
    for (int index = 0; index < images_select_arr.count; ++index) {
        NSNumber* i = [images_select_arr objectAtIndex:index];
        ALAsset* iter = [images_arr objectAtIndex:i.integerValue];
        ALAssetRepresentation* tmp = [iter defaultRepresentation];
        CGImageRef cgf = [tmp fullResolutionImage];
        [ns addObject:[UIImage imageWithCGImage:cgf scale:1.0 orientation:UIImageOrientationUp]];
    }
    postNav.photoArray = [ns copy];
//    postNav.type = PostPreViewPhote;
    [self.navigationController pushViewController:postNav animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"PostPreView"]) {
        if (images_select_arr.count != 0) {
            NSMutableArray* ns = [[NSMutableArray alloc]init];
            for (int index = 0; index < images_select_arr.count; ++index) {
                NSNumber* i = [images_select_arr objectAtIndex:index];
                ALAsset* iter = [images_arr objectAtIndex:i.integerValue];
                ALAssetRepresentation* tmp = [iter defaultRepresentation];
                CGImageRef cgf = [tmp fullResolutionImage];
                
                [ns addObject:[UIImage imageWithCGImage:cgf scale:1.0 orientation:UIImageOrientationUp]];
            }
            ((PhotoPreViewController*)[segue destinationViewController]).photoArray = [ns copy];
        } else {
            // TODO: alert view ...
        }
    }
}
@end
