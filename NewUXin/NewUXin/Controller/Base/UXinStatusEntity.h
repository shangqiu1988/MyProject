//
//  UXinStatusEntity.h
//  NewUXin
//
//  Created by tanpeng on 17/8/10.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UXinStatusEntity : NSObject
@property (nonatomic, assign) NSInteger type; //正确或者错误0：错误 1：正确
@property (nonatomic, copy) NSString *code; //状态码
@property (nonatomic, copy) NSString *message; //状态提示信息

@end
