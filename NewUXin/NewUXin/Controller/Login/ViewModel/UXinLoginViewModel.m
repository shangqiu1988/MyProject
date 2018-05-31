//
//  UXinLoginViewModel.m
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinLoginViewModel.h"
#import <JSONKit/JSONKit.h>
#import "UXinDomainEntity.h"
#import "UXinUserEntity.h"
@implementation UXinLoginViewModel
-(void)getDomains
{
    WEAKSELF
     [UXinNetCenter sendRequest:^(UXinNetRequest * _Nonnull request) {
         request.url=kAllotDomainURL;
         request.httpMethod=HTTPMethodGET;
         request.responseSerializerType=ResponseSerializerRAW;
         request.retryCount=0;
     } onSuccess:^(id  _Nullable responseObject) {
         NSLog(@"%@",responseObject);
         NSData *data=(NSData *)responseObject;
         
         NSString *string=[[NSString alloc]initWithBytes:data.bytes length:[data length ] encoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
         NSArray *DomainArray=[string objectFromJSONString];
         NSMutableArray *entitys=[NSMutableArray array];
         [DomainArray enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             UXinDomainEntity *entity=[UXinDomainEntity yy_modelWithDictionary:obj];
             [entitys addObject:entity];
             if(entitys.count==DomainArray.count){
                 if(weakSelf.successHandle){
                     weakSelf.successHandle(1,entitys);
                 }

             }
            
             
         }];
//         NSArray  *entitys=[UXinDomainEntity mj_objectArrayWithKeyValuesArray:DomainArray];
        
     
     } onFailure:^(NSError * _Nullable error) {
         if(weakSelf.failedHandle){
             weakSelf.failedHandle(1,nil);
         }
        
     }];
   }
-(void)getRelationAccount:(NSString *)url parameters:(NSDictionary *)parameters

{
WEAKSELF
    [UXinNetCenter sendRequest:^(UXinNetRequest * _Nonnull request) {
        request.url=url;
        request.httpMethod=HTTPMethodPOST;
        request.responseSerializerType=ResponseSerializerRAW;
             request.retryCount=0;
        request.parameters=parameters;
        
    } onSuccess:^(id  _Nullable responseObject) {
        NSData *data=(NSData *)responseObject;
        
                NSDictionary *resultDic=[data objectFromJSONData];
        NSLog(@"%@---",resultDic);
        if([resultDic objectForKey:@"error"]){
        UXinStatusEntity *status=[UXinStatusEntity yy_modelWithDictionary:[resultDic objectForKey:@"error"]];
            if(weakSelf.failedHandle){
                weakSelf.failedHandle(2,nil);
            }
            return;
        }
        
        
        NSArray *tempUsers=[resultDic objectForKey:@"users_profile" ];
        NSMutableArray *users=[[NSMutableArray alloc]init];
        [tempUsers enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UXinUserEntity *entity=[UXinUserEntity yy_modelWithDictionary:obj];
            [users addObject:entity];
            if(idx==tempUsers.count-1){
                if(weakSelf.successHandle){
                    weakSelf.successHandle(2,users);
                }

            }
          
            
        } ];
      
        
 
        
            
        
        
    } onFailure:^(NSError * _Nullable error) {
        if(weakSelf.failedHandle){
            weakSelf.failedHandle(2,nil);
        }
    }];
}
-(void)judgeLoginInfo:(NSString *)account pwd:(NSString *)pwd callback:(judgeLogin)callback
{
    if(account == nil
       || pwd == nil
       || (account && [[account stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
       || (pwd && [[pwd stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])){
        callback(@"用户名或密码不能为空");
    }
}
-(void)login:(NSString *)url parameters:(NSDictionary *)parameters
{
 WEAKSELF
    [UXinNetCenter sendRequest:^(UXinNetRequest * _Nonnull request) {
        request.url=url;
        request.useGeneralParameters=YES;
        request.httpMethod=HTTPMethodPOST;
        request.responseSerializerType=ResponseSerializerRAW;
        request.retryCount=0;
       
        request.parameters=parameters;
    } onSuccess:^(id  _Nullable responseObject) {
        NSData *data=(NSData *)responseObject;
        
        NSDictionary *resultDic=[data objectFromJSONData];
        NSLog(@"%@---",resultDic);
        if(weakSelf.successHandle){
            weakSelf.successHandle(3,nil);
        }
        
    } onFailure:^(NSError * _Nullable error) {
        
    }];
}
@end
