//
//  DaoTemplate.h
//  Rate-iOS
//
//  Created by lidaye on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Currency.h"

#define DAO_DEBUG 0

@interface DaoTemplate : NSObject

@property (nonatomic,readonly) NSManagedObjectContext *context;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

- (void)saveContext;

//通过谓词和实体名称查询一个托管对象
- (NSManagedObject *)getByPredicate:(NSPredicate *)predicate
                    withEntityName:(NSString *)entityName;

//通过谓词、排序规则和实体名称查询一个托管对象
- (NSManagedObject *)getByPredicate:(NSPredicate *)predicate
                    withEntityName:(NSString *)entityName
                           orderBy:(NSSortDescriptor *)sortDescriptor;

//通过谓词和实体名称查询一个托管对象数组
- (NSArray *)findByPredicate:(NSPredicate *)predicate
             withEntityName:(NSString *)entityName;

//通过谓词、排序规则和实体名称查询一个托管对象数组
- (NSArray *)findByPredicate:(NSPredicate *)predicate
             withEntityName:(NSString *)entityName
                    orderBy:(NSSortDescriptor *)sortDescriptor;

@end
