//
//  SubscribeTableViewController.h
//  Rate-iOS
//
//  Created by lidaye on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"

@interface SubscriptionsTableViewController : UITableViewController

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (IBAction)addSubscribe:(id)sender;
@end
