//
//  UXinParallaxScrollViewDelegateForwarder.m
//  NewUXin
//
//  Created by tanpeng on 17/9/15.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinParallaxScrollViewDelegateForwarder.h"

@implementation UXinParallaxScrollViewDelegateForwarder
-(BOOL)respondsToSelector:(SEL)Selector
{
    return [self.delegate respondsToSelector:Selector] || [super respondsToSelector:Selector];
}
#pragma mark <parallaxScrollViewDelegate>
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
@end
