//
//  DaoManager.h
//  Rate-iOS
//
//  Created by lidaye on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CurrencyDao.h"
#import "SubscribeDao.h"

@interface DaoManager : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *context;

@property (strong, nonatomic) CurrencyDao *currencyDao;
@property (strong, nonatomic) SubscribeDao *subscribeDao;

- (NSManagedObject *)getObjectById:(NSManagedObjectID *)objectID;
- (void)saveContext;

@end
