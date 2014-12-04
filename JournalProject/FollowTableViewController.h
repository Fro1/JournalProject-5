//
//  FollowTableViewController.h
//  JournalProject
//
//  Created by Nadir Zaman on 11/22/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FollowTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *followTable;
    NSMutableArray *followArray;
}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) PFObject *selected;
@property (strong, nonatomic) NSString *followStatus;
@property (strong, nonatomic) PFFile *photoFile;

@end
