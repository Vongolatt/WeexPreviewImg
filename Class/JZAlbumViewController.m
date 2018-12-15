//
//  JZAlbumViewController.m
//  aoyouHH
//
//  Created by jinzelu on 15/4/27.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "JZAlbumViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "PhotoView.h"
#import "XJCommentListCtrl.h"
#import "BMGlobalEventManager.h"
#define mSystemVersion   ([[UIDevice currentDevice] systemVersion])
#define screen_width    [UIScreen mainScreen].bounds.size.width
#define screen_height   [UIScreen mainScreen].bounds.size.height

@interface JZAlbumViewController ()<UIScrollViewDelegate,PhotoViewDelegate>
{
    CGFloat lastScale;
    MBProgressHUD *HUD;
    NSMutableArray *_subViewList;
}

@end

@implementation JZAlbumViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
        _subViewList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    lastScale = 1.0;
//    self.view.backgroundColor = [UIColor redColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[self.currentIndex]]];
    [self.view addSubview:imageView];
    self.bgImageView = imageView;
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
    view.frame = self.bgImageView.frame;
    [self.view addSubview:view];

    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapView)];
//    [self.view addGestureRecognizer:tap];

    [self initScrollView];
//    [self addLabels];
    [self setPicCurrentIndex:self.currentIndex];
    
    [self initTopView];
    [self initCommentButton];
}

-(void)initCommentButton{
    CGFloat commentBtnWid = 100;
    CGFloat commentBtnHeg = 50;
    UIButton *commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(screen_width - commentBtnWid - 30, screen_height - commentBtnHeg - 40, commentBtnWid, commentBtnHeg)];
    [commentBtn addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn setTitle:@"评论0" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.view addSubview:commentBtn];
}
-(void)initTopView{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    [self.view addSubview:navView];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 80, 44)];
    [backButton setImage:[UIImage imageNamed:@"white-back"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    
    CGFloat viewX = 100 + 50;
    CGFloat viewWid = (screen_width - viewX)/3;
    UIButton *zanBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewX, 20, viewWid, 44)];
    [zanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:zanBtn];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((viewWid - 26)/2, 11, 26, 26)];
    imageView.image = [UIImage imageNamed:@"gray-praise"];
    [zanBtn addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((viewWid - 26)/2 + 26 + 3, 0, 40, 44)];
    label.text = @"0";
    label.textColor = [UIColor whiteColor];
    [zanBtn addSubview:label];
    
    
    UIButton *colBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewX + viewWid, 20, viewWid, 44)];
    [colBtn addTarget:self action:@selector(colBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:colBtn];
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake((viewWid - 26)/2, 9, 26, 26)];
    imageView2.image = [UIImage imageNamed:@"icon-startgray"];
    [colBtn addSubview:imageView2];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake((viewWid - 26)/2 + 26 + 3, 0, 40, 44)];
    label2.text = @"0";
    label2.textColor = [UIColor whiteColor];
    [colBtn addSubview:label2];
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewX + viewWid * 2, 20, viewWid, 44)];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:shareBtn];
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake((viewWid - 26)/2, 9, 26, 26)];
    imageView3.image = [UIImage imageNamed:@"whiteShare"];
    [shareBtn addSubview:imageView3];
    
}
// 返回
-(void)backButtonClick{
    [self TapHiddenPhotoView];
}

// 点赞
-(void)zanBtnClick:(UIButton *)sender{
    UIImageView *imageView = (UIImageView *)sender.subviews[0];
    
    if (sender.selected) {
        sender.selected = NO;
        imageView.image = [UIImage imageNamed:@"gray-praise"];
    }else{
        sender.selected = YES;
        imageView.image = [UIImage imageNamed:@"red-praise"];
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"praise"];
    [BMGlobalEventManager pushMessage:dic appLaunchedByNotification:YES];
}
// 收藏
-(void)colBtnClick:(UIButton *)sender{
    UIImageView *imageView = (UIImageView *)sender.subviews[0];
    if (sender.selected) {
        sender.selected = NO;
        imageView.image = [UIImage imageNamed:@"icon-startgray"];
    }else{
        sender.selected = YES;
        imageView.image = [UIImage imageNamed:@"red-start"];
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"collect"];
    [BMGlobalEventManager pushMessage:dic appLaunchedByNotification:YES];
}
// 分享
-(void)shareBtnClick:(UIButton *)sender{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [self TapHiddenPhotoView];
    [dic setValue:@"1" forKey:@"share"];
    [BMGlobalEventManager pushMessage:dic appLaunchedByNotification:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initScrollView{
//    [[SDImageCache sharedImageCache] cleanDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView.contentSize = CGSizeMake(self.imgArr.count*screen_width, screen_height);
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    //设置放大缩小的最大，最小倍数
//    self.scrollView.minimumZoomScale = 1;
//    self.scrollView.maximumZoomScale = 2;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < self.imgArr.count; i++) {
        [_subViewList addObject:[NSNull class]];
    }

}

-(void)addLabels{
    self.sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-30, screen_height-64-49, 60, 30)];
    self.sliderLabel.backgroundColor = [UIColor clearColor];
    self.sliderLabel.textColor = [UIColor whiteColor];
    self.sliderLabel.textAlignment = NSTextAlignmentCenter;
    self.sliderLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex+1,(unsigned long)self.imgArr.count];
    [self.view addSubview:self.sliderLabel];
}

-(void)setPicCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.scrollView.contentOffset = CGPointMake(screen_width*currentIndex, 0);
    [self loadPhote:_currentIndex];
    [self loadPhote:_currentIndex+1];
    [self loadPhote:_currentIndex-1];
}

-(void)loadPhote:(NSInteger)index{
    if (index<0 || index >=self.imgArr.count) {
        return;
    }
    
    id currentPhotoView = [_subViewList objectAtIndex:index];
    if (![currentPhotoView isKindOfClass:[PhotoView class]]) {
        
        CGRect frame = CGRectMake(index*_scrollView.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        PhotoView *photoV;
        
        if ([self.imagetype isEqualToString:@"本地"]) {
            //本地
            photoV = [[PhotoView alloc] initWithFrame:frame withPhotoImage:[UIImage imageNamed:[self.imgArr objectAtIndex:index]]];
        }else{
            //url数组
            photoV = [[PhotoView alloc] initWithFrame:frame withPhotoUrl:[self.imgArr objectAtIndex:index]];
            
        }
        
        photoV.delegate = self;
        [self.scrollView insertSubview:photoV atIndex:0];
        [_subViewList replaceObjectAtIndex:index withObject:photoV];
        
    }else{
//        PhotoView *photoV = (PhotoView *)currentPhotoView;
    }
    
}

#pragma mark - PhotoViewDelegate
-(void)TapHiddenPhotoView{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)OnTapView{
    [self dismissViewControllerAnimated:NO completion:nil];
}
//手势
-(void)pinGes:(UIPinchGestureRecognizer *)sender{
    if ([sender state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    CGFloat scale = 1.0 - (lastScale -[sender scale]);
    lastScale = [sender scale];
    self.scrollView.contentSize = CGSizeMake(self.imgArr.count*screen_width, screen_height*lastScale);
    NSLog(@"scale:%f   lastScale:%f",scale,lastScale);
    CATransform3D newTransform = CATransform3DScale(sender.view.layer.transform, scale, scale, 1);
    
    sender.view.layer.transform = newTransform;
    if ([sender state] == UIGestureRecognizerStateEnded) {
        //
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
    int i = scrollView.contentOffset.x/screen_width+1;
    [self loadPhote:i-1];
    self.sliderLabel.text = [NSString stringWithFormat:@"%d/%lu",i,(unsigned long)self.imgArr.count];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[i - 1]]];
}
// 评论按钮的点击
-(void)commentButtonClick{
    
    //    NSDictionary *dic = self.infoDic[0];
    XJCommentListCtrl *commentList = [XJCommentListCtrl new];
    //    commentList.imgId = [dic valueForKey:@"id"];
    //    commentList.caseId = self.caseId;
    //    commentList.numDelegate = self;
    //    commentList.currentIndex = btn.tag;
    //    commentList.commentNums = [dic[@"comments"] integerValue];
    //    commentList.itemDic = [NSMutableDictionary dictionaryWithDictionary:self.infoDic[btn.tag]];
    //    [RACObserve(commentList, commentCount) subscribeNext:^(id x) {
    //        [self.infoDic[btn.tag] setValue:x forKey:@"comments"];
    //    }];
    if ([mSystemVersion floatValue] < 8.0) {
        commentList.modalPresentationStyle = UIModalPresentationFullScreen;
    }else
    {
        commentList.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    
    //    mViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:commentList
                           animated:YES
                         completion:NULL];
    });
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
