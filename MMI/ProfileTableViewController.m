//
//  ProfileTableViewController.m
//  MMI
//
//  Created by Matthew Voracek on 2/5/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import "ProfileTableViewController.h"

@interface ProfileTableViewController ()
{
    PFUser *currentUser;
    PFRelation *currentUserFollowingRelation;
    BOOL userIsAlreadyBeingFollowed;
}

//@property UILabel *profileUserLabel;
//@property UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *profileUserLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;


@end

@implementation ProfileTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    currentUser = [PFUser currentUser];
    currentUserFollowingRelation = [currentUser relationforKey:@"following"];
    
    
  
    if (!self.user)
    {
        self.user = currentUser;
    }
 
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //_profileUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 120, 30)];
    //_followButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 50, 50, 30)];
    
    // generate a query based to see if user is already being followed or not
    PFQuery *query = [currentUserFollowingRelation query];
    [query whereKey:@"username" equalTo:self.user.username];
    
    if (query.countObjects == 1)
    {
        userIsAlreadyBeingFollowed = YES;
    }
    else
    {
        userIsAlreadyBeingFollowed = NO;
    }
    
    _profileUserLabel.text = self.user[@"username"];
    [self setupActions];
    
}

-(void)setupActions
{
    if (userIsAlreadyBeingFollowed)
    {
        [_profileButton setTitle:@"UnFollow" forState:UIControlStateNormal];
    }
    else
    {
        [_profileButton setTitle:@"Follow" forState:UIControlStateNormal];
    }
}

- (IBAction)onFollowPressed:(id)sender
{

    if (userIsAlreadyBeingFollowed)
    {
        [currentUserFollowingRelation removeObject:self.user];
        userIsAlreadyBeingFollowed = NO;
    }
    else
    {
        [currentUserFollowingRelation addObject:self.user];
        userIsAlreadyBeingFollowed = YES;
    }
  
    [currentUser saveInBackground];
    [self setupActions];
}

@end
