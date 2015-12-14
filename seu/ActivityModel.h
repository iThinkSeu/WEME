
//  ActivityModel.h
//  牵手东大
//
//  Created by liewli on 12/9/15.
//  Copyright © 2015 li liew. All rights reserved.
//

#import <Mantle/Mantle.h>

//#import <Foundation/Foundation.h>


@interface ActivityModel: MTLModel <MTLJSONSerializing>

@property (nonatomic, copy)NSString * activityID;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSString *location;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *capacity;
@property (nonatomic, copy)NSString *state;

@end
