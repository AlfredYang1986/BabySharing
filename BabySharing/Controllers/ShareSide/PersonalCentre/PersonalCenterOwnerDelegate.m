//
//  PersonalCenterOwnerDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 1/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "PersonalCenterOwnerDelegate.h"
#import "ProfileOverview.h"
#import "OwnerQueryModel.h"
#import "QueryContent+ContextOpt.h"

@interface PersonalCenterOwnerDelegate ()

@end

@implementation PersonalCenterOwnerDelegate

@synthesize delegate = _delegate;

#pragma mark -- UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ProfileOverView* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Profile Overview"];
        
        if (header == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileOverView" owner:self options:nil];
            header = [nib objectAtIndex:0];
        }
       
        [header setOwnerPhoto:[_delegate getOwnerPhotoName]];
        [header setLoation:[_delegate getOwnerLocation]];
        [header setRoleTag:[_delegate getOwnerRoleTag]];
        [header setFriendsCount:[_delegate getFriendsCount]];
        [header setShareCount:[_delegate getSharedCount]];
        [header setCycleCount:[_delegate getCycleCount]];
        [header setPersonalSign:[_delegate getOwnerSign]];
        
        return header;
        
    } else return nil;
}

#pragma mark -- UITableView DataSource 
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == 0 && [view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).tintColor = [UIColor whiteColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [ProfileOverView preferredHeight];
    } else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OwnerQueryModel* om = [_delegate getOM];
    return om.querydata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
   
    OwnerQueryModel* om = [_delegate getOM];
    QueryContent* tmp = [om.querydata objectAtIndex:indexPath.row];
    
    cell.textLabel.text = tmp.owner_name;
    
    return cell;
}

@end
