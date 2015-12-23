//
//  ActivityModel.m
//  牵手东大
//
//  Created by liewli on 12/9/15.
//  Copyright © 2015 li liew. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"activityID":@"id",
             @"title":@"title",
             @"time":@"time",
             @"location":@"location",
             @"capacity":@"number",
             @"state":@"state",
             @"signnumber":@"signnumber",
             @"remark":@"remark"
             };
}

+ (NSValueTransformer *) capacityJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%@", value];
        }
        else if ([value isKindOfClass:[NSString class]]){
            return value;
        }
        else {
            return @"";
        }
        
    }];
}

+ (NSValueTransformer *) activityIDJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%@", value];
        }
        else if ([value isKindOfClass:[NSString class]]){
            return value;
        }
        else {
            return @"";
        }
        
    }];
}


@end
