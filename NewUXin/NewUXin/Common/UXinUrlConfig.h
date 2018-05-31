//
//  UXinUrlConfig.h
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinUrlHelper.h"
//服务器域名
#define KCurrentAPIURLDomain    @"KCurrentAPIURLDomain"
#define KCurrentKeepAliveDomain @"KCurrentKeepAliveDomain"
#define KCurrentPLSURLDomain    @"KCurrentPLSURLDomain"
#define KCurrentSSOURLDomain    @"KCurrentSSOURLDomain"
#define KCurrentTMSURLDomain    @"KCurrentTMSURLDomain"
#define CMS_URLDomain           @"CMS_URLDomain"
#define KCurrentIlearnURLDomain @"KCurrentIlearnURLDomain"
#define KCurrentLCSURLDomain    @"KCurrentLCSURLDomain"
#define KCurrentTQMSURLDomain   @"KCurrentTQMSURLDomain"
#define KCurrentEnURLDomain     @"KCurrentEnURLDomain"
#define KCurrentUpLoadURLDomain @"KCurrentUpLoadURLDomain"
#define Kdownload_url            @"Kdownload_url"
//#define     kAllotDomainURL        @"http://www.czbanbantong.com/get_yx_url.php"       //幼教通全国负载均衡，用于解析域名
#define     kAllotDomainURL         @"http://192.168.149.3/get_yx_url.php"     //测试负载负载均衡，用于解析域名.
//真实请求URL

#define KGetRelationAccountUrl    [UXinUrlHelper getUrlString:[UXinDefaultHelper valueForKey:KCurrentAPIURLDomain] interface:@"/user/hasRelationAccount"]

#define KLoginUrl [UXinUrlHelper getUrlString:[UXinDefaultHelper valueForKey:KCurrentAPIURLDomain] interface:@"/user/loginForUxin"]

#define KHotUpdate @"http://zns.ddcxws.com:8083"
