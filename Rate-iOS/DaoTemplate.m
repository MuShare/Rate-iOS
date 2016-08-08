//
//  DaoTemplate.m
//  Rate-iOS
//
//  Created by lidaye on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "DaoTemplate.h"

@implementation DaoTemplate

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    if (DEBUG) {
        NSLog(@"Running %@ ''%@", self.class, NSStringFromSelector(_cmd));
    }
    self = [super init];
    _context = context;
    return self;
}

- (void)saveContext{
    if (DEBUG) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    }
    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            if(DEBUG) {
                NSLog(@"_context saved changes to persistent store.");
            }
        } else {
            NSLog(@"Failed to save _context : %@",error);
        }
    } else {
        NSLog(@"Skipped _context save, there are no changes.");
    }
}

- (NSManagedObject *)getByPredicate:(NSPredicate *)predicate
                     withEntityName:(NSString *)entityName {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.predicate = predicate;
    request.fetchLimit = 1;
    NSError *error = nil;
    NSArray *objects = [_context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error with fetching request: %@",error);
    }
    if (objects.count > 0) {
        return [objects objectAtIndex:0];
    }
    return nil;
}

- (NSArray *)findAllWithEntityName:(NSString *)entityName {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    }
    return [self findByPredicate:nil withEntityName:entityName];
}

- (NSArray *)findByPredicate:(NSPredicate *)predicate
              withEntityName:(NSString *)entityName {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    }
    NSError *error = nil;
    NSArray *objects = [_context executeFetchRequest:[self fetchRequestByPredicate:predicate
                                                                    withEntityName:entityName]
                                               error:&error];
    if (error) {
       NSLog(@"Error with fetching request: %@",error);
    }
    return objects;
}

- (NSArray *)findByPredicate:(NSPredicate *)predicate
              withEntityName:(NSString *)entityName
                     orderBy:(NSSortDescriptor *)sortDescriptor {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    }
    NSError *error = nil;
    NSArray *objects = [_context executeFetchRequest:[self fetchRequestByPredicate:predicate
                                                                    withEntityName:entityName
                                                                           orderBy:sortDescriptor]
                                               error:&error];
    if (error) {
        NSLog(@"Error with fetching request: %@",error);
    }
    return objects;
}

- (NSFetchRequest *)fetchRequestByPredicate:(NSPredicate *)predicate
                             withEntityName:(NSString *)entityName {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = predicate;
    return request;
}

- (NSFetchRequest *)fetchRequestByPredicate:(NSPredicate *)predicate
                             withEntityName:(NSString *)entityName
                                    orderBy:(NSSortDescriptor *)sortDescriptor {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.predicate = predicate;
    return request;
}
@end
