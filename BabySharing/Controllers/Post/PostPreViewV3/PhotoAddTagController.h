//
//  PhotoAddTagController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 13/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTagView.h"

@protocol addingTagsProtocol <NSObject>

- (void)didSelectTag:(NSString*)tag andType:(TagType)type;
@end

@interface PhotoAddTagController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) UIImage* tagImg;
@property (nonatomic) TagType type;
@property (nonatomic, weak) id<addingTagsProtocol> delegate;
@end
