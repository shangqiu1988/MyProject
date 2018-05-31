//
//  UXinDomainEntity.h
//  NewUXin
//
//  Created by tanpeng on 17/8/10.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UXinBaseEntity.h"
#import "UXinDefaultHelper.h"
@interface UXinDomainEntity : UXinBaseEntity
@property(nonatomic,copy) NSString *api_url;
@property(nonatomic,copy) NSString *areaCode;
@property(nonatomic,assign) NSInteger areaId;
@property(nonatomic,copy) NSString *areaName;
@property(nonatomic,copy) NSString *bss_url;
@property(nonatomic,copy) NSString *cms_url;
@property(nonatomic,copy) NSString *download_url;
@property(nonatomic,copy) NSString *eng_url;
@property(nonatomic,copy) NSString *gl_url;
@property(nonatomic,copy) NSString *hdxx_url;
@property(nonatomic,copy) NSString *lcs_url;
@property(nonatomic,copy) NSString *lp_url;
@property(nonatomic,copy) NSString *pat_url;
@property(nonatomic,copy) NSString *pls_url;
@property(nonatomic,copy) NSString *sso_url;
@property(nonatomic,copy) NSString *tms_url;
@property(nonatomic,copy) NSString *tqms_url;
@property(nonatomic,copy) NSString *ub_url;
@property(nonatomic,copy) NSString *upload_url;
@property(nonatomic,copy) NSString *wk_url;
@property(nonatomic,copy) NSString *xkgj_url;
-(void)saveDomain;
@end
