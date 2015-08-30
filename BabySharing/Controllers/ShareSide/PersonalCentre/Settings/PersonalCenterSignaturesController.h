//
//  PersonalCenterSignaturesController.h
//  BabySharing
//
//  Created by Alfred Yang on 30/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonalSignatureProtocol <NSObject>
- (void)signatureDidChanged:(NSString*)signature;
@end

@interface PersonalCenterSignaturesController : UIViewController

@property (nonatomic, weak) id<PersonalSignatureProtocol> delegate;
@property (nonatomic, weak) NSString* ori_signature;
@end
