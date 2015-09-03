//
//  CycleAddSchoolViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 13/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addSchoolProtocol <NSObject>

- (void)addSchool:(NSString*)school_name;
@end

@interface CycleAddSchoolViewController : UIViewController

@property (nonatomic, weak) id<addSchoolProtocol> delegate;
@property (nonatomic, weak) NSString* ori_school_name;
@end
