//
//  UIColor+NavigationBar.m
//  NewUXin
//
//  Created by tanpeng on 2017/11/3.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UIColor+NavigationBar.h"
#import <objc/runtime.h>
static char kDefaultNavBarBarTintColorKey;
static char kDefaultNavBarBackgroundImageKey;
static char kDefaultNavBarTintColorKey;
static char kDefaultNavBarTitleColorKey;
static char kDefaultStatusBarStyleKey;
static char kDefaultNavBarShadowImageHiddenKey;
@implementation UIColor (NavigationBar)
+ (UIColor *)defaultNavBarBarTintColor
{
    UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kDefaultNavBarBarTintColorKey);
    return (color != nil) ? color : [UIColor whiteColor];
}
+ (void)setDefaultNavBarBarTintColor:(UIColor *)color
{
    objc_setAssociatedObject(self, &kDefaultNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIImage *)defaultNavBarBackgroundImage
{
    UIImage *image = (UIImage *)objc_getAssociatedObject(self, &kDefaultNavBarBackgroundImageKey);
    return image;
}
+ (void)setDefaultNavBarBackgroundImage:(UIImage *)image
{
    objc_setAssociatedObject(self, &kDefaultNavBarBackgroundImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)defaultNavBarTintColor
{
    UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kDefaultNavBarTintColorKey);
    return (color != nil) ? color : [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1.0];
}
+ (void)setDefaultNavBarTintColor:(UIColor *)color
{
    objc_setAssociatedObject(self, &kDefaultNavBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)defaultNavBarTitleColor
{
    UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kDefaultNavBarTitleColorKey);
    return (color != nil) ? color : [UIColor blackColor];
}
+ (void)setDefaultNavBarTitleColor:(UIColor *)color
{
    objc_setAssociatedObject(self, &kDefaultNavBarTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIStatusBarStyle)defaultStatusBarStyle
{
    id style = objc_getAssociatedObject(self, &kDefaultStatusBarStyleKey);
    return (style != nil) ? [style integerValue] : UIStatusBarStyleDefault;
}
+ (void)setDefaultStatusBarStyle:(UIStatusBarStyle)style
{
    objc_setAssociatedObject(self, &kDefaultStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)defaultNavBarShadowImageHidden
{
    id hidden = objc_getAssociatedObject(self, &kDefaultNavBarShadowImageHiddenKey);
    return (hidden != nil) ? [hidden boolValue] : NO;
}
+ (void)setDefaultNavBarShadowImageHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, &kDefaultNavBarShadowImageHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)defaultNavBarBackgroundAlpha
{
    return 1.0;
}

+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}
+ (CGFloat)middleAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha percent:(CGFloat)percent
{
    return fromAlpha + (toAlpha - fromAlpha) * percent;
}

@end
