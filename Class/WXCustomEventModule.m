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
#import <WeexPluginLoader/WeexPluginLoader/WeexPluginLoader.h>
#import "JZAlbumViewController.h"

WX_PlUGIN_EXPORT_MODULE(WeexPreview, WXCustomEventModule)

@implementation WXCustomEventModule
@synthesize weexInstance;
 // 将方法暴露出去
 WX_EXPORT_METHOD(@selector(showParams:Array:))

 // 实现 Module 方法
-(void)showParams:(NSInteger)index Array:(NSArray *)array
 {
     NSLog(@"%@", array);
     if (!array){
        return;
     }
     
     JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
     
     jzAlbumVC.currentIndex = index;//这个参数表示当前图片的index，默认是0
     jzAlbumVC.imgArr = array;//图片数组，可以是url，也可以是UIImage
     //如果是本地图片，这里传“本地”，网络图片是不传
     //    jzAlbumVC.imagetype = @"本地";
     
     UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
     [rootViewController presentViewController:jzAlbumVC animated:NO completion:nil];
     
//     [self presentViewController:jzAlbumVC animated:NO completion:nil];
 }
@end

