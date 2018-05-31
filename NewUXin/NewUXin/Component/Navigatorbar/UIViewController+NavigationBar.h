//
//  UIViewController+NavigationBar.h
//  NewUXin
//
//  Created by tanpeng on 2017/11/3.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBar)
/** record current ViewController navigationBar backgroundImage **/
- (void)customer_setNavBarBackgroundImage:(UIImage *)image;
- (UIImage *)customer_navBarBackgroundImage;

/** record current ViewController navigationBar barTintColor */
- (void)customer_setNavBarBarTintColor:(UIColor *)color;
- (UIColor *)customer_navBarBarTintColor;

/** record current ViewController navigationBar backgroundAlpha */
- (void)customer_setNavBarBackgroundAlpha:(CGFloat)alpha;
- (CGFloat)customer_navBarBackgroundAlpha;

/** record current ViewController navigationBar tintColor */
- (void)customer_setNavBarTintColor:(UIColor *)color;
- (UIColor *)customer_navBarTintColor;

/** record current ViewController titleColor */
- (void)customer_setNavBarTitleColor:(UIColor *)color;
- (UIColor *)customer_navBarTitleColor;

/** record current ViewController statusBarStyle */
- (void)customer_setStatusBarStyle:(UIStatusBarStyle)style;
- (UIStatusBarStyle)customer_statusBarStyle;

/** record current ViewController navigationBar shadowImage hidden */
- (void)customer_setNavBarShadowImageHidden:(BOOL)hidden;
- (BOOL)customer_navBarShadowImageHidden;

/** record current ViewController custom navigationBar */
- (void)customer_setCustomNavBar:(UINavigationBar *)navBar;
- (void)setPushToCurrentVCFinished:(BOOL)isFinished;
@end
