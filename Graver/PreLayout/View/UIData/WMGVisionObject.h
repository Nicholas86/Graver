//
//  WMGVisionObject.h
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
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN
/*
 视觉元素的抽象, 在Graver框架中，对所有视觉元素进行抽象，即每个视觉元素都由其位置、大小、内容唯一决定
 */
@interface WMGVisionObject : NSObject

// 视觉元素的位置、大小
@property (nonatomic, assign) CGRect frame;

// 视觉元素的展示内容，多数情况下，value即是WMMutableAttributedItem
@property (nonatomic, strong, nullable) id value;
@end

NS_ASSUME_NONNULL_END
