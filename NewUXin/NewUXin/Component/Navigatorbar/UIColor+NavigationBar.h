//
//  UIColor+NavigationBar.h
//  NewUXin
//
//  Created by tanpeng on 2017/11/3.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NavigationBar)
/** set default barTintColor of UINavigationBar */
+ (void)setDefaultNavBarBarTintColor:(UIColor *)color;

/** set default barBackgroundImage of UINavigationBar */
+ (void)setDefaultNavBarBackgroundImage:(UIImage *)image;

/** set default tintColor of UINavigationBar */
+ (void)setDefaultNavBarTintColor:(UIColor *)color;

/** set default titleColor of UINavigationBar */
+ (void)setDefaultNavBarTitleColor:(UIColor *)color;

/** set default statusBarStyle of UIStatusBar */
+ (void)setDefaultStatusBarStyle:(UIStatusBarStyle)style;

/** set default shadowImage isHidden of UINavigationBar */
+ (void)setDefaultNavBarShadowImageHidden:(BOOL)hidden;
+ (UIImage *)defaultNavBarBackgroundImage;
+ (UIColor *)defaultNavBarBarTintColor;
+ (UIColor *)defaultNavBarTintColor;
+ (UIColor *)defaultNavBarTitleColor;
+ (UIStatusBarStyle)defaultStatusBarStyle;
+ (BOOL)defaultNavBarShadowImageHidden;
+ (CGFloat)defaultNavBarBackgroundAlpha;
+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent;
+ (CGFloat)middleAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha percent:(CGFloat)percent;
@end
