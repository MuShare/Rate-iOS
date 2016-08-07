//
//  CurrencyDao.m
//  Rate-iOS
//
//  Created by lidaye on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "CurrencyDao.h"

@implementation CurrencyDao

- (Currency *)saveOrUpdateWithJSONObject:(NSObject *)object {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    Currency *currency = [self getByCid:[object valueForKey:@"cid"]];
    if(currency == nil) {
        currency = [NSEntityDescription insertNewObjectForEntityForName:CurrencyEntityName
                                                 inManagedObjectContext:self.context];
    }
    currency.cid = [object valueForKey:@"cid"];
    currency.code = [object valueForKey:@"code"];
    currency.icon = [object valueForKey:@"icon"];
    currency.name = [object valueForKey:@"name"];
    return currency;
}

- (Currency *)getByCid:(NSString *)cid {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return (Currency *)[self getByPredicate:[NSPredicate predicateWithFormat:@"cid=%@", cid]
                             withEntityName:CurrencyEntityName];
}

- (Currency *)getByCode:(NSString *)code {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return (Currency *)[self getByPredicate:[NSPredicate predicateWithFormat:@"code=%@", code]
                             withEntityName:CurrencyEntityName];
}

- (NSArray *)findAll {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self findByPredicate:nil
                  withEntityName:CurrencyEntityName
                         orderBy:[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES]];
}

- (NSArray *)findInCids:(NSArray *)cids{
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self findByPredicate:[NSPredicate predicateWithFormat:@"cid IN %@", cids]
                  withEntityName:CurrencyEntityName
                         orderBy:[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES]];
}

@end
