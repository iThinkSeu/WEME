//
//  NSValueTransformer+Model.m
//  WEME
//
//  Created by liewli on 1/25/16.
//  Copyright © 2016 li liew. All rights reserved.
//

#import "NSValueTransformer+Model.h"

@implementation NSValueTransformer (Model)
+ (void)load {
    [NSValueTransformer setValueTransformer:[self numberORStringToStringValueTransformer] forName:NumberORStringToStringValueTransformer];
}

+ (NSValueTransformer *)numberORStringToStringValueTransformer {
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
