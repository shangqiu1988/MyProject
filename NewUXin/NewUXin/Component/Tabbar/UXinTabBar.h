//
//  UXinTabBar.h
//  NewUXin
//
//  Created by tanpeng on 2018/1/16.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UXinTabBar,UXinTabBarItem;
@protocol TabbarDelegate <NSObject>
- (void)tabBar:(UXinTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to;
@end
@interface UXinTabBar : UIView
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

@property (nonatomic, assign) NSInteger tabBarItemCount;

@property (nonatomic, strong) UXinTabBarItem *selectedItem;

@property (nonatomic, strong) NSMutableArray *tabBarItems;

@property (nonatomic, weak) id<TabbarDelegate> delegate;

- (void)addTabBarItem:(UITabBarItem *)item;

@end
