//
//  MappingViewController.h
//  JournalProject
//
//  Created by Nadir Zaman on 12/2/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MappingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *replaceTable;
    NSMutableArray *replaceArray;
}

@property (weak, nonatomic) IBOutlet UITextField *original;
@property (weak, nonatomic) IBOutlet UITextField *replacement;
- (IBAction)replaceButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *cellOriginal;
@property (weak, nonatomic) IBOutlet UILabel *cellReplacement;

@end
