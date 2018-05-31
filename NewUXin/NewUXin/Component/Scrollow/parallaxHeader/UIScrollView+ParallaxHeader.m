//
//  UIScrollView+ParallaxHeader.m
//  NewUXin
//
//  Created by tanpeng on 17/9/15.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UIScrollView+ParallaxHeader.h"
#import <objc/runtime.h>
@implementation UIScrollView (ParallaxHeader)
-(UXinParallaxHeader *)parallaxHeader
{
    UXinParallaxHeader *parallaxHeader=objc_getAssociatedObject(self,  @selector(parallaxHeader));
    if(!parallaxHeader){
        parallaxHeader=[UXinParallaxHeader new];
        
    }
    return parallaxHeader;
}
-(void)setParallaxHeader:(UXinParallaxHeader *)parallaxHeader
{
   
}
@end
