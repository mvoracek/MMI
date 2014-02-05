//
//  HomeTableViewController.m
//  MMI
//
//  Created by Matthew Voracek on 2/4/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import "HomeTableViewController.h"
#import "FeedTableViewCell.h"

@interface HomeTableViewController () <PFSignUpViewControllerDelegate>

@end

@implementation HomeTableViewController


- (void)viewDidLoad
{
    self.parseClassName = @"Photo";

    PFQuery *q = [PFQuery queryWithClassName:@"Photo"];
    [q getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSLog(@"Object %@",object);
    }];
  //  NSLog(@"%i",[q countObjects]);
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    
    if (!cell)
    {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"a"];
    }
    
 //   PFObject *owner = object[@"user"];
 //   PFQuery *queryUser = [PFQuery queryWithClassName:@"_User"];
 //   [queryUser whereKey:@"username" equalTo:@"objectID"];
    
    
    
    PFFile *profilePhoto = object[@"image"];
    PFFile *mainPhoto = object[@"image"];


    cell.userPhoto.contentMode = UIViewContentModeScaleAspectFit;
    if (profilePhoto)
        cell.userPhoto.file = profilePhoto;
    cell.userPhoto.backgroundColor = [UIColor redColor];
    [cell.userPhoto loadInBackground];
    
    
    cell.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    if (mainPhoto)
        cell.photoImageView.file = mainPhoto;
    cell.photoImageView.backgroundColor = [UIColor redColor];
    [cell.photoImageView loadInBackground];
   
    PFUser *owner = object[@"user"];
    [owner fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        cell.userLabel.text = owner[@"username"];
    }];
    
    [cell.imageView addSubview:cell.userPhoto];
    [cell.imageView addSubview:cell.userLabel];
    [cell.imageView addSubview:cell.photoImageView];
    
    return cell;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self loadObjects];
    
    if (![PFUser currentUser])
    {
        PFLogInViewController *login = [PFLogInViewController new];
        UILabel *label = [[ UILabel alloc]initWithFrame:CGRectZero];
        login.signUpController.delegate = self;
        label.text = @"MM Instagram";
        [label sizeToFit];
        login.logInView.logo = label;
        [self presentViewController:login animated:YES completion:nil];
    }
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [signUpController dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 440.0;
}





@end
