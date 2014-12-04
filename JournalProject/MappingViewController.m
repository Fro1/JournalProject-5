//
//  MappingViewController.m
//  JournalProject
//
//  Created by Nadir Zaman on 12/2/14.
//
//

#import "MappingViewController.h"
#import "MappingTableViewCell.h"

@interface MappingViewController ()

@end

@implementation MappingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(0/255.0) green:(18/255.0) blue:(63/255.0) alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.splitViewController.displayModeButtonItem.title = @"Mapping";
    
    replaceArray = [NSMutableArray array];
    PFQuery *replaceQuery = [PFQuery queryWithClassName:@"Mapping"];
    [replaceQuery whereKey:@"username" equalTo:[[PFUser currentUser] objectForKey:@"username"]];
    [replaceQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            [replaceArray addObjectsFromArray:objects];
            [replaceTable reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reload{
    [replaceTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [replaceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MappingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapCells"];
    PFObject *words = [replaceArray objectAtIndex:indexPath.row];
    cell.original.text = [words objectForKey:@"original"];
    cell.replacement.text = [words objectForKey:@"mapped"];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)replaceButton:(id)sender {
    if(self.original.text.length != 0 && self.replacement.text.length != 0){
        PFObject *replace = [PFObject objectWithClassName:@"Mapping"];
        replace[@"username"] = [[PFUser currentUser] objectForKey:@"username"];
        replace[@"original"] = self.original.text;
        replace[@"mapped"] = self.replacement.text;
        [replace saveInBackground];
        [replaceArray addObject:replace];
    }
    else if(self.original.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                       message: @"No word to replace"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        
        [alert show];
    }
    else if(self.replacement.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                       message: @"No replacement word"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        
        [alert show];
    }
    [self reload];
}
@end
