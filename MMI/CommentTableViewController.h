//
//  CommentTableViewController.h
//  MMI
//
//  Created by Matthew Voracek on 2/4/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface CommentTableViewController : PFQueryTableViewController
@property PFObject *photo;
@end
