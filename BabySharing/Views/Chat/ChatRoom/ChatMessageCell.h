//
//  ChatViewCell.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 9/06/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatViewCellProtocol <NSObject>
- (void)downloadImg:(UIImage*)image;
- (void)changeContent:(NSString*)content;
@end

@interface ChatMessageCell : UITableViewCell

@property (nonatomic, strong, setter=setUser:) NSString* user_id;
@property (nonatomic, strong, setter=setPhotoFile:) NSString* user_photo;
@property (nonatomic, strong, setter=setContextText:) NSString* chat_content;

@property (nonatomic, weak) id<ChatViewCellProtocol> delegate;

- (void)setUser:(NSString*)user;
- (void)setPhotoFile:(NSString*)photo;
- (void)setContextText:(NSString*)content;
@end
