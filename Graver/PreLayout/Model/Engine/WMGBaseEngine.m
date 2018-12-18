//
//  WMGBaseEngine.m
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
    

#import "WMGBaseEngine.h"
#import "WMGresultSet.h"
#import "WMGBusinessModel.h"

@implementation WMGBaseEngine

- (id)init{
    self = [super init];
    if (self) {
        _resultSet = [[WMGResultSet alloc] init];
        _loadState = WMGEngineLoadStateUnload;
    }
    
    return self;
}

- (void)reloadDataWithParams:(NSDictionary *)params completion:(WMGEngineLoadCompletion)completion{
    // override to subclass
}

- (void)loadMoreDataWithParams:(NSDictionary *)params completion:(WMGEngineLoadCompletion)completion{
    // override to subclass
}

- (void)insertDataWithParams:(NSDictionary *)params withIndex:(NSUInteger)insertIndex completion:(WMGEngineLoadCompletion)completion{
    // override to subclass
}

- (void)addItem:(WMGBusinessModel *)item{
    // 如果抽象程度较高，父类统一处理，否则子类覆盖
}

- (void)insertItem:(WMGBusinessModel *)item atIndex:(NSUInteger)index{
    // 如果抽象程度较高，父类统一处理，否则子类覆盖
}

- (void)deleteItem:(WMGBusinessModel *)item{
    // 如果抽象程度较高，父类统一处理，否则子类覆盖
}

- (void)deleteAllItems{
    // 如果抽象程度较高，父类统一处理，否则子类覆盖
}

@end
