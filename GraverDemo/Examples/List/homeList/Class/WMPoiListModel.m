//
//  WMPoiModel.m
//  WMHomelist
//
//  Created by yan on 2018/11/14.
//  Copyright © 2018年 yan. All rights reserved.
//

#import "WMPoiListModel.h"

@implementation WMPoiLabelInfo

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation WMPoiListModel


+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    WMPoiListModel *model = [[WMPoiListModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"labelInfoArray"]) {
        NSArray *labels = (NSArray *)value;
        NSMutableArray *labelArr = [NSMutableArray  array];
        [labels enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WMPoiLabelInfo *labelInfo = [[WMPoiLabelInfo alloc] init];
            [labelInfo setValuesForKeysWithDictionary:obj];
            [labelArr addObject:labelInfo];
        }];
        [super setValue:labelArr.copy forKey:key];
    }else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
