//
//  WMGClientData.h
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

@class WMGBaseCellData;

NS_ASSUME_NONNULL_BEGIN

/*
 客户端可处理的业务数据封装协议
 通过该协议建立业务数据和排版UI数据之间的联系
 依托数据流刷新依赖该协议
*/
@protocol WMGClientData <NSObject>

// 网络返回的业务数据对应的排版数据
@property (nonatomic, strong, nullable) WMGBaseCellData *cellData;

/**
 * 该方法由业务模型数据来实现
 * 一般情况下，该方法由WMGBusinessModel来实现，实现方式如下：
 *   - (void)setNeedsUpdateUIData
 *   {
 *      self.cellData = nil;
 *   }
 *
 * 如果业务中已有网络业务数据父类，直接遵从该协议即可，同时在.m实现中添加上述代码实现
 * 该协议设计借鉴了系统UI更新的策略、机制，同时和RN单向数据流思想相结合
 *
 * 当发生业务数据变化时，响应的排版数据即失效，我们需要以此方式清除，而生成新的对应排版模型是在随后的刷新才会触发的。
 *
 */
- (void)setNeedsUpdateUIData;
@end

NS_ASSUME_NONNULL_END
