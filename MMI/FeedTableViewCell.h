//
//  FeedTableViewCell.h
//  MMI
//
//  Created by Matthew Voracek on 2/3/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface FeedTableViewCell : PFTableViewCell

@property UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
//@property PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property UIButton *commentsButton;
@property UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@property PFObject *photo;
@end
