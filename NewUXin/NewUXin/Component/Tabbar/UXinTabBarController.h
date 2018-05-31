//
//  UXinTabBarController.h
//  NewUXin
//
//  Created by tanpeng on 2017/10/23.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UXinTabBarController : UITabBarController
/**
 *  Tabbar item title color
 */
@property (nonatomic, strong) UIColor *itemTitleColor;

/**
 *  Tabbar selected item title color
 */
@property (nonatomic, strong) UIColor *selectedItemTitleColor;

/**
 *  Tabbar item title font
 */
@property (nonatomic, strong) UIFont *itemTitleFont;

/**
 *  Tabbar item's badge title font
 */
@property (nonatomic, strong) UIFont *badgeTitleFont;

/**
 *  Tabbar item image ratio
 */
@property (nonatomic, assign) CGFloat itemImageRatio;

/**
 *  Remove origin controls, for `- popToRootViewController`
 */
- (void)removeOriginControls;

@end
