//
//  CurrenciesTableViewController.h
//  Rate-iOS
//
//  Created by lidaye on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"

@interface CurrenciesTableViewController : UITableViewController

@property (nonatomic) BOOL selectable;
@property (nonatomic, strong) NSString *currencyAttributeName;

@end
