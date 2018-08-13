//
//  XJSectionHeaderView.m
//  RentCar
//
//  Created by 李晨鹏 on 2018/4/17.
//  Copyright © 2018年 huatek. All rights reserved.
//

#import "XJSectionHeaderView.h"
#import "UIImageView+WebCache.h"
//#import "HTYKLM_API_iPhoneMacro.h"
#import "Masonry.h"

#define mRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define mRGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]

@implementation XJSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.headImg = [UIImageView new];
        self.headImg.layer.cornerRadius = 13;
        self.headImg.backgroundColor = mRGBToColor(0xf2f2f2);
        self.headImg.clipsToBounds = YES;
        [self addSubview:self.headImg];
        
        self.nameLab = [UILabel new];
        self.nameLab.text = @"八斤树";
        self.nameLab.textColor = mRGBToColor(0x999999);
        self.nameLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [self addSubview:self.nameLab];
        
        self.praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.praiseBtn setImage:[UIImage imageNamed:@"black-praise"] forState:UIControlStateNormal];
        [self addSubview:self.praiseBtn];
        
        self.praiseLab = [UILabel new];
        self.praiseLab.text = @"234";
        self.praiseLab.textAlignment = NSTextAlignmentCenter;
        self.praiseLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        self.praiseLab.textColor = mRGBToColor(0x666666);
        [self addSubview:self.praiseLab];
        
        self.contentLab = [UILabel new];
        self.contentLab.text = @"APP点开全文之后会跳到不知道什么地方，查看原文还得划到前面去找，希望可以优化一下";
        self.contentLab.numberOfLines = 0;
        self.contentLab.lineBreakMode = NSLineBreakByWordWrapping;
        self.contentLab.textColor = mRGBToColor(0xdddddd);
        self.contentLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [self addSubview:self.contentLab];
        
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left).offset(15);
            make.width.height.equalTo(@26);
        }];
        
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(9);
            make.left.equalTo(self.headImg.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-54);
            make.height.equalTo(@20);
        }];
        
        [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(11);
            make.right.equalTo(self.mas_right).offset(-20);
            make.width.height.equalTo(@22);
        }];
        
        [self.praiseLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.praiseBtn.mas_right);
            make.top.equalTo(self.praiseBtn.mas_bottom).offset(7);
            make.height.equalTo(@20);
            make.width.equalTo(@30);
        }];
        
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLab.mas_bottom).offset(10);
            make.left.equalTo(self.mas_left).offset(51);
            make.right.equalTo(self.mas_right).offset(-58);
        }];
        
        [self.contentLab sizeToFit];
        
    }
    return self;
}

- (void)setDataToView:(id)data;
{
    NSDictionary *dic = data;
//    self.contentLab.text = dic[@"commentContent"];
//    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_Base_REQUEST_URL,dic[@"customerPhoto"]]] placeholderImage:nil];
//    self.nameLab.text = dic[@"commentUserName"];
//    BOOL isUps = [dic[@"up"] boolValue];
//    [self.praiseBtn setImage: isUps ? [UIImage imageNamed:@"red-praise"] : [UIImage imageNamed:@"black-praise"] forState:UIControlStateNormal];
//    self.praiseLab.text = [NSString stringWithFormat:@"%@",dic[@"ups"]];
}

@end
