//
//  SearchTableViewController.m
//  MMI
//
//  Created by Matthew Voracek on 2/4/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import "SearchTableViewController.h"
#import "Parse/Parse.h"
#import "ProfileTableViewController.h"

@interface SearchTableViewController ()
{
    IBOutlet UITableView *searchTableView;
    NSString *selectedUserName;
}

@end

@implementation SearchTableViewController

- (void)viewDidLoad
{
    self.parseClassName = @"_User";
    [super viewDidLoad];
    
    [self.searchBar setShowsScopeBar:NO];
    [self.searchBar sizeToFit];
    
    // Hide the search bar until user scrolls up
    CGRect newBounds = [[self tableView] bounds];
    newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
    [[self tableView] setBounds:newBounds];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" hasPrefix:self.searchBar.text];
    return query;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self loadObjects];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DisplayUser"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFUser *user = [self.objects objectAtIndex:indexPath.row];
        
        ProfileTableViewController *vc = segue.destinationViewController;
        
        vc.user = user;
    }
}


#pragma mark - Table view data source

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell)
    {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [object objectForKey:@"username"];

    return cell;
}
-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
    selectedUserName = cell.textLabel.text;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.objects.count;
}


@end
