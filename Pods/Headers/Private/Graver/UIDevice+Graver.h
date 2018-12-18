//
//  UIDevice+Graver.h
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
    

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WMGScreenType)
{
    WMGScreenTypeUndefined   = 0,
    WMGScreenTypeIpadClassic = 1,//iPad 1,2,mini
    WMGScreenTypeIpadRetina  = 2,//iPad 3以上,mini2以上
    WMGScreenTypeIpadPro     = 3,//iPad Pro
    WMGScreenTypeClassic     = 4,//3gs及以下
    WMGScreenTypeRetina      = 5,//4&4s
    WMGScreenTypeRetina4Inch = 6,//5&5s&5c
    WMGScreenTypeIphone6     = 7,//6或者6+放大模式
    WMGScreenTypeIphone6Plus = 8,//6+
    WMGScreenTypeIphoneX     = 9,//iphone X
};

@interface UIDevice (Graver)
/**
 * 判断当前屏幕是否为4英寸Retina屏
 *
 * @return BOOL类型YES or NO.
 */
- (BOOL)wmg_isRetina4Inch;

/**
 * 判断当前屏幕是否为iphone6尺寸屏
 *
 * @return BOOL类型YES or NO.
 */
- (BOOL)wmg_isIPhone6;

/**
 * 判断当前屏幕是否为iphone6Plus尺寸屏
 *
 * @return BOOL类型YES or NO.
 */
- (BOOL)wmg_isIPhone6Plus;

@end

