//
//  FollowTableViewController.m
//  JournalProject
//
//  Created by Nadir Zaman on 11/22/14.
//
//

#import "FollowTableViewController.h"
#import "FollowTableViewCell.h"
#import "ProfileViewController.h"

@interface FollowTableViewController ()

@end

@implementation FollowTableViewController

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
    followTable.dataSource = self;
    followTable.delegate = self;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0/255.0) green:(18/255.0) blue:(63/255.0) alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.splitViewController.displayModeButtonItem.title = @"Navigation";
    
    followArray = [NSMutableArray array];
    if([self.followStatus  isEqual: @"followers"]){
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s followers",self.user];
        PFQuery *queryFollowers = [PFQuery queryWithClassName:@"Subscriptions"];
        [queryFollowers whereKey:@"Followed" equalTo:self.user];
        [queryFollowers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded. The first 100 objects are available in objects
                [followArray addObjectsFromArray:objects];
                [self reload];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    
    else if([self.followStatus  isEqual: @"following"]){
        self.navigationItem.title = [NSString stringWithFormat:@"Who %@ follows",self.user];
        PFQuery *queryFollowing = [PFQuery queryWithClassName:@"Subscriptions"];
        [queryFollowing whereKey:@"username" equalTo:self.user];
        [queryFollowing findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded. The first 100 objects are available in objects
                [followArray addObjectsFromArray:objects];
                [self reload];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    
    [self configureView];
}

-(void)reload{
    [followTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return followArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowCell" forIndexPath:indexPath];
    if([self.followStatus  isEqual: @"followers"]){
        cell.name.text = [[followArray objectAtIndex:indexPath.row] objectForKey:@"username"];
    }
    else {
        cell.name.text = [[followArray objectAtIndex:indexPath.row] objectForKey:@"Followed"];
    }
    PFQuery *avaQuery = [PFUser query];
    [avaQuery whereKey:@"username" equalTo:cell.name.text];
    [avaQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            if([[objects objectAtIndex:0] objectForKey:@"avatar"] != nil){
                self.photoFile = (PFFile *)[[objects objectAtIndex:0] objectForKey:@"avatar"];
                cell.avatar.image = [UIImage imageWithData:self.photoFile.getData];
            }
            else{
                cell.avatar.image = [UIImage imageNamed: @"avatar.png"];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    // Configure the cell...
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selected = [followArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"FollowProfile" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"FollowProfile"]) {
        ProfileViewController *controller = (ProfileViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        if([self.followStatus  isEqual: @"followers"]){
            controller.user = [self.selected objectForKey:@"username"];
        }
        else {
            controller.user = [self.selected objectForKey:@"Followed"];
        }
        return;
    }
}

@end
