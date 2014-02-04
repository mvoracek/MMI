//
//  ViewController.m
//  MMI
//
//  Created by Matthew Voracek on 2/3/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import "HomeViewController.h"
#import "FeedTableViewCell.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];

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
    NSUInteger row = indexPath.row;
    if (row == 0) {
        return 320.0;
    }
    if (row == 1) {
        //place to programatically figure out LIKES height
        //return [self heightForLikesCell:row]
        return 20.0;
    }
    if (row == 2) {
        //place to programatically figure out COMMENTS height
        return 20.0;
    }
    if (row == 3) {
        //place to programatically figure out BUTTONS height
        return 30.0;
    }
    return 10.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 5.0, 120.0, 30.0)];
    UIImageView *userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 30, 30)];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260.0, 5.0, 50.0, 30.0)];

    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    if (indexPath.row == 0)
    {
        //code for imageView
        cell.photoImageView.frame = CGRectMake(0.0, 0.0, 320.0, 320.0);
        cell.photoImageView.image = [UIImage imageNamed:@"nicolascage320.jpeg"];
    }
    else if (indexPath.row == 1)
    {
        //code for likes row
        //cell.likesLabel ==
    }
    else if (indexPath.row == 2)
    {
        //code for comments row
        //cell.commentsLabel =
    }
    else if (indexPath.row == 3)
    {
        //code for buttons row
        cell.likeButton.frame = CGRectMake(5.0, 0.0, 60.0, 30.0);
        cell.commentsButton.frame = CGRectMake(70.0, 0.0, 80.0, 30.0);
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
@end
