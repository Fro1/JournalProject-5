//
//  RegisterViewController.h
//  JournalProject
//
//  Created by Nadir Zaman on 11/15/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <CommonCrypto/CommonDigest.h>

@interface RegisterViewController : UIViewController


- (IBAction)CancelButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *UserText;
@property (weak, nonatomic) IBOutlet UITextField *PasswordText;
@property (weak, nonatomic) IBOutlet UITextField *PasswordConfirm;
- (IBAction)RegisterButton:(id)sender;

@end
