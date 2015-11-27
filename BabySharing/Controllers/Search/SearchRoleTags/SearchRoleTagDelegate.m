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

typedef void(^queryRoleTagFinishBlock)(BOOL success, NSString* msg, NSArray* result);

@implementation SearchRoleTagDelegate {
//    NSArray* role_data;
    NSArray* test_tag_arr;
    NSArray* final_tag_arr;
   
    BOOL isSync;
    
    SearchAddRoleTagDelegate* add_delegate;
}

@synthesize delegate = _delegate;
@synthesize actions = _actions;

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

- (void)queryRoleTagsWithStartIndex:(NSInteger)skip andLenth:(NSInteger)take withFinishBlock:(queryRoleTagFinishBlock)block {
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:app.lm.current_user_id forKey:@"user_id"];
    [dic setValue:app.lm.current_auth_token forKey:@"auth_token"];
    
    [dic setValue:[NSNumber numberWithInteger:skip] forKey:@"skit"];
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

- (NSString*)getControllerTitle {
    return [_actions getControllerTitle];
}

#pragma mark -- Dongda Search Bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (!isSync) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"cannot edit until sync" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([searchText isEqualToString:@""]) {
        final_tag_arr = test_tag_arr;
//        self.current_delegate = self;
//        [_searchBar resignFirstResponder];
        
    } else {
//        NSString *regex = [NSString stringWithFormat:@"^[%@]\\w*", searchText];
        NSString *regex = [NSString stringWithFormat:@"^%@\\w*", searchText];
        NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
       
        NSMutableArray* tmp = [[NSMutableArray alloc]initWithCapacity:test_tag_arr.count];
        for (NSString* iter in test_tag_arr) {
            if ([p evaluateWithObject:iter]) {
                [tmp addObject:iter];
            }
        }
        final_tag_arr = [tmp copy];
        
//        if (final_tag_arr.count == 0) self.current_delegate = add_delegate;
//        else self.current_delegate = self;
    }
    
//    [_queryView reloadData];
    [_delegate needToReloadData];
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger index = indexPath.row;
    
    [_actions didSelectItem:[final_tag_arr objectAtIndex:index]];
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [test_tag_arr count];
    return [final_tag_arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
  
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    UIImage* img_0 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Tags"] ofType:@"png"]];
//    
//    cell.imageView.image = img_0;
    NSInteger index = indexPath.row;
    cell.textLabel.text = [final_tag_arr objectAtIndex:index];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.f];
    cell.textLabel.textColor = [UIColor colorWithRed:0.3126 green:0.7529 blue:0.6941 alpha:1.f];
    return cell;
}

#pragma mark -- search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SearchViewController" bundle:nil];
    SearchAddViewController* svc = [storyboard instantiateViewControllerWithIdentifier:@"SearchAdd"];
    SearchAddRoleTagDelegate* sd = [[SearchAddRoleTagDelegate alloc]init];
    sd.delegate = svc;
    sd.actions = self;
    [[_actions getViewController] pushViewController:svc animated:NO];
    svc.delegate = sd;
    [sd pushExistingData:test_tag_arr];
    return NO;
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
@end