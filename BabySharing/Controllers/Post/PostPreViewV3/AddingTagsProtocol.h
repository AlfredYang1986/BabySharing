//
//  AddingTagsProtocol.h
//  BabySharing
//
//  Created by Alfred Yang on 2/22/16.
//  Copyright © 2016 BM. All rights reserved.
//

#ifndef AddingTagsProtocol_h
#define AddingTagsProtocol_h

@protocol addingTagsProtocol <NSObject>

- (void)didSelectTag:(NSString*)tag andType:(TagType)type;
@end

#endif /* AddingTagsProtocol_h */
