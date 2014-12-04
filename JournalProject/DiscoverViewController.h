//
//  DiscoverViewController.h
//  JournalProject
//
//  Created by Nadir Zaman on 11/26/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface DiscoverViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>{
    IBOutlet UITableView *SearchTable;
    IBOutlet UITableView *ResultTable;
    NSArray *searchArray;
    NSMutableArray *findArray;
    NSMutableArray *resultArray;
}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSString *resultType;
@property BOOL *search;
- (IBAction)Entries:(id)sender;
- (IBAction)Users:(id)sender;
- (IBAction)Tags:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
