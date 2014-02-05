//
//  ProfileTableViewController.m
//  MMI
//
//  Created by Matthew Voracek on 2/5/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import "ProfileTableViewController.h"

@interface ProfileTableViewController ()

//@property UILabel *profileUserLabel;
//@property UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *profileUserLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

@end

@implementation ProfileTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.user)
    {
        self.user = [PFUser currentUser];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //_profileUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 120, 30)];
    //_followButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 50, 50, 30)];
    
    [_profileButton setTitle:@"Follow" forState:UIControlStateNormal];
    
    _profileUserLabel.text = self.user[@"username"];
    
    
    
}

@end
