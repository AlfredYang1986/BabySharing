//
//  PostViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 1/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumTableCell.h"
#import "DropDownView.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "AlbumActionProtocol.h"

@interface AlbumViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AlbumTableCellDelegate, DropDownDatasource, DropDownDelegate> 

@property (nonatomic, weak) id<AlbumActionDelegate> delegate;
@property (nonatomic)  BOOL isEditing;
@property (nonatomic, setter=setActionType:) AlbumControllerType actionType;

@property (nonatomic) BOOL allowMutiSelection;

- (void)dismissPosrViewController:(id)sender;
- (void)didSelectCameraBtn:(id)sender;
- (void)didSelectEidtBtn:(id)sender;

- (void)setActionType:(AlbumControllerType)actionType;
@end
