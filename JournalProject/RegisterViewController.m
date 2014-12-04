//
//  RegisterViewController.m
//  JournalProject
//
//  Created by Nadir Zaman on 11/15/14.
//
//

#import "RegisterViewController.h"
#import "DetailViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0/255.0) green:(18/255.0) blue:(63/255.0) alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.splitViewController.displayModeButtonItem.title = @"Navigation";
    // Do any additional setup after loading the view.
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

- (IBAction)RegisterButton:(id)sender {
    if(self.UserText.text.length != 0 && self.PasswordText.text.length != 0){
        if([self.PasswordText.text isEqualToString:self.PasswordConfirm.text]){
            const char *cstr = [self.PasswordText.text cStringUsingEncoding:NSUTF8StringEncoding];
            NSData *data = [NSData dataWithBytes:cstr length:self.PasswordText.text.length];
            
            uint8_t digest[CC_SHA1_DIGEST_LENGTH];
            
            CC_SHA1(data.bytes, data.length, digest);
            
            NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
            
            for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
                [output appendFormat:@"%02x", digest[i]];
            
            PFUser *user = [PFUser user];
            user.username = self.UserText.text;
            user.password =output;
            NSLog(@"FIRST %@", self.PasswordText.text);
            NSLog(@"CHANGED %@", output);

            //userID is just the login name until a format is decided
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Successfully Registered"
                                                                   message: nil
                                                                  delegate: self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                    
                    [alert show];
                    NSNotification *notif = [NSNotification notificationWithName:@"reloadRequest" object:self];
                    [[NSNotificationCenter defaultCenter] postNotification:notif];
                    [self performSegueWithIdentifier:@"RegisterCancel" sender:self];
                    //[self performSegueWithIdentifier:@"RegisterLogin" sender:self];
                } else {
                    NSString *errorString = [error userInfo][@"error"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: nil
                                                                   message: errorString
                                                                  delegate: self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                    
                    [alert show];
                }
            }];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                           message: @"Passwords do not match"
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            
            [alert show];
        }
        
    }
}

- (IBAction)CancelButton:(id)sender {
    [self performSegueWithIdentifier:@"RegisterCancel" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"RegisterCancel"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        return;
    }
}

@end
