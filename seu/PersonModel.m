//
//  PersonModel.m
//  牵手
//
//  Created by liewli on 12/13/15.
//  Copyright © 2015 li liew. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"degree":@"degree",
             @"enrollment":@"enrollment",
             @"hobby":@"hobby",
             @"ID":@"id",
             @"phone":@"phone",
             @"preference":@"preference",
             @"qq":@"qq",
             @"wechat":@"wechat",
             @"username":@"username",
             @"birthday":@"birthday",
             @"name":@"name",
             @"school":@"school",
             @"department":@"department",
             @"gender":@"gender",
             @"hometown":@"hometown",
             @"lookcount":@"lookcount",
             @"activityStatus":@"flag"
             };
}


+ (NSValueTransformer *) activityStatusJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            if ([value isEqualToNumber:@(1)]) {
                return @YES;
            }
            else {
                return @NO;
            }
        }
        else if ([value isKindOfClass:[NSString class]]){
            if ([value isEqualToString:@"1"]) {
                return @YES;
            }
            else {
                return @NO;
            }
        }
        else {
            return @NO;
        }
    }];
}


+ (NSValueTransformer *) IDJSONTransformer {
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

+ (NSValueTransformer *) lookcountJSONTransformer {
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