//
//  WMGResultSet.m
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
    

#import "WMGResultSet.h"
#import "WMGraverMacroDefine.h"

@interface WMGResultSet ()
@property (nonatomic, strong, readwrite) NSMutableArray <NSMutableArray <WMGBusinessModel *> *> *items;
@end

@implementation WMGResultSet

- (id)init{
    self = [super init];
    
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)reset{
    _hasMore = NO;
    _pageSize = 0;
    _currentPage = 0;
    [_items removeAllObjects];
}

- (void)addItem:(id)item{
    if (item) {
        [_items addObject:item];
    }
}

- (void)addItems:(NSArray *)items{
    if (!IsArrEmpty(items)) {
        [_items addObjectsFromArray:items];
    }
}

- (void)deleteItem:(id)item{
    if (item) {
        [_items removeObject:item];
    }
}

@end
