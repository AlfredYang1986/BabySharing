//
//  ContentCardView.h
//  BabySharing
//
//  Created by Alfred Yang on 28/11/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCardView : UIView
@property (weak, nonatomic) IBOutlet UITableView *queryView;
@property (strong, nonatomic) CALayer* shadow;
@end
