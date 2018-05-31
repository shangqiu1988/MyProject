//
//  UXinTabBarItem.h
//  NewUXin
//
//  Created by tanpeng on 2018/1/16.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UXinTabBarItem : UIButton
@property (nonatomic, strong) UITabBarItem *tabBarItem;

@property (nonatomic, assign) NSInteger tabBarItemCount;

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

- (instancetype)initWithItemImageRatio:(CGFloat)itemImageRatio;

@end
