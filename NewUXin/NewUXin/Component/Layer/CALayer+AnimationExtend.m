//
//  CALayer+AnimationExtend.m
//  NewUXin
//
//  Created by tanpeng on 2018/2/9.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "CALayer+AnimationExtend.h"

@implementation CALayer (AnimationExtend)
- (CABasicAnimation *)rotationAnimation
{
    CABasicAnimation *rotationAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue=@0;
    rotationAnimation.toValue=@(M_PI *2.0);
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    return rotationAnimation;
}
- (void)stopRotationAnimation
{
    if([self animationForKey:@"rotationAnimation"]){
        [self removeAnimationForKey:@"rotationAnimation"];
    }
}
@end
