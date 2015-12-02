//
//  DLVoiceRecorderViewController.m
//  VoiceRP
//
//  Created by liewli on 7/7/15.
//  Copyright (c) 2015 li liew. All rights reserved.
//

#import "DLVoiceRecorderViewController.h"


#define H [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - (self.navigationController?[UIApplication sharedApplication].statusBarFrame.size.height:0)
#define W [UIScreen mainScreen].bounds.size.width

#define kVoiceRecorderPanelHeight 280
#define ItemHeight 50.0f
#define ItemSpacing 7.0f

@interface DLVoiceRecorderViewController () <UIGestureRecognizerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property (nonatomic, weak)UIView *backView;
@property (nonatomic, weak)UIImageView *voiceBackView;
@property (nonatomic, weak)UIImageView *operateListenBack;
@property (nonatomic, weak)UIImageView *operateListenFore;
@property (nonatomic, weak)UIImageView *operateDeleteBack;
@property (nonatomic, weak)UIImageView *operateDeleteFore;
@property (nonatomic, weak)UILabel *hintLabel;
@property (nonatomic, strong)NSString *voiceDir;
@property (nonatomic, strong)AVAudioRecorder *recorder;
@property (nonatomic, strong)AVAudioPlayer *player;
@property (nonatomic, strong)NSString *voiceFilePath;
@property (nonatomic, strong)NSDictionary *recordSetting;
@property (nonatomic, strong)NSString *amrFilePath;
@end

@implementation DLVoiceRecorderViewController
{
    BOOL _operateDeletePressed;
    BOOL _operateListenPressed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    _operateDeletePressed = _operateListenPressed = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [paths objectAtIndex:0];
    _voiceDir = [document stringByAppendingPathComponent:@"voice"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_voiceDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:_voiceDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    
    _recordSetting = @{
                        AVEncoderAudioQualityKey:@(AVAudioQualityMin),
                        AVEncoderBitRateKey : @(16),
                        AVNumberOfChannelsKey: @(1),
                        AVSampleRateKey: @(8000.0)
                        };
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadUI];
    });
    
}

- (void)loadUI {
    [self.view setFrame:CGRectMake(0, 0, W, H)];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    
    
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:226.0f/255.f blue:236.0f/255.0f alpha:1];
    [backView setFrame:CGRectMake(0, H, W, kVoiceRecorderPanelHeight)];
    
    [self.view addSubview:backView];
    self.backView = backView;
    
    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelbtn setBackgroundImage:[UIImage imageNamed:@"chat_bottom_arrowdown_nor"] forState:UIControlStateNormal];
    //[cancelbtn setFrame:CGRectMake(0, 0, W, ItemHeight)];
    [cancelbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelbtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbtn setTag:100];
    [backView addSubview:cancelbtn];
    cancelbtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:cancelbtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cancelbtn.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self.backView addConstraint:constraint];
    
    UILabel *label = [[UILabel alloc]init];
    [self.backView addSubview:label];
    _hintLabel = label;
    NSDictionary *dict = NSDictionaryOfVariableBindings(label, cancelbtn);
    label.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *arr = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:0 metrics:nil views:dict];
    [self.backView addConstraints:arr];
   // NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:10];
    arr = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[cancelbtn]-10-[label]" options:0 metrics:nil views:dict];
    [self.backView addConstraints:arr];
    
    label.text = @"按住说话";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:20];
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
//    pan.delegate = self;
//    [self.backView addGestureRecognizer:pan];
    
    UIImageView *voice = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aio_voice_button_nor"]];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressVoice:)];
    [voice addGestureRecognizer:longPress];
    longPress.delegate = self;
    voice.frame = CGRectMake((backView.frame.size.width - 107)/2, (backView.frame.size.height - 107)/2 + 20, 107, 107);
    [self.backView addSubview:voice];
    voice.userInteractionEnabled = YES;
    
    UIImageView *mic = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aio_voice_button_icon"]];
    mic.frame = CGRectMake((voice.frame.size.width - 34)/2, (voice.frame.size.height - 55)/2, 34, 55);
    [voice addSubview:mic];
    
    _voiceBackView = voice;
    
    
    UIImageView *_delete = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aio_voice_operate_nor"]];
    _delete.contentMode = UIViewContentModeScaleAspectFill;
    _operateDeleteBack = _delete;
    CGPoint vec = (CGPoint) {150, -46};
    CGPoint center = (CGPoint) {voice.center.x + vec.x, voice.center.y + vec.y};
    _delete.frame = CGRectMake(center.x - 40/2, center.y - 40/2, 40, 40);
    [self.backView addSubview:_delete];
    self.operateDeleteBack = _delete;
    
    UIImageView *deleteFore = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aio_voice_operate_delete_nor"]];
    deleteFore.frame = CGRectMake((_delete.frame.size.width- 24)/2, (_delete.frame.size.height - 24)/2, 24, 24);
    [_delete addSubview:deleteFore];
    self.operateDeleteFore = deleteFore;
    
    [self addBezierPathBetweenPoint:self.voiceBackView.center andPoint:self.operateDeleteBack.center];
 
    
    UIImageView *listen = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aio_voice_operate_nor"]];
    listen.contentMode = UIViewContentModeScaleAspectFill;
    _operateListenBack = listen;
    vec = (CGPoint) {-150, -46};
    center = (CGPoint) {voice.center.x + vec.x, voice.center.y + vec.y};
    listen.frame = CGRectMake(center.x - 40/2, center.y - 40/2, 40, 40);
    [self.backView addSubview:listen];
    self.operateListenBack = listen;
    
    UIImageView *listenFore = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aio_voice_operate_listen_nor"]];
    listenFore.frame = CGRectMake((listen.frame.size.width- 24)/2, (listen.frame.size.height - 24)/2, 24, 24);
    [listen addSubview:listenFore];
    self.operateListenFore = listenFore;
    
    [self addBezierPathBetweenPoint:self.voiceBackView.center andPoint:self.operateListenBack.center];
    
    
    
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [self.view  setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        [self.backView setFrame:CGRectMake(0, H - kVoiceRecorderPanelHeight, W, kVoiceRecorderPanelHeight)];
        
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        tap.delegate = self;
        [self.view addGestureRecognizer:tap];
        //[self.backView setFrame:CGRectMake(0, H - height, W, height)];
    }];

}

- (void) addBezierPathBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p1];
    [path addQuadCurveToPoint:p2 controlPoint:CGPointMake((p2.x-p1.x)/3 + p1.x, (p2.y-p1.y)/2+p1.y + 30) ];
    [path addQuadCurveToPoint:p1 controlPoint:CGPointMake((p2.x-p1.x)/3 + p1.x, (p2.y-p1.y)/2+p1.y + 30) ];
    [path closePath];
    line.path = path.CGPath;
    line.lineWidth = 1.0;
    line.strokeColor = [UIColor lightGrayColor].CGColor;
    line.fillColor = line.strokeColor;
    line.zPosition = -1;
    [self.backView.layer addSublayer:line];
    
}

- (void)dismiss {
    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        [_backView setFrame:CGRectMake(0, H, W, kVoiceRecorderPanelHeight)];
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

-(void)dismiss:(UITapGestureRecognizer *)tap{
    
    if( CGRectContainsPoint(self.view.frame, [tap locationInView:_backView])) {
        NSLog(@"tap");
    } else{
        
        [self dismiss];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (touch.view != self.view) {
            return NO;
        }
    }
    else if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        if (touch.view != self.voiceBackView) {
            return NO;
        }
    }
    return YES;
}

- (void)longPressVoice:(UILongPressGestureRecognizer *)longPress {
    CGPoint p = [longPress locationInView:self.backView];
    //NSLog(@"longPress x: %f y: %f", p.x, p.y);
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.hintLabel.text = @"松开发送";
        _voiceBackView.image = [UIImage imageNamed:@"aio_voice_button_press"];
        [self startRecording];
    }
    
    else if (longPress.state == UIGestureRecognizerStateChanged) {
        if (!_operateDeletePressed && CGRectContainsPoint(self.operateDeleteBack.frame, p)) {
            self.hintLabel.text = @"松开取消";
            [UIView animateWithDuration:0.3 animations:^{
                self.operateDeleteBack.image = [UIImage imageNamed:@"aio_voice_operate_press"];
                self.operateDeleteBack.frame = CGRectMake(self.operateDeleteBack.center.x - 80/2, self.operateDeleteBack.center.y - 80/2, 80, 80);
                self.operateDeleteFore.image = [UIImage imageNamed:@"aio_voice_operate_delete_press"];
                self.operateDeleteFore.frame =  CGRectMake((self.operateDeleteBack.frame.size.width- 48)/2, (self.operateDeleteBack.frame.size.height - 48)/2, 48, 48);
            } completion:^(BOOL finished) {
                _operateDeletePressed = YES;
            }];
          
        }
        else if (!_operateListenPressed && CGRectContainsPoint(self.operateListenBack.frame, p)) {
            self.hintLabel.text = @"松开试听";
            [UIView animateWithDuration:0.3 animations:^{
                self.operateListenBack.image = [UIImage imageNamed:@"aio_voice_operate_press"];
                self.operateListenBack.frame = CGRectMake(self.operateListenBack.center.x - 80/2, self.operateListenBack.center.y - 80/2, 80, 80);
                self.operateListenFore.image = [UIImage imageNamed:@"aio_voice_operate_listen_press"];
                self.operateListenFore.frame =  CGRectMake((self.operateListenBack.frame.size.width- 48)/2, (self.operateListenBack.frame.size.height - 48)/2, 48, 48);
            } completion:^(BOOL finished) {
                _operateListenPressed = YES;

            }];
          
        }
        else if (_operateListenPressed && !CGRectContainsPoint(self.operateListenBack.frame, p)){
            self.hintLabel.text = @"松开发送";
            [self listenToNormal];
           
        }
        else if (_operateDeletePressed && !CGRectContainsPoint(self.operateDeleteBack.frame, p)) {
            self.hintLabel.text = @"松开发送";
            [self deleteToNormal];
        }
    }
    
    else if (longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateCancelled) {
        self.hintLabel.text = @"按住说话";
        _voiceBackView.image = [UIImage imageNamed:@"aio_voice_button_nor"];
        if (_operateDeletePressed) {
            [self deleteToNormal];
            [self deleteVoice];
        }
        else if (_operateListenPressed) {
            [self listenToNormal];
            [self listenVoice];
        }
        else {
            [self sendVoice];
        }
    }
}


- (void)startRecording {
    
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }

    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    NSString *filename = [NSString stringWithFormat:@"%@_%@.wav", @"voice", (__bridge NSString *)uuidStr];
    CFRelease(uuidStr);
    _voiceFilePath = [_voiceDir stringByAppendingPathComponent:filename];
    
    
    _recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:_voiceFilePath] settings:_recordSetting error:nil];
    _recorder.delegate = self;

    [_recorder record];
    
    
}
- (void)sendVoice {
    if (_recorder.isRecording) {
        [_recorder stop];
    }
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    NSString *filename = [NSString stringWithFormat:@"%@_%@.amr", @"voice", (__bridge NSString *)uuidStr];
    CFRelease(uuidStr);
    _amrFilePath = [_voiceDir stringByAppendingPathComponent:filename];
    
    amr_encode([_voiceFilePath cStringUsingEncoding:NSASCIIStringEncoding], [_amrFilePath cStringUsingEncoding:NSASCIIStringEncoding]);
    
    [self.delegate voiceRecorder:self didSendVoiceFile:_amrFilePath];
    
    //test
//    NSString *amrWavFilePath = [_voiceDir stringByAppendingPathComponent:@"sound-amr-wav.wav"];
//    amr_decode([_amrFilePath cStringUsingEncoding:NSASCIIStringEncoding], [amrWavFilePath cStringUsingEncoding:NSASCIIStringEncoding]);
//    
//    NSError *error = nil;
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
//    if (error) {
//        NSLog(@"error: %@", error.localizedDescription);
//    }
//    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:amrWavFilePath] error:&error];
//    _player.delegate = self;
//    
//    if (error) {
//        NSLog(@"error: %@", error.localizedDescription);
//    }
//    else {
//        [_player play];
//    }
//    
    [self dismiss];
}

- (void)deleteVoice {
    if (_recorder.isRecording) {
        [_recorder stop];
    }
    [[NSFileManager defaultManager] removeItemAtPath:_voiceFilePath error:nil];
    _voiceFilePath = @"";
    [self.delegate voiceRecorderDidCancel:self];
}

- (void)listenVoice {
    
}

- (void)listenToNormal {
    [UIView animateWithDuration:0.3 animations:^{
        self.operateListenBack.image = [UIImage imageNamed:@"aio_voice_operate_nor"];
        self.operateListenBack.frame = CGRectMake(self.operateListenBack.center.x - 40/2, self.operateListenBack.center.y - 40/2, 40, 40);
        self.operateListenFore.image = [UIImage imageNamed:@"aio_voice_operate_listen_nor"];
        self.operateListenFore.frame =  CGRectMake((self.operateListenBack.frame.size.width- 24)/2, (self.operateListenBack.frame.size.height - 24)/2, 24, 24);
    } completion:^(BOOL finished) {
        _operateListenPressed = NO;
    }];

}

- (void)deleteToNormal {
    [UIView animateWithDuration:0.3 animations:^{
        self.operateDeleteBack.image = [UIImage imageNamed:@"aio_voice_operate_nor"];
        self.operateDeleteBack.frame = CGRectMake(self.operateDeleteBack.center.x - 40/2, self.operateDeleteBack.center.y - 40/2, 40, 40);
        self.operateDeleteFore.image = [UIImage imageNamed:@"aio_voice_operate_delete_nor"];
        self.operateDeleteFore.frame =  CGRectMake((self.operateDeleteBack.frame.size.width- 24)/2, (self.operateDeleteBack.frame.size.height - 24)/2, 24, 24);
        
    } completion:^(BOOL finished) {
        _operateDeletePressed = NO;
        
    }];
}

- (void)cancel:(id)sender {
    [self dismiss];
}

#pragma mark -AVAudioRecorderDelegate, AVAudioPlayerDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"recorder finished: %@", flag?@"Success" : @"error");
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"encode error : %@", error.localizedDescription);
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"error : %@", error.localizedDescription);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"player finished: %@", flag?@"Success" : @"error");
}

@end
