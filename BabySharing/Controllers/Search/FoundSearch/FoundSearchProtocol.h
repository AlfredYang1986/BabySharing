//
//  FoundSearchProtocol.h
//  BabySharing
//
//  Created by Alfred Yang on 2/18/16.
//  Copyright © 2016 BM. All rights reserved.
//

#ifndef FoundSearchProtocol_h
#define FoundSearchProtocol_h

typedef void(^asyncFoundSearchBlock)(void);
//typedef void(^syncFoundSearchBlock)(void);
typedef void(^FoundSearchFinishBlock)(BOOL success, NSDictionary* preview);

@protocol FoundSearchProtocol <NSObject>

- (void)asyncQueryFoundSearchDataWithFinishBlock:(asyncFoundSearchBlock)block;
//- (void)syncQueryFoundSearchDataWithFinishBlock:(syncFoundSearchBlock)block;
- (void)resetCurrentSearchDataWithInput:(NSString*)input;
- (void)queryFoundTagSearchWithInput:(NSString*)input andFinishBlock:(FoundSearchFinishBlock)block;

@end

#endif /* FoundSearchProtocol_h */
