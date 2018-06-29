//
//  DaoManager.m
//  Rate-iOS
//
//  Created by lidaye on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "DaoManager.h"

@implementation DaoManager

- (id)init {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    }
    self = [super init];
    if (self) {
        _context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        _currencyDao = [[CurrencyDao alloc] initWithManagedObjectContext:_context];
        _subscribeDao = [[SubscribeDao alloc] initWithManagedObjectContext:_context];
    }
    return self;
}

- (NSManagedObject *)getObjectById:(NSManagedObjectID *)objectID {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    }
    return [_context existingObjectWithID:objectID error:nil];
}

- (void)saveContext{
    if (DEBUG)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            if (DEBUG)
                NSLog(@"_context saved changes to persistent store.");
        }
        else
            NSLog(@"Failed to save _context : %@",error);
    }else{
        NSLog(@"Skipped _context save, there are no changes.");
    }
}

@end
