//
//  PersonalSettingController.m
//  BabySharing
//
//  Created by Alfred Yang on 3/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PersonalSettingController.h"
#include <vector>
#import "PersonalSettingCell.h"
#import "PersonalChangeScreenNameController.h"
//#import "SearchUserTagsController.h"
#import "SearchViewController.h"
#import "SearchRoleTagDelegate.h"
#import "AppDelegate.h"
#import "CycleAddDescriptionViewController.h"
#import "PersonalCenterSignaturesController.h"
#import "SGActionView.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"
#import "LoginModel.h"

@interface PersonalSettingController () <UITableViewDataSource, UITableViewDelegate, chanageScreenNameProtocol, /*SearchUserTagControllerDelegate,*/ PersonalSignatureProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SearchActionsProtocol>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@end

@implementation PersonalSettingController {
    NSArray* data;
    std::vector<SEL> functions;
    NSArray* title;
}

@synthesize current_auth_token = _current_auth_token;
@synthesize current_user_id = _current_user_id;
@synthesize queryView = _queryView;
@synthesize dic_profile_details = _dic_profile_details;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data = @[@"头像", @"昵称", @"角色", @"", @"个性签名", @"", @"自己的描述", @"", @"账号绑定"];
//    data = @[@"头像", @"", @"昵称", @"", @"角色", @"", @"个性签名", @"", @"自己的描述", @"", @"账号绑定"];
    title = @[@"screen_photo", @"screen_name", @"role_tag", @"", @"signature", @"", @"自己的描述", @"", @"账号绑定"];
//    title = @[@"screen_photo", @"", @"screen_name", @"", @"role_tag", @"", @"signature", @"", @"自己的描述", @"", @"账号绑定"];
    
    functions.push_back(@selector(screenPhotoSelected));
    functions.push_back(@selector(screenNameSelected));
    functions.push_back(@selector(roleTagSelected));
    functions.push_back(nil);
    functions.push_back(@selector(personalSignSelected));
    functions.push_back(nil);
    functions.push_back(@selector(personalDescriptionSelected));
    functions.push_back(nil);
    functions.push_back(@selector(accountBoundSelected));

//    _queryView.scrollEnabled = NO;
    [_queryView setSeparatorColor:[UIColor clearColor]];
    
    [_queryView registerNib:[UINib nibWithNibName:@"PersonalSettingCell" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"personal setting cell"];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"个人信息";
//    label.textColor = [UIColor whiteColor];
    label.textColor = [UIColor lightGrayColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
   
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 32, 30, 25)];
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"DongDaBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    NSString* filepath = [resourceBundle pathForResource:@"Previous_blue" ofType:@"png"];
    NSString* filepath = [resourceBundle pathForResource:@"dongda_back" ofType:@"png"];
    CALayer * layer = [CALayer layer];
    layer.contents = (id)[UIImage imageNamed:filepath].CGImage;
    layer.frame = CGRectMake(-15, 0, 25, 25);
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
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"addScreenName"]) {
        ((PersonalChangeScreenNameController*)segue.destinationViewController).delegate = self;
        ((PersonalChangeScreenNameController*)segue.destinationViewController).ori_screen_name = [self.dic_profile_details objectForKey:@"screen_name"];
    } else if ([segue.identifier isEqualToString:@"signature"]) {
        ((PersonalCenterSignaturesController*)segue.destinationViewController).ori_signature = [self.dic_profile_details objectForKey:@"signature"];
    }
}

#pragma mark - uitableview delegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![[data objectAtIndex:indexPath.row] isEqualToString:@""];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self performSelector:functions[indexPath.row] withObject:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PersonalSettingCell preferredHeightWithImage:indexPath.row == 0];
}

#pragma mark -- uitableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return data.count;
//    return 5;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    PersonalSettingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"personal setting cell"];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PersonalSettingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell changeCellTitile:[data objectAtIndex:indexPath.row]];
    
    id content = [self.dic_profile_details objectForKey:[title objectAtIndex:indexPath.row]];
    if (content != nil) {
        if (indexPath.row == 0) {
            [cell changeCellImage:content];
        } else {
            [cell changeCellContent:content];
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    if (indexPath.row % 2 == 1) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(8, [PersonalSettingCell preferredHeightWithImage:indexPath.row == 0] - 1, [UIScreen mainScreen].bounds.size.width, 1);
    [cell.layer addSublayer:line];
    
    return cell;
}

#pragma mark -- change screen name
- (void)didChangeScreenName:(NSString *)name {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setObject:name forKey:@"screen_name"];
    [_delegate personalDetailChanged:[dic copy]];
    [_queryView reloadData];
}

#pragma mark -- change signature
- (void)signatureDidChanged:(NSString *)signature {
     NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setObject:signature forKey:@"siganiture"];
    [_delegate personalDetailChanged:[dic copy]];
//    [_queryView reloadData];
}

#pragma mark -- change role tag
- (void)didSelectTag:(NSString*)tags {
    
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:tags forKey:@"role_tag"];

    [dic setValue:app.lm.current_auth_token forKey:@"auth_token"];
    [dic setValue:app.lm.current_user_id forKey:@"user_id"];
    
    if ([app.lm updateUserProfile:[dic copy]]) {
        
        [_delegate personalDetailChanged:[dic copy]];
        [_queryView reloadData];
    } else {
        NSLog(@"change role tag error");
    }
}

#pragma mark -- functions 
- (void)screenPhotoSelected {
    [SGActionView showSheetWithTitle:@"" itemTitles:@[@"打开照相机", @"从相册中选择", @"取消"] selectedIndex:-1 selectedHandle:^(NSInteger index) {
        switch (index) {
            case 0:
                [self openAppCamera];
                break;
            case 1:
                [self openCameraRoll];
                break;
            default:
                break;
        }
    }];
}

- (void)openCameraRoll {
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:^{
        
    }];
}

- (void)openAppCamera {
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
    //        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    }
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
    }
    
    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
//    [self presentModalViewController:picker animated:YES];//进入照相界面 废弃
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self updateImage:image];
}

//完成拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (image != nil) {
        [self updateImage:image];
    }
}

//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateImage:(UIImage *)image {
    dispatch_queue_t aq = dispatch_queue_create("weibo profile img queue", nil);
    dispatch_async(aq, ^{
        /**
         * 1. save the img to local
         */
        UIImage* img = image;
        if (img) {
            NSString* img_name = [TmpFileStorageModel generateFileName];
            [TmpFileStorageModel saveToTmpDirWithImage:img withName:img_name];
            
            /**
             * 2. change img_name in the server
             */
            AppDelegate* app = [UIApplication sharedApplication].delegate;
            LoginModel* lm = app.lm;
            
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:[lm getCurrentAuthToken] forKey:@"auth_token"];
            [dic setValue:[lm getCurrentUserID] forKey:@"user_id"];
            [dic setValue:img_name forKey:@"screen_photo"];
            //            [lm updateUserProfile:[dic copy]];
            if ([lm updateUserProfile:[dic copy]]) {
                /**
                 * 4. refresh UI
                 */
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [_delegate personalDetailChanged:[dic copy]];
                    [_queryView reloadData];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"照片修改成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [alert show];
                });
            }
            
            /**
             * 3. updata picture
             */
            dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
            dispatch_async(post_queue, ^(void){
                [RemoteInstance uploadPicture:img withName:img_name toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_UPLOAD]] callBack:^(BOOL successs, NSString *message) {
                    if (successs) {
                        NSLog(@"post image success");
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        [alert show];
                    }
                }];
            });
        }
    });
}

- (void)screenNameSelected {
    [self performSegueWithIdentifier:@"addScreenName" sender:nil];
}

- (void)roleTagSelected {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SearchUserTagsController* sut = [storyboard instantiateViewControllerWithIdentifier:@"SearchPickRoleTags"];
//    sut.delegate = self;
//    
//    [self.navigationController pushViewController:sut animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SearchViewController" bundle:nil];
    SearchViewController* svc = [storyboard instantiateViewControllerWithIdentifier:@"Search"];
    SearchRoleTagDelegate* sd = [[SearchRoleTagDelegate alloc]init];
    sd.delegate = svc;
    sd.actions = self;
    [self.navigationController pushViewController:svc animated:YES];
    svc.delegate = sd;
}

- (void)personalSignSelected {
    [self performSegueWithIdentifier:@"signature" sender:nil];
}

- (void)personalDescriptionSelected {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CycleAddDescriptionViewController* cad = [storyboard instantiateViewControllerWithIdentifier:@"DescriptionController"];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    cad.lm = app.lm;
    
    [self.navigationController pushViewController:cad animated:YES];
}

- (void)accountBoundSelected {

}

#pragma mark -- search actions
- (void)didSelectItem:(NSString*)item {
    [self didSelectTag:item];
    [self.navigationController popToViewController:self animated:YES];
}

- (void)addNewItem:(NSString*)item {
    dispatch_queue_t aq = dispatch_queue_create("add tag", nil);
    dispatch_async(aq, ^{
        
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:app.lm.current_user_id forKey:@"user_id"];
        [dic setValue:app.lm.current_auth_token forKey:@"auth_token"];
        [dic setValue:item forKey:@"tag_name"];
        
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:ROLETAGS_ADD_ROLETAGE]];
        
        if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
            NSString* msg = [result objectForKeyedSubscript:@"result"];
            NSLog(@"query role tags : %@", msg);
            
        } else {
            NSDictionary* reError = [result objectForKey:@"error"];
            NSString* msg = [reError objectForKey:@"message"];
            
            NSLog(@"query role tags error : %@", msg);
        }
    });
    
    [self didSelectTag:item];
    [self.navigationController popToViewController:self animated:YES];
}

- (NSString*)getControllerTitle {
    return @"添加你的角色";
}

- (UINavigationController*)getViewController {
    return self.navigationController;
}
@end
