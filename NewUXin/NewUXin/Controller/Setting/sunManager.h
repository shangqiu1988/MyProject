//
//  sunManager.h
//  NewUXin
//
//  Created by tanpeng on 2018/3/24.
//  Copyright © 2018年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sunManager : NSObject
@property int result;
-(sunManager* (^)(int))add:(int)value;
@end
