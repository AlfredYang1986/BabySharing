//
//  PhotoPreVIewEditVIew.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 11/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EffectTypePaste,
    EffectTypePhoto,
} EffectType;

struct effect_protocol {
    EffectType type;
    const char* name;
    CGImageRef img;
};

@protocol PhotoPreViewEditProtocol <NSObject>
- (void)didSelectOneEffectBtn:(struct effect_protocol)effect;
@end

@interface PhotoPreViewEditView : UIView

@property (nonatomic, weak) UISegmentedControl * sg;
@property (nonatomic, weak) id<PhotoPreViewEditProtocol> delegate;

- (void)layoutMySelf;
- (void)addControllButtons:(NSArray*)buttons andType:(EffectType)type;
- (void)addControllButtonsWithImage:(NSArray*)buttons andType:(EffectType)type;
@end
