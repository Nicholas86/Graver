//
//  WMPoiListViewModel.m
//  WMHomelist
//
//  Created by yan on 2018/11/15.
//  Copyright © 2018年 yan. All rights reserved.
//

#import "WMPoiListViewModel.h"
#import <UIImage+Graver.h>
#import <NSAttributedString+GCalculateAndDraw.h>
#import "WMPoiListModel.h"
#import "WMPoiListCellData.h"

@implementation WMPoiListViewModel

- (WMGBaseCellData *)refreshCellDataWithMetaData:(WMPoiListModel *)poi
{
    WMPoiListCellData *cellData = [[WMPoiListCellData alloc] init];
    cellData.cellWidth = [UIScreen mainScreen].bounds.size.width;
    cellData.showAllTag = poi.showAlltag;
    
    // 游标设置
    CGFloat spaceXStart = 0;
    CGFloat spaceYStart = 0;
    CGFloat marginH = 16;
    CGFloat marginV = 5;
    CGFloat spaceXEnd = cellData.cellWidth - marginH;
    
    spaceXStart = marginH;
    spaceYStart = marginV;
    
    // 商家图片
    WMPoiListAttributedImage *logo = [[WMPoiListAttributedImage alloc] initWithText:nil];
    [logo appendImageWithUrl:poi.restaurantImg size:CGSizeMake(80, 60)];
    
    CGSize size = [logo.resultString wmg_size];
    cellData.logoObj.frame = CGRectMake(spaceXStart, spaceYStart, size.width, size.height);
    cellData.logoObj.value = logo.resultString;
    
    spaceXStart += cellData.logoObj.frame.size.width;
    
    // 商家图片右上角 icon
    WMPoiListAttributedImage *logoIcon = [[WMPoiListAttributedImage alloc] initWithText:nil];
    [logoIcon appendImageWithUrl:poi.restaurantIcon size:CGSizeMake(26, 14)];
    
    size = [logoIcon.resultString wmg_size];
    cellData.logoIconObj.frame = CGRectMake(spaceXStart - size.width, spaceYStart - 1, size.width, size.height);
    cellData.logoIconObj.value = logoIcon.resultString;
    spaceXStart += 8;
    
    // 商家名称
    WMMutableAttributedItem *name = [WMMutableAttributedItem itemWithText:poi.name];
    [name setFont:[UIFont systemFontOfSize:16]];
    [name setColor:WMGHEXCOLOR(0x33312D)];
    
    size = [name.resultString wmg_sizeConstrainedToWidth:(spaceXEnd - spaceXStart) numberOfLines:1];
    cellData.nameObj.frame = CGRectMake(spaceXStart, spaceYStart, size.width, size.height);
    cellData.nameObj.value = name.resultString;
    spaceYStart += size.height;
    
    // 仅预定
    WMPoiListAttributedImage *reservationLine = [[WMPoiListAttributedImage alloc] initWithText:nil];
    if (poi.reservationStatus == WMPoiReservationOnly) {
        if (!IsStrEmpty(poi.statusContent) && !IsStrEmpty(poi.descContent)) {
            WMPoiListAttributedImage *status = [[WMPoiListAttributedImage alloc] initWithText:poi.statusContent];
            [status setColor:WMGHEXCOLOR(0xffffff)];
            [status setFont:[UIFont systemFontOfSize:11]];
            CGSize statusSize = [status.resultString wmg_size];
            UIImage *contentImage = [[UIImage wmg_imageWithColor:WMGHEXCOLOR(0xFFA735) size:CGSizeMake(statusSize.width + 8, statusSize.height+1)] wmg_roundedImageWithCornerRadius:2 cornerType:UIRectCornerTopLeft | UIRectCornerBottomLeft];
            contentImage =[contentImage wmg_drawItem:status numberOfLines:1 atPosition:CGPointMake(4, 1)];
            [reservationLine appendImageWithImage:contentImage];
            
            WMPoiListAttributedImage *descContent = [[WMPoiListAttributedImage alloc] initWithText:poi.descContent];
            [status setColor:WMGHEXCOLOR(0xFFA735)];
            [status setFont:[UIFont systemFontOfSize:11]];
            CGSize descContentSize = [descContent.resultString wmg_size];
            UIImage *descImage = [UIImage wmg_imageWithColor:[UIColor clearColor] size:CGSizeMake(descContentSize.width + 8, descContentSize.height) borderWidth:1 borderColor:WMGHEXCOLOR(0xFFA735) borderRadius:WMGCornerRadiusMake(0, 2, 0, 2)];
            descImage = [descImage wmg_drawItem:descContent atPosition:CGPointMake(4, 0)];
            [reservationLine appendImageWithImage:descImage];
            
            size = [reservationLine.resultString wmg_sizeConstrainedToWidth:(spaceXEnd - spaceXStart) numberOfLines:1];
            cellData.reservationObj.frame = CGRectMake(spaceXStart, spaceYStart, size.width, size.height);
            cellData.reservationObj.value = reservationLine.resultString;
            
            spaceYStart += size.height;
        }
    }
    
    // 星星行
    WMMutableAttributedItem *productLine = [WMMutableAttributedItem itemWithText:nil];
    
    // 评分
    UIColor *starColor = WMGHEXCOLOR(0xffa100);
    NSString *imageName = @"icon_star";
    if (poi.star == 0.f) {
        starColor = WMGHEXCOLOR(0x666460);
        imageName = @"icon_star_gray";
    }
    WMMutableAttributedItem *score = [WMMutableAttributedItem itemWithText:[NSString stringWithFormat:@"%.1f",poi.star]];
    [score setColor:starColor];
    [score setFont:[UIFont systemFontOfSize:11]];
    
    [productLine appendImageWithName:imageName size:CGSizeMake(10, 9.5)];
    [productLine appendAttributedItem:score];
    
    // 月售
    if (!IsStrEmpty(poi.monthSalesTip)) {
        WMMutableAttributedItem *monthSale = [WMMutableAttributedItem itemWithText:poi.monthSalesTip];
        [monthSale setFont:[UIFont systemFontOfSize:11]];
        [monthSale setColor:WMGHEXCOLOR(0x6E7278)];
        [productLine appendWhiteSpaceWithWidth:8];
        [productLine appendAttributedItem:monthSale];
    }
    
    WMMutableAttributedItem *deliverText = [WMMutableAttributedItem itemWithText:nil];
    if (!IsStrEmpty(poi.deliveryTime)) {
        // 配送时间
        WMMutableAttributedItem *deliveryTime = [WMMutableAttributedItem itemWithText:poi.deliveryTime];
        [deliveryTime setFont:[UIFont systemFontOfSize:11]];
        [deliveryTime setColor:WMGHEXCOLOR(0x6E7278)];
        [deliverText appendAttributedItem:deliveryTime];
    }
    if (!IsStrEmpty(poi.distance)) {
        // 配送距离
        WMMutableAttributedItem *distance = [WMMutableAttributedItem itemWithText:poi.distance];
        [distance setFont:[UIFont systemFontOfSize:11]];
        [distance setColor:WMGHEXCOLOR(0x6E7278)];
        
        if (!IsStrEmpty(poi.deliveryTime)) {
            [deliverText appendWhiteSpaceWithWidth:8];
        }
        [deliverText appendAttributedItem:distance];
    }
    CGSize deliverSize = [deliverText.resultString wmg_size];
    CGSize productSize = [productLine.resultString wmg_size];
    if (deliverText) {
        [productLine appendWhiteSpaceWithWidth:(spaceXEnd - spaceXStart) - deliverSize.width - productSize.width - 2];
        [productLine appendAttributedItem:deliverText];
    }
    
    size = [productLine.resultString wmg_sizeConstrainedToWidth:(spaceXEnd - spaceXStart) numberOfLines:1];
    cellData.productObj.frame = CGRectMake(spaceXStart, spaceYStart, spaceXEnd - spaceXStart, size.height);
    cellData.productObj.value = productLine.resultString;
    spaceYStart += size.height;
    
    // 配送行
    WMMutableAttributedItem *deliverLine = [WMMutableAttributedItem itemWithText:nil];
    
    if (!IsStrEmpty(poi.minPriceTip)) {
        WMMutableAttributedItem *minText = [WMMutableAttributedItem itemWithText:poi.minPriceTip];
        [minText setFont:[UIFont systemFontOfSize:11]];
        [minText setColor:WMGHEXCOLOR(0x6E7278)];
        [deliverLine appendAttributedItem:minText];
    }
    if (!IsStrEmpty(poi.shippingFeeTip)) {
        WMMutableAttributedItem *shippingFeeTip = [WMMutableAttributedItem itemWithText:poi.shippingFeeTip];
        [shippingFeeTip setFont:[UIFont systemFontOfSize:11]];
        [shippingFeeTip setColor:WMGHEXCOLOR(0x6E7278)];
        if (!IsStrEmpty(poi.minPriceTip)) {
            [deliverLine appendWhiteSpaceWithWidth:8];
        }
        [deliverLine appendAttributedItem:shippingFeeTip];
    }
    if (!IsStrEmpty(poi.originShippingFeeTip)) {
        WMMutableAttributedItem *originShippingFeeTip = [WMMutableAttributedItem itemWithText:poi.originShippingFeeTip];
        [originShippingFeeTip setFont:[UIFont systemFontOfSize:11]];
        [originShippingFeeTip setColor:WMGHEXCOLOR(0x6E7278)];
        [originShippingFeeTip setStrikeThroughStyle:WMGTextStrikeThroughStyleSingle];
        if (!IsStrEmpty(poi.shippingFeeTip)) {
            [deliverLine appendWhiteSpaceWithWidth:4];
            [deliverLine appendAttributedItem:originShippingFeeTip];
        }
    }
    if (!IsStrEmpty(poi.averagePriceTip)) {
        WMMutableAttributedItem *averagePriceTip = [WMMutableAttributedItem itemWithText:poi.averagePriceTip];
        [averagePriceTip setFont:[UIFont systemFontOfSize:11]];
        [averagePriceTip setColor:WMGHEXCOLOR(0x6E7278)];
        if (!IsStrEmpty(poi.minPriceTip) || !IsStrEmpty(poi.shippingFeeTip)) {
            [deliverLine appendWhiteSpaceWithWidth:8];
        }
        [deliverLine appendAttributedItem:averagePriceTip];
    }
    WMPoiListAttributedImage *deliverIcon = [[WMPoiListAttributedImage alloc] initWithText:nil];
    [deliverIcon appendImageWithName:@"icon_delivery" size:CGSizeMake(48, 14)];
    CGSize deliverIconSize = [deliverIcon.resultString wmg_size];
    CGSize deliverLineSize = [deliverLine.resultString wmg_size];
    [deliverLine appendWhiteSpaceWithWidth:spaceXEnd - spaceXStart - deliverIconSize.width - deliverLineSize.width - 2];
    [deliverLine appendAttributedItem:deliverIcon];
    
    size = [deliverLine.resultString wmg_sizeConstrainedToWidth:(spaceXEnd - spaceXStart) numberOfLines:1];
    cellData.deliverObj.frame = CGRectMake(spaceXStart, spaceYStart, spaceXEnd - spaceXStart, size.height);
    cellData.deliverObj.value = deliverLine.resultString;
    
    spaceYStart += size.height;
    
    if (!IsStrEmpty(poi.thirdCategory)) {
        WMMutableAttributedItem * thirdCategory = [WMMutableAttributedItem itemWithText:nil];
        [thirdCategory appendText:poi.thirdCategory];
        [thirdCategory setFont:[UIFont systemFontOfSize:11]];
        [thirdCategory setColor:WMGHEXCOLOR(0x666460)];
        [thirdCategory appendImageWithName:@"icon_category" size:CGSizeMake(12, 12)];
        
        size = [thirdCategory.resultString wmg_sizeConstrainedToWidth:(spaceXEnd - spaceXStart) numberOfLines:1];
        cellData.markObj.frame = CGRectMake(spaceXStart, spaceYStart, size.width, size.height);
        cellData.markObj.value = thirdCategory.resultString;
        spaceYStart += size.height;
    }
    
    // 标签
    CGFloat tagMaxWidth = spaceXEnd - spaceXStart - 30;
    WMPoiListAttributedImage *tags = [[WMPoiListAttributedImage alloc] initWithText:nil];
    
    for (WMPoiLabelInfo *obj in poi.labelInfoArray) {
        WMMutableAttributedItem *str = [WMMutableAttributedItem itemWithText:obj.content];
        [str setColor:WMGHEXCOLOR(strtoul(obj.contentColor.UTF8String,0,0))];
        [str setFont:[UIFont systemFontOfSize:11]];
        CGSize size = [str.resultString wmg_sizeConstrainedToWidth:tagMaxWidth numberOfLines:1];
        UIImage *tagImage = [UIImage wmg_imageWithColor:[UIColor clearColor] size:CGSizeMake(size.width + 6, 16) borderWidth:1 borderColor:WMGHEXCOLOR(strtoul(obj.labelFrameColor.UTF8String,0,0)) borderRadius:WMGCornerRadiusMake(0, 2, 0, 2)];
        tagImage = [tagImage wmg_drawItem:str atPosition:CGPointMake(3, 0)];
        [tags appendImageWithImage:tagImage];
    }
    WMGTextParagraphStyle *style = [WMGTextParagraphStyle defaultParagraphStyle];
    [style setLineSpacing:6];
    [tags setTextParagraphStyle:style fontSize:11];
    
    CGSize allSize = [tags.resultString wmg_sizeConstrainedToWidth:tagMaxWidth numberOfLines:0];
    CGSize onelineSize = [tags.resultString wmg_sizeConstrainedToWidth:tagMaxWidth numberOfLines:1];
    if (allSize.height > onelineSize.height) {
        cellData.canShowAllTag = YES;
        // 下拉箭头
        WMPoiListAttributedImage *arrow = [[WMPoiListAttributedImage alloc] initWithText:nil];
        NSString *imageName = cellData.showAllTag ? @"icon_up" : @"icon_down";
        [arrow appendImageWithName:imageName size:CGSizeMake(7.5, 7.5)];
        size = [arrow.resultString wmg_size];
        cellData.arrowObj.value = arrow.resultString;
        cellData.arrowObj.frame = CGRectMake(spaceXEnd - size.width, spaceYStart- 5, size.width, size.height);
    }
    size = cellData.showAllTag ? allSize : onelineSize;
    cellData.mutableTagObj.value = tags.resultString;
    cellData.mutableTagObj.frame = CGRectMake(spaceXStart, spaceYStart, size.width, size.height);
    spaceYStart += size.height;
    
    cellData.cellHeight = spaceYStart + marginV + 10;
    return cellData;
}

@end
