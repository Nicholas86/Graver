//
//  WMPoiListTextView.h
//  WMCoreText
//
//  Created by yan on 2018/11/26.
//  Copyright © 2018年 sankuai. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <WMGVisionObject.h>
#import <WMGCanvasControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMPoiListTextView : WMGCanvasControl

@property (nonatomic, strong) NSArray<WMGVisionObject *> *drawerDates;

@end

NS_ASSUME_NONNULL_END
