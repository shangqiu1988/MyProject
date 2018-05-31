//
//  UIView+Response.m
//  NewUXin
//
//  Created by tanpeng on 2017/10/19.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UIView+Response.h"

@implementation UIView (Response)
- (UIViewController *)findViewController
{
    for(UIView* next = self; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]){
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
