//
//  JSQVoiceAudioMediaItem.h
//  PaoFace
//
//  Created by liewli on 7/7/15.
//  Copyright (c) 2015 li liew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMediaItem.h"

@interface JSQVoiceAudioMediaItem : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>

@property (nonatomic, copy)UIImage *image;
@property (nonatomic, copy)NSString *filePath;
@property (nonatomic, assign)BOOL isOutgoing;

- (instancetype)initWithImage:(UIImage *)image withFilePath:(NSString *)filePath isOutgoing:(BOOL)outgoing;
@end
