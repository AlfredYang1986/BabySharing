//
//  CycleAddKidsCell.m
//  BabySharing
//
//  Created by Alfred Yang on 17/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "CycleAddKidsCell.h"
#import "cycleDescriptionCell.h"

@interface CycleAddKidsCell () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@end

@implementation CycleAddKidsCell {
    NSMutableDictionary* kid_changed;
    
    NSArray* titles;
    NSArray* titles_cn;
    NSArray* str_horoscrope;
    
    UIButton* maleBtn;
    UIButton* femaleBtn;
    
    UIButton* addBtn;
}

@synthesize queryView = _queryView;
@synthesize kid = _kid;
@synthesize delegate = _delegate;

+ (CGFloat)preferredHeight {
    return 44 * 4;
}

- (void)awakeFromNib {
    // Initialization code
    _queryView.delegate = self;
    _queryView.dataSource = self;
    _queryView.scrollEnabled = NO;

    titles = @[@"age", @"horoscrope", @"gender", @"school"];
    titles_cn = @[@"年龄", @"星座", @"性别", @"学校"];
    
    [_queryView registerNib:[UINib nibWithNibName:@"CycleDescriptionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cycle description cell"];
    kid_changed = [_kid mutableCopy];
    if (kid_changed == nil) {
        kid_changed = [[NSMutableDictionary alloc]init];
    }

    str_horoscrope = @[@"Aries", @"Taurus", @"Gemini", @"Cancer", @"Leo", @"Virgo", @"Libra", @"Scorpio", @"Sagittarius", @"Capricorn", @"Aquarius", @"Pisces"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSDictionary*)getChangedKidData {
    return [kid_changed copy];
}

- (void)resetKidData:(NSDictionary*)dic_new {

    for (NSString* iter in dic_new.allKeys) {
        [kid_changed setObject:[dic_new objectForKey:iter] forKey:iter];
    }
    
    [_queryView reloadData];
}

- (BOOL)hasValue {
    return _kid != nil || kid_changed.count > 2;
}

#pragma mark -- table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_delegate selectKidsSchool];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return YES;
    } else return NO;
}

#pragma mark -- data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CycleDescriptionCell* cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cycle description cell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CycleDescriptionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"YYBoundle" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    
    @try {
        
        cell.titleLabel.text = [titles_cn objectAtIndex:indexPath.row];
      
        NSString* title = [titles objectAtIndex:indexPath.row];
        
        if ([title isEqualToString:@"gender"]) {
            if (maleBtn == nil) {
                maleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
                [maleBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Male" ofType:@"png"]] forState:UIControlStateNormal];
                [maleBtn addTarget:self action:@selector(maleBtnSelected) forControlEvents:UIControlEventTouchDown];
                
                maleBtn.layer.borderColor = [UIColor grayColor].CGColor;
                maleBtn.layer.cornerRadius = 4.f;
                maleBtn.clipsToBounds = YES;
            }
            
            if (femaleBtn == nil) {
                femaleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
                [femaleBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Female" ofType:@"png"]] forState:UIControlStateNormal];
                [femaleBtn addTarget:self action:@selector(femaleBtnSelected) forControlEvents:UIControlEventTouchDown];

                femaleBtn.layer.borderColor = [UIColor grayColor].CGColor;
                femaleBtn.layer.cornerRadius = 4.f;
                femaleBtn.clipsToBounds = YES;
            }
            
            [maleBtn removeFromSuperview];
            [femaleBtn removeFromSuperview];
            
            [cell addSubview:maleBtn];
            maleBtn.center = CGPointMake(cell.center.x + 40, cell.center.y);
            
            [cell addSubview:femaleBtn];
            femaleBtn.center = CGPointMake(cell.center.x - 40, cell.center.y);
        }
        
        if ([title isEqualToString:@"school"]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSObject* val = [kid_changed objectForKey:title];
        if ([val isKindOfClass:[NSString class]]) {
            cell.descriptionLabel.text = (NSString*)val;
        } else if ([val isKindOfClass:[NSNumber class]]) {
            if ([title isEqualToString:@"horoscrope"]) {
                cell.descriptionLabel.text = [str_horoscrope objectAtIndex:((NSNumber*)val).intValue];
            } else if ([title isEqualToString:@"gender"]) {
                if (((NSNumber*)val).intValue == 0) {
                    [self femaleBtnSelected];
                } else {
                    [self maleBtnSelected];
                }
                
            } else {
                cell.descriptionLabel.text = [NSString stringWithFormat:@"%d", ((NSNumber*)val).intValue];
            }
        }
    }
    @catch (NSException *exception) {
//        cell.titleLabel.text = @"";
//        
//        if (addBtn == nil) {
//            addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//            [addBtn setImage:[UIImage imageNamed:[resourceBundle pathForResource:@"Plus" ofType:@"png"]] forState:UIControlStateNormal];
//            [addBtn addTarget:self action:@selector(addKidsBtnSelected) forControlEvents:UIControlEventTouchDown];
//            
//            addBtn.layer.borderWidth = 1.f;
//            addBtn.layer.borderColor = [UIColor blueColor].CGColor;
//            addBtn.layer.cornerRadius = 15.f;
//            addBtn.clipsToBounds = YES;
//        }
//        
//        [addBtn removeFromSuperview];
//        [cell addSubview:addBtn];
//        addBtn.center = CGPointMake(30, cell.center.y);
    }
    return cell;
}

- (void)maleBtnSelected {
    maleBtn.selected = YES;
    femaleBtn.selected = NO;

    maleBtn.layer.borderWidth = 1.f;
    femaleBtn.layer.borderWidth = 0.f;

    [kid_changed setObject:[NSNumber numberWithInt:1] forKey:@"gender"];
}

- (void)femaleBtnSelected {
    maleBtn.selected = NO;
    femaleBtn.selected = YES;

    maleBtn.layer.borderWidth = 0.f;
    femaleBtn.layer.borderWidth = 1.f;
    
    [kid_changed setObject:[NSNumber numberWithInt:0] forKey:@"gender"];
}

- (void)addKidsBtnSelected {
    
}
@end
