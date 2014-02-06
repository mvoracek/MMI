//
//  CommentTableViewController.m
//  MMI
//
//  Created by Matthew Voracek on 2/4/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import "CommentTableViewController.h"

@interface CommentTableViewController ()
{
    PFUser *currentUser;
    __weak IBOutlet UITextField *commentTextField;
}

@end

@implementation CommentTableViewController

- (void)viewDidLoad
{
    self.parseClassName = @"Comment";
    currentUser = [PFUser currentUser];
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)flag
{
    [super viewWillAppear:flag];
    
    // Listen for the keyboard to show up so we can get its height
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // Set focus on the text view to display the keyboard immediately
    [commentTextField becomeFirstResponder];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* keyboardFrame = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's
    // coordinate system. The bottom of the text view's frame should align with the
    // top of the keyboard's final position.
    CGRect keyboardRect = [keyboardFrame CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    // Set the text view's frame height as the distance from the top of the view bounds
    // to the top of the keyboard
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = 40;
    commentTextField.frame = newTextViewFrame;
}

- (IBAction)onAddCommentPressed:(id)sender {
    PFObject *comment = [PFObject objectWithClassName:@"Comment"];
    [comment setValue:commentTextField.text forKey:@"text"];
    [comment setObject:currentUser forKey:@"createdByUser"];
    [comment setObject:self.photo forKey:@"attachedToPhoto"];
    [comment saveInBackground];
}

#pragma mark - Table view data source

-(PFQuery *)queryForTable
{
    PFQuery *queryComments = [PFQuery queryWithClassName:@"Comment"];
 //   [queryComments includeKey:@"createdByUser"];
 //   [queryComments includeKey:@"attachedToPhoto"];
    [queryComments orderByDescending:@"createdAt"];
    [queryComments whereKey:@"createdByUser" equalTo:currentUser.objectId];
    [queryComments whereKey:@"attachedToPhoto" equalTo:self.photo.objectId];
    
    return queryComments;
}


-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [object objectForKey:@"text"];
    
    return cell;
}

@end
