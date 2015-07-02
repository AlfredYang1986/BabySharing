//
//  ChatViewOwnerCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewCell.h"

@interface ChatViewOwnerCell : ChatViewCell <ChatViewCellProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;
@end
