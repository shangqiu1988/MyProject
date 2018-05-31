//
//  UXinNetCenter.h
//  NewUXin
//
//  Created by tanpeng on 17/8/7.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UXinNetEngine.h"
#import "NetConst.h"
#import "UXinNetConfig.h"

NS_ASSUME_NONNULL_BEGIN
/**
 `XMCenter` is a global central place to send and manage all network requests.
 `+center` method is used to creates a new `XMCenter` object,
 `+defaultCenter` method will return a default shared `UXinNetCenter` singleton object.
 
 The class methods for `UXinNetCenter` are invoked by `[UXinNetCenter defaultCenter]`, which are recommend to use `Class Method` instead of manager a `UXinNetCenter` yourself.
 
 Usage:
 
 (1) Config UXinNetCenter
 
 [UXinNetCenter setupConfig:^(UXinNetConfig *config) {
 config.server = @"general server address";
 config.headers = @{@"general header": @"general header value"};
 config.parameters = @{@"general parameter": @"general parameter value"};
 config.callbackQueue = dispatch_get_main_queue(); // set callback dispatch queue
 }];
 
 [UXinNetCenter setRequestProcessBlock:^(UXinNetRequest *request) {
 // Do the custom request pre processing logic by yourself.
 }];
 
 [UXinNetCenter setResponseProcessBlock:^(UXinNetRequest *request, id responseObject, NSError *__autoreleasing *error) {
 // Do the custom response data processing logic by yourself.
 // You can assign the passed in `error` argument when error occurred, and the failure block will be called instead of success block.
 }];
 
 (2) Send a Request
 
 [UXinNetCenter sendRequest:^(XMRequest *request) {
 request.server = @"server address"; // optional, if `nil`, the genneal server is used.
 request.api = @"api path";
 request.parameters = @{@"param1": @"value1", @"param2": @"value2"}; // and the general parameters will add to reqeust parameters.
 } onSuccess:^(id responseObject) {
 // success code here...
 } onFailure:^(NSError *error) {
 // failure code here...
 }];
 
 */

@interface UXinNetCenter : NSObject
///---------------------
/// @name Initialization
///---------------------

/**
 Creates and returns a new `UXinNetCenter` object.
 */
+ (instancetype)center;

/**
 Returns the default shared `UXinNetCenter` singleton object.
 */
+ (instancetype)defaultCenter;

///-----------------------
/// @name General Property
///-----------------------

// NOTE: The following properties could only be assigned by `UXinNetConfig` through invoking `-setupConfig:` method.

/**
 The general server address for XMCenter, if UXinNetRequest.server is `nil` and the XMRequest.useGeneralServer is `YES`, this property will be assigned to UXinNetRequest.server.
 */
@property (nonatomic, copy, nullable) NSString *generalServer;
/**
 The general parameters for UXinNetCenter, if UXinNetRequest.serveruseGeneralParameters is `YES` and this property is not empty, it will be appended to XMRequest.parameters.
 */
@property (nonatomic, strong, nullable, readonly) NSMutableDictionary<NSString *, id> *generalParameters;

/**
 The general headers for UXinNetCenter, if UXinNetRequest.useGeneralHeaders is `YES` and this property is not empty, it will be appended to  UXinNetRequest.headers.
 */
@property (nonatomic, strong, nullable, readonly) NSMutableDictionary<NSString *, NSString *> *generalHeaders;

/**
 The general user info for UXinNetCenter, if UXinNetRequest.userInfo is `nil` and this property is not `nil`, it will be assigned to UXinNetRequest.userInfo.
 */
@property (nonatomic, strong, nullable) NSDictionary *generalUserInfo;
/**
 The dispatch queue for callback blocks. If `NULL` (default), a private concurrent queue is used.
 */
@property (nonatomic, strong, nullable) dispatch_queue_t callbackQueue;

/**
 The global requests engine for current UXinNetCenter object, `[UXinNetEngine sharedEngine]` by default.
 */
@property (nonatomic, strong) UXinNetEngine *engine;

/**
 Whether or not to print the request and response info in console, `NO` by default.
 */
@property (nonatomic, assign) BOOL consoleLog;

///--------------------------------------------
/// @name Instance Method to Configure UXinNetCenter
///--------------------------------------------


#pragma mark - Instance Method

/**
 Method to config the UXinNetCenter properties by a `UXinNetConfig` object.
 
 @param block The config block to assign the values for `UXinNetConfig` object.
 */
- (void)setupConfig:(void(^)(UXinNetConfig *config))block;

/**
 Method to set custom request pre processing block for UXinNetCenter.
 
 @param block The custom processing block (`CenterRequestProcessBlock`).
 */
- (void)setRequestProcessBlock:(CenterRequestProcessBlock)block;

/**
 Method to set custom response data processing block for UXinNetCenter.
 
 @param block The custom processing block (`CenterResponseProcessBlock`).
 */
- (void)setResponseProcessBlock:(CenterResponseProcessBlock)block;

/**
 Sets the value for the general HTTP headers of UXinNetCenter, If value is `nil`, it will remove the existing value for that header field.
 
 @param value The value to set for the specified header, or `nil`.
 @param field The HTTP header to set a value for.
 */
- (void)setGeneralHeaderValue:(nullable NSString *)value forField:(NSString *)field;

/**
 Sets the value for the general parameters of UXinNetCenter, If value is `nil`, it will remove the existing value for that parameter key.
 
 @param value The value to set for the specified parameter, or `nil`.
 @param key The parameter key to set a value for.
 */
- (void)setGeneralParameterValue:(nullable id)value forKey:(NSString *)key;

///---------------------------------------
/// @name Instance Method to Send Requests
///---------------------------------------

#pragma mark -

/**
 Creates and runs a Normal `UXinNetRequest`.
 
 @param configBlock The config block to setup context info for the new created UXinNetRequest object.
 @return Unique identifier for the new running UXinNetRequest object,`nil` for fail.
 */
- (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock;

/**
 Creates and runs a Normal `UXinNetRequest` with success block.
 
 NOTE: The success block will be called on `callbackQueue` of UXinNetCenter.
 
 @param configBlock The config block to setup context info for the new created UXinNetRequest object.
 @param successBlock Success callback block for the new created XMRequest object.
 @return Unique identifier for the new running UXinNetRequest object,`nil` for fail.
 */
- (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                         onSuccess:(nullable SuccessBlock)successBlock;

/**
 Creates and runs a Normal `UXinNetRequest` with failure block.
 
 NOTE: The failure block will be called on `callbackQueue` of UXinNetCenter.
 
 @param configBlock The config block to setup context info for the new created UXinNetRequest object.
 @param failureBlock Failure callback block for the new created UXinNetRequest object.
 @return Unique identifier for the new running UXinNetRequest object,`nil` for fail.
 */
- (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                         onFailure:(nullable FailureBlock)failureBlock;

/**
 Creates and runs a Normal `UXinNetCenter` with finished block.
 
 NOTE: The finished block will be called on `callbackQueue` of UXinNetCenter.
 
 @param configBlock The config block to setup context info for the new created XMRequest object.
 @param finishedBlock Finished callback block for the new created UXinNetRequest object.
 @return Unique identifier for the new running UXinNetCenter object,`nil` for fail.
 */
- (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                        onFinished:(nullable FinishedBlock)finishedBlock;

/**
 Creates and runs a Normal `UXinNetRequest` with success/failure blocks.
 
 NOTE: The success/failure blocks will be called on `callbackQueue` of UXinNetCenter.
 
 @param configBlock The config block to setup context info for the new created UXinNetRequest object.
 @param successBlock Success callback block for the new created UXinNetRequest object.
 @param failureBlock Failure callback block for the new created UXinNetRequest object.
 @return Unique identifier for the new running UXinNetCenter object,`nil` for fail.
 */
- (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                         onSuccess:(nullable SuccessBlock)successBlock
                         onFailure:(nullable FailureBlock)failureBlock;

/**
 Creates and runs a Normal `UXinNetRequest` with success/failure/finished blocks.
 
 NOTE: The success/failure/finished blocks will be called on `callbackQueue` of UXinNetCenter.
 
 @param configBlock The config block to setup context info for the new created UXinNetRequest object.
 @param successBlock Success callback block for the new created UXinNetRequest object.
 @param failureBlock Failure callback block for the new created UXinNetRequest object.
 @param finishedBlock Finished callback block for the new created UXinNetRequest object.
 @return Unique identifier for the new running XMRequest object,`nil` for fail.
 */
- (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                         onSuccess:(nullable SuccessBlock)successBlock
                         onFailure:(nullable FailureBlock)failureBlock
                        onFinished:(nullable FinishedBlock)finishedBlock;

/**
 Creates and runs an Upload/Download `UXinNetRequest` with progress/success/failure blocks.
 
 NOTE: The success/failure blocks will be called on `callbackQueue` of UXinCenter.
 BUT !!! the progress block is called on the session queue, not the `callbackQueue` of UXinNetCenter.
 
 @param configBlock The config block to setup context info for the new created UXinNetRequest object.
 @param progressBlock Progress callback block for the new created UXinNetRequest object.
 @param successBlock Success callback block for the new created UXinNetRequest object.
 @param failureBlock Failure callback block for the new created UXinNetRequest object.
 @return Unique identifier for the new running XMRequest object,`nil` for fail.
 */
- (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                        onProgress:(nullable ProgressBlock)progressBlock
                         onSuccess:(nullable SuccessBlock)successBlock
                         onFailure:(nullable FailureBlock)failureBlock;

/**
 Creates and runs an Upload/Download `UXinNetRequest` with progress/success/failure/finished blocks.
 
 NOTE: The success/failure/finished blocks will be called on `callbackQueue` of UXinNetCenter.
 BUT !!! the progress block is called on the session queue, not the `callbackQueue` of UXinNetCenter.
 
 @param configBlock The config block to setup context info for the new created UXinNetRequest object.
 @param progressBlock Progress callback block for the new created UXinNetRequest object.
 @param successBlock Success callback block for the new created UXinNetRequest object.
 @param failureBlock Failure callback block for the new created UXinNetRequest object.
 @param finishedBlock Finished callback block for the new created UXinNetRequest object.
 @return Unique identifier for the new running XMRequest object,`nil` for fail.
 */
- (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                        onProgress:(nullable ProgressBlock)progressBlock
                         onSuccess:(nullable SuccessBlock)successBlock
                         onFailure:(nullable FailureBlock)failureBlock
                        onFinished:(nullable FinishedBlock)finishedBlock;

/**
 Creates and runs batch requests
 
 @param configBlock The config block to setup batch requests context info for the new created UXinNetBatchRequest object.
 @param successBlock Success callback block called when all batch requests finished successfully.
 @param failureBlock Failure callback block called once a request error occured.
 @param finishedBlock Finished callback block for the new created XMBatchRequest object.
 @return Unique identifier for the new running XMBatchRequest object,`nil` for fail.
 */
- (nullable NSString *)sendBatchRequest:(BatchRequestConfigBlock)configBlock
                              onSuccess:(nullable BCSuccessBlock)successBlock
                              onFailure:(nullable BCFailureBlock)failureBlock
                             onFinished:(nullable BCFinishedBlock)finishedBlock;

/**
 Creates and runs chain requests
 
 @param configBlock The config block to setup chain requests context info for the new created UXinNetBatchRequest object.
 @param successBlock Success callback block called when all chain requests finished successfully.
 @param failureBlock Failure callback block called once a request error occured.
 @param finishedBlock Finished callback block for the new created UXinNetChainRequest object.
 @return Unique identifier for the new running UXinNetChainRequest object,`nil` for fail.
 */
- (nullable NSString *)sendChainRequest:(ChainRequestConfigBlock)configBlock
                              onSuccess:(nullable BCSuccessBlock)successBlock
                              onFailure:(nullable BCFailureBlock)failureBlock
                             onFinished:(nullable BCFinishedBlock)finishedBlock;

///------------------------------------------
/// @name Instance Method to Operate Requests
///------------------------------------------

#pragma mark -

/**
 Method to cancel a runnig request by identifier.
 
 @param identifier The unique identifier of a running request.
 */
- (void)cancelRequest:(NSString *)identifier;

/**
 Method to cancel a runnig request by identifier with a cancel block.
 
 NOTE: The cancel block is called on current thread who invoked the method, not the `callbackQueue` of XMCenter.
 
 @param identifier The unique identifier of a running request.
 @param cancelBlock The callback block to be executed after the running request is canceled. The canceled request object (if exist) will be passed in argument to the cancel block.
 */
- (void)cancelRequest:(NSString *)identifier
             onCancel:(nullable CancelBlock)cancelBlock;

/**
 Method to get a runnig request object matching to identifier.
 
 @param identifier The unique identifier of a running request.
 @return return The runing UXinNetRequest/UXinNetBatchRequest/UXinNetChainRequest object (if exist) matching to identifier.
 */
- (nullable id)getRequest:(NSString *)identifier;

/**
 Method to get current network reachablity status.
 
 @return The network is reachable or not.
 */
- (BOOL)isNetworkReachable;

///--------------------------------
/// @name Class Method for UXinNetCenter
///--------------------------------

// NOTE: The following class method is invoke through the `[UXinNetCenter defaultCenter]` singleton object.

#pragma mark - Class Method

+ (void)setupConfig:(void(^)(UXinNetConfig *config))block;
+ (void)setRequestProcessBlock:(CenterRequestProcessBlock)block;
+ (void)setResponseProcessBlock:(CenterResponseProcessBlock)block;
+ (void)setGeneralHeaderValue:(nullable NSString *)value forField:(NSString *)field;
+ (void)setGeneralParameterValue:(nullable id)value forKey:(NSString *)key;

#pragma mark -

+ (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock;

+ (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                         onSuccess:(nullable SuccessBlock)successBlock;

+ (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                         onFailure:(nullable FailureBlock)failureBlock;

+ (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                        onFinished:(nullable FinishedBlock)finishedBlock;

+ (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                         onSuccess:(nullable SuccessBlock)successBlock
                         onFailure:(nullable FailureBlock)failureBlock;

+ (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                         onSuccess:(nullable SuccessBlock)successBlock
                         onFailure:(nullable FailureBlock)failureBlock
                        onFinished:(nullable FinishedBlock)finishedBlock;

+ (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                        onProgress:(nullable ProgressBlock)progressBlock
                         onSuccess:(nullable SuccessBlock)successBlock
                         onFailure:(nullable FailureBlock)failureBlock;

+ (nullable NSString *)sendRequest:(RequestConfigBlock)configBlock
                        onProgress:(nullable ProgressBlock)progressBlock
                         onSuccess:(nullable SuccessBlock)successBlock
                         onFailure:(nullable FailureBlock)failureBlock
                        onFinished:(nullable FinishedBlock)finishedBlock;

+ (nullable NSString *)sendBatchRequest:(BatchRequestConfigBlock)configBlock
                              onSuccess:(nullable BCSuccessBlock)successBlock
                              onFailure:(nullable BCFailureBlock)failureBlock
                             onFinished:(nullable BCFinishedBlock)finishedBlock;

+ (nullable NSString *)sendChainRequest:(ChainRequestConfigBlock)configBlock
                              onSuccess:(nullable BCSuccessBlock)successBlock
                              onFailure:(nullable BCFailureBlock)failureBlock
                             onFinished:(nullable BCFinishedBlock)finishedBlock;

#pragma mark -

+ (void)cancelRequest:(NSString *)identifier;

+ (void)cancelRequest:(NSString *)identifier
             onCancel:(nullable CancelBlock)cancelBlock;

+ (nullable id)getRequest:(NSString *)identifier;

+ (BOOL)isNetworkReachable;

#pragma mark -

+ (void)addSSLPinningURL:(NSString *)url;
+ (void)addSSLPinningCert:(NSData *)cert;
+ (void)addTwowayAuthenticationPKCS12:(NSData *)p12 keyPassword:(NSString *)password;


@end
NS_ASSUME_NONNULL_END
