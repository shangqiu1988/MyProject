//
//  UXinRecordStateView.h
//  NewUXin
//
//  Created by tanpeng on 2017/10/20.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,RecordState) {
    RecordStateDefault = 0,       // 按住说话
    RecordStateClickRecord,       // 点击录音
    RecordStateTouchChangeVoice,  // 按住变声
    RecordStateListen ,           // 试听
    RecordStateCancel,            // 取消
    RecordStateSend,              // 发送
    RecordStatePrepare,           // 准备中
    RecordStateRecording,         // 录音中
    RecordStatePreparePlay,       // 准备播放
    RecordStatePlay               // 播放
} ;
@interface UXinRecordStateView : UIView
@property (nonatomic,assign) RecordState recordState; // 录音状态

@property (nonatomic,copy) void(^playProgress)(CGFloat progress);

// 开始录音
- (void)beginRecord;

// 结束录音
- (void)endRecord;

@end
