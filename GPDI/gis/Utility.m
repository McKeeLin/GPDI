//
//  Utility.m
//  GPDI
//
//  Copyright (c) 2015年 GPDI. All rights reserved.
//

#import "Utility.h"

@implementation Utility


+(NSArray*)arrayWithResponseObject:(id)responseObject
{
    NSData *responseData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
    NSError *error = nil;
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
    return responseArray;
}

+(NSDictionary*)dictionaryWithResponseObject:(id)responseObject
{
    NSData *responseData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
    NSError *error = nil;
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
    return responseDic;
}

@end
