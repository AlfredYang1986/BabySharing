//
//  QueryCellDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 18/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#ifndef QueryCellDelegate_h
#define QueryCellDelegate_h

@protocol QueryCellActionProtocol <NSObject>
- (void)didSelectLikeBtn:(id)content;
- (void)didSelectShareBtn:(id)content;
- (void)didSelectCommentsBtn:(id)content;

- (void)didSelectCollectionBtn:(id)content;
- (void)didSelectNotLikeBtn:(id)content;

@optional
- (void)didSelectScreenImg:(id)content;
@end
#endif /* QueryCellDelegate_h */
