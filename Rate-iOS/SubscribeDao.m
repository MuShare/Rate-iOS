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
    if(subscribe == nil) {
        //Create new subscribe
        subscribe = [NSEntityDescription insertNewObjectForEntityForName:SubsribeEntityName
                                                  inManagedObjectContext:self.context];
        CurrencyDao *currencyDao = [[CurrencyDao alloc] init];
        subscribe.from = [currencyDao getByCid:[object valueForKey:@"fromCurrency"]];
        subscribe.to = [currencyDao getByCid:[object valueForKey:@"toCurrency"]];
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
    return [self findByPredicate:nil withEntityName:SubsribeEntityName];
}

@end
