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
    
    header.headLabell.text = @"热门角色";
//    header.headLabell.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
    header.headLabell.textColor = [UIColor whiteColor];
    header.headLabell.font = [UIFont systemFontOfSize:14.f];
        
    header.backgroundView = [[UIImageView alloc] initWithImage:[SearchRoleTagDelegate imageWithColor:[UIColor blackColor] size:header.bounds.size alpha:1.0]];
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
   
    cell.isDarkTheme = YES;
    [cell setHotTagsTest:final_tag_arr];
    cell.backgroundColor = [UIColor blackColor];
    
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
