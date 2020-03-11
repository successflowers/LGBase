//
//  ZJNetWorking.m
//  CP-Fitness
//
//  Created by 张敬 on 2017/11/17.
//  Copyright © 2017年 Jing Zhang. All rights reserved.
//

#import "XXNetWorking.h"
#import "XXNetWorkingHelper.h"

static BOOL flag = NO;
static id result = nil;
static NSString *eMsg = nil;

@interface XXNetWorking()

@end

@implementation XXNetWorking

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static XXNetWorking *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark ----- public methods ------
- (void)postResponseDataWithUrl:(NSString *)urlStr parameter:(NSDictionary*) parameters callBack:(BusinessOperationCallback)callBack
{
    flag = NO;result = nil;eMsg = nil;
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString * app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary * newParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [newParameter setObject:@"ios" forKey:@"source"];
    [newParameter setObject:app_Version forKey:@"version"];
    if ([kUserDefaults valueForKey:kUserToken]) {
        [newParameter setObject:[kUserDefaults valueForKey:kUserToken]  forKey:@"token"];
    }
    //添加手机机型和系统版本号 公用参数
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString * phoneModel = [NSString getPhoneModel];
    
    //手机型号
    if (phoneVersion) {
        //系统版本
        [newParameter setObject:phoneVersion forKey:@"deviceSystemVersion"];
    }
    if (phoneModel) {
        [newParameter setObject:phoneModel forKey:@"deviceModel"];
    }
    
    [XXNetWorkingHelper  postJsonWithUrl:urlStr parameter:newParameter
                                   success:^(NSDictionary *responseObject){
                                       
                                       
                                       if (responseObject)
                                       {
                                           if ([responseObject objectForKey:@"code"]) {
                                               long errnoNumber = [[responseObject objectForKey:@"code"] longValue];
                                               if (errnoNumber == 2000 || errnoNumber == 2001){
                                                   //2000成功 ; 2001请求成功，其他逻辑错误
                                                   flag = YES;
                                                   result = responseObject;
                                                   //DDLog(@"success  %@",responseObject);
                                               } else if (errnoNumber == 4001) {
                                                   //4001为token过期/失效
                                                   flag = NO;
                                                   result = nil;
                                                   eMsg = @"登录已失效，请重新登录";
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:kUserTokenOutTimeNotification object:nil userInfo:nil];
                                               }else if (errnoNumber == 1001){
                                                   
                                                   flag = YES;
                                                   result = responseObject;
                                               }else if (errnoNumber == 5001) {
                                                   //登录和注册接口 特殊code
                                                   flag = NO;
                                                   result = responseObject;
                                                   eMsg = responseObject[@"message"] ? responseObject[@"message"]:@"数据获取失败";
                                               }
                                               else{
                                                   flag = NO;
                                                   result = responseObject;
                                                   eMsg = responseObject[@"message"] ? responseObject[@"message"]:@"数据获取失败";
                                               }
                                           }else{
                                               //如果code不存在，可能是之前未约定接口返回数据
                                               flag = YES;
                                               result = responseObject;
                                           }
                                       }else{
                                           flag = NO;
                                           eMsg = @"数据获取失败";
                                           result = nil;
                                           // DDLog(@" @@@@@@@@ %@",[responseObject objectForKey:@"errmsg"]);
                                       }
                                       callBack(flag,result,eMsg);
                                   }
                                      fail:^(NSError *error){
                                          if (error){
                                              eMsg = [NSString stringWithFormat:@"%@",error];
                                               DDLog(@"%@",error);
                                          }
                                          eMsg = @"由于网络问题，请稍后再试~";
                                          callBack(NO,nil,eMsg);
                                      }];
}


- (void)getResponseDataWithUrl:(NSString *)urlStr parameter:(NSDictionary*) parameters callBack:(BusinessOperationCallback)callBack
{
    flag = NO;result = nil;eMsg = nil;
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString * app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary * newParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [newParameter setObject:@"ios" forKey:@"source"];
    [newParameter setObject:app_Version forKey:@"version"];
    if ([kUserDefaults valueForKey:kUserToken]) {
        [newParameter setObject:[kUserDefaults valueForKey:kUserToken]  forKey:@"token"];
    }
    [XXNetWorkingHelper getJsonWithUrl:urlStr parameter:newParameter success:^(NSDictionary *responseObject) {
        if (responseObject)
        {
            if ([responseObject objectForKey:@"code"]) {
                long errnoNumber = [[responseObject objectForKey:@"code"] longValue];
                if (errnoNumber == 2000 || errnoNumber == 2001){
                    //2000成功 ; 2001请求成功，其他逻辑错误
                    flag = YES;
                    result = responseObject;
                    //DDLog(@"success  %@",responseObject);
                } else if (errnoNumber == 4001) {
                    //4001为token过期/失效
                    flag = NO;
                    result = nil;
                    eMsg = @"登录已失效，请重新登录";
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserTokenOutTimeNotification object:nil userInfo:nil];
                }else if (errnoNumber == 1001){
                    flag = YES;
                    result = responseObject;
                }else if (errnoNumber == 5001) {
                    //登录和注册接口 特殊code
                    flag = NO;
                    result = responseObject;
                    eMsg = responseObject[@"message"] ? responseObject[@"message"]:@"数据获取失败";
                }else{
                    flag = NO;
                    result = responseObject;
                    eMsg = responseObject[@"message"] ? responseObject[@"message"]:@"数据获取失败";
                }
            }else{
                //如果code不存在，可能是之前未约定接口返回数据
                flag = YES;
                result = responseObject;
            }
        }else{
            flag = NO;
            eMsg = @"数据获取失败";
            result = nil;
            // DDLog(@" @@@@@@@@ %@",[responseObject objectForKey:@"errmsg"]);
        }
        callBack(flag,result,eMsg);
        
    } fail:^(NSError *error) {
        
        if (error){
            eMsg = [NSString stringWithFormat:@"%@",error];
        }
        eMsg = @"由于网络问题，请稍后再试~";
        callBack(NO,nil,eMsg);
    }];
}




@end
