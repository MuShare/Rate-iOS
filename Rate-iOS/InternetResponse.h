//
//  InternetResponse.h
//  MuShare-iOS
//
//  Created by 李大爷的电脑 on 7/13/16.
//  Copyright © 2016 limeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternetResponse : NSObject

@property (nonatomic, strong) NSObject *data;

//init with Internet response
- (instancetype) initWithResponseObject:(id)responseObject;

//response status is 200
- (BOOL)statusOK;

//response result
- (id)getResponseResult;
@end
