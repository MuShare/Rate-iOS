//
//  InternetTool.m
//  Rate-iOS
//
//  Created by lidaye on 8/2/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "InternetTool.h"

@implementation InternetTool

+ (void)setRequestToken:(NSString *)token {
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    [delegate.httpSessionManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
}

+ (AFHTTPSessionManager *)getSessionManager {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    return delegate.httpSessionManager;
}

+ (NSString *)createUrl:(NSString *)relativePosition {
    NSString *url=[NSString stringWithFormat:@"http://%@/%@", DoaminName, relativePosition];
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        NSLog(@"Request URL is: %@",url);
    }
    return url;
}

+ (NSDictionary *)getResponse:(id)responseObject {
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        NSLog(@"Get Message from server: %@", response);
    }
    return response;
}

@end
