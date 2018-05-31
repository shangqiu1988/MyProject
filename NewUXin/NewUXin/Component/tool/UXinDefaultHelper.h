//
//  UXinDefaultHelper.h
//  NewUXin
//
//  Created by tanpeng on 17/8/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UXinDefaultHelper : NSObject
+(void)setValue:(id)value forKey:(NSString *)key;
+(id)valueForKey:(NSString *)key;
+(void)setInterValue:(NSInteger)value forKey:(NSString *)key;
+(NSInteger)interValueForKey:(NSString *)key;
+(void)setFloatValue:(NSInteger)value forKey:(NSString *)key;
+(CGFloat)floatValueForKey:(NSString *)key;
+(void)setDoubleValue:(NSInteger)value forKey:(NSString *)key;
+(double)doubleValueForKey:(NSString *)key;

@end
