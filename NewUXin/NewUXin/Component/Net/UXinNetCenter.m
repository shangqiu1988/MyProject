//
//  UXinNetCenter.m
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinNetCenter.h"
#import "UXinNetChainRequest.h"
#import "UXinNetRequest.h"
#import "UXinNetBatchRequest.h"
@interface UXinNetCenter () {
    dispatch_semaphore_t _lock;
}

@property (nonatomic, assign) NSUInteger autoIncrement;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *runningBatchAndChainPool;
@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, id> *generalParameters;
@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, NSString *> *generalHeaders;

@property (nonatomic, copy) CenterResponseProcessBlock responseProcessHandler;
@property (nonatomic, copy) CenterRequestProcessBlock requestProcessHandler;

@end

@implementation UXinNetCenter
+ (instancetype)center {
    return [[[self class] alloc] init];
}

+ (instancetype)defaultCenter {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self center];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _autoIncrement = 0;
    _lock = dispatch_semaphore_create(1);
    _engine = [UXinNetEngine sharedEngine];
    return self;
}
#pragma mark - Public Instance Methods for UXinNetCenter
-(void)setupConfig:(void (^)(UXinNetConfig * _Nonnull))block
{
    UXinNetConfig *config=[[UXinNetConfig alloc]init];
    config.consoleLog=NO;
    Net_SAFE_BLOCK(block,config);
    if(config.generalServer){
        self.generalServer=config.generalServer;
    }
    if(config.generalParameters.count>0){
        [self.generalParameters addEntriesFromDictionary:config.generalParameters];
    }
    if(config.generalHeaders.count>0){
        [self.generalHeaders addEntriesFromDictionary:config.generalHeaders];
    }
    if(config.callbackQueue!=NULL){
        self.callbackQueue=config.callbackQueue;
    }
    if(config.generalUserInfo){
        self.generalUserInfo=config.generalUserInfo;
    }
    if(config.engine){
        self.engine=config.engine;
    }
    self.consoleLog=config.consoleLog;
}
-(void)setRequestProcessBlock:(CenterRequestProcessBlock)block
{
    self.requestProcessHandler = block;
}
-(void)setResponseProcessBlock:(CenterResponseProcessBlock)block
{
     self.responseProcessHandler = block;
}
-(void)setGeneralHeaderValue:(NSString *)value forField:(NSString *)field
{
    [self.generalHeaders setValue:value forKey:field];
}
-(void)setGeneralParameterValue:(id)value forKey:(NSString *)key
{
     [self.generalParameters setValue:value forKey:key];
}
#pragma mark -
-(NSString *)sendRequest:(RequestConfigBlock)configBlock
{
 return [self sendRequest:configBlock onProgress:nil onSuccess:nil onFailure:nil onFinished:nil];
}
-(NSString *)sendRequest:(RequestConfigBlock)configBlock onSuccess:(SuccessBlock)successBlock
{
     return [self sendRequest:configBlock onProgress:nil onSuccess:successBlock onFailure:nil onFinished:nil];
}
-(NSString *)sendRequest:(RequestConfigBlock)configBlock onFailure:(FailureBlock)failureBlock
{
     return [self sendRequest:configBlock onProgress:nil onSuccess:nil onFailure:failureBlock onFinished:nil];
}
-(NSString *)sendRequest:(RequestConfigBlock)configBlock onFinished:(FinishedBlock)finishedBlock
{
     return [self sendRequest:configBlock onProgress:nil onSuccess:nil onFailure:nil onFinished:finishedBlock];
}
-(NSString *)sendRequest:(RequestConfigBlock)configBlock onSuccess:(SuccessBlock)successBlock onFailure:(FailureBlock)failureBlock onFinished:(FinishedBlock)finishedBlock
{
     return [self sendRequest:configBlock onProgress:nil onSuccess:successBlock onFailure:failureBlock onFinished:nil];
}
-(NSString *)sendRequest:(RequestConfigBlock)configBlock onProgress:(ProgressBlock)progressBlock onSuccess:(SuccessBlock)successBlock onFailure:(FailureBlock)failureBlock
{
     return [self sendRequest:configBlock onProgress:progressBlock onSuccess:successBlock onFailure:failureBlock onFinished:nil];
}
-(NSString *)sendRequest:(RequestConfigBlock)configBlock
              onProgress:(nullable ProgressBlock)progressBlock
               onSuccess:(nullable SuccessBlock)successBlock
               onFailure:(nullable FailureBlock)failureBlock
              onFinished:(nullable FinishedBlock)finishedBlock
{
    UXinNetRequest *request = [UXinNetRequest request];
    Net_SAFE_BLOCK(self.requestProcessHandler, request);
    Net_SAFE_BLOCK(configBlock, request);
    
    [self processRequest:request onProgress:progressBlock onSuccess:successBlock onFailure:failureBlock onFinished:finishedBlock];
    [self readySendRequest:request];
    
    return request.identifier;

}
- ( NSString *)sendBatchRequest:(BatchRequestConfigBlock)configBlock
                      onSuccess:(nullable BCSuccessBlock)successBlock
                      onFailure:(nullable BCFailureBlock)failureBlock
                     onFinished:(nullable BCFinishedBlock)finishedBlock
{
    UXinNetBatchRequest *batchRequest=[[UXinNetBatchRequest alloc]init];
    Net_SAFE_BLOCK(configBlock,batchRequest);
    if(batchRequest.requestArray.count>0){
        if(successBlock){
            [batchRequest setValue:successBlock forKey:@"_batchSuccessBlock"];
        }
        if(failureBlock){
            [batchRequest setValue:failureBlock forKey:@"_batchFailureBlock"];
        }
        if(finishedBlock){
            [batchRequest setValue:finishedBlock forKey:@"_batchFinishedBlock"];;
        }
        [batchRequest.responseArray removeAllObjects];
        for(UXinNetRequest *request in batchRequest.requestArray)
        {
            [batchRequest.responseArray addObject:[NSNull null]];
            __weak __typeof(self)weakSelf = self;
            [self processRequest:request onProgress:nil onSuccess:nil onFailure:nil onFinished:^(id  _Nullable responseObject, NSError * _Nullable error) {
                if([batchRequest onFinishedOneRequest:request response:responseObject error:error]){
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    dispatch_semaphore_wait(strongSelf->_lock, DISPATCH_TIME_FOREVER);
                    [strongSelf.runningBatchAndChainPool removeObjectForKey:batchRequest.identifier];
                    dispatch_semaphore_signal(strongSelf->_lock);

                }
            }];
            [self readySendRequest:request];
        }
        NSString *identifier = [self identifierForBatchAndChainRequest];
        [batchRequest setValue:identifier forKey:@"_identifier"];
        NetLock();
        [self.runningBatchAndChainPool setValue:batchRequest forKey:identifier];
        NetUnlock();
        
        return identifier;

    }else{
        return nil;
    }
}
- ( NSString *)sendChainRequest:(ChainRequestConfigBlock)configBlock
                      onSuccess:(nullable BCSuccessBlock)successBlock
                      onFailure:(nullable BCFailureBlock)failureBlock
                     onFinished:(nullable BCFinishedBlock)finishedBlock
{
    UXinNetChainRequest *chainRequest=[[UXinNetChainRequest alloc]init];
    Net_SAFE_BLOCK(configBlock,chainRequest);
    if(chainRequest.runningRequest){
        if(successBlock){
            [chainRequest setValue:successBlock forKey:@"_chainSuccessBlock"];
        }
        if (failureBlock) {
            [chainRequest setValue:failureBlock forKey:@"_chainFailureBlock"];
        }
        if (finishedBlock) {
            [chainRequest setValue:finishedBlock forKey:@"_chainFinishedBlock"];
        }
        [self sendChainRequest:chainRequest];
        NSString *identifier = [self identifierForBatchAndChainRequest];
        [chainRequest setValue:identifier forKey:@"_identifier"];
        NetLock();
        [self.runningBatchAndChainPool setValue:chainRequest forKey:identifier];
        NetUnlock();
        
        return identifier;


    }else{
        return nil;
    }
}
#pragma mark -

- (void)cancelRequest:(NSString *)identifier
{
     [self cancelRequest:identifier onCancel:nil];
}
-(void)cancelRequest:(NSString *)identifier onCancel:(CancelBlock)cancelBlock
{
    id request = nil;
    if ([identifier hasPrefix:@"BC"]) {
        NetLock();
        request = [self.runningBatchAndChainPool objectForKey:identifier];
        [self.runningBatchAndChainPool removeObjectForKey:identifier];
        NetUnlock();
        if ([request isKindOfClass:[UXinNetBatchRequest class]]) {
            UXinNetBatchRequest *batchRequest = request;
            if (batchRequest.requestArray.count > 0) {
                for (UXinNetRequest *rq in batchRequest.requestArray) {
                    if (rq.identifier.length > 0) {
                        [self.engine cancelRequestByIdentifier:rq.identifier];
                    }
                }
            }
        } else if ([request isKindOfClass:[UXinNetChainRequest class]]) {
            UXinNetChainRequest *chainRequest = request;
            if (chainRequest.runningRequest && chainRequest.runningRequest.identifier.length > 0) {
                [self.engine cancelRequestByIdentifier:chainRequest.runningRequest.identifier];
            }
        }
    } else if (identifier.length > 0) {
        request = [self.engine cancelRequestByIdentifier:identifier];
    }
    Net_SAFE_BLOCK(cancelBlock, request);

}
- (id)getRequest:(NSString *)identifier
{
    if(identifier==nil){
        return nil;
    }else if ([identifier hasPrefix:@"BC"]){
        NetLock();
        id request=[self.runningBatchAndChainPool objectForKey:identifier];
        NetUnlock();
        return request;
    }else{
        return [self.engine getRequestByIdentifier:identifier];
        
    }
    
}
- (BOOL)isNetworkReachable
{
      return self.engine.reachabilityStatus != 0;
}
#pragma mark - Public Class Methods for UXinNetCenter
+(void)setupConfig:(void (^)(UXinNetConfig * _Nonnull))block
{
    [[UXinNetCenter defaultCenter]setupConfig:block];
}
+(void)setRequestProcessBlock:(CenterRequestProcessBlock)block
{
    [[UXinNetCenter defaultCenter]setRequestProcessBlock:block];
}
+(void)setGeneralHeaderValue:(NSString *)value forField:(NSString *)field
{
    [[UXinNetCenter defaultCenter]setGeneralHeaderValue:value forField:field];
}
+(void)setGeneralParameterValue:(id)value forKey:(NSString *)key
{
    [[UXinNetCenter defaultCenter]setGeneralParameterValue:value forKey:key];
}
#pragma mark -
+(NSString *)sendRequest:(RequestConfigBlock)configBlock
{
    return [[UXinNetCenter defaultCenter]  sendRequest:configBlock onProgress:nil onSuccess:nil onFailure:nil onFinished:nil];
}
+(NSString *)sendRequest:(RequestConfigBlock)configBlock onFailure:(FailureBlock)failureBlock
{
    return [[UXinNetCenter defaultCenter] sendRequest:configBlock onProgress:nil onSuccess:nil onFailure:failureBlock onFinished:nil];
}
+(NSString *)sendRequest:(RequestConfigBlock)configBlock onSuccess:(SuccessBlock)successBlock
{
      return [[UXinNetCenter defaultCenter] sendRequest:configBlock onProgress:nil onSuccess:successBlock onFailure:nil onFinished:nil];
}
+(NSString *)sendRequest:(RequestConfigBlock)configBlock onFinished:(FinishedBlock)finishedBlock
{
    return [[UXinNetCenter defaultCenter] sendRequest:configBlock onProgress:nil onSuccess:nil onFailure:nil onFinished:finishedBlock];
}
+(NSString *)sendRequest:(RequestConfigBlock)configBlock onSuccess:(SuccessBlock)successBlock onFailure:(FailureBlock)failureBlock
{
    return [[UXinNetCenter defaultCenter] sendRequest:configBlock onProgress:nil onSuccess:successBlock onFailure:failureBlock onFinished:nil];

}
+(NSString *)sendRequest:(RequestConfigBlock)configBlock onSuccess:(SuccessBlock)successBlock onFailure:(FailureBlock)failureBlock onFinished:(nullable FinishedBlock)finishedBlock
{
    return [[UXinNetCenter defaultCenter] sendRequest:configBlock onProgress:nil onSuccess:successBlock onFailure:failureBlock onFinished:finishedBlock];

}

+(NSString *)sendRequest:(RequestConfigBlock)configBlock onProgress:(ProgressBlock)progressBlock onSuccess:(SuccessBlock)successBlock onFailure:(FailureBlock)failureBlock
{
     return [[UXinNetCenter defaultCenter] sendRequest:configBlock onProgress:progressBlock onSuccess:successBlock onFailure:failureBlock onFinished:nil];
}
+ ( NSString *)sendRequest:(RequestConfigBlock)configBlock
                        onProgress:(nullable ProgressBlock)progressBlock
                         onSuccess:(nullable SuccessBlock)successBlock
                         onFailure:(nullable FailureBlock)failureBlock
                        onFinished:(nullable FinishedBlock)finishedBlock
{
     return [[UXinNetCenter defaultCenter] sendRequest:configBlock onProgress:progressBlock onSuccess:successBlock onFailure:failureBlock onFinished:finishedBlock];
}
+ ( NSString *)sendBatchRequest:(BatchRequestConfigBlock)configBlock
                              onSuccess:(nullable BCSuccessBlock)successBlock
                              onFailure:(nullable BCFailureBlock)failureBlock
                             onFinished:(nullable BCFinishedBlock)finishedBlock
{
     return [[UXinNetCenter defaultCenter] sendBatchRequest:configBlock onSuccess:successBlock onFailure:failureBlock onFinished:finishedBlock];
}
+ ( NSString *)sendChainRequest:(ChainRequestConfigBlock)configBlock
                              onSuccess:(nullable BCSuccessBlock)successBlock
                              onFailure:(nullable BCFailureBlock)failureBlock
                             onFinished:(nullable BCFinishedBlock)finishedBlock
{
    return [[UXinNetCenter defaultCenter] sendChainRequest:configBlock onSuccess:successBlock onFailure:failureBlock onFinished:finishedBlock];
}
#pragma mark -
+(void)cancelRequest:(NSString *)identifier
{
     [[UXinNetCenter defaultCenter] cancelRequest:identifier onCancel:nil];
}
+(void)cancelRequest:(NSString *)identifier onCancel:(CancelBlock)cancelBlock
{
    [[UXinNetCenter defaultCenter] cancelRequest:identifier onCancel:cancelBlock];

}
+(BOOL)isNetworkReachable
{
     return [[UXinNetCenter defaultCenter] isNetworkReachable];
}
#pragma mark -
+(void)addSSLPinningURL:(NSString *)url
{
     [[UXinNetCenter defaultCenter].engine addSSLPinningURL:url];
}
+(void)addSSLPinningCert:(NSData *)cert
{
        [[UXinNetCenter defaultCenter].engine addSSLPinningCert:cert];
}
+(void)addTwowayAuthenticationPKCS12:(NSData *)p12 keyPassword:(NSString *)password
{
    [[UXinNetCenter defaultCenter].engine addTwowayAuthenticationPKCS12:p12 keyPassword:password];

}
#pragma mark - Private Methods for UXinNetCenter
- (void)sendChainRequest:(UXinNetChainRequest *)chainRequest
{
    if(chainRequest.runningRequest!=nil){
         __weak __typeof(self)weakSelf = self;
        [self processRequest:chainRequest.runningRequest
                     onProgress:nil
                      onSuccess:nil
                      onFailure:nil
                     onFinished:^(id responseObject, NSError *error) {
                         __strong __typeof(weakSelf)strongSelf = weakSelf;
                         if ([chainRequest onFinishedOneRequest:chainRequest.runningRequest response:responseObject error:error]) {
                             dispatch_semaphore_wait(strongSelf->_lock, DISPATCH_TIME_FOREVER);
                             [strongSelf.runningBatchAndChainPool removeObjectForKey:chainRequest.identifier];
                             dispatch_semaphore_signal(strongSelf->_lock);
                         } else {
                             if (chainRequest.runningRequest != nil) {
                                 [strongSelf sendChainRequest:chainRequest];
                             }
                         }
                     }];
        
        [self readySendRequest:chainRequest.runningRequest];

    }
}
- (void)processRequest:(UXinNetRequest *)request
               onProgress:(ProgressBlock)progressBlock
                onSuccess:(SuccessBlock)successBlock
                onFailure:(FailureBlock)failureBlock
               onFinished:(FinishedBlock)finishedBlock
{
    // set callback blocks for the request object.
    if (successBlock) {
        [request setValue:successBlock forKey:@"_successBlock"];
    }
    if (failureBlock) {
        [request setValue:failureBlock forKey:@"_failureBlock"];
    }
    if (finishedBlock) {
        [request setValue:finishedBlock forKey:@"_finishedBlock"];
    }
    if (progressBlock && request.requestType != RequestNormal) {
        [request setValue:progressBlock forKey:@"_progressBlock"];
    }
    
    // add general user info to the request object.
    if (!request.userInfo && self.generalUserInfo) {
        request.userInfo = self.generalUserInfo;
    }
    
    // add general parameters to the request object.
    if (request.useGeneralParameters && self.generalParameters.count > 0) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters addEntriesFromDictionary:self.generalParameters];
        if (request.parameters.count > 0) {
            [parameters addEntriesFromDictionary:request.parameters];
        }
        request.parameters = parameters;
    }
    
    // add general headers to the request object.
    if (request.useGeneralHeaders && self.generalHeaders.count > 0) {
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
        [headers addEntriesFromDictionary:self.generalHeaders];
        if (request.headers) {
            [headers addEntriesFromDictionary:request.headers];
        }
        request.headers = headers;
    }
    if(request.url.length==0){
        if (request.server.length == 0 && request.useGeneralServer && self.generalServer.length > 0) {
            request.server = self.generalServer;
        }
        if (request.api.length > 0) {
            NSURL *baseURL = [NSURL URLWithString:request.server];
            // ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected.
            if ([[baseURL path] length] > 0 && ![[baseURL absoluteString] hasSuffix:@"/"]) {
                baseURL = [baseURL URLByAppendingPathComponent:@""];
            }
            request.url = [[NSURL URLWithString:request.api relativeToURL:baseURL] absoluteString];
        } else {
            request.url = request.server;
        }

    }
   NSAssert(request.url.length > 0, @"The request url can't be null.");
}
- (void)readySendRequest:(UXinNetRequest *)request
{
    if (self.consoleLog) {
        if (request.requestType == RequestDownload) {
            NSLog(@"\n============ [UXinNetRequest Info] ============\nrequest download url: %@\nrequest save path: %@ \nrequest headers: \n%@ \nrequest parameters: \n%@ \n==========================================\n", request.url, request.downloadSavePath, request.headers, request.parameters);
        } else {
            NSLog(@"\n============ [UXinNetRequest Info] ============\nrequest url: %@ \nrequest headers: \n%@ \nrequest parameters: \n%@ \n==========================================\n", request.url, request.headers, request.parameters);
        }
    }
    [self.engine sendRequest:request handler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if(error){
            [self failureWithError:error forRequest:request];
        }else{
            [self successWithResponse:responseObject forRequest:request];
        }
    }];

}
- (void)successWithResponse:(id)responseObject forRequest:(UXinNetRequest *)request
{
    NSError *processError = nil;
    // custom processing the response data.
    Net_SAFE_BLOCK(self.responseProcessHandler, request, responseObject, &processError);
    if (processError) {
        [self failureWithError:processError forRequest:request];
        return;
    }
    
    if (self.consoleLog) {
        if (request.requestType == RequestDownload) {
            NSLog(@"\n============ [XMResponse Data] ===========\nrequest download url: %@\nresponse data: %@\n==========================================\n", request.url, responseObject);
        } else {
            if (request.responseSerializerType == ResponseSerializerRAW) {
                NSLog(@"\n============ [XMResponse Data] ===========\nrequest url: %@ \nresponse data: \n%@\n==========================================\n", request.url, [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            } else {
                NSLog(@"\n============ [XMResponse Data] ===========\nrequest url: %@ \nresponse data: \n%@\n==========================================\n", request.url, responseObject);
            }
        }
    }

    if (self.callbackQueue) {
        __weak __typeof(self)weakSelf = self;
        dispatch_async(self.callbackQueue, ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf execureSuccessBlockWithResponse:responseObject forRequest:request];
        });
    } else {
        // execure success block on a private concurrent dispatch queue.
        [self execureSuccessBlockWithResponse:responseObject forRequest:request];
    }

}
- (void)execureSuccessBlockWithResponse:(id)responseObject forRequest:(UXinNetRequest *)request
{
    Net_SAFE_BLOCK(request.successBlock, responseObject);
    Net_SAFE_BLOCK(request.finishedBlock, responseObject, nil);
    [request cleanCallbackBlocks];

}
-(void)failureWithError:(NSError *)error forRequest:(UXinNetRequest *)request
{
    if (self.consoleLog) {
        NSLog(@"\n=========== [XMResponse Error] ===========\nrequest url: %@ \nerror info: \n%@\n==========================================\n", request.url, error);
    }
    
    if (request.retryCount > 0) {
        request.retryCount --;
        // retry current request after 2 seconds.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self readySendRequest:request];
        });
        return;
    }
    
    if (self.callbackQueue) {
        __weak __typeof(self)weakSelf = self;
        dispatch_async(self.callbackQueue, ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf execureFailureBlockWithError:error forRequest:request];
        });
    } else {
        // execure failure block in a private concurrent dispatch queue.
        [self execureFailureBlockWithError:error forRequest:request];
    }

}
- (void)execureFailureBlockWithError:(NSError *)error forRequest:(UXinNetRequest *)request
{
    Net_SAFE_BLOCK(request.failureBlock, error);
    Net_SAFE_BLOCK(request.finishedBlock, nil, error);
    [request cleanCallbackBlocks];

}
- (NSString *)identifierForBatchAndChainRequest
{
    NSString *identifier = nil;
    NetLock();
    self.autoIncrement++;
    identifier = [NSString stringWithFormat:@"BC%lu", (unsigned long)self.autoIncrement];
    NetUnlock();
    return identifier;

}
#pragma mark - Accessor
-(NSMutableDictionary<NSString *,id>*)runningBatchAndChainPool
{
    if (!_runningBatchAndChainPool) {
        _runningBatchAndChainPool = [NSMutableDictionary dictionary];
    }
    return _runningBatchAndChainPool;

}
- (NSMutableDictionary<NSString *, id> *)generalParameters
{
    if (!_generalParameters) {
        _generalParameters = [NSMutableDictionary dictionary];
    }
    return _generalParameters;
}
- (NSMutableDictionary<NSString *, NSString *> *)generalHeaders
{
    if (!_generalHeaders) {
        _generalHeaders = [NSMutableDictionary dictionary];
    }
    return _generalHeaders;
}
@end
