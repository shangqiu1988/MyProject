//
//  UXinLoginViewModel.h
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UXinBaseViewModel.h"
typedef void (^judgeLogin)(NSString *result);
@interface UXinLoginViewModel : UXinBaseViewModel


-(void)getDomains;
-(void)getRelationAccount:(NSString *)url parameters:(NSDictionary *)parameters;
-(void)login:(NSString *)url parameters:(NSDictionary *)parameters ;
-(void)judgeLoginInfo:(NSString *)account pwd:(NSString *)pwd callback:(judgeLogin)callback;
@end
