//
//  gisDataMgr.h
//  GPDI
//
//  Copyright (c) 2015年 GPDI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"

typedef void(^SOAP_BLOCK) (NSString* result, NSString *error);

@interface gisDataMgr : NSObject

+ (instancetype)manager;

+ (void)asyncLogin:(NSString*)account password:(NSString*)password block:(void(^)(int status, NSString *msg))block;

+ (void)asyncLogout:(void(^)(int status, NSString *msg))block;

- (void)doRequest;

- (void)postSoapMessage:(NSString*)message params:(NSDictionary*)params block:(SOAP_BLOCK)block;


@end
