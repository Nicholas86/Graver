//
//  WMGBusinessModel.h
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
#import "WMGClientData.h"

NS_ASSUME_NONNULL_BEGIN
/*
 业务数据模型，标识网络返回的标准数据模型基类
 如果业务中已有业务数据模型基类，可直接遵从<WMGClientData>协议即可，不再需要此类
 */
@interface WMGBusinessModel : NSObject<WMGClientData>

@end

NS_ASSUME_NONNULL_END
