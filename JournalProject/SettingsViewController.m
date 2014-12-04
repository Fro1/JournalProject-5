//
//  SettingsViewController.m
//  JournalProject
//
//  Created by Nadir Zaman on 11/21/14.
//
//

#import "SettingsViewController.h"
#import "MappingViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0/255.0) green:(18/255.0) blue:(63/255.0) alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.splitViewController.displayModeButtonItem.title = @"Navigation";
    
    PFUser *current = [PFUser currentUser];
    PFFile *photoFile = (PFFile *)[current objectForKey:@"avatar"];
    if(photoFile != nil){
        self.Avatar.image = [UIImage imageWithData:photoFile.getData];
    }
    else{
        self.Avatar.image = [UIImage imageNamed: @"avatar.png"]; 
    }
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

- (IBAction)avatarButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    NSMutableString *path;
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        NSString *imagepath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        [path setString:imagepath];
    }
    
    float cacheSize = 0;
    NSFileManager *filemgr =[NSFileManager defaultManager];
    NSData *data = [filemgr contentsAtPath:[NSString stringWithFormat:@"%@",path]];
    cacheSize = cacheSize + ([data length]/1000);
    cacheSize = (cacheSize/1024);
    if(cacheSize <= 10){
        self.Avatar.image = imageToUse;
        self.uploadData = UIImagePNGRepresentation(imageToUse);
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                       message: @"File too large"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        
        [alert show];
    }
    
    self.uploadImage = [PFFile fileWithData:self.uploadData];
    
    //[[picker parentViewController] dismissModalViewControllerAnimated: YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)SaveButton:(id)sender {
    PFUser *current = [PFUser currentUser];
    if(self.uploadImage != nil){
        [current setObject:self.uploadImage forKey:@"avatar"];
    }
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
        } else {
        }
    }];
}

- (IBAction)mappingButton:(id)sender {
    [self performSegueWithIdentifier:@"MappingSegue" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"MappingSegue"]) {
        MappingViewController *controller = (MappingViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        return;
    }
}
@end
