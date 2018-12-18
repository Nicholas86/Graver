//
//  WMGBaseViewModel.m
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
    

#import "WMGBaseViewModel.h"

@interface WMGBaseViewModel ()
{
    dispatch_queue_t prelayout_queue;
}
@property (nonatomic, strong, readwrite) NSError *error;
- (void)_refreshModelWithResultSet:(WMGResultSet *)resultSet correspondingLayouts:(NSMutableArray *)layouts;
- (void)_handleNetworkResult:(WMGResultSet *)resultSet error:(NSError *)error completion:(WMGPrelayoutCompletionBlock)completion;
- (void)_updateListLoadedState;

@end

@implementation WMGBaseViewModel

- (id)init
{
    self = [super init];
    if (self){
        _error = nil;
        _arrayLayouts = [NSMutableArray array];
        
        _listState = WMGListStateUnLoad;
        
        const char *queue_name = [[NSString stringWithFormat:@"%@_prelayout_queue", [self class]] cStringUsingEncoding:NSUTF8StringEncoding];
        prelayout_queue = dispatch_queue_create(queue_name, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - 数据刷新

- (void)refreshModelWithResultSet:(WMGResultSet *)resultSet
{
    [self safe_invoke:^{
        
        NSMutableArray *layouts = [NSMutableArray array];
        [self _refreshModelWithResultSet:resultSet correspondingLayouts:layouts];
        
        [self.arrayLayouts removeAllObjects];
        if (layouts.count > 0) {
            [self.arrayLayouts addObjectsFromArray:layouts];
        }
    }];
}

- (void)asyncRefreshModelWithResultSet:(WMGResultSet *)resultSet completion:(WMGPrelayoutCompletionBlock)completion
{
    [self async_safe_invoke:^{
        NSMutableArray *layouts = [NSMutableArray array];
        [self _refreshModelWithResultSet:resultSet correspondingLayouts:layouts];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.arrayLayouts removeAllObjects];
            if (layouts.count > 0) {
                [self.arrayLayouts addObjectsFromArray:layouts];
            }
            
            if (completion) {
                completion(self.arrayLayouts, nil);
            }
        });
    }];
}

- (WMGBaseCellData *)refreshCellDataWithMetaData:(WMGBusinessModel *)item
{
    // override to subclass
    WMGBaseCellData *cellData = [[WMGBaseCellData alloc] init];
    return cellData;
}


#pragma mark - 网络请求

- (void)reloadDataWithParams:(NSDictionary *)params completion:(WMGPrelayoutCompletionBlock)completion
{
    _error = nil;
    [self async_safe_invoke:^{
        [self.engine reloadDataWithParams:params completion:^(WMGResultSet *resultSet, NSError *error) {
            self.error = error;
            [self _handleNetworkResult:resultSet error:error completion:completion];
        }];
    }];
}

- (void)loadMoreDataWithParams:(NSDictionary *)params completion:(WMGPrelayoutCompletionBlock)completion
{
    [self async_safe_invoke:^{
        [self.engine loadMoreDataWithParams:params completion:^(WMGResultSet *resultSet, NSError *error) {
            
            [self _handleNetworkResult:resultSet error:error completion:completion];
        }];
    }];
}

- (void)insertDataWithParams:(NSDictionary *)params withIndex:(NSUInteger)insertIndex completion:(WMGPrelayoutCompletionBlock)completion
{
    [self async_safe_invoke:^{
        
        [self.engine insertDataWithParams:params withIndex:insertIndex completion:^(WMGResultSet *resultSet, NSError *error) {
            [self _handleNetworkResult:resultSet error:error completion:completion];
        }];
    }];
}

#pragma mark - 增删改查

- (void)insertItem:(WMGBusinessModel *)item atIndex:(NSUInteger)index
{
    if (![NSThread isMainThread]) {
        assert("must be main thread");
    }
    
    [self safe_invoke:^{
        [self.engine insertItem:item atIndex:index];
        
        NSMutableArray *layouts = [NSMutableArray array];
        [self _refreshModelWithResultSet:self.engine.resultSet correspondingLayouts:layouts];
        
        [self.arrayLayouts removeAllObjects];
        if (layouts.count > 0) {
            [self.arrayLayouts addObjectsFromArray:layouts];
        }
        
        [self _updateListLoadedState];
    }];
}

- (void)deleteItem:(WMGBusinessModel *)item
{
    if (![NSThread isMainThread]) {
        assert("must be main thread");
    }
    
    [self safe_invoke:^{
        [self.engine deleteItem:item];
        
        NSMutableArray *layouts = [NSMutableArray array];
        [self _refreshModelWithResultSet:self.engine.resultSet correspondingLayouts:layouts];
        
        [self.arrayLayouts removeAllObjects];
        if (layouts.count > 0) {
            [self.arrayLayouts addObjectsFromArray:layouts];
        }
        
        [self _updateListLoadedState];
    }];
}

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(WMGBusinessModel *)item
{
    id origin = [[_engine.resultSet items] objectAtIndex:index];
    [self deleteItem:origin];
    [self insertItem:item atIndex:index];
}

- (void)removeAllItems
{
    if (![NSThread isMainThread]) {
        assert("must be main thread");
    }
    
    [self safe_invoke:^{
        [self.engine deleteAllItems];
        
        [self.arrayLayouts removeAllObjects];
        
        [self _updateListLoadedState];
    }];
}

#pragma mark - 安全调用

- (void)safe_invoke:(WMGSafeInvokeBlock)block{
    if (block == NULL) return;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (dispatch_get_current_queue() == prelayout_queue) assert(0);
#pragma clang diagnostic pop
        
        dispatch_sync(prelayout_queue, block);
        }

- (void)async_safe_invoke:(WMGSafeInvokeBlock)block{
    if (block == NULL) return;
    
    dispatch_async(prelayout_queue, block);
}

#pragma mark - Private

- (void)_handleNetworkResult:(WMGResultSet *)resultSet error:(NSError *)error completion:(WMGPrelayoutCompletionBlock)completion
{
    NSMutableArray *layouts = [NSMutableArray array];
    [self _refreshModelWithResultSet:resultSet correspondingLayouts:layouts];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.arrayLayouts removeAllObjects];
        if (layouts.count > 0) {
            [self.arrayLayouts addObjectsFromArray:layouts];
        }
        
        [self safe_invoke:^{
            [self _updateListLoadedState];
        }];
        
        if (completion) {
            completion(self.arrayLayouts, error);
        }
    });
}

- (void)_refreshModelWithResultSet:(WMGResultSet *)resultSet correspondingLayouts:(NSMutableArray *)layouts
{
    for (WMGBusinessModel *item in resultSet.items) {
        
        //生成视图数据
        if (item.cellData == nil) {
            //创建缓存
            WMGBaseCellData *cellData = [self refreshCellDataWithMetaData:item];
            cellData.metaData = item;
            
            item.cellData = cellData;
        }
        
        //入队
        [layouts addObject:item.cellData];
    }
}

- (void)_updateListLoadedState
{
    if (_error)
    {
        if (_arrayLayouts.count > 0) {
            _listState = WMGListStateHasList;
        }else{
            _listState = WMGListStateFailed;
        }
    }
    else
    {
        if (_arrayLayouts.count > 0) {
            _listState = WMGListStateHasList;
        }
        else{
            _listState = WMGListStateEmptyList;
        }
    }
}

@end
