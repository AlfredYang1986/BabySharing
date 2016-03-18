//
//  FoundSearchController.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoundHotTagsCell.h"

@interface FoundSearchController : UIViewController <FoundHotTagsCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView* queryView;
@end
