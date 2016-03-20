//
//  ProfileViewDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 11/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "ModelDefines.h"
#ifndef BabySharing_ProfileViewDelegate_h
#define BabySharing_ProfileViewDelegate_h

typedef void(^ProfileViewDelegate)(UserPostOwnerConnections new_connections);

@protocol ProfileViewDelegate

- (void)chatBtnSelected;
- (void)followBtnSelected;
- (void)followBtnSelectedComplete:(ProfileViewDelegate)complete;
- (void)editBtnSelected;
- (void)segControlValueChangedWithSelectedIndex:(NSInteger)index;

@end
#endif
