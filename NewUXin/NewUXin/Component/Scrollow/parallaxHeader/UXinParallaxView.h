//
//  UXinParallaxView.h
//  NewUXin
//
//  Created by tanpeng on 17/9/15.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UXinParallaxHeader;
static void * const kParallaxHeaderKVOContext = (void*)&kParallaxHeaderKVOContext;
@interface UXinParallaxView : UIView
@property(nonatomic,weak) UXinParallaxHeader *parent;
@end
