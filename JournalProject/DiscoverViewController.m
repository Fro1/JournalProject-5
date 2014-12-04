//
//  DiscoverViewController.m
//  JournalProject
//
//  Created by Nadir Zaman on 11/26/14.
//
//

#import "DiscoverViewController.h"
#import "DetailViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

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
    // Do any additional setup after loading the view.
    self.resultType = @"post";
    self.search = NO;
    //searchArray = @[@"Tags", @"Entries", @"Users"];
    searchArray = @[@"Tags"];
    [SearchTable reloadData];
    [self posts];
    [self configureView];
}

- (void) posts {
    findArray = [NSMutableArray array];
    PFQuery *orderQuery = [PFQuery queryWithClassName:@"Journal_Like"];
    [orderQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            [findArray addObjectsFromArray:objects];
            [self sortPosts];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) tags {
    findArray = [NSMutableArray array];
    PFQuery *orderQuery = [PFQuery queryWithClassName:@"Journal_Tags"];
    [orderQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            [findArray addObjectsFromArray:objects];
            [self sortTags];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) users {
    findArray = [NSMutableArray array];
    PFQuery *orderQuery = [PFQuery queryWithClassName:@"Subscriptions"];
    [orderQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            [findArray addObjectsFromArray:objects];
            [self sortUsers];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) sortPosts {
    resultArray = [NSMutableArray array];
    NSMutableArray *countArray = [NSMutableArray new];
    int countInt = 1;
    if(findArray.count > 1){
        NSMutableArray *newArray = [[NSMutableArray alloc]initWithArray:findArray];
        for (int i = 0; i < newArray.count; i++){
            NSString *check = [newArray[i] objectForKey:@"Entry_ID"];
            for (int j = i+1; j < newArray.count; j++){
                if ([check isEqualToString:[[newArray objectAtIndex:j]objectForKey:@"Entry_ID"]]) {
                    [newArray removeObjectAtIndex:j];
                    countInt++;
                }
            }
            NSDictionary *sorted = @{
                                     @"Entry_ID" : check,
                                     @"Likes" : [NSNumber numberWithInt:countInt],
                                     };
            [countArray addObject:sorted];
            countInt = 1;
        }
        NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"Likes" ascending:NO];
        [countArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        [resultArray addObjectsFromArray:countArray];
        [ResultTable reloadData];
    }
    else{
        [resultArray addObjectsFromArray:findArray];
        [ResultTable reloadData];
    }
}

- (void) sortTags {
    resultArray = [NSMutableArray array];
    NSMutableArray *countArray = [NSMutableArray new];
    int countInt = 1;
    if(findArray.count > 1){
        NSMutableArray *newArray = [[NSMutableArray alloc]initWithArray:findArray];
        for (int i = 0; i < newArray.count; i++){
            NSString *check = [newArray[i] objectForKey:@"Tag"];
            for (int j = i+1; j < newArray.count; j++){
                if ([check isEqualToString:[[newArray objectAtIndex:j]objectForKey:@"Tag"]]) {
                    [newArray removeObjectAtIndex:j];
                    countInt++;
                }
            }
            NSDictionary *sorted = @{
                                     @"Tag" : check,
                                     @"Use" : [NSNumber numberWithInt:countInt],
                                     };
            [countArray addObject:sorted];
            countInt = 1;
        }
        NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"Use" ascending:NO];
        [countArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        [resultArray addObjectsFromArray:countArray];
        [ResultTable reloadData];
    }
    else{
        [resultArray addObjectsFromArray:findArray];
        [ResultTable reloadData];
    }
}

- (void) sortUsers {
    resultArray = [NSMutableArray array];
    int countInt = 1;
    if(findArray.count > 1){
        NSMutableArray *newArray = [[NSMutableArray alloc]initWithArray:findArray];
        NSMutableArray *countArray = [NSMutableArray new];
        for (int i = 0; i < newArray.count; i++){
            NSString *check = [newArray[i] objectForKey:@"username"];
            for (int j = i+1; j < newArray.count; j++){
                if ([check isEqualToString:[[newArray objectAtIndex:j]objectForKey:@"username"]]) {
                    [newArray removeObjectAtIndex:j];
                    countInt++;
                }
            }
            NSDictionary *sorted = @{
                                     @"username" : check,
                                     @"followers" : [NSNumber numberWithInt:countInt],
                                     };
            [countArray addObject:sorted];
            countInt = 1;
        }
        NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"followers" ascending:NO];
        [countArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        [resultArray addObjectsFromArray:countArray];
        [ResultTable reloadData];
    }
    else{
        [resultArray addObjectsFromArray:findArray];
        [ResultTable reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == SearchTable){
        return [searchArray count];
    }
    else{
        return [resultArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == SearchTable){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        cell.textLabel.text = searchArray[indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(18/255.0) blue:(63/255.0) alpha:1];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
        PFObject *results = [resultArray objectAtIndex:indexPath.row];
        if([self.resultType  isEqual: @"post" ]){
            PFQuery *resultQuery = [PFQuery queryWithClassName:@"Journal_Entries"];
            [resultQuery whereKey:@"Entry_ID" equalTo:[results objectForKey:@"Entry_ID"]];
            [resultQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    cell.textLabel.text = [objects[0] objectForKey:@"Title"];
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else if([self.resultType  isEqual: @"user"]){
            cell.textLabel.text = [results objectForKey:@"username"];
        }
        else if([self.resultType  isEqual: @"tag"]){
            cell.textLabel.text = [results objectForKey:@"Tag"];
        }
        return cell;
    }
}

- (IBAction)Entries:(id)sender {
    [self posts];
    self.searchBar.text = nil;
    self.resultType = @"post";
}

- (IBAction)Users:(id)sender {
    [self users];
    self.searchBar.text = nil;
    self.resultType = @"user";
}

- (IBAction)Tags:(id)sender {
    [self tags];
    self.searchBar.text = nil;
    self.resultType = @"tag";
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    resultArray = [NSMutableArray array];
    findArray = [NSMutableArray array];
    self.resultType = @"post";
    PFQuery *normQuery = [PFQuery queryWithClassName:@"Journal_Tags"];
    [normQuery whereKey:@"Tag" equalTo:searchBar.text];
    [normQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            [findArray addObjectsFromArray:objects];
            PFQuery *caseQuery = [PFQuery queryWithClassName:@"Journal_Tags"];
            [caseQuery whereKey:@"Tag" equalTo:[searchBar.text lowercaseString]];
            [caseQuery findObjectsInBackgroundWithBlock:^(NSArray *objects2, NSError *error) {
                if (!error) {
                    // The find succeeded. The first 100 objects are available in objects
                    [findArray addObjectsFromArray:objects2];
                    [self sortPosts];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
