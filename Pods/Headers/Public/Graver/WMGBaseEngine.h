//
//  WMGBaseEngine.h
//  Graver-Meituan-Waimai
//
//  Created by yangyang
//
//  Copyright © 2018-present, Beijing Sankuai Online Technology Co.,Ltd (Meituan).  All rights reserved.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
    

#import <Foundation/Foundation.h>

@class WMGResultSet;
@class WMGBusinessModel;

typedef void (^WMGEngineLoadCompletion)(WMGResultSet *resultSet, NSError *error);

typedef NS_ENUM(NSUInteger, WMGEngineLoadState) {
    WMGEngineLoadStateUnload, //未载入状态
    WMGEngineLoadStateLoading, //网络载入中
    WMGEngineLoadStateLoaded, //网络载入完成
};

NS_ASSUME_NONNULL_BEGIN

/*
 整体负责
 1.数据存储 Insert Delete Update Select操作
 2.网络请求、数据解析
 */
@interface WMGBaseEngine : NSObject{
    WMGResultSet *_resultSet;
    WMGEngineLoadState _loadState;
}

// 结果集，业务列表数据、是否有下一页、当前处于第几页的封装，适用于流式列表结构
@property (nonatomic, strong, readonly, nullable) WMGResultSet *resultSet;

// 载入状态，用于标识当前网络请求的载入状态
@property (nonatomic, assign, readonly) WMGEngineLoadState loadState;

/**
 * reload请求
 *
 * @param params 网络请求参数
 * @param completion 请求完成的回调block,该block返回(WMGResultSet *resultSet, NSError *error)
 *
 */
- (void)reloadDataWithParams:(nullable NSDictionary *)params completion:(nullable WMGEngineLoadCompletion)completion;

/**
 * loadmore请求
 *
 * @param params 网络请求参数
 * @param completion 请求完成的回调block,该block返回(WMGResultSet *resultSet, NSError *error)
 *
 */
- (void)loadMoreDataWithParams:(nullable NSDictionary *)params completion:(nullable WMGEngineLoadCompletion)completion;

/**
 * insert请求
 *
 * @param params 网络请求参数
 * @param completion 请求完成的回调block,该block返回(WMGResultSet *resultSet, NSError *error)
 *
 */
- (void)insertDataWithParams:(nullable NSDictionary *)params withIndex:(NSUInteger)insertIndex completion:(nullable WMGEngineLoadCompletion)completion;
@end

// 对数据的增删改查
@interface WMGBaseEngine (DataOperation)

/**
 * 添加一条数据
 *
 * @param item WMGBusinessModel *类型，标识一条业务数据
 *
 */
- (void)addItem:(WMGBusinessModel *)item;

/**
 * 插入一条数据
 *
 * @param item WMGBusinessModel *类型，标识一条业务数据
 * @param index 插入位置
 *
 */
- (void)insertItem:(WMGBusinessModel *)item atIndex:(NSUInteger)index;

/**
 * 删除一条数据
 *
 * @param item WMGBusinessModel *类型，标识一条业务数据
 *
 */
- (void)deleteItem:(WMGBusinessModel *)item;

/**
 * 删除所有业务数据
 *
 */
- (void)deleteAllItems;

@end

NS_ASSUME_NONNULL_END
