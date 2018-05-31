//
//  UINavigationBar+NavigationBar.h
//  NewUXin
//
//  Created by tanpeng on 2017/11/3.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (NavigationBar)
/** 设置导航栏所有BarButtonItem的透明度 */
- (void)setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator;

/** 设置导航栏在垂直方向上平移多少距离 */
- (void)setTranslationY:(CGFloat)translationY;

/** 获取当前导航栏在垂直方向上偏移了多少 */
- (CGFloat)getTranslationY;
-(void)customer_setBackgroundColor:(UIColor *)color;
-(void)customer_setBackgroundImage:(UIImage *)image;
- (void)customer_setBackgroundAlpha:(CGFloat)alpha;
@end
