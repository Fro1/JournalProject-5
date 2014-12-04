//
//  DetailViewController.m
//  JournalProject
//
//  Created by Nadir Zaman on 11/14/14.
//
//

#import "DetailViewController.h"
#import "MasterViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

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
    if ([PFUser currentUser])
    {
        [self performSegueWithIdentifier:@"LoginHome" sender:self];
    }
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"LoginHome"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        return;
    }
    if ([[segue identifier] isEqualToString:@"LoginRegister"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginButton:(id)sender {
    const char *cstr = [self.PasswordText.text cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.PasswordText.text.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
//    [PFUser logInWithUsernameInBackground:self.UserText.text
//                                 password:output block:^(PFUser *user, NSError *error)
    [PFUser logInWithUsernameInBackground:self.UserText.text
                                 password:self.PasswordText.text block:^(PFUser *user, NSError *error)
    
     {
         if (!error) {
             NSNotification *notif = [NSNotification notificationWithName:@"reloadRequest" object:self];
             [[NSNotificationCenter defaultCenter] postNotification:notif];
             [self performSegueWithIdentifier:@"LoginHome" sender:self];
             //This is the user name used for the tables and the one displayed in public
         } else {
             NSString *errorString = [error userInfo][@"error"];
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle: nil
                                                            message: errorString
                                                           delegate: self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
             
             [alert show];
             // The login failed. Check error to see why.
         }
     }];

}

- (IBAction)RegisterButton:(id)sender {
    [self performSegueWithIdentifier:@"LoginRegister" sender:self];
}
@end
