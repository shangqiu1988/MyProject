//
//  UXinDefaultHelper.m
//  NewUXin
//
//  Created by tanpeng on 17/8/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinDefaultHelper.h"

@implementation UXinDefaultHelper
+(void)setValue:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+(id)valueForKey:(NSString *)key
{

   
    return [[NSUserDefaults standardUserDefaults]valueForKey:key];
    
}
+(void)setInterValue:(NSInteger)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults]setInteger:value forKey:key];
}
+(NSInteger)interValueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults]integerForKey:key];
}
+(void)setFloatValue:(NSInteger)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults]setFloat:value forKey:key];
}
+(CGFloat)floatValueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults]floatForKey:key];
}
+(void)setDoubleValue:(NSInteger)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults]setDouble:value forKey:key];
}
+(double)doubleValueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults]doubleForKey:key];
}
@end
