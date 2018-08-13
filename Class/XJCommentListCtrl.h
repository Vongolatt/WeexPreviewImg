//
//  XJCommentListCtrl.h
//  RentCar
//
//  Created by 李晨鹏 on 2018/4/17.
//  Copyright © 2018年 huatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol commentsNumDelegate <NSObject>
- (void)toChangeComments:(NSInteger)index andValue:(NSNumber*)num;
@end

@interface XJCommentListCtrl : UIViewController
@property (nonatomic , strong) NSString *imgId;
@property (nonatomic , strong) NSString *caseId;
@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , assign) NSInteger commentNums;
@property (nonatomic , strong) NSString *commentCount;
@property (nonatomic , assign) id<commentsNumDelegate>numDelegate;
@end
