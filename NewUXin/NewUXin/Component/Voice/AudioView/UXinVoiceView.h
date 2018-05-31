//
//  UXinVoiceView.h
//  NewUXin
//
//  Created by tanpeng on 2017/10/19.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,VoiceState) {
    VoiceStateDefault = 0, // 默认状态
    VoiceStateRecord,      // 录音
    VoiceStatePlay         // 播放
} ;
@interface UXinVoiceView : UIView
@property (nonatomic,assign) VoiceState state;
@end
