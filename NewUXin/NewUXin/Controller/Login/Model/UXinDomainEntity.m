//
//  UXinDomainEntity.m
//  NewUXin
//
//  Created by tanpeng on 17/8/10.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinDomainEntity.h"

@implementation UXinDomainEntity
-(void)dealloc
{
    
}
-(void)saveDomain
{
    [UXinDefaultHelper setValue:self.api_url forKey:KCurrentAPIURLDomain];
    [UXinDefaultHelper setValue:self.lp_url forKey:KCurrentKeepAliveDomain];
}
@end
