//
//  UXinParallaxView.m
//  NewUXin
//
//  Created by tanpeng on 17/9/15.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinParallaxView.h"
#import "UXinParallaxHeader.h"

@interface UXinParallaxView()

@end
@implementation UXinParallaxView
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview removeObserver:self.parent forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:kParallaxHeaderKVOContext];
    }
}

- (void)didMoveToSuperview{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview addObserver:self.parent
                         forKeyPath:NSStringFromSelector(@selector(contentOffset))
                            options:NSKeyValueObservingOptionNew
                            context:kParallaxHeaderKVOContext];
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
