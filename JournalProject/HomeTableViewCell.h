//
//  HomeTableViewCell.h
//  JournalProject
//
//  Created by Nadir Zaman on 11/21/14.
//
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Avatar;
@property (weak, nonatomic) IBOutlet UIImageView *heart;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *tag1;
@property (weak, nonatomic) IBOutlet UILabel *tag2;

@end
