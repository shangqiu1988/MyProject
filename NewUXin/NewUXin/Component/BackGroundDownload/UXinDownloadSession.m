//
//  UXinDownloadSession.m
//  NewUXin
//
//  Created by tanpeng on 2018/1/26.
//  Copyright © 2018年 Study. All rights reserved.
//

#import "UXinDownloadSession.h"
#import "NSURLSession+CorrectedResumeData.h"

static NSString * const kIsAllowCellar = @"kIsAllowCellar";
@interface UXinDownloadSession ()<NSURLSessionDownloadDelegate>
/**正在下载的task*/
@property (nonatomic, strong) NSMutableDictionary *downloadTasks;
/**下载完成的task*/
@property (nonatomic, strong) NSMutableDictionary *downloadedTasks;
/**后台下载回调的handlers，所有的下载任务全部结束后调用*/
@property (nonatomic, copy) BGCompletedHandler completedHandler;
@property (nonatomic, strong, readonly) NSURLSession *downloadSession;
/**重新创建sessio标记位*/
@property (nonatomic, assign) BOOL isNeedCreateSession;
/**启动下一个下载任务的标记位*/
@property (nonatomic, assign) BOOL isStartNextTask;

@end
@implementation UXinDownloadSession
static UXinDownloadSession *_instance;

+ (instancetype)downloadSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
+(id)allocWithZone:(struct _NSZone *)zone
{
    return [UXinDownloadSession downloadSession];
}
- (id)copyWithZone:(struct _NSZone *)zone
{
    return [UXinDownloadSession downloadSession];
}
-(instancetype)init
{
    self=[super init];
    if(self){
        _downloadSession = [self getDownloadURLSession];
        _maxTaskCount = 1;
        self.downloadTasks=[NSKeyedUnarchiver unarchiveObjectWithFile:[self getArchiverPathIsDownloaded:NO]];
        self.downloadedTasks=[NSKeyedUnarchiver unarchiveObjectWithFile:[self getArchiverPathIsDownloaded:YES]];
        
        if(!self.downloadedTasks){
            self.downloadedTasks=[NSMutableDictionary dictionary];
        }
        if(!self.downloadTasks){
            self.downloadTasks=[NSMutableDictionary dictionary];
        }
        //获取背景session正在运行的(app重启，或者闪退会有任务)
        NSMutableDictionary *dictM = [self.downloadSession valueForKey:@"tasks"];
        [dictM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            UXinDownloadTask *task=[self getDownloadTaskWithUrl:[UXinDownloadTask getURLFromTask:obj] isDownloadingList:YES];
            if(!task){
                [obj cancel];
            }else{
                task.downloadTask=obj;
            }
        }];
        [self pauseAllDownloadTask];
    }
    return self;
}
- (NSURLSession *)getDownloadURLSession
{
    NSURLSession *session=nil;
    NSString *identify=[self backgroundSessionIdentifier];
    NSURLSessionConfiguration *sessionConfig=[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identify];
    sessionConfig.allowsCellularAccess= [[NSUserDefaults standardUserDefaults] boolForKey:kIsAllowCellar];
    session=[NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    return session;
}
- (NSString *)backgroundSessionIdentifier {
    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *identifier = [NSString stringWithFormat:@"%@.BackgroundSession", bundleId];
    return identifier;
}
- (void)recreateSession
{
    _downloadSession=[self getDownloadURLSession];
    [self.downloadTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UXinDownloadTask *task= obj;
        if(task.needToRestart){
            task.needToRestart=NO;
            [self resumeDownloadTask:task];
        }
    }];
}
-(void)setMaxTaskCount:(NSInteger)maxTaskCount {
    if (maxTaskCount>3) {
        _maxTaskCount = 3;
    }else if(maxTaskCount <= 0){
        _maxTaskCount = 1;
    }else{
        _maxTaskCount = maxTaskCount;
    }
}
- (NSInteger)currentTaskCount
{
    NSMutableDictionary *dicM=[self.downloadSession valueForKey:@"tasks"];
    __block NSInteger count = 0;
    [dicM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSURLSessionTask *task = obj;
        if(task.state == NSURLSessionTaskStateRunning){
            count++;
        }
    }];
    return count;
}
#pragma mark - event
- (NSString *)getArchiverPathIsDownloaded:(BOOL)isDownloaded {
    NSString *saveDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true).firstObject;
    saveDir = [saveDir stringByAppendingPathComponent:@"Download/Archiver"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:saveDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:saveDir withIntermediateDirectories:true attributes:nil error:nil];
    }
    saveDir = isDownloaded ? [saveDir stringByAppendingPathComponent:@"Downloaded.data"] : [saveDir stringByAppendingPathComponent:@"Downloading.data"];
    
    return saveDir;
}
- (void)saveDownloadStatus {
    
    [NSKeyedArchiver archiveRootObject:self.downloadTasks toFile:[self getArchiverPathIsDownloaded:false]];
    [NSKeyedArchiver archiveRootObject:self.downloadedTasks toFile:[self getArchiverPathIsDownloaded:true]];
}
- (UXinDownloadTask *)getDownloadTaskWithUrl:(NSString *)downloadUrl isDownloadingList:(BOOL)isDownloadList
{
    NSMutableDictionary *tasks = isDownloadList ? self.downloadTasks : self.downloadedTasks;
        __block UXinDownloadTask *task = nil;
    [tasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UXinDownloadTask *dTask= obj;
        if([dTask.downloadURL isEqualToString:downloadUrl]){
            task=dTask;
            *stop=YES;
        }
    }];
    return task;
}
- (BOOL)detectDownloadTaskIsFinished:(UXinDownloadTask *)task
{
    NSMutableArray *tmpPaths = [NSMutableArray array];
    
    if (task.tempPath.length > 0) [tmpPaths addObject:task.tempPath];
    
    if (task.tmpName.length > 0) {
        [tmpPaths addObject:[NSTemporaryDirectory() stringByAppendingPathComponent:task.tmpName]];
        NSString *downloadPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true).firstObject;
        NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        downloadPath = [downloadPath stringByAppendingPathComponent: [NSString stringWithFormat:@"/com.uxin.nsurlsessiond/Downloads/%@/", bundleId]];
        downloadPath = [downloadPath stringByAppendingPathComponent:task.tmpName];
        [tmpPaths addObject:downloadPath];
    }
    __block BOOL isFinished = false;
    [tmpPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path = obj;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            NSInteger fileSize = dic ? (NSInteger)[dic fileSize] : 0;
            if (fileSize>0 && fileSize == task.fileSize) {
                [[NSFileManager defaultManager] moveItemAtPath:path toPath:[UXinDownloadTask savePathWithSaveName:task.saveName] error:nil];
                isFinished = true;
                task.downloadStatus = DownloadStatusFinished;
                *stop = true;
            }
        }
    }];
    
    return isFinished;
    
}
#pragma mark - public

-(void)startDownloadWithUrl:(NSString *)downloadURLString delegate:(id<DownloadTaskDelegate>)delegate saveName:(NSString *)saveName
{
    //判断是否是下载完成的任务
    UXinDownloadTask *task=[self getDownloadTaskWithUrl:downloadURLString isDownloadingList:NO];
    if(task){
        task.delegate=delegate;
        [self downloadStatusChanged:DownloadStatusFinished task:task];
        return;
    }
    //读取正在下载的任务
    task=[self getDownloadTaskWithUrl:downloadURLString isDownloadingList:YES];
    if(!task){
         //判断任务的个数，如果达到最大值则返回，回调等待
        if([self currentTaskCount]>=self.maxTaskCount){
            [self createDownloadTaskWithUrl:downloadURLString delegate:delegate saveName:saveName];
            [self downloadStatusChanged:DownloadStatusWaiting task:task];
        }else{
            //开始下载
            [self createDownloadTaskWithUrl:downloadURLString delegate:delegate saveName:saveName];
        }
    }else{
        task.delegate=delegate;
        if([self detectDownloadTaskIsFinished:task]){
            [self downloadStatusChanged:DownloadStatusFinished task:task];
            return;
        }
        if(task.downloadTask&&task.downloadTask.state ==NSURLSessionTaskStateRunning&&task.resumeData.length == 0){
            [task.downloadTask resume];
            [self downloadStatusChanged:DownloadStatusDownloading task:task];
            return;
        }
        [self resumeDownloadTask:task];
    }
}
-(void)pauseDownloadWithUrl:(NSString *)downloadURLString
{
    self.isStartNextTask=YES;
    [self pauseDownloadTask:[self getDownloadTaskWithUrl:downloadURLString isDownloadingList:YES]];
}
-(void)pauseAllDownloadTask
{
    [self.downloadTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self pauseDownloadTask:obj];
    }];
}
-(void)resumeDownloadWithUrl:(NSString *)downloadURLString delegate:(id<DownloadTaskDelegate>)delegate saveName:(NSString *)saveName
{
        //判断是否是下载完成的任务
    UXinDownloadTask *task=[self getDownloadTaskWithUrl:downloadURLString isDownloadingList:NO];
    if(task){
        task.delegate=delegate;
        [self downloadStatusChanged:DownloadStatusFinished task:task];
        return;
    }
   
    task=[self getDownloadTaskWithUrl:downloadURLString isDownloadingList:YES];
   //如果下载列表和下载完成列表都不存在，则重新创建
    if(!task){
        [self startDownloadWithUrl:downloadURLString delegate:delegate saveName:nil];
        return;
    }
    if(delegate){
        task.delegate=delegate;
    }
    [self resumeDownloadTask:task];
}
-(void)stopDownloadWithUrl:(NSString *)downloadURLString
{
    @try{
        [self stopDownloadWithTask:[self getDownloadTaskWithUrl:downloadURLString isDownloadingList:YES]];
        UXinDownloadTask *task=[self getDownloadTaskWithUrl:downloadURLString isDownloadingList:YES];
        if(!task){
            task =[self getDownloadTaskWithUrl:downloadURLString isDownloadingList:NO];
        }
         NSString *filePath = [UXinDownloadTask savePathWithSaveName:task.saveName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        [self.downloadTasks removeObjectForKey:downloadURLString];
        [self.downloadedTasks removeObjectForKey:downloadURLString];
    }@catch(NSException *exception){
        
    }
    [self saveDownloadStatus];
    
}
- (void)allowsCellularAccess:(BOOL)isAllow
{
    [[NSUserDefaults standardUserDefaults] setBool:isAllow forKey:kIsAllowCellar];
    [self.downloadTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UXinDownloadTask *task = obj;
        if (task.downloadTask.state == NSURLSessionTaskStateRunning) {
            task.needToRestart = true;
            [self pauseDownloadTask:task];
        }
    }];
    
    [_downloadSession invalidateAndCancel];
    self.isNeedCreateSession = true;
}
-(void)addCompletionHandler:(BGCompletedHandler)handler identifier:(NSString *)identifier
{
    if ([[self backgroundSessionIdentifier] isEqualToString:identifier]) {
        self.completedHandler = handler;
    }
}
-(BOOL)isAllowsCellularAccess
{
     return [[NSUserDefaults standardUserDefaults] boolForKey:kIsAllowCellar];
}
#pragma mark - private
- (void)createDownloadTaskWithUrl:(NSString *)downloadURLString delegate:(id<DownloadTaskDelegate>)delegate saveName:(NSString *)saveName
{
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    NSURLSessionDownloadTask *downloadTask = [self.downloadSession downloadTaskWithRequest:request];
    UXinDownloadTask *task = [self createDownloadTaskItemWithUrl:downloadURLString delegate:delegate saveName:saveName];
    task.downloadTask = downloadTask;
    [downloadTask resume];
    [self downloadStatusChanged:DownloadStatusDownloading task:task];
}
- (UXinDownloadTask *)createDownloadTaskItemWithUrl:(NSString *)downloadURLString delegate:(id<DownloadTaskDelegate>)delegate saveName:(NSString *)saveName
{
    UXinDownloadTask *task = [[UXinDownloadTask alloc] initWithSaveName:saveName];
    task.downloadURL = downloadURLString;
    task.delegate = delegate;
    [self.downloadTasks setObject:task forKey:task.downloadURL];
    [self downloadStatusChanged:DownloadStatusWaiting task:task];
    return task;
}
- (void)pauseDownloadTask:(UXinDownloadTask *)task
{
    [task.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        if(resumeData.length>0) task.resumeData = resumeData;
        task.downloadTask = nil;
        [self saveDownloadStatus];
        [self downloadStatusChanged:DownloadStatusPaused task:task];
        if (self.isStartNextTask) {
            [self startNextDownloadTask];
        }
    }];
}
- (void)resumeDownloadTask:(UXinDownloadTask *)task
{
    
    if(!task) return;
    if (([self currentTaskCount] >= self.maxTaskCount) && task.downloadStatus != DownloadStatusDownloading) {
        [self downloadStatusChanged:DownloadStatusWaiting task:task];
        return;
    }
    if ([self detectDownloadTaskIsFinished:task]) {
        [self downloadStatusChanged:DownloadStatusFinished task:task];
        return;
    }
    NSData *data = task.resumeData;
    if (data.length > 0) {
        if(task.downloadTask && task.downloadTask.state == NSURLSessionTaskStateRunning){
            [self downloadStatusChanged:DownloadStatusDownloading task:task];
            return;
        }
        NSURLSessionDownloadTask *downloadTask = nil;
        if (IS_IOS10ORLATER) {
            @try { //非ios10 升级到ios10会引起崩溃
                downloadTask = [self.downloadSession downloadTaskWithCorrectResumeData:data];
            } @catch (NSException *exception) {
                downloadTask = [self.downloadSession downloadTaskWithResumeData:data];
            }
        } else {
            downloadTask = [self.downloadSession downloadTaskWithResumeData:data];
        }
        task.downloadTask = downloadTask;
        [downloadTask resume];
        task.resumeData = nil;
        [self downloadStatusChanged:DownloadStatusDownloading task:task];
        
    }else{
        //没有下载任务，那么重新创建下载任务；  部分下载暂停异常 NSURLSessionTaskStateCompleted ，但并没有完成，所以重新下载
        if (!task.downloadTask || task.downloadTask.state == NSURLSessionTaskStateCompleted) {
            NSString *url = task.downloadURL;
            if (url.length ==0) return;
            [self.downloadTasks removeObjectForKey:url];
            [self createDownloadTaskWithUrl:url delegate:task.delegate saveName:task.saveName];
        }else{
            [task.downloadTask resume];
            [self downloadStatusChanged:DownloadStatusDownloading task:task];
        }
    }
}
- (void)stopDownloadWithTask:(UXinDownloadTask *)task
{
    [task.downloadTask cancel];
}
- (void)startNextDownloadTask
{
    self.isStartNextTask =NO;
    if([self currentTaskCount]<self.maxTaskCount){
        [self.downloadTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            UXinDownloadTask *task=obj;
            if ((!task.downloadTask || task.downloadTask.state != NSURLSessionTaskStateRunning) && task.downloadStatus == DownloadStatusWaiting) {
                [self resumeDownloadTask:task];
            }
        }];
    }
    
}
- (void)downloadStatusChanged:(DownloadStatus)status task:(UXinDownloadTask *)task
{
    task.downloadStatus = status;
    [self saveDownloadStatus];
    switch (status) {
        case DownloadStatusWaiting:
            break;
        case DownloadStatusDownloading:
            break;
        case DownloadStatusPaused:
            break;
        case DownloadStatusFailed:
            break;
        case DownloadStatusFinished:
            [self startNextDownloadTask];
            break;
        default:
            break;
    }
    
    if ([task.delegate respondsToSelector:@selector(downloadStatusChanged:downloadTask:)]) {
        [task.delegate downloadStatusChanged:status downloadTask:task];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadStatusChangedNoti object:nil];
    //等task delegate方法执行完成后去判断该逻辑
    //URLSessionDidFinishEventsForBackgroundURLSession 方法在后台执行一次，所以在此判断执行completedHandler
    if (status == DownloadStatusFinished) {
        
        if ([self allTaskFinised]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadAllTaskFinishedNoti object:nil];
            //所有的任务执行结束之后调用completedHanlder
            if (self.completedHandler) {
                NSLog(@"completedHandler");
                self.completedHandler();
                self.completedHandler = nil;
            }
        }
        
    }
}
- (BOOL)allTaskFinised
{
    if (self.downloadTasks.count == 0) return true;
    
    __block BOOL isFinished = true;
    [self.downloadTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UXinDownloadTask *task = obj;
        if (task.downloadStatus == DownloadStatusWaiting || task.downloadStatus == DownloadStatusDownloading) {
            isFinished = false;
            *stop = true;
        }
    }];
    return isFinished;
}
#pragma mark -  NSURLSessionDelegate
//将一个后台session作废完成后的回调，用来切换是否允许使用蜂窝煤网络，重新创建session
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
    if (self.isNeedCreateSession) {
        self.isNeedCreateSession = false;
        [self recreateSession];
    }
}

//如果appDelegate实现下面的方法，后台下载完成时，会自动唤醒启动app。如果不实现，那么后台下载完成不唤醒，用户手动启动会调用相关回调方法
//-[AppDelegate application:handleEventsForBackgroundURLSession:completionHandler:]
//后台唤醒调用顺序： appdelegate ——> didFinishDownloadingToURL  ——> URLSessionDidFinishEventsForBackgroundURLSession
//手动启动调用顺序: didFinishDownloadingToURL  ——> URLSessionDidFinishEventsForBackgroundURLSession
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"%s", __func__);
    
    NSString *locationString = [location path];
    NSError *error;
    
    NSString *downloadUrl = [UXinDownloadTask getURLFromTask:downloadTask];
    UXinDownloadTask *task = [self getDownloadTaskWithUrl:downloadUrl isDownloadingList:true];
    if(!task){
        NSLog(@"download finished , item nil error!!!! url: %@", downloadUrl);
        return;
    }
    task.tempPath = locationString;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:locationString error:nil];
    NSInteger fileSize = dic ? (NSInteger)[dic fileSize] : 0;
    //校验文件大小
    BOOL isCompltedFile = (fileSize>0) && (fileSize == task.fileSize);
    //文件大小不对，回调失败 ios11 多次暂停继续会出现文件大小不对的情况
    if (!isCompltedFile) {
        [self downloadStatusChanged:DownloadStatusFailed task:task];
        return;
    }
    task.downloadedSize = task.fileSize;
    [[NSFileManager defaultManager] moveItemAtPath:locationString toPath:[UXinDownloadTask savePathWithSaveName:task.saveName] error:&error];
    
    if (task.downloadURL.length != 0) {
        [self.downloadedTasks setObject:task forKey:task.downloadURL];
        [self.downloadTasks removeObjectForKey:task.downloadURL];
    }
    [self downloadStatusChanged:DownloadStatusFinished task:task];
}
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
      UXinDownloadTask *task = [self getDownloadTaskWithUrl:[UXinDownloadTask getURLFromTask:downloadTask] isDownloadingList:true];
    task.downloadedSize = (NSInteger)totalBytesWritten;
    if (task.fileSize == 0)  {
        [task updateTask];
        if ([task.delegate respondsToSelector:@selector(downloadCreated:)]) {
            [task.delegate downloadCreated:task];
        }
        [self saveDownloadStatus];
    }
    
    if([task.delegate respondsToSelector:@selector(downloadProgress:downloadedSize:fileSize:)]){
        [task.delegate downloadProgress:task downloadedSize:task.downloadedSize fileSize:task.fileSize];
    }
    
    NSString *url = downloadTask.response.URL.absoluteString;
    NSLog(@"downloadURL: %@  downloadedSize: %zd totalSize: %zd  progress: %f", url, task.downloadedSize, task.fileSize, (float)task.downloadedSize / task.fileSize);
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    
    //NSLog(@"willPerformHTTPRedirection ------> %@",response);
}

//后台下载完成后调用。在执行 URLSession:downloadTask:didFinishDownloadingToURL: 之后调用
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    //NSLog(@"%s", __func__);
    
}

/*
 * 该方法下载成功和失败都会回调，只是失败的是error是有值的，
 * 在下载失败时，error的userinfo属性可以通过NSURLSessionDownloadTaskResumeData
 * 这个key来取到resumeData(和上面的resumeData是一样的)，再通过resumeData恢复下载
 */
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if (error) {
        
        // check if resume data are available
        NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
        UXinDownloadTask *yctask = [self getDownloadTaskWithUrl:[UXinDownloadTask getURLFromTask:task] isDownloadingList:true];
        NSLog(@"error ----->   %@  ----->   %@   --->%zd",error, yctask.downloadURL, resumeData.length);
        if (resumeData) {
            //通过之前保存的resumeData，获取断点的NSURLSessionTask，调用resume恢复下载
            yctask.resumeData = resumeData;
            id obj = [NSPropertyListSerialization propertyListWithData:resumeData options:0 format:0 error:nil];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *resumeDict = obj;
                NSLog(@"%@", resumeDict);
                yctask.tmpName = [resumeDict valueForKey:@"NSURLSessionResumeInfoTempFileName"];
            }
            
        }else{
            [self downloadStatusChanged:DownloadStatusFailed task:yctask];
            [self startNextDownloadTask];
        }
    }
}
@end
   
    
