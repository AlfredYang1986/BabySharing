//
//  SearchSegDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#ifndef SearchSegDelegate_h
#define SearchSegDelegate_h

@class SearchSegView;
@class SearchSegView2;

@protocol SearchSegViewDelegate <NSObject>

@optional
- (void)segValueChanged:(SearchSegView*)seg;
- (void)segValueChanged2:(SearchSegView2*)seg;
@end
#endif /* SearchSegDelegate_h */
