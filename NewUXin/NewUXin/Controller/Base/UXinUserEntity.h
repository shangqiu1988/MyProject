//
//  UXinUserEntity.h
//  NewUXin
//
//  Created by tanpeng on 17/8/10.
//  Copyright © 2017年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UXinBaseEntity.h"
#import "UXinDefaultHelper.h"
@interface UXinUserEntity : UXinBaseEntity
@property (nonatomic, copy) NSString *userId; //用户id
//@property (nonatomic, copy) NSString *password; //密码
@property (nonatomic, copy) NSString *userName; //用户名
@property (nonatomic, copy) NSString *realName; //真实姓名
//@property (nonatomic, copy) NSString *nickName; //昵称
//@property (nonatomic, copy) NSString *aliaseName; //别名
//@property (nonatomic, copy) NSString *verifyMessage; //别名
//@property (nonatomic, copy) NSString *userEmail; //用户邮箱
//@property (nonatomic, copy) NSString *cityId; //最后一次选择城市ID
//@property (nonatomic, copy) NSString *cityName; //最后一次选择城市名字
@property (nonatomic, copy) NSString *mobile; //用户电话
//@property (nonatomic, copy) NSString *balance; //账户余额
//@property (nonatomic, copy) NSString *mobileEncode; //加密后的手机号
@property (nonatomic, copy) NSString *headImageUrl; //账户头像
@property (nonatomic, copy) NSString *userSign;
@property (nonatomic, assign) NSInteger sex; //用户性别 0:男性 1:女性
@property (nonatomic, assign) NSInteger type; //供应商和采购商
//@property (nonatomic, assign) NSInteger userStatus; //好友关系0，我加别人等待确认；1，别人加我等待我的确认；3，双方确认成功
//@property (nonatomic, assign) BOOL isVerify; //用户是否需要验证 0，不需要。1，需要
//@property (nonatomic, assign) BOOL isFriend; //是否是好友
//@property (nonatomic, assign) BOOL isNew; //是否是新好友 //此处添加新的定义：在获取作业已读反馈信息中保存作业是否已读
//@property(nonatomic,copy) NSString *relationCount;
// xwx : 2013.10.16 去掉“体验版”相关各种代码
//@property (nonatomic, assign) NSInteger isExperience; //是否是体验版用户
// xwx : 2013.10.16 完
// xwx : 2013.10.16 新添加的定义，给通讯录提供要求
@property (nonatomic, copy) NSString *schoolId; //用户学校
@property (nonatomic, copy) NSString *gradeId; //用户年级
@property (nonatomic, copy) NSString *classId; //用户班级
@property (nonatomic, copy) NSString *areaId; //用户区域
@property (nonatomic, copy) NSString *post; //用户职务
@property (nonatomic, copy) NSString *subject; //用户科目
//@property (nonatomic, copy) NSString *parentId1; //用户家长1 //xwx：2016.08.02：该字段服务端不在返回，客户端代码虽有应用但无实际效果
//@property (nonatomic, copy) NSString *parentId2; //用户家长2
//@property (nonatomic, copy) NSString *parentId3; //用户家长3
@property (nonatomic, copy) NSString *children_account; //用户家长4 //xwx：2016.08.02：parentid4 改为存储家长账号关联的学生账号id，由服务端返回数据 children_account 读取而来
// xwx : 2013.10.16 完
// xwx : 2013.11.25 通讯录更新标示
@property (nonatomic, assign) NSInteger  flagOfUpdating; //用户是否需要更新 默认为不需要更新NO
//@property (nonatomic, copy) NSString *prefix; //用户首字母
// xwx : 2013.11.25 完
-(void)saveUser;

@end
