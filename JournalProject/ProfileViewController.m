//
//  ProfileViewController.m
//  JournalProject
//
//  Created by Nadir Zaman on 11/18/14.
//
//

#import "ProfileViewController.h"
#import "DetailViewController.h"
#import "PostViewController.h"
#import "ProfileTableViewCell.h"
#import "FollowTableViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0/255.0) green:(18/255.0) blue:(63/255.0) alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.splitViewController.displayModeButtonItem.title = @"Navigation";
    
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = 20.0;
    
    PFQuery *avaQuery = [PFUser query];
    [avaQuery whereKey:@"username" equalTo:self.user];
    [avaQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if([[objects objectAtIndex:0] objectForKey:@"avatar"] != nil){
                self.photoFile = (PFFile *)[[objects objectAtIndex:0] objectForKey:@"avatar"];
                self.avatar.image = [UIImage imageWithData:self.photoFile.getData];
            }
            else{
                self.avatar.image = [UIImage imageNamed: @"avatar.png"];
            }
            [self reload];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    // Do any additional setup after loading the view.
    [self reload];
    [self configureView];
}

- (void) viewWillAppear:(BOOL)animated{
    feedArray = [NSMutableArray array];
    
    PFQuery *queryUser = [PFQuery queryWithClassName:@"Journal_Entries"];
    [queryUser whereKey:@"username" equalTo:self.user];
    self.navigationItem.title = self.user;
    [queryUser findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            feedArray = [objects sortedArrayUsingComparator:
                         ^NSComparisonResult(PFObject *a, PFObject *b)
                         {
                             return [b.createdAt compare:a.createdAt];
                         }];
            [self reload];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void) reload {
    [feedTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [feedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
    PFObject *feed = [feedArray objectAtIndex:indexPath.row];
    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.layer.masksToBounds = YES;
    cell.title.text = [feed objectForKey:@"Title"];
    NSMutableArray *tagArray = [NSMutableArray array];
    PFQuery *Tagsquery = [PFQuery queryWithClassName:@"Journal_Tags"];
    [Tagsquery whereKey:@"Entry_ID" equalTo:[feed objectForKey:@"Entry_ID"]];
    [Tagsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            [tagArray addObjectsFromArray:objects];
            if(tagArray.count == 0){
                cell.tag1.text = nil;
                cell.tag2.text = nil;
            }
            if(tagArray.count == 1){
                cell.tag1.text = [[tagArray objectAtIndex:0] objectForKey:@"Tag"];
                cell.tag2.text = nil;
            }
            if(tagArray.count >= 2){
                cell.tag1.text = [[tagArray objectAtIndex:0] objectForKey:@"Tag"];
                cell.tag2.text = [[tagArray objectAtIndex:1] objectForKey:@"Tag"];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    cell.heart.image = [UIImage imageNamed: @"blank_heart.png"];
    
    PFQuery *heartQuery = [PFQuery queryWithClassName:@"Journal_Like"];
    [heartQuery whereKey:@"Entry_ID" equalTo:[feed objectForKey:@"Entry_ID"]];
    [heartQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            UILabel *likes = [[UILabel alloc]init];
            likes.text = [NSString stringWithFormat:@"%lu",(unsigned long)objects.count];
            likes.textAlignment = NSTextAlignmentCenter;
            likes.frame = CGRectMake(710, 31, 40, 21);
            [cell addSubview:likes];
            for(int i = 0; i < objects.count; i++){
                if ([[[PFUser currentUser] objectForKey:@"username"] isEqualToString:[[objects objectAtIndex:i] objectForKey:@"username"]]){
                    cell.heart.image = [UIImage imageNamed: @"heart.png"];
                }
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _chosenJournal = [feedArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ProfilePost" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)FollowingButton:(id)sender {
    self.followStatus = @"following";
    [self performSegueWithIdentifier:@"FollowSegue" sender:self];
}

- (IBAction)FollowersButton:(id)sender {
    self.followStatus = @"followers";
    [self performSegueWithIdentifier:@"FollowSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ProfilePost"]) {
        PostViewController *postDetails = (PostViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        postDetails.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        postDetails.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        postDetails.journal = _chosenJournal;
        return;
    }
    else if ([[segue identifier] isEqualToString:@"FollowSegue"]) {
        FollowTableViewController *followDetails = (FollowTableViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        followDetails.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        followDetails.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        followDetails.user = self.user;
        followDetails.followStatus = self.followStatus;
        return;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        [self delete:indexPath];
        [self reload]; // tell table to refresh now
    }
}

-(void) delete:(NSIndexPath *)IndexRow
{
    
    PFObject *deleting = [feedArray objectAtIndex:IndexRow.row];
    [deleting deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    PFQuery *Tagsquery = [PFQuery queryWithClassName:@"Journal_Tags"];
    [Tagsquery whereKey:@"Entry_ID" equalTo:[deleting objectForKey:@"Entry_ID"]];
    [Tagsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(int i = 0; i < objects.count; i++){
               PFObject *feedDel = [objects objectAtIndex:i];
                [feedDel deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        // The find succeeded. The first 100 objects are available in objects
                        
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    PFQuery *Likesquery = [PFQuery queryWithClassName:@"Journal_Tags"];
    [Likesquery whereKey:@"Entry_ID" equalTo:[deleting objectForKey:@"Entry_ID"]];
    [Likesquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(int i = 0; i < objects.count; i++){
                PFObject *likeDel = [objects objectAtIndex:i];
                [likeDel deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        // The find succeeded. The first 100 objects are available in objects
                        
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    PFQuery *Commentssquery = [PFQuery queryWithClassName:@"Journal_Tags"];
    [Commentssquery whereKey:@"Entry_ID" equalTo:[deleting objectForKey:@"Entry_ID"]];
    [Commentssquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(int i = 0; i < objects.count; i++){
                PFObject *comDel = [objects objectAtIndex:i];
                [comDel deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        // The find succeeded. The first 100 objects are available in objects
                        
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    NSMutableArray *del = [feedArray mutableCopy];
    int row = IndexRow.row;
    NSLog(@"%ld", (long)IndexRow.row);
    [del removeObjectAtIndex:row];
    feedArray = del;
    [self reload];
}

- (IBAction)Follow:(id)sender {
    if(![PFUser currentUser]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: nil
                                                       message: @"Sign in to follow"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        
        [alert show];
    }
    else if ([[[PFUser currentUser] objectForKey:@"username"] isEqualToString:self.user]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: nil
                                                       message: @"Cannot follow yourself"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        
        [alert show];
    }
    else {
        PFObject *follow = [PFObject objectWithClassName:@"Subscriptions"];
        follow[@"username"] = [[PFUser currentUser] objectForKey:@"username"];
        follow[@"Followed"] = self.user;
        [follow saveInBackground];
    }
}
@end
