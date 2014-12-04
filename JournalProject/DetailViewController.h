//
//  DetailViewController.h
//  JournalProject
//
//  Created by Nadir Zaman on 11/14/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <CommonCrypto/CommonDigest.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UITextField *UserText;
@property (weak, nonatomic) IBOutlet UITextField *PasswordText;
- (IBAction)LoginButton:(id)sender;
- (IBAction)RegisterButton:(id)sender;

@end

