//
//  WMPoiCellData.m
//  WMHomelist
//
//  Created by yan on 2018/11/15.
//  Copyright © 2018年 yan. All rights reserved.
//

#import "WMPoiListCellData.h"

@interface WMPoiListCellData ()

@property (nonatomic, strong, readwrite) NSMutableArray *mutableAttributedTexts;

@end

@implementation WMPoiListCellData

- (instancetype)init {
    if (self = [super init]) {
        _logoObj = [[WMGVisionObject alloc] init];
        _logoIconObj = [[WMGVisionObject alloc] init];
        _nameObj = [[WMGVisionObject alloc] init];
        _reservationObj = [[WMGVisionObject alloc] init];
        _productObj = [[WMGVisionObject alloc] init];
        _deliverObj = [[WMGVisionObject alloc] init];
        _markObj = [[WMGVisionObject alloc] init];
        _arrowObj = [[WMGVisionObject alloc] init];
        _mutableTagObj = [[WMGVisionObject alloc] init];
    
        [self.mutableAttributedTexts addObjectsFromArray:@[_logoObj,_logoIconObj,_nameObj,_reservationObj,_productObj,_deliverObj,_markObj,_arrowObj,_mutableTagObj]];
    }
    return self;
}

#pragma mark -setter & getter
- (NSMutableArray *)mutableAttributedTexts {
    if (!_mutableAttributedTexts) {
        _mutableAttributedTexts = [NSMutableArray array];
    }
    return _mutableAttributedTexts;
}


@end
