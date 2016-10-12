//
//  MeTableViewController.h
//  Rate-iOS
//
//  Created by lidaye on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *signOrNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeOrEmailLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UISwitch *showFavoriteSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;

- (IBAction)logout:(id)sender;
- (IBAction)changeShowFavorite:(UISwitch *)sender;
- (IBAction)changeNotification:(UISwitch *)sender;

@end
