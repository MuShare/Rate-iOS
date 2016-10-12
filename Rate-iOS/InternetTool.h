//
//  InternetTool.h
//  Rate-iOS
//
//  Created by lidaye on 8/2/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InternetResponse.h"
#import "AppDelegate.h"

#define DoaminName @"rate.mushare.cn"
//#define DoaminName @"192.168.96.74:8080"

@interface InternetTool : NSObject

+ (AFHTTPSessionManager *)getSessionManager;

+ (AFHTTPSessionManager *)getSessionManagerForJSON;

+ (NSString *)createUrl:(NSString *)relativePosition;

+ (NSDictionary *)getResponse:(id  _Nullable)responseObject;

@end
