//
//  PostViewController.h
//  JournalProject
//
//  Created by Nadir Zaman on 11/17/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreImage/CoreImage.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Social/Social.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>


@interface PostViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, GPPSignInDelegate>{
    IBOutlet UITableView *tagTable;
    IBOutlet UITableView *commentsTable;
    NSMutableArray *tagArray;
    NSMutableArray *commentsArray;
    NSMutableArray *likesArray;
}

@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) id detailItem;
@property (strong,nonatomic) PFObject *journal;
@property (strong,nonatomic) NSURL *url;
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) UIImageView *images;
@property CGPoint center;
@property (strong,nonatomic) MPMoviePlayerController *myPlayer;
@property (weak, nonatomic) IBOutlet UITextView *Entry;
@property (weak, nonatomic) IBOutlet UITextView *Comment;
- (IBAction)CommentButton:(id)sender;
@property(retain,nonatomic)UIButton *likeButton;
@property(retain,nonatomic)UIButton *deleteButton;
- (IBAction)shareButton:(id)sender;
- (IBAction)Map:(id)sender;


@end
