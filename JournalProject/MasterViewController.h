//
//  MasterViewController.h
//  JournalProject
//
//  Created by Nadir Zaman on 11/14/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

