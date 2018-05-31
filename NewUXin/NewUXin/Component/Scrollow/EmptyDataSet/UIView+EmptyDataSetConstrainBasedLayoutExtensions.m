//
//  UIView+EmptyDataSetConstrainBasedLayoutExtensions.m
//  NewUXin
//
//  Created by tanpeng on 2017/11/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UIView+EmptyDataSetConstrainBasedLayoutExtensions.h"

@implementation UIView (EmptyDataSetConstrainBasedLayoutExtensions)
- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}
@end
