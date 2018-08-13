//
//  preview.m
//  WeexEros
//
//  Created by hefoni on 2018/8/13.
//  Copyright © 2018年 benmu. All rights reserved.
//

//
//  BMCalendarComponent.m
//
#import "WXCustomEventModule.h"
#import <WeexPluginLoader/WeexPluginLoader.h>

WX_PlUGIN_EXPORT_MODULE(WeexPreview, WXCustomEventModule)

@implementation WXCustomEventModule
@synthesize weexInstance;
 // 将方法暴露出去
 WX_EXPORT_METHOD(@selector(showParams:))

 // 实现 Module 方法
 -(void)showParams:(NSString*)inputParams
 {
     if (!inputParams){
        return;
     }
     NSLog(@"%@", inputParams);
 }
@end

