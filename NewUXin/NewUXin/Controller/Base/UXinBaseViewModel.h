//
//  UXinBaseViewModel.h
//  NewUXin
//
//  Created by tanpeng on 17/8/10.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import <PPNetworkHelper/PPNetworkHelper.h>
#import "UXinNetCenter.h"
#import "UXinNetRequest.h"

#import <JSONKit/JSONKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "UXinStatusEntity.h"
typedef void  (^successBlock)(NSInteger type,id value);
typedef void  (^failedBlock)(NSInteger type,id value);
@interface UXinBaseViewModel : NSObject
{
  
  
}
@property(nonatomic,copy)   successBlock  successHandle;
@property(nonatomic,copy)    failedBlock failedHandle;
-(instancetype)initWithSuccessHandle:(successBlock )successHandle failedHandle:(failedBlock)failedHandle;
@end
