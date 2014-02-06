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

@interface SearchTableViewController () <UISearchBarDelegate,UISearchDisplayDelegate>
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
    
  //  self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
 //   self.tableView.tableHeaderView = self.searchBar;
    
 //   self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];

    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    
    CGPoint offset = CGPointMake(0, self.searchBar.frame.size.height);
    self.tableView.contentOffset = offset;
    
    self.searchResults = [NSMutableArray array];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)filterResults:(NSString *)searchTerm
{
    [self.searchResults removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName: @"_User"];
    [query whereKey:@"username" containsString:searchTerm];
    
    NSArray *results  = [query findObjects];
    
    NSLog(@"%@", results);
    NSLog(@"%u", results.count);
    
    [self.searchResults addObjectsFromArray:results];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterResults:searchString];
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DisplayUser"])
    {
        NSIndexPath *indexPath = [searchTableView indexPathForSelectedRow];
        
        ProfileTableViewController *vc = segue.destinationViewController;
 
        if (searchTableView != self.searchDisplayController.searchResultsTableView)
        {
            PFQuery *query = [PFQuery queryWithClassName:@"_User"];
            [query whereKey:@"username" equalTo:selectedUserName];
            vc.user = [query findObjects][0];
        }
        
        if ([searchTableView isEqual:self.searchDisplayController.searchResultsTableView])
        {
            PFUser *obj2 = [self.searchResults objectAtIndex:indexPath.row];
            PFQuery *query = [PFQuery queryWithClassName:@"_User"];
            PFObject *searchedUser = [query getObjectWithId:obj2.objectId];
            vc.user = [searchedUser objectForKey:@"username"];
        }
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
    
    
    if (tableView != self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [object objectForKey:@"username"];
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        PFUser *obj2 = [self.searchResults objectAtIndex:indexPath.row];
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        PFObject *searchedUser = [query getObjectWithId:obj2.objectId];
        cell.textLabel.text = [searchedUser objectForKey:@"username"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFTableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
    selectedUserName = cell.textLabel.text;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.tableView)
    {

        return self.objects.count;
    }
    else
    {
        return self.searchResults.count;
    }
    
}


@end
