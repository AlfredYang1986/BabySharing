//
//  CycleSyncDataProtocol.h
//  BabySharing
//
//  Created by Alfred Yang on 14/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#ifndef BabySharing_CycleSyncDataProtocol_h
#define BabySharing_CycleSyncDataProtocol_h

@protocol CycleSyncDataProtocol <NSObject>
- (void)detailInfoSynced:(BOOL)success;
@end

#endif
