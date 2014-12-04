//
//  NewPostViewController.m
//  JournalProject
//
//  Created by Nadir Zaman on 11/15/14.
//
//

#import "NewPostViewController.h"
#import "DetailViewController.h"

@interface NewPostViewController ()
@property CLLocationManager *locationManager;

@end

@implementation NewPostViewController
@synthesize longitude, latitude;

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
    newArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
    
    [self configureView];
}

-(void)reload{
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [newArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cells"];
    cell.textLabel.text = [newArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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

- (IBAction)AddTag:(id)sender {
    if(self.Tag.text.length != 0){
        if(![newArray containsObject:self.Tag.text]){
            [newArray addObject:self.Tag.text];
            [self reload];
        }
    self.Tag.text = nil;
    }
}

- (IBAction)Submit:(id)sender {
    if(self.Title.text.length != 0){
        PFUser *current = [PFUser currentUser];
        PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];
        NSMutableString *replaced = [[NSMutableString alloc]initWithString:self.Entry.text];
        PFQuery *replaceQuery = [PFQuery queryWithClassName:@"Mapping"];
        [replaceQuery whereKey:@"username" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
        [replaceQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded. The first 100 objects are available in objects
                for(int i = 0; i < objects.count; i++){
                    PFObject *change = objects[i];
                    NSString *replacing = [replaced stringByReplacingOccurrencesOfString:[change objectForKey:@"original"] withString:[change objectForKey:@"mapped"]];
                    [replaced setString:replacing];
                }
                PFObject *journal = [PFObject objectWithClassName:@"Journal_Entries"];
                journal[@"username"] = [current objectForKey:@"username"];
                journal[@"Entry"] = replaced;
                journal[@"Title"] = self.Title.text;
                
                static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
                
                NSMutableString *randomString = [NSMutableString stringWithCapacity: 8];
                for (int i=0; i<8; i++) {
                    [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
                }
                
                // other fields can be set if you want to save more information
                journal[@"Entry_ID"] = randomString;
                journal[@"Location"] = point;
                if(self.uploadImage)
                {
                    journal[@"filetype"] = self.filetype;
                    journal[@"Pic_Vid"] = self.uploadImage;
                }
                [journal saveInBackground];
                
                for(int i = 0; i < newArray.count; i++){
                    PFObject *tag = [PFObject objectWithClassName:@"Journal_Tags"];
                    tag[@"Entry_ID"] = randomString;
                    tag[@"Tag"] = [newArray objectAtIndex:i];
                    [tag saveInBackground];
                }
                [self performSegueWithIdentifier:@"NewHome" sender:self];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                       message: @"Posts must have a title"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        
        [alert show];
    }

}

- (IBAction)AttachButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse, *thumbnail;
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
        self.filetype = @"image";
    }
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        self.videoURL=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        
        AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:self.videoURL options:nil];
        AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
        generate1.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(1, 1);
        CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
        UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
        thumbnail = one;
//        [_firstImage setImage:one];
//        _firstImage.contentMode = UIViewContentModeScaleAspectFit;
        
        self.filetype = @"video";
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 726, 100, 100)];
    float cacheSize = 0;
    NSFileManager *filemgr =[NSFileManager defaultManager];
    NSData *data = [filemgr contentsAtPath:[NSString stringWithFormat:@"%@",path]];
    cacheSize = cacheSize + ([data length]/1000);
    cacheSize = (cacheSize/1024);
    if(cacheSize <= 10){
        if(imageToUse){
            imageView.image = imageToUse;
            self.uploadData = UIImagePNGRepresentation(imageToUse);
        }
        else{
            [imageView setImage:thumbnail];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            self.uploadData = [NSData dataWithContentsOfURL:self.videoURL];
        }
        [picker dismissViewControllerAnimated:YES completion:NULL];
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
    [self.view addSubview:imageView];
    
    //[[picker parentViewController] dismissModalViewControllerAnimated: YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[picker release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"NewHome"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        return;
    }
}

- (IBAction)CancelButton:(id)sender {
    [self performSegueWithIdentifier:@"NewHome" sender:self];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSMutableString *userLoc = [[NSMutableString alloc] init];
    CLLocation *currentLocation = (CLLocation *)[locations lastObject];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = placemarks[0];
        NSDictionary *addressDictionary = [placemark addressDictionary];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [userLoc setString:[NSString stringWithFormat:@"%@, %@",addressDictionary[(NSString *)kABPersonAddressCityKey],addressDictionary[(NSString *)kABPersonAddressStateKey]]];
            
            CLGeocoder *geo = [[CLGeocoder alloc] init];
            [geo geocodeAddressString:userLoc completionHandler:^(NSArray* placemarks, NSError* error){
                for (CLPlacemark* aPlacemark in placemarks)
                {
                    latitude = aPlacemark.location.coordinate.latitude;
                    longitude = aPlacemark.location.coordinate.longitude;
                }
            }];
        });
        
        
    }];
    
    [self.locationManager stopUpdatingLocation];
}


@end
