//
//  BasicDetailViewController.m
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
    

#import "BasicDetailViewController.h"
#import "UIImage+Graver.h"
#import "WMGCanvasView.h"
#import "WMGMixedView.h"
#import "WMMutableAttributedItem.h"
#import "WMPoiListAttributedImage.h"

@interface BasicDetailViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    GraverDemoBasicRow _rowStyle;
    UIScrollView *_scrollView;
    
    UITextView *text;
    UITextField *width;
    UITextField *linenumber;
    
    WMGMixedView *effectView;
}
@end

@implementation BasicDetailViewController

- (id)initWithStyle:(GraverDemoBasicRow)rowStyle
{
    self = [super init];
    if (self) {
        _rowStyle = rowStyle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 20000);
    _scrollView.scrollEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    NSString *title = @"";
    
    switch (_rowStyle) {
        case GraverDemoBasicRow_BasicUse:
            title = @"basic use";
            [self basicUseDemo];
            break;
            
        case GraverDemoBasicRow_AdvancedUse:
            title = @"advance use";
            [self advancedUseDemo];
            break;
            
        case GraverDemoBasicRow_ImageRelated:
            title = @"image related";
            [self imageRelatedDemo];
            break;
            
        case GraverDemoBasicRow_TextCaculate:
            title = @"size caculate";
            [self sizeCaculateDemo];
            break;
            
        default:
            break;
    }
    
    self.navigationItem.title =  title;
}


- (void)basicUseDemo
{
    WMMutableAttributedItem *item = [WMMutableAttributedItem itemWithText:@""];
    
    WMMutableAttributedItem *text1 = [WMMutableAttributedItem itemWithText:@"Graver是一种高效的UI渲染框架。"];
    [text1 setFont:[UIFont systemFontOfSize:18]];
    [text1 setColor:WMGHEXCOLOR(0xff8205)];
    
    
    WMMutableAttributedItem *text2 = [WMMutableAttributedItem itemWithText:@"它采用了全新视觉元素分解思路。"];
    [text2 setFont:[UIFont systemFontOfSize:18]];
    [text2 setColor:WMGHEXCOLOR(0x37A2EE)];
    
    
    [[[[item appendAttributedItem:text1] appendImageWithName:@"story_icon" size:CGSizeMake(18, 18)] appendWhiteSpaceWithWidth:5] appendAttributedItem:text2];
    
    WMGMixedView *view = [[WMGMixedView alloc] initWithFrame:CGRectZero];
    view.attributedItem = item;
    
    CGSize size = [item.resultString wmg_sizeConstrainedToWidth:self.view.frame.size.width - 20];
    view.frame = CGRectMake(10, 10, size.width, size.height);
    [_scrollView addSubview:view];
}

- (void)advancedUseDemo
{
    WMPoiListAttributedImage *status = [[WMPoiListAttributedImage alloc] initWithText:@"雕工"];
    [status setColor:WMGHEXCOLOR(0xFFFFFF)];
    [status setFont:[UIFont systemFontOfSize:16]];
    CGSize statusSize = [status.resultString wmg_size];
    
    WMPoiListAttributedImage *desc = [[WMPoiListAttributedImage alloc] initWithText:@"是一种高效的UI渲染框架"];
    [desc setColor:WMGHEXCOLOR(0x37A2EE)];
    [desc setFont:[UIFont systemFontOfSize:16]];
    CGSize descSize = [desc.resultString wmg_sizeConstrainedToWidth:160 numberOfLines:1];
    
    UIImage *contentImage = [[UIImage wmg_imageWithColor:WMGHEXCOLOR(0x37A2EE) size:CGSizeMake(statusSize.width + 8, MAX(statusSize.height, descSize.height))] wmg_roundedImageWithCornerRadius:2 cornerType:UIRectCornerTopLeft | UIRectCornerBottomLeft];
    contentImage = [contentImage wmg_drawItem:status numberOfLines:1 atPosition:CGPointMake(4, 1)];

    UIImage *descImage = [UIImage wmg_imageWithColor:[UIColor clearColor] size:CGSizeMake(descSize.width + 8, MAX(statusSize.height, descSize.height)) borderWidth:1 borderColor:WMGHEXCOLOR(0x37A2EE) borderRadius:WMGCornerRadiusMake(0, 2, 0, 2)];
    descImage = [descImage wmg_drawItem:desc numberOfLines:1 atPosition:CGPointMake(4, 0)];

    WMMutableAttributedItem *item = [[[[WMPoiListAttributedImage alloc] initWithText:@""] appendImageWithImage:contentImage] appendImageWithImage:descImage];
    
    CGSize size = [item.resultString wmg_sizeConstrainedToWidth:self.view.frame.size.width - 20 numberOfLines:1];
    
    WMGMixedView *view = [[WMGMixedView alloc] initWithFrame:CGRectZero];
    view.attributedItem = item;
    view.frame = CGRectMake(10, 10, size.width, size.height);
    
    [_scrollView addSubview:view];
}

- (void)sizeCaculateDemo
{
    CGFloat spaceYStart = 20;
    
    text = [[UITextView alloc] initWithFrame:CGRectMake(10, spaceYStart, self.view.frame.size.width - 20, 60)];
    text.text = @"Graver是一种高效的UI渲染框架";
    text.textColor = WMGHEXCOLOR(0x666666);
    text.layer.borderColor = WMGHEXCOLOR(0xe4e4e4).CGColor;
    text.layer.cornerRadius = 1;
    text.layer.borderWidth = 1.0;
    text.delegate = self;
    [text becomeFirstResponder];
    [_scrollView addSubview:text];

    spaceYStart += 80;
    
    UILabel *widthW = [[UILabel alloc] initWithFrame:CGRectMake(10, spaceYStart, 80, 20)];
    widthW.text = @"宽度限制：";
    widthW.font = [UIFont systemFontOfSize:13];
    widthW.textColor = WMGHEXCOLOR(0x666666);
    [_scrollView addSubview:widthW];
    
    width = [[UITextField alloc] initWithFrame:CGRectMake(90, spaceYStart - 5, 100, 30)];
    width.placeholder = @"宽度限制";
    width.font = [UIFont systemFontOfSize:13];
    width.text = @"60";
    width.textAlignment = NSTextAlignmentCenter;
    width.delegate = self;
    width.layer.borderWidth = 1.0;
    width.layer.cornerRadius = 3;
    width.layer.borderColor = WMGHEXCOLOR(0xe4e4e4).CGColor;
    [_scrollView addSubview:width];
    
    spaceYStart += 40;
    
    UILabel *widthL = [[UILabel alloc] initWithFrame:CGRectMake(10, spaceYStart, 80, 20)];
    widthL.text = @"行数限制：";
    widthL.font = [UIFont systemFontOfSize:13];
    widthL.textColor = WMGHEXCOLOR(0x666666);
    [_scrollView addSubview:widthL];
    
    linenumber = [[UITextField alloc] initWithFrame:CGRectMake(90, spaceYStart - 5, 100, 30)];
    linenumber.placeholder = @"行数限制";
    linenumber.textAlignment = NSTextAlignmentCenter;
    linenumber.font = [UIFont systemFontOfSize:13];
    linenumber.text = @"3";
    linenumber.delegate = self;
    linenumber.layer.borderWidth = 1.0;
    linenumber.layer.cornerRadius = 3;
    linenumber.layer.borderColor = WMGHEXCOLOR(0xe4e4e4).CGColor;
    [_scrollView addSubview:linenumber];
    
    spaceYStart += 40;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, spaceYStart, self.view.frame.size.width - 20, 40)];
    [button setTitle:@"点击查看效果" forState:UIControlStateNormal];
    [button setTitleColor:WMGHEXCOLOR(0x333333) forState:UIControlStateNormal];
    [button setTitleColor:WMGHEXCOLOR(0x999999) forState:UIControlStateHighlighted];
    [button setBackgroundColor:WMGHEXCOLOR(0xe4e4e4)];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
}

- (void)didClick:(id)sender
{
    if (effectView == nil) {
        effectView = [[WMGMixedView alloc] initWithFrame:CGRectMake(10, 230, 0, 0)];
        [_scrollView addSubview:effectView];
        effectView.borderWidth = 0.5;
        effectView.borderColor = WMGHEXCOLOR(0xe4e4e4);
        effectView.cornerRadius = 1;
    }
    [text resignFirstResponder];
    [width resignFirstResponder];
    [linenumber resignFirstResponder];
    
    
    NSString *string = text.text;
    if (string) {
        CGFloat widthF = [width.text floatValue] > (self.view.frame.size.width - 20) ? self.view.frame.size.width - 20 : [width.text floatValue];
        NSUInteger line = [linenumber.text integerValue];
        
        WMMutableAttributedItem *item = [WMMutableAttributedItem itemWithText:string];
        [item setFont:[UIFont systemFontOfSize:13]];
        [item setColor:WMGHEXCOLOR(0x333333)];
        
        CGSize size = [item.resultString wmg_sizeConstrainedToWidth:widthF numberOfLines:line];
        
        effectView.frame = CGRectMake((self.view.frame.size.width - size.width)/2, 230, size.width, size.height);
        effectView.attributedItem = item;
        effectView.numerOfLines = line;
    }
}

- (void)imageRelatedDemo
{
    CGFloat spaceYStart = 0;
    spaceYStart = [self basicImageUseDemoWithStartY:spaceYStart];
    spaceYStart += 5;
    [self addLineWithSpaceYStart:spaceYStart];    
}

- (CGFloat)basicImageUseDemoWithStartY:(CGFloat)startY
{
    NSUInteger singleLineCount = 4;
    CGFloat width = (_scrollView.frame.size.width - 15 * 2 - (singleLineCount - 1) * 15) / singleLineCount;
    CGSize imgSize = CGSizeMake(width , width);
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    // 纯色图片
    UIImage *image1 = [UIImage wmg_imageWithColor:WMGHEXCOLOR(0xf4f4f4) size:imgSize];
    [imageArray addObject:image1];
    
    // 纯色带框图片
    UIImage *image3 = [UIImage wmg_imageWithColor:WMGHEXCOLOR(0xf4f4f4) size:imgSize borderWidth:2 borderColor:[UIColor redColor] cornerRadius:0];
    [imageArray addObject:image3];
    
    // 纯色圆角图片
    UIImage *image5 = [UIImage wmg_imageWithColor:WMGHEXCOLOR(0xf4f4f4) size:imgSize borderWidth:0 borderColor:nil cornerRadius:10];
    [imageArray addObject:image5];
    
    // 纯色圆角框
    UIImage *image6 = [UIImage wmg_imageWithColor:WMGHEXCOLOR(0xf4f4f4) size:imgSize borderWidth:2 borderColor:[UIColor redColor] cornerRadius:10];
    [imageArray addObject:image6];
    
    // 透明带框图片
    UIImage *image2 = [UIImage wmg_imageWithColor:[UIColor clearColor] size:imgSize borderWidth:2 borderColor:[UIColor redColor] cornerRadius:0];
    [imageArray addObject:image2];
    
    // 透明带框圆角图片
    UIImage *image4 = [UIImage wmg_imageWithColor:[UIColor clearColor] size:imgSize borderWidth:2 borderColor:[UIColor redColor] cornerRadius:10];
    [imageArray addObject:image4];
    
    // 透明带框圆角图片
    UIImage *image7 = [UIImage wmg_imageWithColor:[UIColor clearColor] size:imgSize borderWidth:2 borderColor:[UIColor redColor] borderRadius:WMGCornerRadiusMake(0, 20, 20, 0)];
    [imageArray addObject:image7];
    
    CGFloat spaceXStart = 0;
    CGFloat spaceYStart = startY;
    for (int i = 0; i < imageArray.count; i++) {
        
        if (i == 0) {
            spaceXStart = 15;
            spaceYStart += 10;
        }
        else
        {
            if (i % singleLineCount == 0)
            {
                spaceXStart = 15;
                spaceYStart += imgSize.height;
                spaceYStart += 15;
            }
            else{
                spaceXStart+= imgSize.width;
                spaceXStart += 15;
            }
        }
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, imgSize.width, imgSize.height)];
        imgView.image = [imageArray objectAtIndex:i];
        [_scrollView addSubview:imgView];
    }
    
    spaceYStart += imgSize.height;
    spaceYStart += 15;
    
    return spaceYStart;
}

- (CGFloat)addLineWithSpaceYStart:(CGFloat)spaceYStart
{
    UIView *singleLine = [[UIView alloc] initWithFrame:CGRectMake(10, spaceYStart, _scrollView.frame.size.width - 20, 1 / [UIScreen mainScreen].scale)];
    singleLine.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:singleLine];
    return spaceYStart + 1;
}

@end
