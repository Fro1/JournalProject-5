//
//  MasterViewController.m
//  JournalProject
//
//  Created by Nadir Zaman on 11/14/14.
//
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ProfileViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController{
    NSArray *_objects;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0/255.0) green:(18/255.0) blue:(63/255.0) alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    if(![PFUser currentUser]){
    _objects = @[@"Login", @"Discover", @"Exit"];
    }
    else{
        _objects = @[@"Home", @"My Profile", @"Discover", @"Make a Post", @"Settings", @"Log Out", @"Exit"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload)
                                                 name:@"reloadRequest"
                                               object:nil];
    // Do any additional setup after loading the view, typically from a nib.

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reload {
    if(![PFUser currentUser]){
        _objects = @[@"Login", @"Discover", @"Exit"];
    }
    else{
        _objects = @[@"Home", @"My Profile", @"Discover", @"Make a Post", @"Settings", @"Log Out", @"Exit"];
    }
    [self.tableView reloadData];
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Login"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        return;
    }
    if ([[segue identifier] isEqualToString:@"Home"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        return;
    }
    if ([[segue identifier] isEqualToString:@"NewPost"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        return;
    }
    if ([[segue identifier] isEqualToString:@"MyProfile"]) {
        ProfileViewController *controller = (ProfileViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        PFUser *current = [PFUser currentUser];
        controller.user = [current objectForKey:@"username"];
        return;
    }
    if ([[segue identifier] isEqualToString:@"Settings"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        return;
    }
    if ([[segue identifier] isEqualToString:@"DiscoverSegue"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        return;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(18/255.0) blue:(63/255.0) alpha:1];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_objects[indexPath.row] isEqualToString:@"Login"]) {
        [self performSegueWithIdentifier:@"Login" sender:self];
        [self reload];
    } else if([_objects[indexPath.row] isEqualToString:@"Home"]){
        [self performSegueWithIdentifier:@"Home" sender:self];
    } else if([_objects[indexPath.row] isEqualToString:@"Log Out"]){
        [PFUser logOut];
        [self performSegueWithIdentifier:@"Login" sender:self];
        [self reload];
    } else if([_objects[indexPath.row] isEqualToString:@"Exit"]){
        exit(0);
    }else if([_objects[indexPath.row] isEqualToString:@"My Profile"]){
        [self performSegueWithIdentifier:@"MyProfile" sender:self];
    }else if([_objects[indexPath.row] isEqualToString:@"Make a Post"]){
        [self performSegueWithIdentifier:@"NewPost" sender:self];
    }
    else if([_objects[indexPath.row] isEqualToString:@"Settings"]){
        [self performSegueWithIdentifier:@"Settings" sender:self];
    }
    else if([_objects[indexPath.row] isEqualToString:@"Discover"]){
        [self performSegueWithIdentifier:@"DiscoverSegue" sender:self];
    }
}

@end
