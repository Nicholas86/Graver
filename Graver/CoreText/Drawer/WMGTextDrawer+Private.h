//
//  WMGTextDrawer+Private.h
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
    

#import "WMGTextDrawer.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextDrawer ()
// 绘制原点，一般情况下，经过预排版之后，通过WMGTextDrawer的Frame设置，仅供框架内部使用，请勿直接操作
@property (nonatomic, assign) CGPoint drawOrigin;
@end

NS_ASSUME_NONNULL_END
