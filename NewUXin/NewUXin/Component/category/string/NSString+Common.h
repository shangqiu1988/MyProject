//
//  NSString+Common.h
//  NewUXin
//
//  Created by tanpeng on 17/9/5.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)
- (NSString *)md5Str;
-(NSString *)ThreeDesByKey:(NSString *)threeDesKey;
- (NSString*) sha1;
+ (NSString *)UUID;
@end
