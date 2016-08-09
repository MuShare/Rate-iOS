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

//#define DoaminName @"rate.mushare.cn"
#define DoaminName @"127.0.0.1:8080"

@interface InternetTool : NSObject

+ (AFHTTPSessionManager *)getSessionManager;

+ (AFHTTPSessionManager *)getSessionManagerForJSON;

+ (NSString *)createUrl:(NSString *)relativePosition;

+ (NSDictionary *)getResponse:(id  _Nullable)responseObject;

@end
