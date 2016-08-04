//
//  AppDelegate.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 7/31/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AFNetworking/AFNetworking.h>

#define DoaminName @"rate.fczm.pw"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AFHTTPSessionManager *httpSessionManager;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

