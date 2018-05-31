//
//  UXinNetEngine.m
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinNetEngine.h"
#import  <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <objc/runtime.h>
#import "UXinNetRequest.h"
#import "NSObject+BindingNetRequest.h"
static dispatch_queue_t request_completion_callback_queue() {
    static dispatch_queue_t request_completion_callback_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request_completion_callback_queue = dispatch_queue_create("com.networking.request.completion.callback.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return request_completion_callback_queue;
}

@interface UXinNetEngine(){
    dispatch_semaphore_t _lock;
}
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) AFHTTPSessionManager *securitySessionManager;

@property (nonatomic, strong) AFHTTPRequestSerializer *afHTTPRequestSerializer;
@property (nonatomic, strong) AFJSONRequestSerializer *afJSONRequestSerializer;
@property (nonatomic, strong) AFPropertyListRequestSerializer *afPListRequestSerializer;

@property (nonatomic, strong) AFHTTPResponseSerializer *afHTTPResponseSerializer;
@property (nonatomic, strong) AFJSONResponseSerializer *afJSONResponseSerializer;
@property (nonatomic, strong) AFXMLParserResponseSerializer *afXMLResponseSerializer;
@property (nonatomic, strong) AFPropertyListResponseSerializer *afPListResponseSerializer;
@property (nonatomic, strong) NSMutableArray *sslPinningHosts;
@end
@implementation UXinNetEngine
+ (instancetype)engine {
    return [[[self class] alloc] init];
}

+ (instancetype)sharedEngine {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self engine];
    });
    return sharedInstance;
}
-(instancetype)init
{
    self=[super init];
    if(!self){
        return nil;
    }
    _lock=dispatch_semaphore_create(1);
    [AFNetworkActivityIndicatorManager sharedManager].enabled=YES;
    return self;
}
+(void)load
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
-(void)dealloc
{
    if (_sessionManager) {
        [_sessionManager invalidateSessionCancelingTasks:YES];
    }
    if (_securitySessionManager) {
        [_securitySessionManager invalidateSessionCancelingTasks:YES];
    }

}
#pragma mark - Public Methods
- (void)sendRequest:(UXinNetRequest *)request handler:( completionHandler)handler
{
    if(request.requestType==RequestNormal){
      [self dataTaskWithRequest:request handle:handler];
    }else if (request.requestType==RequestUpload){
//        [self uploadTaskWithRequest:request completionHandler:handler];
        [self uploadTaskWithRequest:request handle:handler];
    }else if (request.requestType==RequestDownload){
//        [self downloadTaskWithRequest:request completionHandler:handler];
        [self downloadTaskWithRequest:request handle:handler];
    }else{
         NSAssert(NO, @"Unknown request type.");
    }
}
- (UXinNetRequest *)cancelRequestByIdentifier:(NSString *)identifier
{
    if(identifier.length==0){
        return nil;
    }
    NetLock();
    NSArray *tasks=nil;
    if([identifier hasPrefix:@"+"]){
        tasks=self.sessionManager.tasks;
    }else if([identifier hasPrefix:@"-"]){
        tasks=self.securitySessionManager.tasks;
    }
    __block UXinNetRequest *request=nil;
    if(tasks.count>0){
        [tasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL *stop) {
            if([tasks.bindedRequest.identifier isEqualToString:identifier]){
                request=task.bindedRequest;
                [task cancel];
                *stop=YES;
            }
        }];
    }
    NetUnlock();
    return request;
}
-(UXinNetRequest *)getRequestByIdentifier:(NSString *)identifier
{
    if (identifier.length == 0) return nil;
    
    NetLock();
    NSArray *tasks = nil;
    if ([identifier hasPrefix:@"+"]) {
        tasks = self.sessionManager.tasks;
    } else if ([identifier hasPrefix:@"-"]) {
        tasks = self.securitySessionManager.tasks;
    }
    __block UXinNetRequest *request = nil;
    [tasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL *stop) {
        if ([task.bindedRequest.identifier isEqualToString:identifier]) {
            request = task.bindedRequest;
            *stop = YES;
        }
    }];
    NetUnlock();
    return request;
}
-(NSInteger)reachabilityStatus
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}
-(void)addSSLPinningURL:(NSString *)url
{
    NSParameterAssert(url);
    
    if ([url hasPrefix:@"https"]) {
        NSString *rootDomainName = [self rootDomainNameFromURL:url];
        if (rootDomainName && ![self.sslPinningHosts containsObject:rootDomainName]) {
            [self.sslPinningHosts addObject:rootDomainName];
        }
    }

}
-(void)addSSLPinningCert:(NSData *)cert
{
    
}
-(void)addTwowayAuthenticationPKCS12:(NSData *)p12 keyPassword:(NSString *)password
{
    
}
#pragma mark - Private Methods
- (void)dataTaskWithRequest:(UXinNetRequest *)request
             handle:(completionHandler)handle
{
    NSString *httpMethod = nil;
    static dispatch_once_t onceToken;
    static NSArray *httpMethodArray = nil;
    dispatch_once(&onceToken, ^{
        httpMethodArray = @[@"GET", @"POST", @"HEAD", @"DELETE", @"PUT", @"PATCH"];
    });
    if (request.httpMethod >= 0 && request.httpMethod < httpMethodArray.count) {
        httpMethod = httpMethodArray[request.httpMethod];
    }
    NSAssert(httpMethod.length > 0, @"The HTTP method not found.");
    AFHTTPSessionManager *sessionManager=[self getSessionManager:request];
    AFHTTPRequestSerializer *requestSerializer=[self getRequestSerializer:request];
    NSError *serializationError=nil;
    NSMutableURLRequest *urlRequest=[requestSerializer requestWithMethod:httpMethod URLString:request.url parameters:request.parameters error:&serializationError];
    if(serializationError){
        if(handle ){
            dispatch_async(request_completion_callback_queue(), ^{
                handle(nil,serializationError);
            });
        }
        return;
    }
    
    [self processURLRequest:urlRequest byRequest:request];
    NSURLSessionTask *dataTask=nil;
    
    __weak __typeof(self)weakSelf = self;
//    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.stringEncoding=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    dataTask=[sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf processResponse:response object:responseObject error:error request:request handle:handle];
    }];
    [self setIdentifierForReqeust:request taskIdentifier:dataTask.taskIdentifier sessionManager:sessionManager];
    
    [dataTask bindingRequest:request];
    [dataTask resume];
    
}
- (void)uploadTaskWithRequest:(UXinNetRequest *)request
               handle:(completionHandler)handle
{
   
    AFHTTPSessionManager *sessionManager = [self getSessionManager:request];
    AFHTTPRequestSerializer *requestSerializer = [self getRequestSerializer:request];
    
    __block NSError *serializationError = nil;
    NSMutableURLRequest *urlRequest=[requestSerializer multipartFormRequestWithMethod:@"POST" URLString:request.url parameters:request.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [request.uploadFormDatas enumerateObjectsUsingBlock:^(UXinNetUploadFormData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.fileData) {
                if (obj.fileName && obj.mimeType) {
                    [formData appendPartWithFileData:obj.fileData name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
                } else {
                    [formData appendPartWithFormData:obj.fileData name:obj.name];
                }
            } else if (obj.fileURL) {
                NSError *fileError = nil;
                if (obj.fileName && obj.mimeType) {
                    [formData appendPartWithFileURL:obj.fileURL name:obj.name fileName:obj.fileName mimeType:obj.mimeType error:&fileError];
                } else {
                    [formData appendPartWithFileURL:obj.fileURL name:obj.name error:&fileError];
                }
                if (fileError) {
                    serializationError = fileError;
                    *stop = YES;
                }
            }
        }];
    } error:&serializationError];
    
    if (serializationError) {
        if (handle) {
            dispatch_async(request_completion_callback_queue(), ^{
                handle(nil, serializationError);
            });
        }
        return;
    }
    
    [self processURLRequest:urlRequest byRequest:request];
    
    NSURLSessionUploadTask *uploadTask = nil;
    __weak __typeof(self)weakSelf = self;
     uploadTask=[sessionManager uploadTaskWithStreamedRequest:urlRequest progress:request.progressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        
         [strongSelf processResponse:response object:responseObject error:error request:request handle:handle];
     }];
    [self setIdentifierForReqeust:request taskIdentifier:uploadTask.taskIdentifier sessionManager:sessionManager];
    [uploadTask bindingRequest:request];
    [uploadTask resume];
}
- (void)downloadTaskWithRequest:(UXinNetRequest *)request
                 handle:(completionHandler)handle
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request.url]];
    [self processURLRequest:urlRequest byRequest:request];
    NSURL *downloadFileSavePath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:request.downloadSavePath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    if (isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadFileSavePath = [NSURL fileURLWithPath:[NSString pathWithComponents:@[request.downloadSavePath, fileName]] isDirectory:NO];
    } else {
        downloadFileSavePath = [NSURL fileURLWithPath:request.downloadSavePath isDirectory:NO];
    }
    NSURLSessionDownloadTask *downloadTask = nil;
    AFHTTPSessionManager *sessionManager = [self getSessionManager:request];
    downloadTask = [sessionManager downloadTaskWithRequest:urlRequest
                                                  progress:request.progressBlock
                                               destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                   return downloadFileSavePath;
                                               } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                   if (handle) {
                                                       handle(filePath, error);
                                                   }
                                               }];
    
    [self setIdentifierForReqeust:request taskIdentifier:downloadTask.taskIdentifier sessionManager:sessionManager];
    [downloadTask bindingRequest:request];
    [downloadTask resume];


}
- (void)processURLRequest:(NSMutableURLRequest *)urlRequest byRequest:(UXinNetRequest *)request
{
    if(request.headers.count>0){
        [request.headers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [urlRequest setValue:obj forHTTPHeaderField:key];
        }];
    }
    urlRequest.timeoutInterval=request.timeoutInterval;
}
- (void)processResponse:(NSURLResponse *)response
                    object:(id)responseObject
                     error:(NSError *)error
                   request:(UXinNetRequest *)request
         handle:(completionHandler)handle

{
    NSError *serializationError = nil;
    if (request.responseSerializerType != ResponseSerializerRAW) {
        AFHTTPResponseSerializer *responseSerializer = [self getResponseSerializer :request];
        responseObject = [responseSerializer responseObjectForResponse:response data:responseObject error:&serializationError];
    }
    if(handle){
        if(serializationError){
            handle(nil,serializationError);
        }else{
            handle(responseObject,error);
        }
    }

}
- (void)setIdentifierForReqeust:(UXinNetRequest *)request
                    taskIdentifier:(NSUInteger)taskIdentifier
                    sessionManager:(AFHTTPSessionManager *)sessionManager
{
    NSString *identifier = nil;
    if ([sessionManager isEqual:self.sessionManager]) {
        identifier = [NSString stringWithFormat:@"+%lu", (unsigned long)taskIdentifier];
    } else if ([sessionManager isEqual:self.securitySessionManager]) {
        identifier = [NSString stringWithFormat:@"-%lu", (unsigned long)taskIdentifier];
    }
    [request setValue:identifier forKey:@"_identifier"];

}
- (NSString *)rootDomainNameFromURL:(NSString *)urlString
{
    NSString *host = [[NSURL URLWithString:urlString] host];
    // Separate the host into its constituent components, e.g. [@"secure", @"twitter", @"com"]
    NSArray * hostComponents = [host componentsSeparatedByString:@"."];
    if ([hostComponents count] >= 2) {
        // Create a string out of the last two components in the host name, e.g. @"twitter" and @"com"
        host = [NSString stringWithFormat:@"%@.%@", [hostComponents objectAtIndex:(hostComponents.count - 2)], [hostComponents objectAtIndex:(hostComponents.count - 1)]];
    }
    return host;

}
- (BOOL)shouldSSLPinningWithURL:(NSString *)urlString
{
    if (urlString && [urlString hasPrefix:@"https"]) {
        NSString *rootDomainName = [self rootDomainNameFromURL:urlString];
        if ([self.sslPinningHosts containsObject:rootDomainName]) {
            return YES;
        }
    }
    return NO;

}
- (AFHTTPSessionManager *)getSessionManager:(UXinNetRequest *)request
{
    if([self shouldSSLPinningWithURL:request.url]){
       return  self.securitySessionManager;
    }else{
        return self.sessionManager;
    }
}
- (AFHTTPRequestSerializer *)getRequestSerializer:(UXinNetRequest *)request
{
    if(request.requestSerializerType==RequestSerializerRAW){
        return self.afHTTPRequestSerializer;
    }else if (request.requestSerializerType==RequestSerializerJSON){
        return self.afJSONRequestSerializer;
    }else if (request.requestSerializerType==RequestSerializerPlist){
        return self.afPListRequestSerializer;
    }else{
        NSAssert(NO, @"Unknown request serializer type.");
        return nil;
    }
}
- (AFHTTPResponseSerializer *)getResponseSerializer:(UXinNetRequest *)request {
    if (request.responseSerializerType == ResponseSerializerRAW) {
        return self.afHTTPResponseSerializer;
    } else if (request.responseSerializerType == ResponseSerializerJSON) {
        return self.afJSONResponseSerializer;
    } else if (request.responseSerializerType == ResponseSerializerPlist) {
        return self.afPListResponseSerializer;
    } else if (request.responseSerializerType == ResponseSerializerXML) {
        return self.afXMLResponseSerializer;
    } else {
        NSAssert(NO, @"Unknown response serializer type.");
        return nil;
    }
}

#pragma mark - Accessor
- (AFHTTPSessionManager *)sessionManager
{
    if(!_sessionManager){
        _sessionManager=[AFHTTPSessionManager manager];
        _sessionManager.requestSerializer=self.afHTTPRequestSerializer;
        _sessionManager.responseSerializer=self.afHTTPResponseSerializer;
        _sessionManager.operationQueue.maxConcurrentOperationCount=2;
        
        _sessionManager.completionQueue=request_completion_callback_queue();
    }
    return _sessionManager;
}
- (AFHTTPSessionManager *)securitySessionManager
{
    if (!_securitySessionManager) {
        _securitySessionManager = [AFHTTPSessionManager manager];
        _securitySessionManager.requestSerializer = self.afHTTPRequestSerializer;
        _securitySessionManager.responseSerializer = self.afHTTPResponseSerializer;
        _securitySessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        _securitySessionManager.operationQueue.maxConcurrentOperationCount = 5;
        _securitySessionManager.completionQueue = request_completion_callback_queue();
    }
    return _securitySessionManager;
}
- (AFHTTPRequestSerializer *)afHTTPRequestSerializer
{
    if (!_afHTTPRequestSerializer) {
        _afHTTPRequestSerializer = [AFHTTPRequestSerializer serializer];
        
    }
    return _afHTTPRequestSerializer;
}
-(AFJSONRequestSerializer *)afJSONRequestSerializer
{
    if (!_afJSONRequestSerializer) {
        _afJSONRequestSerializer = [AFJSONRequestSerializer serializer];
        
    }
    return _afJSONRequestSerializer;
}
- (AFPropertyListRequestSerializer *)afPListRequestSerializer
{
    if (!_afPListRequestSerializer) {
        _afPListRequestSerializer = [AFPropertyListRequestSerializer serializer];
    }
    return _afPListRequestSerializer;
}
- (AFHTTPResponseSerializer *)afHTTPResponseSerializer
{
    if (!_afHTTPResponseSerializer) {
        _afHTTPResponseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _afHTTPResponseSerializer;

}
- (AFJSONResponseSerializer *)afJSONResponseSerializer
{
    if (!_afJSONResponseSerializer) {
        _afJSONResponseSerializer = [AFJSONResponseSerializer serializer];
        // Append more other commonly-used types to the JSON responses accepted MIME types.
        //_afJSONResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    }
    return _afJSONResponseSerializer;

}
- (AFXMLParserResponseSerializer *)afXMLResponseSerializer
{
    if (!_afXMLResponseSerializer) {
        _afXMLResponseSerializer = [AFXMLParserResponseSerializer serializer];
    }
    return _afXMLResponseSerializer;
}
- (AFPropertyListResponseSerializer *)afPListResponseSerializer
{
    if (!_afPListResponseSerializer) {
        _afPListResponseSerializer = [AFPropertyListResponseSerializer serializer];
    }
    return _afPListResponseSerializer;

}
- (NSMutableArray *)sslPinningHosts
{
    if (!_sslPinningHosts) {
        _sslPinningHosts = [NSMutableArray array];
    }
    return _sslPinningHosts;
}
@end
