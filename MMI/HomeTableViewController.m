//
//  HomeTableViewController.m
//  MMI
//
//  Created by Matthew Voracek on 2/4/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import "HomeTableViewController.h"
#import "FeedTableViewCell.h"
#import "CommentTableViewController.h"

@interface HomeTableViewController () <PFSignUpViewControllerDelegate>
{
    PFUser *currentUser;
    PFRelation *currentUserFollowingRelation;
    PFRelation *currentPhotoLikedByRelation;
    NSIndexPath *selectedIP;
}
@end

@implementation HomeTableViewController


- (void)viewDidLoad
{
    self.parseClassName = @"Photo";
    
    currentUser = [PFUser currentUser];
    currentUserFollowingRelation = [currentUser relationforKey:@"following"];
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

-(PFQuery *)queryForTable
{
    PFQuery *queryPhotos = [PFQuery queryWithClassName:@"Photo"];
    [queryPhotos includeKey:@"user"];
    [queryPhotos orderByDescending:@"createdAt"];
    
    PFQuery *queryUsersBeingFollowed = [currentUserFollowingRelation query];
    [queryPhotos whereKey:@"user" matchesKey:@"objectId" inQuery:queryUsersBeingFollowed];
    [queryPhotos orderByDescending:@"createdAt"];
    
    return queryPhotos;
}

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    
    if (!cell)
    {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"a"];
    }
    
    cell.photo = object;
    
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
    cell.userLabel.text = owner.username;
    
    currentPhotoLikedByRelation = [object relationforKey:@"following"];
    PFQuery *query = [currentPhotoLikedByRelation query];
    [query whereKey:@"username" equalTo:currentUser.username];
    
    if (query.countObjects == 1)
    {
        [cell.likeButton setTitle:@"I Like this!" forState:UIControlStateNormal];
    }
    else
    {
        [cell.likeButton setTitle:@"Do I Like this?" forState:UIControlStateNormal];
    }
    
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
- (IBAction)onLikeButtonPressed:(UIButton*)button
{
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        FeedTableViewCell *cell = (FeedTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        PFObject *photo = cell.photo;
        currentPhotoLikedByRelation = [photo relationforKey:@"following"];
        if ([button.titleLabel.text isEqualToString:@"I Like this!"])
        {
            [currentPhotoLikedByRelation removeObject:currentUser];
            [button setTitle:@"Do I Like this?" forState:UIControlStateNormal];
        }
        else
        {
            [currentPhotoLikedByRelation addObject:currentUser];
            [button setTitle:@"I Like this!" forState:UIControlStateNormal];
        }
        [photo saveInBackground];
    }
}
- (IBAction)onCommentButtonPressed:(UIButton*)button {
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        selectedIP = indexPath;
        
//        FeedTableViewCell *cell = (FeedTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
//        PFObject *photo = cell.photo;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Comments"])
    {

        FeedTableViewCell *cell = (FeedTableViewCell*)[self.tableView cellForRowAtIndexPath:selectedIP];
        PFObject *photo = cell.photo;
       
        CommentTableViewController *vc = segue.destinationViewController;
        
        vc.photo = photo;
    }
}



-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [signUpController dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
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
