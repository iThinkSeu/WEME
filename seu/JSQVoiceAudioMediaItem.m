//
//  JSQVoiceAudioMediaItem.m
//  PaoFace
//
//  Created by liewli on 7/7/15.
//  Copyright (c) 2015 li liew. All rights reserved.
//

#import "JSQVoiceAudioMediaItem.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "UIColor+JSQMessages.h"

#define W [UIScreen mainScreen].bounds.size.width - 160


@implementation JSQVoiceAudioMediaItem
{
    unsigned long long _time;
}

- (instancetype)initWithImage:(UIImage *)image withFilePath:(NSString *)filePath isOutgoing:(BOOL)outgoing {
    if (self = [super init]) {
        _image = image;
        _filePath = filePath;
        _isOutgoing = outgoing;
        _time = 0;
        [self calcSize];
    }
    
    return self;
}

- (void)calcSize {
    unsigned long long  size = [[[NSFileManager defaultManager] attributesOfItemAtPath:_filePath error:nil][NSFileSize] unsignedLongLongValue];
      NSLog(@"file size: %llu", size);
     _time = MAX(1, (unsigned long long)ceil(size*8 / 4750.0));
}

- (UIView *)mediaView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.mediaViewDisplaySize.width, self.mediaViewDisplaySize.height)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:_image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imageView];
    UILabel *label = [[UILabel alloc]init];
   
    label.text = [NSString stringWithFormat:@"%llu''", _time];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    [view addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *dict = NSDictionaryOfVariableBindings(label, imageView);
    NSArray *arr = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[label]-10-|" options:0 metrics:nil views:dict];
    [view addConstraints:arr];
    arr = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[imageView]-10-|" options:0 metrics:nil views:dict];
    [view addConstraints:arr];
    if (_isOutgoing) {
        view.backgroundColor = [UIColor jsq_messageBubbleLightGrayColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        NSArray *arr = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[label]-[imageView(24@120)]-20-|" options:0 metrics:nil views:dict];
        [view addConstraints:arr];
    }
    else {
        view.backgroundColor = [UIColor jsq_messageBubbleLightGrayColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentRight;
        NSArray *arr = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[imageView(24)]-[label]-20-|" options:0 metrics:nil views:dict];
        [view addConstraints:arr];
    }
    [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:view isOutgoing:self.appliesMediaViewMaskAsOutgoing];
    return view;
}


- (CGSize)mediaViewDisplaySize {
    
    CGFloat width = MIN(W, 140 + _time*2);
    return (CGSize) {width, 36};
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

- (NSUInteger)hash
{
    return super.hash ^ self.image.hash ^ self.filePath.hash;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _image = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
        _filePath = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(filePath))];
        _isOutgoing = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(isOutgoing))] boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
    [aCoder encodeObject:self.filePath forKey:NSStringFromSelector(@selector(filePath))];
    [aCoder encodeObject:@(self.isOutgoing) forKey:NSStringFromSelector(@selector(isOutgoing))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQVoiceAudioMediaItem *copy = [[[self class] allocWithZone:zone] initWithImage:_image withFilePath:_filePath isOutgoing:_isOutgoing];
    return copy;
}


@end
