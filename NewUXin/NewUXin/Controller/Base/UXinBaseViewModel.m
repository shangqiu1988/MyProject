//
//  UXinBaseViewModel.m
//  NewUXin
//
//  Created by tanpeng on 17/8/10.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinBaseViewModel.h"

@implementation UXinBaseViewModel
-(void)dealloc
{
    _successHandle=nil;
    _failedHandle=nil;
}
-(instancetype)initWithSuccessHandle:(successBlock )successHandle failedHandle:(failedBlock)failedHandle
{
    self=[super init];
    if(self){
        [UXinNetCenter setupConfig:^(UXinNetConfig * _Nonnull config) {
            config.generalParameters=@{@"device_type":@"1",@"device_identifier":DeviceUUID};
            config.consoleLog=YES;
        }];
        _successHandle=[successHandle copy];
        _failedHandle=[failedHandle copy];
    }
    return self;
}
@end
