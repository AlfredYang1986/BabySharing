//
//  CycleAddDOBViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 13/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Horoscrope) {
    Aries,
    Taurus,
    Gemini,
    Cancer,
    Leo,
    Virgo,
    Libra,
    Scorpio,
    Sagittarius,
    Capricorn,
    Aquarius,
    Pisces
};

@protocol addDOBProtocol <NSObject>
- (void)didChangeDOB:(NSDate*)dob andAge:(NSInteger)age andHoroscrope:(Horoscrope)horoscrope;
@end

@interface CycleAddDOBViewController : UIViewController

@property (nonatomic, weak) id<addDOBProtocol> delegate;
@property (nonatomic, weak) NSMutableDictionary* dic_description;
@end
