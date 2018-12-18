//
//  DemoOrderListViewModel.m
//  GraverDemo
//
//  Created by jiangwei on 2018/12/5.
//

#import "DemoOrderListViewModel.h"
#import "DemoOrderCellData.h"
#import "UIImage+Graver.h"
#import "DemoOrderModel.h"

@implementation DemoOrderListViewModel

- (WMGBaseCellData *)refreshCellDataWithMetaData:(DemoOrderModel *)item
{
    DemoOrderCellData *cellData = [[DemoOrderCellData alloc] init];
    
    cellData.cellHeight = 215;
    cellData.cellWidth = [UIScreen mainScreen].bounds.size.width-20;
    
    //商家icon
    WMMutableAttributedItem * poiImageAttributedItem = [WMMutableAttributedItem itemWithText:nil];
    WMMutableAttributedItem * imageAttibutedItem = [poiImageAttributedItem appendImageWithUrl:item.poiPic size:CGSizeMake(35, 35)];
    WMGTextAttachment * imageAttachment = imageAttibutedItem.arrayAttachments[0];
    imageAttachment.baselineFontMetrics = WMGFontMetricsMakeWithTargetLineHeight(WMGFontMetricsMakeFromUIFont([UIFont systemFontOfSize:11]), floor(imageAttachment.size.height));
    
    WMGVisionObject * poiImageDrawObject = [[WMGVisionObject alloc] init];
    poiImageDrawObject.frame = CGRectMake(15, 15, 35, 35);
    poiImageDrawObject.value = poiImageAttributedItem.resultString;
    
    [cellData.textDrawerDatas addObject:poiImageDrawObject];
    //商家名称
    WMMutableAttributedItem * titleAttributedItem = [WMMutableAttributedItem itemWithText:item.poiName];
    [titleAttributedItem setFont:[UIFont boldSystemFontOfSize:15]];
    [titleAttributedItem setColor:[UIColor blackColor]];
    [titleAttributedItem setAlignment:WMGTextAlignmentLeft lineBreakMode:NSLineBreakByTruncatingTail];
    CGSize titleSize = [titleAttributedItem.resultString wmg_size];
    
    WMGVisionObject * titleDrawObject = [[WMGVisionObject alloc] init];
    titleDrawObject.value = titleAttributedItem.resultString;
    titleDrawObject.frame = CGRectMake(60, 14, titleSize.width>180?180:titleSize.width, titleSize.height);
    [cellData.textDrawerDatas addObject:titleDrawObject];
    
    //商家箭头
    WMMutableAttributedItem * titleArrowAttributedItem = [WMMutableAttributedItem itemWithImageName:@"icon_arrow_store" size:CGSizeMake(10, 18)];
    WMGVisionObject * titleArrowDrawObject = [[WMGVisionObject alloc] init];
    titleArrowDrawObject.frame = CGRectMake(titleDrawObject.frame.size.width+titleDrawObject.frame.origin.x, titleDrawObject.frame.origin.y, 10, 18);
    titleArrowDrawObject.value = titleArrowAttributedItem.resultString;
    [cellData.textDrawerDatas addObject:titleArrowDrawObject];
    
    //订单状态
    WMMutableAttributedItem * statusAttributedItem = [WMMutableAttributedItem itemWithText:item.statusDescription];
    [statusAttributedItem setFont:[UIFont systemFontOfSize:15]];
    WMGVisionObject * statusDrawObject = [[WMGVisionObject alloc] init];
    statusDrawObject.value = statusAttributedItem.resultString;
    CGSize statusSize = [statusAttributedItem.resultString wmg_size];
    statusDrawObject.frame = CGRectMake(cellData.cellWidth-statusSize.width-15, 24, statusSize.width, statusSize.height);
    [cellData.textDrawerDatas addObject:statusDrawObject];
    
    //满减信息
    WMMutableAttributedItem * activityListAttributedItem = [WMMutableAttributedItem itemWithText:nil];
    [activityListAttributedItem setFont:[UIFont systemFontOfSize:10]];
    [activityListAttributedItem setAlignment:WMGTextAlignmentLeft lineBreakMode:NSLineBreakByTruncatingTail];
    for (DemoOrderLabelInfo * labelInfo in item.labelList) {
        WMMutableAttributedItem * labelAttributedItem = [WMMutableAttributedItem itemWithText:labelInfo.content];
        [labelAttributedItem setColor:WMGHEXCOLOR(strtoul(labelInfo.contentColor.UTF8String,0,0))];
        CGSize labelSize = [labelAttributedItem.resultString wmg_size];
        UIImage * borderImage = [UIImage wmg_imageWithColor:[UIColor clearColor] size:CGSizeMake(labelSize.width+4, labelSize.height+2) borderWidth:0.5 borderColor:WMGHEXCOLOR(strtoul(labelInfo.labelFrameColor.UTF8String,0,0)) cornerRadius:0];
        UIImage * image = [borderImage wmg_drawItem:labelAttributedItem atPosition:CGPointMake(2, 1)];
        WMMutableAttributedItem * borderLabelAttributedItem = [WMMutableAttributedItem itemWithText:nil];
        [borderLabelAttributedItem appendImageWithImage:image size:labelSize];
        [activityListAttributedItem appendAttributedItem:borderLabelAttributedItem];
    }
    
    WMGVisionObject * activityListObject = [[WMGVisionObject alloc] init];
    activityListObject.frame = CGRectMake(titleDrawObject.frame.origin.x, titleDrawObject.frame.origin.y+titleDrawObject.frame.size.height+4, 200, 15);
    activityListObject.value = activityListAttributedItem.resultString;
    [cellData.textDrawerDatas addObject:activityListObject];
    
    //分隔线
    WMMutableAttributedItem * lineAttributedItem = [WMMutableAttributedItem itemWithText:nil];
    UIImage * line = [UIImage wmg_imageWithColor:WMGHEXCOLOR(0xEEEEEE) size:CGSizeMake(cellData.cellWidth-75, 0.5)];
    [lineAttributedItem appendImageWithImage:line size:CGSizeMake(cellData.cellWidth-75, 0.5)];
    
    WMGVisionObject * lineDrawObject = [[WMGVisionObject alloc] init];
    lineDrawObject.frame = CGRectMake(titleDrawObject.frame.origin.x, activityListObject.frame.origin.y+activityListObject.frame.size.height+5, cellData.cellWidth-75, 15);
    lineDrawObject.value = lineAttributedItem.resultString;
    [cellData.textDrawerDatas addObject:lineDrawObject];
    
    //食物
    DemoOrderProductInfo * foodInfo = item.productList[0];
    WMMutableAttributedItem * foodAttributedItem = [WMMutableAttributedItem itemWithText:foodInfo.productName];
    [foodAttributedItem setFont:[UIFont systemFontOfSize:15]];
    CGSize foodTextSize = [foodAttributedItem.resultString wmg_size];
    WMMutableAttributedItem * totalPriceAttibutedText = [WMMutableAttributedItem itemWithText:item.totalPrice];
    [totalPriceAttibutedText setFont:[UIFont boldSystemFontOfSize:15]];
    [totalPriceAttibutedText setColor:WMGHEXCOLOR(0x333333)];
    CGSize totalPriceSize = [totalPriceAttibutedText.resultString wmg_size];
    [foodAttributedItem appendWhiteSpaceWithWidth:cellData.cellWidth-totalPriceSize.width-foodTextSize.width-60-15];
    [foodAttributedItem appendAttributedItem:totalPriceAttibutedText];
    
    WMGVisionObject * foodDrawObject = [[WMGVisionObject alloc] init];
    foodDrawObject.frame = CGRectMake(titleDrawObject.frame.origin.x, lineDrawObject.frame.origin.y+lineDrawObject.frame.size.height+18, cellData.cellWidth-titleDrawObject.frame.origin.x, totalPriceSize.height);
    foodDrawObject.value = foodAttributedItem.resultString;
    [cellData.textDrawerDatas addObject:foodDrawObject];
    
    
    //按钮列表
    WMMutableAttributedItem * buttonListAttributedItem = [WMMutableAttributedItem itemWithText:nil];
    [buttonListAttributedItem setAlignment:WMGTextAlignmentRight];
    for (DemoOrderButtonInfo * buttonInfo in item.buttonList) {
        WMMutableAttributedItem * labelAttributedItem = [WMMutableAttributedItem itemWithText:buttonInfo.title];
        [labelAttributedItem setFont:[UIFont systemFontOfSize:15]];
        [labelAttributedItem setColor:WMGHEXCOLOR(0x333333)];
        CGSize textSize = [labelAttributedItem.resultString wmg_size];
        UIImage * borderImage;
        if (buttonInfo.highlight) {
            borderImage = [UIImage wmg_imageWithColor:WMGHEXCOLOR(0xffd161) size:CGSizeMake(73, 32) borderWidth:0 borderColor:nil cornerRadius:2];
        }else{
            borderImage = [UIImage wmg_imageWithColor:[UIColor whiteColor] size:CGSizeMake(73, 32) borderWidth:0.5 borderColor:[UIColor grayColor] cornerRadius:2];
        }
        UIImage * image = [borderImage wmg_drawItem:labelAttributedItem atPosition:CGPointMake((73-textSize.width)/2, (32-textSize.height)/2)];
        WMMutableAttributedItem * buttonAttributedItem = [WMMutableAttributedItem itemWithText:nil];
        [buttonAttributedItem appendImageWithImage:image size:CGSizeMake(73, 32)];
        [buttonListAttributedItem appendAttributedItem:buttonAttributedItem];
        [buttonListAttributedItem appendWhiteSpaceWithWidth:10];
    }
    CGSize buttonListSize = [buttonListAttributedItem.resultString wmg_size];
    
    WMGVisionObject * buttonListObject = [[WMGVisionObject alloc] init];
    buttonListObject.frame = CGRectMake(cellData.cellWidth-buttonListSize.width, foodDrawObject.frame.origin.y+foodDrawObject.frame.size.height+22, buttonListSize.width, 32);
    buttonListObject.value = buttonListAttributedItem.resultString;
    [cellData.textDrawerDatas addObject:buttonListObject];
    
    cellData.cellHeight = buttonListObject.frame.origin.y + buttonListObject.frame.size.height+14;

    return cellData;
}
@end
