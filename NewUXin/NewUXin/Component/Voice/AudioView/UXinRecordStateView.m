//
//  UXinRecordStateView.m
//  NewUXin
//
//  Created by tanpeng on 2017/10/20.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinRecordStateView.h"
static CGFloat const levelWidth = 3.0;
static CGFloat const levelMargin = 2.0;
@interface UXinRecordStateView ()
/**
 显示文字相关
 */
@property (nonatomic,weak) UILabel *titleLb; // 按住说话文字标签
@property (nonatomic,weak) UIActivityIndicatorView *activityView;
/**
 振幅界面相关
 */
@property (nonatomic,weak) UIView *levelContentView;        // 振幅所有视图的载体
@property (nonatomic,weak) UILabel *timeLabel;              // 录音时长标签
@property (nonatomic,weak) CAReplicatorLayer *replicatorL;  // 复制图层
@property (nonatomic,weak) CAShapeLayer *levelLayer;        // 振幅layer

@property (nonatomic,strong) NSMutableArray *currentLevels; // 当前振幅数组
@property (nonatomic,strong) NSMutableArray *allLevels;     // 所有收集到的振幅,预先保存，用于播放

@property (nonatomic,strong) UIBezierPath *levelPath;       // 画振幅的path

@property (nonatomic,strong) NSTimer *audioTimer;           // 录音时长/播放录音 计时器
@property (nonatomic,strong) CADisplayLink *levelTimer;     // 振幅计时器

@property (nonatomic,assign) NSInteger recordDuration;      // 录音时长

@property (nonatomic,strong) CADisplayLink *playTimer;      // 播放时振幅计时器

@end
@implementation UXinRecordStateView
{
    NSInteger _allCount;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor = [UIColor yellowColor];
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    [self titleLb];
    [self activityView];
    [self updateLableFrame:self.titleLb];
    
    [self levelContentView];
    
}
#pragma mark - displayLink
- (void)startMeterTimer
{
    [self stopMeterTimer];
    self.levelTimer=[CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter)];
    if([[UIDevice currentDevice].systemVersion floatValue]>10.0){
        self.levelTimer.preferredFramesPerSecond =10;
    }else{
        self.levelTimer.frameInterval = 6;
    }
    [self.levelTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
// 停止定时器
- (void)stopMeterTimer
{
    [self.levelTimer invalidate];
}
#pragma mark - audioTimer
-(void)startAudioTimer
{
    [self.audioTimer invalidate];
    if(_recordState != RecordStatePlay){
        
    }
}
- (void)addSeconed
{
    
}
- (void)updateTimeLabel
{
    
}
- (void)updateMeter
{
    
}
- (void)updateLevelLayer
{
    
}
#pragma mark - lazyLoad
- (NSMutableArray *)allLevels
{
    return nil;
}
- (NSMutableArray *)currentLevels
{
    return nil;
}
- (UIView *)levelContentView
{
    if (_levelContentView == nil) {
        UIView *contentV = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:contentV];
        contentV.hidden = YES;
        _levelContentView = contentV;
        
        [self timeLabel];
        [self replicatorL];
        
    }
    return _levelContentView;
}
- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, self.frame.size.height)];
        timeL.text = @"0:00";
        timeL.textAlignment = NSTextAlignmentCenter;
        timeL.font = [UIFont systemFontOfSize:17];
        timeL.textColor =[UIColor  colorWithRed: 119 /255.0 green: 119 /255.0 blue: 119/255.0 alpha:1.0];
        //        [timeL sizeToFit];
        //        timeL.backgroundColor = [UIColor yellowColor];
        timeL.center = self.levelContentView.center;
        [self.levelContentView addSubview:timeL];
        _timeLabel = timeL;
    }
    return _timeLabel;
}
- (CAReplicatorLayer *)replicatorL
{
    if(_replicatorL == nil){
        CAReplicatorLayer *repL =[CAReplicatorLayer layer];
        repL.bounds=self.layer.bounds;
        repL.instanceCount =2;
        repL.instanceTransform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        [self.levelContentView.layer addSublayer:repL];
        _replicatorL = repL;
        [self levelLayer];
    }
    return _replicatorL;
}
- (CAShapeLayer *)levelLayer
{
    if (_levelLayer == nil) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(self.timeLabel.frame.origin.x+self.timeLabel.frame.size.width, 10, self.frame.size.width / 2.0 - 30, self.frame.size.height - 20);
        //        layer.backgroundColor = [UIColor whiteColor].CGColor;
        layer.strokeColor =[UIColor  colorWithRed: 253 /255.0 green: 99 /255.0 blue: 9/255.0 alpha:1.0].CGColor;
        layer.lineWidth = levelWidth;
        [self.replicatorL addSublayer:layer];
        _levelLayer = layer;
    }
    return _levelLayer;
}
- (UILabel *)titleLb
{
    if (_titleLb == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"按住说话";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor  colorWithRed: 119 /255.0 green: 119 /255.0 blue: 119/255.0 alpha:1.0];
        [self addSubview:label];
        //        [self updateLableFrame:label];
        _titleLb = label;
    }
    return _titleLb;
}
- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil) {
        UIActivityIndicatorView *acView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //        acView.frame = CGRectMake(0, 0, 15, 15);
        acView.hidesWhenStopped = YES;
        [self addSubview:acView];
        self.activityView = acView;
    }
    return _activityView;
}
- (void)updateLableFrame:(UILabel *)label
{
    label.hidden = NO;
    [label sizeToFit];
    CGPoint centerPoint = label.center;
    
    centerPoint.x = self.frame.size.width/2;
    centerPoint.y = self.frame.size.height/2;
    label.center=centerPoint;
    CGRect rect =self.activityView.frame;
    rect.origin.x=label.frame.origin.x-5;
    self.activityView.frame=rect;
    centerPoint=self.activityView.center;
    centerPoint.y= label.center.y;
    self.activityView.center=centerPoint;
    self.activityView.transform =CGAffineTransformMakeScale(0.8, 0.8);
}
#pragma mark - setter
- (void)setRecordState:(RecordState)recordState
{
    self.levelContentView.hidden = YES;
    _recordState = recordState;
    [self.activityView stopAnimating];
    switch (recordState) {
        case RecordStateDefault:
            self.titleLb.text = @"按住说话";
            [self updateLableFrame:self.titleLb];
            break;
        case RecordStateClickRecord:
            self.titleLb.text = @"点击录音";
            [self updateLableFrame:self.titleLb];
            break;
        case RecordStateTouchChangeVoice:
            self.titleLb.text = @"按住变声";
            [self updateLableFrame:self.titleLb];
            break;
        case RecordStateListen:
            self.titleLb.text = @"松手试听";
            [self updateLableFrame:self.titleLb];
            break;
        case RecordStateCancel:
            self.titleLb.text = @"松手取消发送";
            [self updateLableFrame:self.titleLb];
            break;
            
        case RecordStateSend:
            
            break;
        case RecordStatePrepare:
            self.titleLb.text = @"准备中";
            [self updateLableFrame:self.titleLb];
            [self.activityView startAnimating];
            
            break;
        case RecordStateRecording:
            self.titleLb.hidden = YES;
            self.levelContentView.hidden = NO;
            break;
        case RecordStatePlay:
            self.titleLb.hidden = YES;
            self.levelContentView.hidden = NO;
            [self playAndMertering];
            break;
        case RecordStatePreparePlay:
            self.titleLb.hidden = YES;
            self.levelContentView.hidden = NO;
            [self preparePlay];
            break;
        default:
            break;
    }
}
#pragma mark recorde play
// 开始录音
- (void)beginRecord
{
    
}
- (void)endRecord
{
    
}
// 准备播放
- (void)preparePlay
{
    
}
// 播放录音
- (void)playAndMertering
{
    
}
- (void)startPlayTimer
{
    
}
- (void)updatePlayMeter
{
    
}
@end
