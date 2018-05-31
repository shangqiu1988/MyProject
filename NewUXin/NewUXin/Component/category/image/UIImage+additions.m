//
//  UIImage+additions.m
//  NewUXin
//
//  Created by tanpeng on 17/8/14.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UIImage+additions.h"

@implementation UIImage (additions)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
