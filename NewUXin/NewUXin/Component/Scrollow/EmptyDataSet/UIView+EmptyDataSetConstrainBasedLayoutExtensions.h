//
//  UIView+EmptyDataSetConstrainBasedLayoutExtensions.h
//  NewUXin
//
//  Created by tanpeng on 2017/11/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EmptyDataSetConstrainBasedLayoutExtensions)
- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute;

@end
