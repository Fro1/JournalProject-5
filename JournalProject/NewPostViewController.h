//
//  NewPostViewController.h
//  JournalProject
//
//  Created by Nadir Zaman on 11/15/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <CoreImage/CoreImage.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@interface NewPostViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>{
    IBOutlet UITableView *tableView;
    NSMutableArray *newArray;
}

- (IBAction)CancelButton:(id)sender;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (strong, nonatomic) NSData *uploadData;
@property (strong, nonatomic) PFFile *uploadImage;
@property (strong, nonatomic) NSString *filetype;
@property (strong,nonatomic) MPMoviePlayerController *Player;
@property (weak, nonatomic) IBOutlet UITextField *Title;
@property (weak, nonatomic) IBOutlet UITextView *Entry;
@property (weak, nonatomic) IBOutlet UITextField *Tag;
@property (readwrite, nonatomic) double longitude;
@property (readwrite, nonatomic) double latitude;
- (IBAction)AddTag:(id)sender;
- (IBAction)Submit:(id)sender;
- (IBAction)AttachButton:(id)sender;

@end
