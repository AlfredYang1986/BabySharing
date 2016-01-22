//
//  PhotoTagEnumDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 1/22/16.
//  Copyright © 2016 BM. All rights reserved.
//

#ifndef PhotoTagEnumDefines_h
#define PhotoTagEnumDefines_h

typedef enum : NSUInteger {
    PhotoTagViewStatusRight,
    PhotoTagViewStatusLeft,
} PhotoTagViewStatus;

typedef enum : NSUInteger {
    TagTypeLocation,
    TagTypeTime,
    TagTypeTags,
    TagTypeBrand,
} TagType;

#endif /* PhotoTagEnumDefines_h */
