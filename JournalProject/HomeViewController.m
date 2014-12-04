//
//  HomeViewController.m
//  JournalProject
//
//  Created by Nadir Zaman on 11/14/14.
//
//

#import "HomeViewController.h"
#import "DetailViewController.h"
#import "PostViewController.h"
#import "HomeTableViewCell.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    self.navigationController.navigationItem.leftBarButtonItem.title = @"Navigation";
    
    PFUser *current = [PFUser currentUser];
    
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = 20.0;
    
    if([PFUser currentUser]){
        self.userText.text = [current objectForKey:@"username"];
    }
    else{
        self.NewButton.hidden = YES;
        self.userText.text = @"Not Signed In";
    }
    if([current objectForKey:@"avatar"] != nil){
        self.photoFile = (PFFile *)[current objectForKey:@"avatar"];
        self.avatar.image = [UIImage imageWithData:self.photoFile.getData];
    }
    else{
        self.avatar.image = [UIImage imageNamed: @"avatar.png"];
    }
    [self.userText sizeToFit];
    //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reload) userInfo:nil repeats: YES];
    [self configureView];
}

- (void) viewWillAppear:(BOOL)animated{
    homeArray = [NSMutableArray array];
    all = [NSMutableArray array];
    if([PFUser currentUser]){
        PFQuery *userPostsQuery = [PFQuery queryWithClassName:@"Journal_Entries"];
        [userPostsQuery whereKey:@"username" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
        [userPostsQuery orderByDescending:@"createdAt"];
        [userPostsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded. The first 100 objects are available in objects
                [all addObjectsFromArray:objects];
                PFQuery *followQuery = [PFQuery queryWithClassName:@"Subscriptions"];
                [followQuery whereKey:@"username" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
                //[followQuery orderByDescending:@"createdAt"];
                [followQuery findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error) {
                    if (!error) {
                        // The find succeeded. The first 100 objects are available in objects
                        for(int i = 0; i < object.count; i++){
                            PFQuery *followQuery = [PFQuery queryWithClassName:@"Journal_Entries"];
                            [followQuery whereKey:@"username" equalTo:[object[i] objectForKey:@"Followed"]];
                            //[followQuery orderByDescending:@"createdAt"];
                            [followQuery findObjectsInBackgroundWithBlock:^(NSArray *object2, NSError *error) {
                                if (!error) {
                                    // The find succeeded. The first 100 objects are available in objects
                                    [all addObjectsFromArray:object2];
                                    homeArray = [all sortedArrayUsingComparator:
                                                 ^NSComparisonResult(PFObject *a, PFObject *b)
                                                 {
                                                     return [[b createdAt] compare:[a createdAt]];
                                                 }];
                                    [self reload];
                                } else {
                                    // Log details of the failure
                                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                                }
                            }];
                        }
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [homeArray count];
}

-(void)reload{
    [tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PFObject *journal = [homeArray objectAtIndex:indexPath.row];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10.0;
    cell.name.text = [journal objectForKey:@"username"];
    cell.title.text = [journal objectForKey:@"Title"];
    cell.Avatar.layer.masksToBounds = YES;
    cell.Avatar.layer.cornerRadius = 10.0;
    cell.frame = CGRectMake(10, 0, cell.frame.size.width - 20, cell.frame.size.height);
    
    NSMutableArray *tagArray = [NSMutableArray array];
    PFQuery *Tagsquery = [PFQuery queryWithClassName:@"Journal_Tags"];
    [Tagsquery whereKey:@"Entry_ID" equalTo:[journal objectForKey:@"Entry_ID"]];
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
    [heartQuery whereKey:@"Entry_ID" equalTo:[journal objectForKey:@"Entry_ID"]];
    [heartQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            UILabel *likes = [[UILabel alloc]init];
            likes.text = [NSString stringWithFormat:@"%lu",(unsigned long)objects.count];
            likes.textAlignment = NSTextAlignmentCenter;
            likes.frame = CGRectMake(703, 37, 40, 21);
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
    
    PFQuery *avaQuery = [PFUser query];
    [avaQuery whereKey:@"username" equalTo:[journal objectForKey:@"username"]];
    [avaQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            if([[objects objectAtIndex:0] objectForKey:@"avatar"] != nil){
                self.photoFile = (PFFile *)[[objects objectAtIndex:0] objectForKey:@"avatar"];
                cell.Avatar.image = [UIImage imageWithData:self.photoFile.getData];
            }
            else{
                cell.Avatar.image = [UIImage imageNamed: @"avatar.png"];
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
    _chosenJournal = [homeArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Details" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"HomeNew"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        return;
    }
    else if ([[segue identifier] isEqualToString:@"Details"]) {
        PostViewController *postDetails = (PostViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        postDetails.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        postDetails.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        postDetails.journal = _chosenJournal;
        return;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)NewButton:(id)sender {
}
@end
