//
//  QueryCellDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 18/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#ifndef QueryCellDelegate_h
#define QueryCellDelegate_h

typedef void(^complete)(BOOL success);

@protocol QueryCellActionProtocol <NSObject>
- (void)didSelectLikeBtn:(id)content complete:(complete)complete;
- (void)didSelectShareBtn:(id)content;
//- (void)didSelectCommentsBtn:(id)content;
- (void)didSelectJoinGroupBtn:(id)content;

- (void)didSelectCollectionBtn:(id)content;
- (void)didSelectNotLikeBtn:(id)content complete:(complete)complete;

@optional
- (void)didSelectScreenImg:(id)content;
@end
#endif /* QueryCellDelegate_h */
