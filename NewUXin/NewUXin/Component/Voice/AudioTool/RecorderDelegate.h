//
//  RecorderDelegate.h
//  NewUXin
//
//  Created by tanpeng on 2017/10/23.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^beginRecord)();
typedef void (^endRecord)();
@protocol RecorderDelegate <NSObject>
@optional
/**
 * 准备中
 */
- (void)recorderPrepare;

/**
 * 录音中
 */
- (void)recorderRecording;

/**
 * 录音失败
 */
- (void)recorderFailed:(NSString *)failedMessage;
/**
 * 录音完成
 */
-(void)recorderFinished:(NSString *)voicePath;
@end

