//
//  XJSectionFooterView.m
//  RentCar
//
//  Created by 李晨鹏 on 2018/4/17.
//  Copyright © 2018年 huatek. All rights reserved.
//

#import "XJSectionFooterView.h"

#define mRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define mRGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]

@implementation XJSectionFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.allBtn setTitle:@"全部评论" forState:UIControlStateNormal];
        [self.allBtn setTitleColor:mRGBToColor(0x6287B2) forState:UIControlStateNormal];
        self.allBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [self addSubview:self.allBtn];
        
        self.timeLab = [UILabel new];
        self.timeLab.textColor = mRGBToColor(0x666666);
        self.timeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        self.timeLab.text = @"4-8";
        [self addSubview:self.timeLab];
        
        [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(51);
            make.width.equalTo(@50);
            make.height.equalTo(@20);
        }];
        
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.allBtn);
//            make.top.equalTo(self.allBtn.mas_bottom).offset(5);
            make.centerY.equalTo(self);
            make.height.equalTo(@20);
            make.width.equalTo(@110);
        }];
    }
    return self;
}

@end
