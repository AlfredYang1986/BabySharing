//
//  PostInputViewController.h
//  YYBabyAndMother
//
//  Created by Alfred Yang on 4/01/2015.
//  Copyright (c) 2015 YY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDefine.h"

@interface PostInputViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *messageInput;
@property (nonatomic, weak) NSArray* photos;
@property (nonatomic) PostPreViewType type;
@property (nonatomic, strong) NSString* filename;
@end
