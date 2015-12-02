//
//  DLVoiceRecorderViewController.h
//  VoiceRP
//
//  Created by liewli on 7/7/15.
//  Copyright (c) 2015 li liew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WavAmrCodec.h"
#import <AVFoundation/AVFoundation.h>

@class DLVoiceRecorderViewController;

@protocol DLVoiceRecorderViewControllerDelegate <NSObject>
- (void)voiceRecorder:(DLVoiceRecorderViewController *)voiceRecorder didSendVoiceFile:(NSString *)filePath;
- (void)voiceRecorderDidCancel:(DLVoiceRecorderViewController *)voiceRecorder;

@end

@interface DLVoiceRecorderViewController : UIViewController
@property (nonatomic, weak)id<DLVoiceRecorderViewControllerDelegate> delegate;
@end
