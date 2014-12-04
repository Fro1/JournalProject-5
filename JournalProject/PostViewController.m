//
//  PostViewController.m
//  JournalProject
//
//  Created by Nadir Zaman on 11/17/14.
//
//

#import "PostViewController.h"
#import "DetailViewController.h"
#import "ProfileViewController.h"
#import "MapViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController

static NSString * const kClientId = @"882214278070-b4rp1u53eb22ut0ubksv0ss2vm64dkbq.apps.googleusercontent.com";
static NSString * const kClientSecret = @"L54lQQPvQYtBQbLiuSiNhEbd";

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

    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.clientID = kClientId;
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    signIn.delegate = self;
    [signIn trySilentAuthentication];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    self.center = self.view.center;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0/255.0) green:(18/255.0) blue:(63/255.0) alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.splitViewController.displayModeButtonItem.title = @"Navigation";
    tagArray = [NSMutableArray array];
    self.navigationItem.title = [self.journal objectForKey:@"Title"];
    self.Entry.text = [self.journal objectForKey:@"Entry"];
    
    if([[self.journal objectForKey:@"username"] isEqualToString:[[PFUser currentUser] objectForKey:@"username"]]){
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.deleteButton addTarget:self
                              action:@selector(delete:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        self.deleteButton.frame = CGRectMake(611, 101, 61, 21);
        [self.view addSubview:self.deleteButton];
    }
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.likeButton addTarget:self
                        action:@selector(likeMethod:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.likeButton setTitle:@"Like" forState:UIControlStateNormal];
    self.likeButton.frame = CGRectMake(511, 101, 41, 21);
    [self.view addSubview:self.likeButton];
    
    UIButton *user = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [user addTarget:self
               action:@selector(userProfile)
     forControlEvents:UIControlEventTouchUpInside];
    user.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [user setTitle:[self.journal objectForKey:@"username"] forState:UIControlStateNormal];
    user.frame = CGRectMake(16, 72, 100, 21);
    [self.view addSubview:user];
    PFQuery *queryTags = [PFQuery queryWithClassName:@"Journal_Tags"];
    [queryTags whereKey:@"Entry_ID" equalTo:[self.journal objectForKey:@"Entry_ID"]];
    
    [queryTags findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            [tagArray addObjectsFromArray:objects];
            [self reload:tagTable];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    commentsArray = [NSMutableArray array];
    PFQuery *queryComments = [PFQuery queryWithClassName:@"Journal_Comments"];
    [queryComments whereKey:@"Entry_ID" equalTo:[self.journal objectForKey:@"Entry_ID"]];
    
    [queryComments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            [commentsArray addObjectsFromArray:objects];
            [self reload:commentsTable];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    likesArray = [NSMutableArray array];
    PFQuery *likesComments = [PFQuery queryWithClassName:@"Journal_Like"];
    [likesComments whereKey:@"Entry_ID" equalTo:[self.journal objectForKey:@"Entry_ID"]];
    
    [likesComments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            [likesArray addObjectsFromArray:objects];
            self.likeLabel.text = [NSString stringWithFormat:@"%lu Likes",(unsigned long)likesArray.count];
            for(int i = 0; i < likesArray.count; i++){
                if ([[[PFUser currentUser] objectForKey:@"username"] isEqualToString:[[likesArray objectAtIndex:i] objectForKey:@"username"]]){
                    self.likeButton.enabled = NO;
                }
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    if([_journal objectForKey:@"Pic_Vid"]){
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 380, 200, 200)];
        PFFile *photoFile = (PFFile *)[_journal objectForKey:@"Pic_Vid"];
        if([[_journal objectForKey:@"filetype"] isEqual:@"image"]){
            imageView.image = [UIImage imageWithData:photoFile.getData];
            self.image = [UIImage imageWithData:photoFile.getData];
        }
        else{
            PFFile *movie = [_journal objectForKey:@"Pic_Vid"];
            [movie getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if(!error){
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *name = [NSString stringWithFormat:@"%@.mp4",movie.name];
                    NSString *path = [documentsDirectory stringByAppendingPathComponent:name];
                    [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
                    
                    self.url = [NSURL fileURLWithPath:path];
                    
                    AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:self.url options:nil];
                    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
                    generate1.appliesPreferredTrackTransform = YES;
                    NSError *err = NULL;
                    CMTime time = CMTimeMake(1, 1);
                    CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
                    UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
                    [imageView setImage:one];
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                }
            }];
            
        }
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:singleTap];
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
    }
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)keyboardDidShow:(NSNotification *)note
{
    self.view.center = CGPointMake(self.center.x, self.center.y - 216);
}

- (void)keyboardDidHide:(NSNotification *)note
{
    self.view.center = self.center;
}

- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer {
    UITapGestureRecognizer *tapAgain = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapped:)];
    tapAgain.numberOfTapsRequired = 1;
    tapAgain.numberOfTouchesRequired = 1;
    if([[_journal objectForKey:@"filetype"] isEqualToString:@"image"]){
        self.images = [[UIImageView alloc]initWithFrame:self.view.bounds];
        self.images.image = self.image;
        [self.images addGestureRecognizer:tapAgain];
        self.images.userInteractionEnabled = YES;
        [self.view addSubview:self.images];
    }
    else{
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                        style:UIBarButtonItemStyleDone target:self
                                                                       action:@selector(closeMovie)];
        self.navigationItem.rightBarButtonItem = rightButton;
        self.myPlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.url];
        [self.myPlayer prepareToPlay];
        [self.myPlayer.view setFrame: self.view.bounds];
        self.myPlayer.movieSourceType = MPMovieSourceTypeFile;
        [self.view addSubview: self.myPlayer.view];
        [self.myPlayer play];
    }
    
}

- (void)closeTapped:(UIGestureRecognizer *)gestureRecognizer {
    self.images.removeFromSuperview;
}

- (void) closeMovie {
    [self.myPlayer stop];
    self.myPlayer.view.removeFromSuperview;
    self.navigationItem.rightBarButtonItem = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == tagTable){
        return [tagArray count];
    }
    else{
        return [commentsArray count];
    }
}

- (void) reloadAgain:(UITableView *)table {
    if (table == commentsTable){
        commentsArray = [NSMutableArray array];
        PFQuery *queryComments = [PFQuery queryWithClassName:@"Journal_Comments"];
        [queryComments whereKey:@"Entry_ID" equalTo:[self.journal objectForKey:@"Entry_ID"]];
        
        [queryComments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded. The first 100 objects are available in objects
                [commentsArray addObjectsFromArray:objects];
                [self reload:commentsTable];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    [table reloadData];
}

- (void) reload:(UITableView *)table {
    [table reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == tagTable){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell"];
        PFObject *tags = [tagArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [tags objectForKey:@"Tag"];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        PFObject *comments = [commentsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [comments objectForKey:@"Comment"];
        return cell;
    }
}

-(void) userProfile {
    [self performSegueWithIdentifier:@"PostUser" sender:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CommentButton:(id)sender {
    if(![PFUser currentUser]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: nil
                                                       message: @"Sign in to comment"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        
        [alert show];
    }
    else{
        if(self.Comment.text.length == 0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                           message: @"Please enter comment"
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            
            [alert show];
        }
        else{
            PFUser *current = [PFUser currentUser];
            PFObject *comment = [PFObject objectWithClassName:@"Journal_Comments"];
            comment[@"Entry_ID"] = [_journal objectForKey:@"Entry_ID"];
            comment[@"Comment"] = self.Comment.text;
            comment[@"username"] = [current objectForKey:@"username"];
            [comment saveInBackground];
            self.Comment.text = nil;
            [self reloadAgain:commentsTable];
        }
    }
}

- (void)likeMethod:(id)sender {
    PFObject *like = [PFObject objectWithClassName:@"Journal_Like"];
    like[@"Entry_ID"] = [_journal objectForKey:@"Entry_ID"];
    like[@"username"] = [[PFUser currentUser] objectForKey:@"username"];
    [like saveInBackground];
    self.likeButton.enabled = NO;
    self.likeLabel.text = [NSString stringWithFormat:@"%lu Likes",(unsigned long)likesArray.count+1];
}

-(void) delete:(NSIndexPath *)IndexRow
{
    PFObject *deleting = self.journal;
    [deleting deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    PFQuery *Tagsquery = [PFQuery queryWithClassName:@"Journal_Tags"];
    [Tagsquery whereKey:@"Entry_ID" equalTo:[deleting objectForKey:@"Entry_ID"]];
    [Tagsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(int i = 0; i < objects.count; i++){
                PFObject *feedDel = [objects objectAtIndex:i];
                [feedDel deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        // The find succeeded. The first 100 objects are available in objects
                        
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    PFQuery *Likesquery = [PFQuery queryWithClassName:@"Journal_Tags"];
    [Likesquery whereKey:@"Entry_ID" equalTo:[deleting objectForKey:@"Entry_ID"]];
    [Likesquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(int i = 0; i < objects.count; i++){
                PFObject *likeDel = [objects objectAtIndex:i];
                [likeDel deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        // The find succeeded. The first 100 objects are available in objects
                        
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    PFQuery *Commentssquery = [PFQuery queryWithClassName:@"Journal_Tags"];
    [Commentssquery whereKey:@"Entry_ID" equalTo:[deleting objectForKey:@"Entry_ID"]];
    [Commentssquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(int i = 0; i < objects.count; i++){
                PFObject *comDel = [objects objectAtIndex:i];
                [comDel deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        // The find succeeded. The first 100 objects are available in objects
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    [self performSegueWithIdentifier:@"PostUser" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"PostUser"]) {
        ProfileViewController *controller = (ProfileViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        controller.user = [_journal objectForKey:@"username"];
        return;
    }
    else if ([[segue identifier] isEqualToString:@"MapSegue"]) {
        MapViewController *controller = (MapViewController *)[[segue destinationViewController] topViewController];
        self.splitViewController.displayModeButtonItem.title = @"Navigation";
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftBarButtonItem.title = @"Navigation";
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        controller.location = [_journal objectForKey:@"Location"];
        return;
    }
}
- (IBAction)shareButton:(id)sender {
    UIActionSheet *sharingSheet = [[UIActionSheet alloc] initWithTitle:@"Share"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Tweet",
                                   @"Share on Facebook", @"Share on Google+", nil];
    [sharingSheet showInView:self.view];
}

- (IBAction)Map:(id)sender {
    [self performSegueWithIdentifier:@"MapSegue" sender:sender];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweet setInitialText:[self.journal objectForKey:@"Title"]];
            [tweet setCompletionHandler:^(SLComposeViewControllerResult result)
             {
                 if (result == SLComposeViewControllerResultCancelled)
                 {
                     NSLog(@"The user cancelled.");
                 }
                 else if (result == SLComposeViewControllerResultDone)
                 {
                     NSLog(@"The user sent the tweet");
                 }
             }];
            [self presentViewController:tweet animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
                                                            message:@"Twitter integration is not available.  A Twitter account must be set up on your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (buttonIndex == 1)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [facebook setInitialText:[self.journal objectForKey:@"Title"]];
            [facebook setCompletionHandler:^(SLComposeViewControllerResult result)
             {
                 if (result == SLComposeViewControllerResultCancelled)
                 {
                     NSLog(@"The user cancelled.");
                 }
                 else if (result == SLComposeViewControllerResultDone)
                 {
                     NSLog(@"The user posted to Facebook");
                 }
             }];
            [self presentViewController:facebook animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                            message:@"Facebook integration is not available.  A Facebook account must be set up on your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (buttonIndex == 2)
    {
        if ([[GPPSignIn sharedInstance] authentication]) {
            id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
            [shareBuilder setPrefillText:[self.journal objectForKey:@"Title"]];
            [shareBuilder open];
        } else {
            [self googleLogin];
        }
    }
}

-(void) googleLogin{

    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.clientID = kClientId;
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    signIn.delegate = self;
    [signIn authenticate];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
    [[self navigationController] pushViewController:viewController animated:YES];
}

@end
