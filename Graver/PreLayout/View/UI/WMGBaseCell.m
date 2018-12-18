//
//  WMGBaseCell.m
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
    

#import "WMGBaseCell.h"

@interface WMGBaseCell ()
@property (nonatomic, strong, readwrite) WMGBaseCellData *cellData;
@end

@implementation WMGBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = WMGHEXCOLOR(0xe4e4e4);
        [self.contentView addSubview:_separatorLine];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.accessibilityIdentifier = NSStringFromClass([self class]);
    }
    return self;
}

- (void)setupCellData:(WMGBaseCellData *)cellData{
    _bgView.frame = CGRectMake(0, 0, cellData.cellWidth, cellData.cellHeight);
    _separatorLine.hidden = (cellData.separatorStyle == WMGCellSeparatorLineStyleNone);
    [self.contentView bringSubviewToFront:_separatorLine];
    
    switch (cellData.separatorStyle) {
        case WMGCellSeparatorLineStyleLeftPadding:{
            _separatorLine.frame = CGRectMake(15, cellData.cellHeight - 1/[UIScreen mainScreen].scale, cellData.cellWidth - 15, 1/[UIScreen mainScreen].scale);
        }
            break;
        case WMGCellSeparatorLineStyleRightPadding:{
            _separatorLine.frame = CGRectMake(0, cellData.cellHeight - 1/[UIScreen mainScreen].scale, cellData.cellWidth - 15, 1/[UIScreen mainScreen].scale);
        }
            break;
        case WMGCellSeparatorLineStyleNonePadding:{
            _separatorLine.frame = CGRectMake(0, cellData.cellHeight - 1/[UIScreen mainScreen].scale, cellData.cellWidth, 1/[UIScreen mainScreen].scale);
        }
            break;
            
        default:
            break;
    }
    
    _cellData = cellData;
}

@end
