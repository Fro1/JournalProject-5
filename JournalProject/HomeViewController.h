//
//  HomeViewController.h
//  JournalProject
//
//  Created by Nadir Zaman on 11/14/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *tableView;
    NSMutableArray *homeArray;
    NSMutableArray *all;
}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) PFFile *photoFile;
@property (weak, nonatomic) IBOutlet UILabel *userText;
@property (weak, nonatomic) IBOutlet UIButton *NewButton;
@property PFObject *chosenJournal;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@end
