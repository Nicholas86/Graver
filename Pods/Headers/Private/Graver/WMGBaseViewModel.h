//
//  WMGBaseViewModel.h
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
#import "WMGBaseEngine.h"
#import "WMGResultSet.h"
#import "WMGBaseCellData.h"
#import "WMGBusinessModel.h"

typedef void(^WMGPrelayoutCompletionBlock)(NSArray <WMGBaseCellData *> *cellLayouts, NSError *error);
typedef void(^WMGSafeInvokeBlock)(void);

/*
 列表状态
 -----------------------------------------------------
 | .unload | .loading |               loaded         |
 |         |          |       —————————————————————— |
 |         |          |          ↓              ↓    |
 |         |          |      Successed       .Failed |
 |         |          | ————————————————————         |
 |         |          |     ↓          ↓             |
 |         |          | .HasList  .EmptyList         |
 -----------------------------------------------------
 */
typedef NS_ENUM (NSUInteger, WMGListState)
{
    WMGListStateUnLoad             = 1<<0,// initilize
    WMGListStateLoading            = 1<<1,// 菊花转
    WMGListStateHasList            = 1<<2,// list数据
    WMGListStateEmptyList          = 1<<3,// 空列表
    WMGListStateFailed             = 1<<4,// 重新加载
    
    WMGListStateSuccessed          = (WMGListStateHasList | WMGListStateEmptyList),
    WMGListStateLoaded             = (WMGListStateSuccessed | WMGListStateFailed),
};

NS_ASSUME_NONNULL_BEGIN

@interface WMGBaseViewModel : NSObject{
@protected
    NSMutableArray <WMGBaseCellData *> *_arrayLayouts;
    
    WMGListState _listState;
    
    WMGBaseEngine *_engine;
}
// 预排版结果，该数组内装的对象均为排版结果
// 对于该数组的增删改查务必要使用WMGBaseViewModel (Operation)中的方式由业务数据驱动
// 排版模型和业务模型的关联关系如下图所示:
//
//  |-------------|  ---weak---->   |---------------|
//  | LayoutModel |                 | BusinessModel |
//  |-------------|  <——strong——    |---------------|
//
@property (nonatomic, strong, readonly) NSMutableArray <WMGBaseCellData *> *arrayLayouts;

// 网络请求返回的错误
@property (nonatomic, strong, readonly) NSError *error;

// 当前列表状态，详见WMGListState说明
@property (nonatomic, assign) WMGListState listState;

// 松耦合方式连接engine和viewModel，通过桥接模式实现
@property (nonatomic, strong) WMGBaseEngine *engine;

/**
 * 同步刷新方法，该方法会根据BaseModel的list刷新出最新的UI数据
 * 该方法是线程安全的
 *
 * @param resultSet 网络返回结果的一层包装
 *
 */
- (void)refreshModelWithResultSet:(WMGResultSet *)resultSet;

/**
 * 异步刷新方法，该方法会根据BaseModel的list刷新出最新的UI数据
 * 异步刷新完成的回调block,该block返回刷新完成的UI数据和Error.
 * 该方法是线程安全的
 *
 * @param resultSet 网络返回结果的一层包装
 * @param completion 结果以block方式回调, block回调两个参数即是该类的两个只读变量arrayLayouts和error
 */
- (void)asyncRefreshModelWithResultSet:(WMGResultSet *)resultSet completion:(WMGPrelayoutCompletionBlock)completion;

/**
 * UI数据生成的单元方法，该方法会根据业务数据模型刷新出其对应的UI数据
 * 一般情况下，我们需要通过子类集成的方式覆写该方法实现
 * 注意：该方法会在多线程环境调用，注意保证线程安全
 *
 * @param item 一条业务数据，这里的WMGBusinessModel是网络数据模型的一个抽象类,可根据业务实际进行改造.
 *
 * @return WMGBaseCellData 列表场景下的抽象UI数据，亦即排版模型
 */

- (WMGBaseCellData *)refreshCellDataWithMetaData:(WMGBusinessModel *)item;

@end

// 增删改查 实际上是对Engine的对应封装,区别在于由ViewModel操控线程安全
@interface WMGBaseViewModel (Operation)
/**
 * 插入一个item到指定的index位置
 * 当插入一条业务数据的时候，会在下次刷新排版的时机自动调取单条刷新方法生成对应的UI排版模型
 * 该方法是线程安全的
 *
 * @param item 待插入的一项业务数据
 * @param index 要插入的位置
 *
 */
- (void)insertItem:(WMGBusinessModel *)item atIndex:(NSUInteger)index;

/**
 * 删除一项业务数据、及其对应的UI排版数据
 *
 * 该方法是线程安全的
 *
 * @param item 一个客户端定义的业务数据项
 *
 */
- (void)deleteItem:(WMGBusinessModel *)item;

/**
 * 将指定位置的数据替换为新的数据
 * 该方法是线程安全的
 *
 * @param index 替换位置
 * @param item 一个客户端定义的业务数据项
 *
 */
- (void)replaceItemAtIndex:(NSUInteger)index withItem:(WMGBusinessModel *)item;

/**
 * 移除所有业务数据，包含其对应的所有UI排版模型数据
 * 该方法是线程安全的
 *
 */
- (void)removeAllItems;
@end

//网络请求 同样是对engine层面同名方法的封装
@interface WMGBaseViewModel (NetworkRequest)
/**
 * 根据指定参数对业务数据进行重载
 * 我们把网络请求、磁盘等本地数据读取均定义到数据层。
 * 按此逻辑，该重载方法多数场景下代表着网络请求，当然也会包含读取本地磁盘等形式的数据
 *
 * @param params 请求参数
 * @param completion 请求完成的回调,当实质性的数据重载请求完成之后，预排版内部会根据业务数据进行UI排版操作
 *
 */
- (void)reloadDataWithParams:(NSDictionary *)params completion:(WMGPrelayoutCompletionBlock)completion;

/**
 * 根据指定参数对业务数据进行增量加载，即我们常说的后项刷新
 * 我们把网络请求、磁盘等本地数据读取均定义到数据层。
 * 按此逻辑，该重载方法多数场景下代表着网络请求，当然也会包含读取本地磁盘等形式的数据
 * 请求完成的block回调arrayLayouts，即排版数据, 是当前整体业务数据List的排版结果
 * 注意，不仅仅是本次loadmore回来的数据，但是上次或者原有的业务数据并不会进行重新排版
 *
 * @param params 请求参数
 * @param completion 请求完成的回调,当实质性的数据重载请求完成之后，预排版内部会根据新增业务数据进行UI排版操作
 * 
 */
- (void)loadMoreDataWithParams:(NSDictionary *)params completion:(WMGPrelayoutCompletionBlock)completion;

/**
 * 将本地逻辑产生的一条数据插入到整体业务数据池中
 *
 * @param params 请求参数
 * @param index 插入位置
 * @param completion 请求完成的回调
 *
 */
- (void)insertDataWithParams:(NSDictionary *)params withIndex:(NSUInteger)index completion:(WMGPrelayoutCompletionBlock)completion;
@end

//安全调用
@interface WMGBaseViewModel (SafeInvoke)
/**
 * 同步安全调用
 * 该类其他方法均已线程安全，禁止再该block里面再调用同类的其他方法
 *
 * @param block  : 对engine中的一切数据操作都放到这个block里面执行。
 *
 */
- (void)safe_invoke:(WMGSafeInvokeBlock)block;

/**
 * 异步安全调用
 *
 * @param block  :对engine中的一切数据操作都放到这个block里面执行。
 *
 */
- (void)async_safe_invoke:(WMGSafeInvokeBlock)block;
@end

NS_ASSUME_NONNULL_END
