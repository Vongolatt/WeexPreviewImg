//
//  XJSectionHeaderView.h
//  RentCar
//
//  Created by 李晨鹏 on 2018/4/17.
//  Copyright © 2018年 huatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJSectionHeaderView : UIView
@property (nonatomic , strong) UIImageView *headImg;
@property (nonatomic , strong) UILabel *nameLab;
@property (nonatomic , strong) UILabel *contentLab;
@property (nonatomic , strong) UIButton *praiseBtn;
@property (nonatomic , strong) UILabel *praiseLab;

- (void)setDataToView:(id)data;
@end
