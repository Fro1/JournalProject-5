//
//  SettingsViewController.h
//  JournalProject
//
//  Created by Nadir Zaman on 11/21/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <CoreImage/CoreImage.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface SettingsViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSData *uploadData;
@property (strong, nonatomic) PFFile *uploadImage;
- (IBAction)avatarButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *Avatar;
- (IBAction)SaveButton:(id)sender;
- (IBAction)mappingButton:(id)sender;

@end
