//
//  RatesTableViewController.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 7/31/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"

@interface RatesTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) UISearchController *searchController;

@property (nonatomic, strong) Currency *basedCurrency;

@end
