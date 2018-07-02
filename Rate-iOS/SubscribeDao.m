//
//  SubscribeDao.m
//  Rate-iOS
//
//  Created by lidaye on 8/8/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "SubscribeDao.h"
#import "CurrencyDao.h"
@implementation SubscribeDao

- (Subscribe *)saveOrUpdateWithJSONObject:(NSObject *)object {
    if (DEBUG) {
        NSLog(@"Ruuning %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    Subscribe *subscribe = [self getBySid:[object valueForKey:@"sid"]];
    if (subscribe == nil) {
        //Create new subscribe
        subscribe = [NSEntityDescription insertNewObjectForEntityForName:SubsribeEntityName
                                                  inManagedObjectContext:self.context];
        CurrencyDao *currencyDao = [[CurrencyDao alloc] initWithManagedObjectContext:self.context];
        subscribe.from = [currencyDao getByCid:[object valueForKey:@"fromCid"]];
        subscribe.to = [currencyDao getByCid:[object valueForKey:@"toCid"]];
    }
    subscribe.enable = [NSNumber numberWithInt:[[object valueForKey:@"enable"] boolValue]];
    subscribe.sendEmail = [NSNumber numberWithInt:[[object valueForKey:@"sendEmail"] boolValue]];
    subscribe.sendSMS = [NSNumber numberWithInt:[[object valueForKey:@"sendSms"] boolValue]];
    subscribe.sname = [object valueForKey:@"sname"];
    subscribe.threshold = [NSNumber numberWithFloat:[[object valueForKey:@"threshold"] floatValue]];
    subscribe.sid = [object valueForKey:@"sid"];
    
    return subscribe;
}

- (Subscribe *)getBySid:(NSString *)sid {
    if (DEBUG) {
        NSLog(@"Ruuning %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return (Subscribe *)[self getByPredicate:[NSPredicate predicateWithFormat:@"sid=%@", sid]
                              withEntityName:SubsribeEntityName];
}

- (NSArray *)findAll {
    if (DEBUG) {
        NSLog(@"Ruuning %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self findAllWithEntityName:SubsribeEntityName];
}

- (void)deleteBySid:(NSString *)sid {
    if (DEBUG) {
        NSLog(@"Ruuning %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    Subscribe *subscribe = [self getBySid:sid];
    if (subscribe != nil) {
        [self.context deleteObject:subscribe];
    }
}

- (NSFetchedResultsController *)fetchedResultsControllerForAll {
    if (DEBUG) {
        NSLog(@"Ruuning %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSFetchRequest *request = [self fetchRequestByPredicate:nil
                                             withEntityName:SubsribeEntityName
                                                    orderBy:[NSSortDescriptor sortDescriptorWithKey:@"sname" ascending:YES]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                               managedObjectContext:self.context
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Perform fetch with error: %@", error);
    }
    return fetchedResultsController;
}

@end
