//
//  SearchUserTagsController.m
//  BabySharing
//
//  Created by Alfred Yang on 17/07/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "SearchUserTagsController.h"
#import "INTUAnimationEngine.h"

#import "AppDelegate.h"
#import "RemoteInstance.h"

#import "UserAddNewTagDelegate.h"

typedef void(^queryRoleTagFinishBlock)(BOOL success, NSString* msg, NSArray* result);

@interface SearchUserTagsController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, addNewTagProtocol>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *queryView;

@property (strong, nonatomic, setter=setCurrentDelegate:) id<UITableViewDataSource, UITableViewDelegate> current_delegate;
@end

@implementation SearchUserTagsController {
    NSArray* test_tag_arr;
    
    NSArray* final_tag_arr;
    
    BOOL isSync;
    
    UserAddNewTagDelegate* add_delegate;
}

@synthesize delegate = _delegate;
@synthesize searchBar = _searchBar;
@synthesize queryView = _queryView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    for (UIView* v in _searchBar.subviews)
    {
        if ( [v isKindOfClass: [UITextField class]] )
        {
            UITextField *tf = (UITextField *)v;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            break;
        }
    }
  
    add_delegate = [[UserAddNewTagDelegate alloc]init];
    add_delegate.delegate = self;
    
    self.current_delegate = self;
//    _queryView.delegate = self;
//    _queryView.dataSource = self;
    isSync = NO;
   
    dispatch_queue_t qt = dispatch_queue_create("tag_query", nil);
    dispatch_async(qt, ^{
        [self queryRoleTagsWithStartIndex:0 andLenth:20 withFinishBlock:^(BOOL success, NSString *msg, NSArray *result) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    test_tag_arr = result;
                    _searchBar.text = @"";
                    [_searchBar resignFirstResponder];
                    final_tag_arr = test_tag_arr;
                    [_queryView reloadData];
                    isSync = YES;
                });
            }
        }];
    });
    
    
    test_tag_arr = @[];//@[@"a_tag1", @"b_tag2", @"c_tag3", @"d_tag4", @"e_tag5"];
    final_tag_arr = test_tag_arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)setCurrentDelegate:(id<UITableViewDataSource,UITableViewDelegate>)current_delegate {
    _current_delegate = current_delegate;
    _queryView.dataSource = _current_delegate;
    _queryView.delegate = _current_delegate;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- Search Bar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (!isSync) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"cannot edit until sync" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
    
    return isSync;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Search text change");
    
    if ([searchText isEqualToString:@""]) {
        final_tag_arr = test_tag_arr;
        self.current_delegate = self;
        
    } else {
        NSString *regex = [NSString stringWithFormat:@"^[%@]\\w*", searchText];
        NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
       
        NSMutableArray* tmp = [[NSMutableArray alloc]initWithCapacity:test_tag_arr.count];
        for (NSString* iter in test_tag_arr) {
            if ([p evaluateWithObject:iter]) {
                [tmp addObject:iter];
            }
        }
        final_tag_arr = [tmp copy];
        
        if (final_tag_arr.count == 0) self.current_delegate = add_delegate;
        else self.current_delegate = self;
    }
    
    [_queryView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    final_tag_arr = test_tag_arr;
    [_queryView reloadData];
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger index = indexPath.row;
    
    [_delegate didSelectTag:[final_tag_arr objectAtIndex:index]];
    [self.navigationController popViewControllerAnimated:YES];
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
  
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage* img_0 = [UIImage imageNamed:[resourceBundle pathForResource:[NSString stringWithFormat:@"Tags"] ofType:@"png"]];
    
    cell.imageView.image = img_0;
    NSInteger index = indexPath.row;
    cell.textLabel.text = [final_tag_arr objectAtIndex:index];
    return cell;
}

- (IBAction)cancelBtnSelected {
    [_searchBar resignFirstResponder];
}

- (void)moveView:(float)move {
    static const CGFloat kAnimationDuration = 0.30; // in seconds
    CGRect rc_start = self.view.frame;
    CGRect rc_end = CGRectMake(rc_start.origin.x, rc_start.origin.y + move, self.view.frame.size.width, self.view.frame.size.height);
    [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                       delay:0.0
                                      easing:INTUEaseInOutQuadratic
                                     options:INTUAnimationOptionNone
                                  animations:^(CGFloat progress) {
                                      self.view.frame = INTUInterpolateCGRect(rc_start, rc_end, progress);
                                      
                                      // NSLog(@"Progress: %.2f", progress);
                                  }
                                  completion:^(BOOL finished) {
                                      // NOTE: When passing INTUAnimationOptionRepeat, this completion block is NOT executed at the end of each cycle. It will only run if the animation is canceled.
                                      NSLog(@"%@", finished ? @"Animation Completed" : @"Animation Canceled");
                                      //                                                         self.animationID = NSNotFound;
                                  }];
}

#pragma mark -- add new role tag
- (NSString*)getInputTagName {
    return _searchBar.text;
}

- (void)addNewTag:(NSString*)tag_name {
    NSLog(@"add new tag : %@", tag_name);
    
    dispatch_queue_t aq = dispatch_queue_create("add tag", nil);
    dispatch_async(aq, ^{

        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:app.lm.current_user_id forKey:@"user_id"];
        [dic setValue:app.lm.current_auth_token forKey:@"auth_token"];
        [dic setValue:tag_name forKey:@"tag_name"];
        
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
    
    [_delegate didSelectTag:tag_name];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
