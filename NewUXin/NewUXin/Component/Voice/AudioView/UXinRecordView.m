//
//  UXinRecordView.m
//  NewUXin
//
//  Created by tanpeng on 2017/10/19.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinRecordView.h"
#import "UXinAudioPlayView.h"
#import "UXinRecordStateView.h"
#import "UIView+Response.h"
#import "UXinVoiceButton.h"
#import "UXinVoiceView.h"
#import "RecorderDelegate.h"
@interface UXinRecordView()<RecorderDelegate>
@property(nonatomic,weak) UXinRecordStateView *stateView;
@property(nonatomic,weak) UXinVoiceButton *recordButton;
@property(nonatomic,weak) UXinAudioPlayView *playView;
@end
@implementation UXinRecordView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self stateView];
    [self recordButton];
}
#pragma mark - subViews
-(UXinAudioPlayView *)playView
{
    return nil;
}
-(UXinRecordStateView *)stateView
{
    if (_stateView == nil) {
        UXinRecordStateView *stateView = [[UXinRecordStateView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 50)];
        stateView.recordState = RecordStateClickRecord;
        [self addSubview:stateView];
        _stateView = stateView;
    }
    return  _stateView;
}
- (UXinVoiceButton *)recordButton {
    if (_recordButton == nil) {
        UXinVoiceButton *btn = [UXinVoiceButton buttonWithBackImageNor:@"aio_record_being_button" backImageSelected:@"aio_record_being_button" imageNor:@"aio_record_start_nor" imageSelected:@"aio_record_stop_nor" frame:CGRectMake(0, self.stateView.frame.origin.y+self.stateView.frame.size.height, 0, 0) isMicPhone:YES];
        // 松开手指
        [btn addTarget:self action:@selector(startRecorde:) forControlEvents:UIControlEventTouchUpInside];
        CGPoint center=btn.center;
        center.x = self.frame.size.width / 2.0;
        [self addSubview:btn];
        _recordButton = btn;
    }
    return _recordButton;
}
- (void)startRecorde:(UXinVoiceButton *)btn
{
      [(UXinVoiceView *)self.superview.superview setState:VoiceStateRecord];
    btn.selected =!btn.selected;
    if(btn.selected){
        
    }else{
        
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
