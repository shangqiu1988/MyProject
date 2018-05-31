//
//  UXinHotUpdateVersionCheck.m
//  NewUXin
//
//  Created by tanpeng on 2017/11/6.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinHotUpdateVersionCheck.h"

@implementation UXinHotUpdateVersionCheck
+ (void)getVersionInfo:(NSURL *)url
     completionHandler:(void (^)(NSDictionary *info, NSError *error))completionHandler
{
    UXinHotUpdateVersionCheck *check=[UXinHotUpdateVersionCheck new];
    check.completionHandler=completionHandler;
    [check sendCheckRequest:url];
    
}
-(void)sendCheckRequest:(NSURL *)url
{
       __weak typeof(self) weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if([dic isKindOfClass:[NSDictionary class]]){
            weakSelf.completionHandler(dic, nil);
        }else{
            weakSelf.completionHandler(nil, error);
        }
    }];
    [task resume];
}
@end
