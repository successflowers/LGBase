//
//  BaseModel.m
//  XiuXiuTuanGou
//
//  Created by 张敬 on 2018/8/9.
//  Copyright © 2018年 XiuXiuTuanGou. All rights reserved.
//

#import "BaseModel.h"
#import "YYKit.h"

@implementation BaseModel

//重写以下几个方法
- (void)encodeWithCoder:(NSCoder*)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone*)zone {
    return [self modelCopy];
}

- (NSUInteger)hash {
    return [self modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}

@end
