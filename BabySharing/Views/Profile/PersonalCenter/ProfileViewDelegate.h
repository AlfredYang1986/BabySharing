//
//  ProfileViewDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 11/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#ifndef BabySharing_ProfileViewDelegate_h
#define BabySharing_ProfileViewDelegate_h

@protocol ProfileViewDelegate
- (void)chatBtnSelected;
- (void)followBtnSelected;
- (void)editBtnSelected;
- (void)segControlValueChangedWithSelectedIndex:(NSInteger)index;
@end
#endif
