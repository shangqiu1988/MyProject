//
//  CALayer+AnimationExtend.h
//  NewUXin
//
//  Created by tanpeng on 2018/2/9.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (AnimationExtend)
- (CABasicAnimation *)rotationAnimation;
- (void)stopRotationAnimation;
@end
