//
//  ProfileViewController.h
//  JournalProject
//
//  Created by Nadir Zaman on 11/18/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *feedTable;
    NSMutableArray *feedArray;
    NSMutableArray *followersArray;
    NSMutableArray *followingArray;
}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *followStatus;
- (IBAction)FollowingButton:(id)sender;
- (IBAction)FollowersButton:(id)sender;
@property PFObject *chosenJournal;
- (IBAction)Follow:(id)sender;
@property (strong, nonatomic) PFFile *photoFile;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@end
