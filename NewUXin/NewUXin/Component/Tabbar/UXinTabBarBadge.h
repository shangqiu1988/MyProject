//
//  UXinTabBarBadge.h
//  NewUXin
//
//  Created by tanpeng on 2018/1/16.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UXinTabBarBadge : UIButton
@property (nonatomic, copy) NSString *badgeValue;

@property (nonatomic, assign) NSInteger tabBarItemCount;

/**
 *  Tabbar item's badge title font
 */
@property (nonatomic, strong) UIFont *badgeTitleFont;
@end
