//
//  ProfileTableViewController.m
//  MMI
//
//  Created by Matthew Voracek on 2/5/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import "ProfileTableViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>


@interface ProfileTableViewController () <UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePicker;
    UIImage *image;

    PFUser *currentUser;
    PFRelation *currentUserFollowingRelation;
    BOOL userIsAlreadyBeingFollowed;
}


@property (weak, nonatomic) IBOutlet UILabel *profileUserLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;


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
    PFFile *profileImage = self.user[@"profilePic"];

    _profileImageView.file = profileImage;
    _profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_profileImageView loadInBackground];
    _profileUserLabel.text = self.user[@"username"];
    [self setupActions];
    
}

-(void)setupActions
{
    if (self.user != currentUser)
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
    else
    {
        [_profileButton setTitle:@"Edit Profile Picture" forState:UIControlStateNormal];
    }
    
    
}

- (IBAction)onFollowPressed:(id)sender
{
    if (self.user != currentUser)
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
    else
    {
        imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else  {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        [self presentViewController :imagePicker animated:NO completion:nil];
    }
    

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [ info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        image = info[UIImagePickerControllerOriginalImage];
        _profileImageView.image = image;
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
        
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                //PFObject *userPhoto = [PFObject objectWithClassName:@"_User"];
                //[userPhoto setObject:imageFile forKey:@"userPhoto"];
                
                [currentUser setObject:imageFile forKey:@"profilePic"];
                
                //PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                //[ACL setPublicReadAccess:YES];
                //[ACL setWriteAccess:YES forUser:[PFUser currentUser]];
    
                //PFUser *user = [PFUser currentUser];
                //[userPhoto setObject:user forKey:@"user"];
                
                
                
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        // [self refresh:nil];
                        
                    }
                    else{
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        }];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
