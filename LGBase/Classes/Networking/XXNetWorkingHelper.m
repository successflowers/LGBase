//
//  ZJNetWorkingHelper.m
//  CP-Fitness
//
//  Created by 张敬 on 2017/11/17.
//  Copyright © 2017年 Jing Zhang. All rights reserved.
//

#import "XXNetWorkingHelper.h"
#import "NSString+Signature.h"
#import "NSString+TimeConvert.h"
#import "AFURLSessionManager.h"
#import "AFHTTPSessionManager.h"


@implementation XXNetWorkingHelper

+ (AFHTTPSessionManager *)sharedSessionManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10.0;
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
        /*
        [manager.requestSerializer setValue:@"123" forHTTPHeaderField:@"x-access-id"];
        [manager.requestSerializer setValue:@"123" forHTTPHeaderField:@"x-signature"];
         */
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",nil];
    });
    return manager;
}

+ (void)postJsonWithUrl:(NSString *)urlStr
              parameter:(NSDictionary *)parameters
                success:(void (^)(NSDictionary*responseObject))success
                   fail:(void(^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [XXNetWorkingHelper sharedSessionManager];
    //新增新的加密
    
    //获取时间戳
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString * timeString = [NSString stringWithFormat:@"%ld",(long)time];
    //添加t对应时间戳
    NSMutableDictionary * newParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [newParameter setObject:timeString forKey:@"t"];
    
    //排序key，根据排序后的key 获取value 进行拼接
    NSArray * keyArray = [newParameter allKeys];
    NSArray * afterKeyArray;
    if (keyArray.count > 0) {
        afterKeyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
    }else {
        afterKeyArray = [NSArray array];
    }
    NSString * sign = @"";
    for (NSString *key in afterKeyArray) {
        if ([newParameter[key] isKindOfClass:[NSNumber class]]) {
            NSInteger number = [newParameter[key] integerValue];
            sign = [sign stringByAppendingString:[NSString stringWithFormat:@"%ld",number]];
        }else {
            sign = [sign stringByAppendingString:newParameter[key]];
        }
    }
    sign = [sign stringByAppendingString:timeString];
    sign = [sign stringByAppendingString:XXTG_Client_Request_Secret];
    NSString * lastSign = [NSString MD5ForLower32Bate:sign];
    [manager.requestSerializer setValue:lastSign forHTTPHeaderField:@"sign"];
    [manager.requestSerializer setValue:@"148" forHTTPHeaderField:@"appid"];
    
    
    
    [manager POST:urlStr parameters:newParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(resultDic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            fail(error);
        }
    }];
}

+ (void)getJsonWithUrl:(NSString *)urlStr
             parameter:(NSDictionary *)parameters
               success:(void (^)(NSDictionary*responseObject))success
                  fail:(void(^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [XXNetWorkingHelper sharedSessionManager];
    
    //新增新的加密
    
    //获取时间戳
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString * timeString = [NSString stringWithFormat:@"%ld",(long)time];
    
    //添加t对应时间戳
    NSMutableDictionary * newParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [newParameter setObject:timeString forKey:@"t"];
    
    //排序key，根据排序后的key 获取value 进行拼接
    NSArray * keyArray = [newParameter allKeys];
    NSArray * afterKeyArray;
    if (keyArray.count > 0) {
        afterKeyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
    }else {
        afterKeyArray = [NSArray array];
    }
    NSString * sign = @"";
    for (NSString *key in afterKeyArray) {
        if ([newParameter[key] isKindOfClass:[NSNumber class]]) {
            NSInteger number = [newParameter[key] integerValue];
            sign = [sign stringByAppendingString:[NSString stringWithFormat:@"%ld",number]];
        }else {
            sign = [sign stringByAppendingString:newParameter[key]];
        }
    }
    sign = [sign stringByAppendingString:timeString];
    sign = [sign stringByAppendingString:XXTG_Client_Request_Secret];
    NSString * lastSign = [NSString MD5ForLower32Bate:sign];
    [manager.requestSerializer setValue:lastSign forHTTPHeaderField:@"sign"];
    [manager.requestSerializer setValue:@"148" forHTTPHeaderField:@"appid"];
    
    [manager GET:urlStr parameters:newParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            //id dataSet = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(resultDic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            fail(error);
        }
    }];
}


@end
