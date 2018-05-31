//
//  UXinLoginViewController.m
//  NewUXin
//
//  Created by tanpeng on 17/8/2.
//  Copyright © 2017年 Study. All rights reserved.
//

#import "UXinLoginViewController.h"
#import "UXinLoginViewModel.h"
#import "UXinDomainEntity.h"

@interface UXinLoginViewController ()
{
    
}
@property(nonatomic,strong) UXinLoginViewModel *loginViewModel;
@property(nonatomic,strong) NSMutableArray *domains;
@property(nonatomic,strong) NSMutableArray *domainNames;
@property(nonatomic,strong) NSMutableArray *userNames;
@property(nonatomic,strong) NSMutableArray *users;
@end

@implementation UXinLoginViewController{
    
    
  

}
-(void)dealloc
{
    
}
-(void)loadView
{
    UIScrollView *scrollview=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    scrollview.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.showsHorizontalScrollIndicator=NO;
    scrollview.scrollEnabled=NO;
    self.view=scrollview;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:YES];
    [self.loginViewModel getDomains];
    _isNeedShowPicker=NO;
    _domains=nil;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *iconView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon.png"]];
    _accountField = [[UITextField alloc]init];
    _accountField.layer.cornerRadius = 5;
    _accountField.layer.borderWidth = .5;
    _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountField.layer.borderColor = [UIColor grayColor].CGColor;
    _accountField.placeholder = @"请输入账号";
  
    _passwordField = [[UITextField alloc]init];
    _passwordField.layer.cornerRadius = 5;
    _passwordField.layer.borderWidth = .5;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
   _passwordField.layer.borderColor = [UIColor grayColor].CGColor;
    _passwordField.placeholder = @"请输入密码";
    _passwordField.secureTextEntry = YES;
  

    UIImage *image = [UIImage imageNamed:@"btn_green.png"];
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ self.loginBtn setBackgroundImage:[image stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [ self.loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [ self.loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:fontSizeAdaptive(17.0f)]];
    
    //约束
    UIImage *IMG_Register=[UIImage imageNamed:@"btn_orange.png"];
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerBtn setBackgroundImage:[IMG_Register stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.registerBtn setTitle:@"注  册" forState:UIControlStateNormal];
    [self.registerBtn.titleLabel setFont:[UIFont systemFontOfSize:fontSizeAdaptive(17)]];
    [self.view addSubview:iconView];
    [self.view addSubview:self.accountField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
    WEAKSELF
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(50);
    }];
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(iconView.mas_bottom).offset(30);
        make.width.equalTo(weakSelf.view).multipliedBy(0.7);
        make.height.mas_equalTo(50);
        
    }];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.accountField.mas_bottom).offset(20);
        make.width.equalTo(weakSelf.view).multipliedBy(0.7);
        make.height.mas_equalTo(50);
        
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.passwordField.mas_bottom).offset(20);
        make.width.equalTo(weakSelf.view).multipliedBy(0.7);
             make.height.mas_equalTo(40);
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.loginBtn.mas_bottom).offset(20);
        make.width.equalTo(weakSelf.view).multipliedBy(0.7);
         make.height.mas_equalTo(40);
    }];
 
 //ReactiveCocoa
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf selectArea];
    }];
    [[self.accountField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        if(weakSelf.accountField.text.length==0){
            weakSelf.passwordField.text=@"";
        }
    }];
        RACSignal *validUserNameSignal=[[self.accountField rac_textSignal] map:^id _Nullable(NSString * _Nullable value) {
      
        return @(value.length!=0);
    }];
    
    RACSignal *validPasswordSignal=[[self.passwordField rac_textSignal] map:^id _Nullable(NSString * _Nullable value) {
        
        return @(value.length!=0);
    }];
    RACSignal *loginActiveSignal=[RACSignal combineLatest:@[validUserNameSignal,validPasswordSignal] reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid){
        return @([usernameValid boolValue]&&[passwordValid boolValue]);
    }];
    [loginActiveSignal subscribeNext:^(NSNumber* isActive) {
        
        if([isActive boolValue]){
            self.loginBtn.enabled=YES;
//            self.loginBtn.backgroundColor=RGBA(83, 149, 232, 1.0);
        }else{
            self.loginBtn.enabled=NO;
            self.loginBtn.backgroundColor=[UIColor grayColor];
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
       
       
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextFieldTextDidEndEditingNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
    }];
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma get
-(NSMutableArray *)userNames
{
    if(_userNames==nil){
        _userNames=[[NSMutableArray alloc] init];
    }
    return _userNames;
}
#pragma mark-private
-(void)showDomainPicker
{
    if(!_domainNames){
        _domainNames=[NSMutableArray array];
        for(UXinDomainEntity *entity in self.domains)
        {
            [_domainNames addObject:entity.areaName];
        }
    }
    WEAKSELF
    [self.accountField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    dispatch_async(dispatch_get_main_queue(), ^{
    [BRStringPickerView showStringPickerWithTitle:@"请选择" dataSource:_domainNames defaultSelValue:nil isAutoSelect:NO resultBlock:^(id selectValue) {
        NSInteger index=[weakSelf.domainNames indexOfObject:selectValue];
        UXinDomainEntity *entity=[weakSelf.domains objectAtIndex:index];
        [entity saveDomain];
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        [params setObject:weakSelf.accountField.text forKey:@"mobile"];
        [params setObject:@"1" forKey:@"device_type"];
        if(weakSelf.userNames.count==0){
          [SVProgressHUD showWithStatus:@"正在获取..."];
        
        [weakSelf.loginViewModel getRelationAccount:KGetRelationAccountUrl parameters:params];
        }else{
            [weakSelf showUsers];
        }
        
    }];
         });
}
-(void)showUsers
{
    if(self.userNames.count==0){
        for(UXinUserEntity *entity in self.users)
        {
            [self.userNames addObject:entity.realName];
        }
        
    }
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [BRStringPickerView showStringPickerWithTitle:@"请选择" dataSource:weakSelf.userNames defaultSelValue:nil isAutoSelect:NO resultBlock:^(id selectValue) {
            NSInteger index=[weakSelf.userNames indexOfObject:selectValue];
            UXinUserEntity *entity=[weakSelf.users objectAtIndex:index];
            [weakSelf loginWithUSer:entity];
            
        }];
    });
   
}
-(void)loginWithUSer:(UXinUserEntity *)entity
{
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    NSString *password=[self.passwordField.text md5Str];
    [params setObject:entity.userName forKey:@"user_name"];
    [params setObject:password forKey:@"user_password"];
    NSString *time=kCurrentTime;
    NSString *sign=[[NSString stringWithFormat:@"%@_%@_1_%@_%@_%@",entity.userName,[password sha1],[NSString UUID],time,kSignKey] sha1];
    [params setObject:time forKey:@"time"];
    [params setObject:sign forKey:@"security_sign"];
    [SVProgressHUD showWithStatus:@"正在登陆..."];
    [self.loginViewModel login:KLoginUrl parameters:params];
}
#pragma mark-event
-(void)selectArea
{
    if(self.domains){
        [self showDomainPicker];
    }else{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];//设置HUD的Style
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//设置HUD和文本的颜色
        [SVProgressHUD setBackgroundColor:[UIColor blackColor]];//设置HUD的背景颜色

        [SVProgressHUD showWithStatus:@"正在获取..."];
        self.isNeedShowPicker=YES;
        [self.loginViewModel getDomains];
    }
}
#pragma mark-viewModel
-(UXinLoginViewModel *)loginViewModel
{
    WEAKSELF
  
    if(_loginViewModel==nil){
        _loginViewModel=[[UXinLoginViewModel alloc]initWithSuccessHandle:^(NSInteger type, id value) {
              [SVProgressHUD dismiss];
            if(type==1){
                weakSelf.domains=(NSMutableArray *)value;
                if(weakSelf.isNeedShowPicker){
                [weakSelf showDomainPicker];
                }
                
            }else if(type==2){
                NSMutableArray *TempUsers=(NSMutableArray *)value;
                weakSelf.users=TempUsers;
                if(TempUsers.count>1){
                    [weakSelf showUsers];
                }else if(TempUsers.count==1){
                   
//                    [weakSelf.loginViewModel login:<#(NSString *)#> parameters:<#(NSDictionary *)#>]
                }else{
                    
                }
                
            }else if (type==3){
                
            }
        } failedHandle:^(NSInteger type, id value) {
            if(type==1){
                
            }else if (type==2){
                
            }else if (type==3){
                
            }else{
                
            }
        }];
    }
    return _loginViewModel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
