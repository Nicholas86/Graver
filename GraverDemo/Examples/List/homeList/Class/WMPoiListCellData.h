//
//  WMPoiCellData.h
//  WMHomelist
//
//  Created by yan on 2018/11/15.
//  Copyright © 2018年 yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMPoiListModel.h"
#import <CoreText/CoreText.h>
#import <WMGVisionObject.h>
#import <WMGraverMacroDefine.h>
#import "WMPoiListAttributedImage.h"
#import <WMGBaseCellData.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMPoiListCellData : WMGBaseCellData

@property (nonatomic, assign) BOOL showAllTag;
@property (nonatomic, assign) BOOL canShowAllTag;

@property (nonatomic, strong) WMGVisionObject *logoObj;
@property (nonatomic, strong) WMGVisionObject *logoIconObj;
@property (nonatomic, strong) WMGVisionObject *nameObj;
@property (nonatomic, strong) WMGVisionObject *reservationObj;
@property (nonatomic, strong) WMGVisionObject *productObj;
@property (nonatomic, strong) WMGVisionObject *deliverObj;
@property (nonatomic, strong) WMGVisionObject *markObj;
@property (nonatomic, strong) WMGVisionObject *arrowObj;
@property (nonatomic, strong) WMGVisionObject *mutableTagObj;

@property (nonatomic, strong, readonly) NSMutableArray<WMGVisionObject *> *mutableAttributedTexts;

@end

NS_ASSUME_NONNULL_END
