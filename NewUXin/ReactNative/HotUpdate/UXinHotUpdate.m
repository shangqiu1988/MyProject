//
//  UXinHotUpdate.m
//  NewUXin
//
//  Created by tanpeng on 2017/10/24.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinHotUpdate.h"

static NSString *const PackagePath = @"PackagePath";// js文件路径
static NSString *const PackageVersion = @"PackageVersion";//原生包版本号
static NSString *const  PackageCurrentVersion = @"currentVersion";//当前js版本
static NSString *const  PackageZipPath =  @"PackageZipPath"; //js文件压缩包路径

typedef void (^UnZipFinished)(BOOL isFinished);
typedef void (^patchFinished)(BOOL isFinished);

@implementation UXinHotUpdate
@synthesize defaultModulenName = _defaultModulenName;
@synthesize methodQueue = _methodQueue;
+(NSURL*)bundleForAppKey:(NSString *)appName
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *updateInfo =[defaults dictionaryForKey:appName];
    if(updateInfo){
        NSString *packageVersion;
       packageVersion = [updateInfo objectForKey:packageVersion];
        BOOL isNeedUpdate=NO;
        if(packageVersion!=[UXinHotUpdate packageVersion]){
            isNeedUpdate=YES;
        }
        if(!isNeedUpdate){
            
         NSString *downloadDir=[UXinHotUpdate downloadDir];
            
         NSString *bundlePath=[downloadDir stringByAppendingPathComponent:[updateInfo objectForKey:PackageZipPath]];
            
         if([[NSFileManager defaultManager]fileExistsAtPath:bundlePath isDirectory:NULL]){
             bundlePath=[downloadDir stringByAppendingPathComponent:[updateInfo objectForKey:PackagePath]];
            NSURL *bundleURL=[NSURL fileURLWithPath:bundlePath];
            
            return bundleURL;
            
         }else{
         
             [[NSUserDefaults standardUserDefaults]setObject:nil forKey:appName];
         }
            
        }else{
             [[NSUserDefaults standardUserDefaults]setObject:nil forKey:appName];
        }
      
        
        
        
       
        
    }
    
    return [UXinHotUpdate binaryBundleURL];
}
-(void)dealloc
{
    _defaultModulenName=nil;
    _fileManager=nil;
    _finishedUpdateBlock=nil;
}
-(instancetype)initWithDefaultModuleName:(NSString *)appName block:( FinishedUpdate )block callback:(CallBack)callback
{
    self=[super init];
    if(self){
             _methodQueue = dispatch_queue_create("cn.reactnative.hotupdate", DISPATCH_QUEUE_SERIAL);
        _fileManager=[[UXinHotUpdateManager alloc] init];
        self.defaultModulenName=appName;
        _finishedUpdateBlock=[block copy];
        _callBack=[callback copy];
    }
    return self;
}

-(void)setDefaultModulenName:(NSString *)defaultModulenName
{
    _defaultModulenName=nil;
    _defaultModulenName=[defaultModulenName copy];
}
-(NSString *)defaultModulenName
{
    return _defaultModulenName;
}
-(void)checkPackageVersion:(NSString *)appName url:(NSString *)url
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *updateInfo =[defaults dictionaryForKey:appName];
 
    NSString *appVersion=[UXinHotUpdate packageVersion];
    NSString *packageVersion=nil;
    if(updateInfo){
      
        packageVersion=[updateInfo objectForKey:PackageVersion];
        if(packageVersion!=appVersion){
//            [mutableUpdateInfo setObject:appVersion forKey:PackageVersion];
//            [mutableUpdateInfo setObject:appVersion forKey:PackageCurrentVersion];
             [[NSUserDefaults standardUserDefaults]setObject:nil forKey:appName];
            packageVersion=appVersion;
        }else{
                     NSString *downloadDir=[UXinHotUpdate downloadDir];
            NSString *bundlePath=[downloadDir stringByAppendingPathComponent:[updateInfo objectForKey:PackageZipPath]];
            
            if([[NSFileManager defaultManager]fileExistsAtPath:bundlePath isDirectory:NULL]){
               
                 packageVersion=[updateInfo objectForKey:PackageCurrentVersion];
                
            }else{
                  [[NSUserDefaults standardUserDefaults]setObject:nil forKey:appName];
                packageVersion=appVersion;
            }
          
        }
    }else{
        packageVersion=appVersion;
    }
    NSString *checkUrl=[NSString stringWithFormat:@"%@?vc=%@&nv=%@&module=%@&dev=ios",url,packageVersion,appVersion,appName];
    [self getVersionInfo:[NSURL URLWithString:checkUrl]];
}
-(void)getVersionInfo:(NSURL *)url
{
     __weak typeof(self) weakSelf = self;
    [UXinHotUpdateVersionCheck getVersionInfo:url completionHandler:^(NSDictionary *info, NSError *error) {
        if(info){
            NSString *isUpdate=[info objectForKey:@"isUpdate"];
            if([isUpdate isKindOfClass:[NSString class]]){
                if([isUpdate isEqualToString:@"0"]){
                    if(_callBack){
                        _callBack(@"没有新版本");
                    }
                }else{
                    NSMutableDictionary *options=[NSMutableDictionary dictionary];
                    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                    NSDictionary *updateInfo =[defaults dictionaryForKey:weakSelf.defaultModulenName];
                   
                    [options setObject:[UXinHotUpdate packageVersion] forKey:@"nv"];
                    [options setObject:[info objectForKey:@"newVersion"] forKey:@"newVersion"];
                 
                    if(updateInfo){
                        [options setObject:[updateInfo objectForKey:PackageCurrentVersion] forKey:@"vc"];
                          [options setObject:[updateInfo objectForKey:PackageZipPath] forKey:@"currentZipPath"];
                        [options setObject:[info objectForKey:@"patchUrl"] forKey:@"patchUrl"];
                         [weakSelf downloadUpdate:options hotType:HotUpdateTypePatchFromPpk];
                    }else{
                          [options setObject:[UXinHotUpdate packageVersion] forKey:@"vc"];
                           [options setObject:[info objectForKey:@"fullUrl"] forKey:@"fullUrl"];
                          [weakSelf downloadUpdate:options hotType:HotUpdateTypeFullDownload];
                    }
                    
                    
                    
                }
                
                
                
                
                
                
            }
        }
    }];
}
-(void)downloadUpdate:(NSDictionary *)options hotType:(HotUpdateType)hotType
{
    NSString *vc=[options objectForKey:@"vc"];
    NSString *newVersion=[options objectForKey:@"newVersion"];
    NSString *patchUrl=[options objectForKey:@"patchUrl"];
    NSString *fullUrl=[options objectForKey:@"fullUrl"];
    NSString *currentZipPath=[options objectForKey:@"currentZipPath"];
    NSString *dir = [UXinHotUpdate downloadDir];
    dir=[dir stringByAppendingPathComponent:newVersion];
    BOOL success = [_fileManager createDir:dir];
    if(!success){
        if(_callBack){
            _callBack(@"创建文件失败");
            return;
        }
    }
    if(currentZipPath){
        vc=[dir stringByAppendingPathComponent:vc];
        currentZipPath=[vc stringByAppendingPathComponent:currentZipPath ];
    }
     NSString *zipFilePath=[dir stringByAppendingPathComponent:[NSString stringWithFormat:@"RN%@",[self zipExtension:hotType] ]];
    NSString *downloadUrl= (hotType == HotUpdateTypeFullDownload )? fullUrl : patchUrl;
          __weak typeof(self) weakSelf = self;
    [UXinHotUpdateDownloader download:downloadUrl savePath:zipFilePath progressHandler:^(long long receivedBytes, long long totalBytes) {
        
    } completionHandler:^(NSString *path, NSError *error) {
        dispatch_async(weakSelf.methodQueue, ^{
            switch (hotType) {
                case HotUpdateTypeFullDownload:
                {
                    [weakSelf unzipFile:zipFilePath destionPath:dir callback:^(BOOL isFinished) {
                        if(isFinished){
                            NSMutableDictionary *newInfo=[NSMutableDictionary dictionary];
                            [newInfo setObject:[zipFilePath lastPathComponent] forKey:PackageZipPath];
                            [newInfo setObject:newVersion forKey:PackageCurrentVersion];
                            [newInfo setObject:[UXinHotUpdate packageVersion] forKey:PackageVersion];
                            [newInfo setObject:@"index.bundlejs" forKey:PackagePath];
                            if(weakSelf.finishedUpdateBlock){
                                weakSelf.finishedUpdateBlock(newInfo, nil);
                            }
                        }else{
                            weakSelf.callBack(@"解压失败");
                        }
                    }];
                }
                    break;
                case HotUpdateTypePatchFromPpk:
                {
                    NSString *destionZip=[dir stringByAppendingPathComponent:@"RN.zip"];
                    [weakSelf patch:zipFilePath fromBundle:currentZipPath source:destionZip callback:^(BOOL isFinished) {
                        if(isFinished){
                            [weakSelf unzipFile:destionZip destionPath:dir callback:^(BOOL isFinished) {
                                if(isFinished){
                                    NSMutableDictionary *newInfo=[NSMutableDictionary dictionary];
                                    [newInfo setObject:[destionZip lastPathComponent] forKey:PackageZipPath];
                                    [newInfo setObject:newVersion forKey:PackageCurrentVersion];
                                    [newInfo setObject:[UXinHotUpdate packageVersion] forKey:PackageVersion];
                                    [newInfo setObject:@"index.bundlejs" forKey:PackagePath];
                                    if(weakSelf.finishedUpdateBlock){
                                        weakSelf.finishedUpdateBlock(newInfo, nil);
                                    }
                                }else{
                                    weakSelf.callBack(@"解压失败");
                                }
                            }];
                        }else{
                               weakSelf.callBack(@"生成新包失败");
                        }
                    }];
                }
                    break;
                default:
                    if(weakSelf.callBack){
                        weakSelf.callBack(nil);
                    }
                    break;
            }
        });
    }];
    
}
- (void)patch:(NSString *)hashName fromBundle:(NSString *)bundleOrigin source:(NSString *)sourceOrigin  callback:(patchFinished)callback
{
    [_fileManager bsdiffFileAtPath:hashName fromOrigin:bundleOrigin toDestination:sourceOrigin completionHandler:^(BOOL success) {
        if(callback){
            callback(success);
        }
    }];
}
-(void)unzipFile:(NSString *)sourceFile destionPath:(NSString *)deationPath callback:(UnZipFinished)callback;
{
  
    [_fileManager unzipFileAtPath:sourceFile toDestination:deationPath progressHandler:^(NSString *entry, long entryNumber, long total) {
        
    } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
        if(succeeded){
            callback(YES);
        }else{
            if(callback){
                callback(NO);
            }
        }
    }];
}
-(void)setMarkSuccess:(NSDictionary *)options
{
      [[NSUserDefaults standardUserDefaults]setObject:options forKey:self.defaultModulenName];
}
-(void)reloadUpdate:(NSDictionary *)options
{
    
}
- (NSString *)zipExtension:(HotUpdateType)type
{
    switch (type) {
        case HotUpdateTypeFullDownload:
            return @".zip";
        case HotUpdateTypePatchFromPackage:
            return @".apk.patch";
        case HotUpdateTypePatchFromPpk:
            return @".zip.patch";
        default:
            break;
    }
}

-(void)clearHistoryVersion
{
    [_fileManager removeFile:[UXinHotUpdate downloadDir] completionHandler:^(NSError *error) {
        
    }];
}
+ (NSURL *)binaryBundleURL
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"bundlejs"];
    return url;
}
+ (NSString *)packageVersion
{
    static NSString *version = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    });
    return version;
}
+ (NSString *)downloadDir
{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSString *downloadDir = [directory stringByAppendingPathComponent:@"reactnativechotupdate"];
    
    return downloadDir;
}
@end
