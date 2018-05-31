//
//  UXinNetRequest.m
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinNetRequest.h"

@implementation UXinNetRequest
-(void)dealloc
{
    
}
+(instancetype)request
{
    return [[[self class]alloc]init];
}
-(instancetype)init
{
    self=[super init];
    if(!self){
        return nil;
    }
    _requestType=RequestNormal;
    _httpMethod=HTTPMethodPOST;
    _requestSerializerType=RequestSerializerRAW;
    _responseSerializerType=ResponseSerializerJSON;
    _timeoutInterval=30.0;
    _useGeneralServer=YES;
    _useGeneralHeaders=YES;
    _useGeneralParameters=YES;
    _retryCount=0;
    return self;
}
-(void)cleanCallbackBlocks
{
    _successBlock=nil;
    _failureBlock=nil;
    _finishedBlock=nil;
    _progressBlock=nil;
}
-(NSMutableArray<UXinNetUploadFormData *> *)uploadFormDatas
{
    if(!_uploadFormDatas){
        _uploadFormDatas=[NSMutableArray array];
    }
    return _uploadFormDatas;
}
-(void)addFormDataWithName:(NSString *)name fileData:(NSData *)fileData
{
    UXinNetUploadFormData *formData = [UXinNetUploadFormData formDataWithName:name fileData:fileData];
    [self.uploadFormDatas addObject:formData];
}
-(void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData
{
    UXinNetUploadFormData *formData = [UXinNetUploadFormData formDataWithName:name fileName:fileName mimeType:mimeType fileData:fileData];
    [self.uploadFormDatas addObject:formData];
}
-(void)addFormDataWithName:(NSString *)name fileURL:(NSURL *)fileURL
{
    UXinNetUploadFormData *formData = [UXinNetUploadFormData formDataWithName:name fileURL:fileURL];
    [self.uploadFormDatas addObject:formData];
}
-(void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL
{
    UXinNetUploadFormData *formData = [UXinNetUploadFormData formDataWithName:name fileName:fileName mimeType:mimeType fileURL:fileURL];
    [self.uploadFormDatas addObject:formData];
}
@end
