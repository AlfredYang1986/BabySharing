//
//  AddingFriendsProtocol.h
//  BabySharing
//
//  Created by Alfred Yang on 1/09/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#ifndef BabySharing_AddingFriendsProtocol_h
#define BabySharing_AddingFriendsProtocol_h

@protocol AddingFriendsProtocol <NSObject>
- (BOOL)isDelegateReady;
- (void)filterFriendsWithString:(NSString*)searchText;
@end

@protocol AsyncDelegateProtocol <NSObject>
- (void)asyncDelegateIsReady:(id<UITableViewDataSource, UITableViewDelegate, AddingFriendsProtocol>)delegate;
@end
#endif
