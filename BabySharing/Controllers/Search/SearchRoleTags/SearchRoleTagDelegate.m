//
//  SearchRoleTagDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 20/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "SearchRoleTagDelegate.h"
#import "AppDelegate.h"
#import "RemoteInstance.h"
#import "ModelDefines.h"
#import "SearchAddRoleTagDelegate.h"
#import "SearchAddViewController.h"

#import "FoundHotTagsCell.h"
#import "FoundSearchHeader.h"
#import "HomeTagsController.h"

#import "SearchViewController.h"

#import "SearchAddRoleTagDelegate.h"

typedef void(^queryRoleTagFinishBlock)(BOOL success, NSString* msg, NSArray* result);

@interface SearchRoleTagDelegate () <FoundHotTagsCellDelegate>

@end

@implementation SearchRoleTagDelegate {
//    NSArray* role_data;
    NSArray* test_tag_arr;
    NSArray* final_tag_arr;
   
    BOOL isSync;
    
    SearchAddRoleTagDelegate* add_delegate;
}

@synthesize delegate = _delegate;
@synthesize actions = _actions;

@synthesize controller = _controller;

#pragma mark -- search protocol
//- (void)dataWithCallBack:(SearchCallback)block {
- (void)collectData {
    if (test_tag_arr == nil) {
        dispatch_queue_t qt = dispatch_queue_create("tag_query", nil);
        dispatch_async(qt, ^{
            [self queryRoleTagsWithStartIndex:0 andLenth:20 withFinishBlock:^(BOOL success, NSString *msg, NSArray *result) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        test_tag_arr = result;
//                        _searchBar.text = @"";
//                        [_searchBar resignFirstResponder];
                        final_tag_arr = test_tag_arr;
                        [_delegate needToReloadData];
                        isSync = YES;
//                        block(YES, test_tag_arr);
                    });
                }
            }];
        });
    
    } else  {
//        block(YES, test_tag_arr);
    }
}

- (NSString*)getSearchPlaceHolder {
//    return @"搜索角色标签";
    return [_actions getPlaceHolder];
}

- (void)queryRoleTagsWithStartIndex:(NSInteger)skip andLenth:(NSInteger)take withFinishBlock:(queryRoleTagFinishBlock)block {
//    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:app.lm.current_user_id forKey:@"user_id"];
//    [dic setValue:app.lm.current_auth_token forKey:@"auth_token"];
    
    [dic setValue:[NSNumber numberWithInteger:skip] forKey:@"skip"];
    [dic setValue:[NSNumber numberWithInteger:take] forKey:@"take"];
    
    NSError * error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[dic copy] options:NSJSONWritingPrettyPrinted error:&error];
    
    NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:ROLETAGS_QUERY_ROLETAGS]];
    
    if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
        block(YES, nil, [result objectForKey:@"result"]);
        
    } else {
        NSDictionary* reError = [result objectForKey:@"error"];
        NSString* msg = [reError objectForKey:@"message"];
        
        NSLog(@"query role tags error : %@", msg);
        block(NO, msg, nil);
    }
}

- (NSArray*)enumedData {
    return final_tag_arr;
}

- (NSString*)enumedDataAtIndex:(NSInteger)index {
    return [final_tag_arr objectAtIndex:index];
}

- (NSString *)getControllerTitle {
    return [_actions getControllerTitle];
}




#pragma mark -- search bar delegate
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (!isSync) {
        return NO;
    } else return YES;
}

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SearchViewController" bundle:nil];
//    SearchAddViewController* svc = [storyboard instantiateViewControllerWithIdentifier:@"SearchAdd"];
//    SearchAddRoleTagDelegate* sd = [[SearchAddRoleTagDelegate alloc]init];
//    sd.delegate = svc;
//    sd.actions = self;
//    [[_actions getViewController] pushViewController:svc animated:NO];
//    svc.delegate = sd;
//    [sd pushExistingData:test_tag_arr withHeader:@""];
//    return NO;
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (!isSync) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"cannot edit until sync" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (searchText.length > 0) {
        SearchAddRoleTagDelegate* sd = [[SearchAddRoleTagDelegate alloc]init];
        ((SearchViewController*)self.controller).delegate = sd;
        sd.delegate = self;
        sd.actions = self;
        
        [sd pushExistingData:[final_tag_arr copy] withHeader:searchText];
        
        [((SearchViewController*)self.controller).queryView reloadData];
    }
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger index = indexPath.row;
    
    [_actions didSelectItem:[final_tag_arr objectAtIndex:index]];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [FoundSearchHeader prefferredHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FoundHotTagsCell preferredHeight];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FoundSearchHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"hot role header"];
    
    if (header == nil) {
        header = [[FoundSearchHeader alloc]initWithReuseIdentifier:@"hot role header"];
    }
    
    header.headLabell.text = @"选择或者添加一个你的角色";
    header.headLabell.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    header.headLabell.font = [UIFont systemFontOfSize:14.f];
    
    header.backgroundView = [[UIImageView alloc] initWithImage:[SearchRoleTagDelegate imageWithColor:[UIColor whiteColor] size:header.bounds.size alpha:1.0]];
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

#pragma mark -- table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [test_tag_arr count];
//    return [final_tag_arr count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FoundHotTagsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"hot role tags"];
    if (!cell) {
        cell = [[FoundHotTagsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hot role tags"];
    }
   
//    cell.isDarkTheme = YES;
    [cell setHotTagsText:final_tag_arr];
    cell.delegate = self;
//    cell.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    return cell;
}



#pragma mark -- actions delegate
- (UINavigationController*)getViewController {
    return [_actions getViewController];
}

- (void)needToReloadData {
    [_delegate needToReloadData];
}

- (NSString*)getUserInputString {
    return [_delegate getUserInputString];
}

- (NSString*)getAddSectionTitle {
    return [_delegate getAddSectionTitle];
}

- (void)didSelectItem:(NSString *)item {
    [_actions didSelectItem:item];
}

- (void)addNewItem:(NSString*)item {
    // TODO: something, then call actions
    [_actions addNewItem:item];
}

#pragma mark -- found
- (void)recommandTagBtnSelected:(NSString*)tag_name adnType:(NSInteger)tag_type {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    HomeTagsController* svc = [storyboard instantiateViewControllerWithIdentifier:@"TagSearch"];
//    svc.tag_name = tag_name;
//    svc.tag_type = tag_type;
//    
//    [_controller.navigationController setNavigationBarHidden:NO animated:YES];
//    [_controller.navigationController pushViewController:svc animated:YES];
}

- (void)recommandRoleTagBtnSelected:(NSString*)tag_name {
    [_actions didSelectItem:tag_name];
}
@end
