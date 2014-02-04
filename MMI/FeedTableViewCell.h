//
//  FeedTableViewCell.h
//  MMI
//
//  Created by Matthew Voracek on 2/3/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewCell : UITableViewCell

@property UIImageView *photoImageView;
@property UIButton *likeButton;
@property UIButton *commentsButton;
@property UILabel *likesLabel;
@property UILabel *commentsLabel;

@end
