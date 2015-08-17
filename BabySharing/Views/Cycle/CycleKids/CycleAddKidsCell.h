//
//  CycleAddKidsCell.h
//  BabySharing
//
//  Created by Alfred Yang on 17/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CycleAddKisCellProtocol <NSObject>
- (void)selectKidsSchool;
- (void)addKidsBtnSelected;
@end

@interface CycleAddKidsCell : UITableViewCell

@property (nonatomic, strong) NSMutableDictionary* kid;
@property (nonatomic, weak) id<CycleAddKisCellProtocol> delegate;

+ (CGFloat)preferredHeight;

- (NSDictionary*)getChangedKidData;
- (void)resetKidData:(NSDictionary*)dic_new;

- (BOOL)hasValue;
@end
