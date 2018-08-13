//
//  XJCommentListCtrl.m
//  RentCar
//
//  Created by 李晨鹏 on 2018/4/17.
//  Copyright © 2018年 huatek. All rights reserved.
//

#import "XJCommentListCtrl.h"
#import "TPKeyboardAvoidingTableView.h"
#import "XJSectionFooterView.h"
#import "XJSectionHeaderView.h"
//#import "XJCommentCell.h"
#import "XXTextView.h"
//#import "XJRequestModel.h"
//#import "XJCommentInfo.h"
//#import "UITextField+RACSignalSupport.h"


#define mRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define mRGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]

@interface XJCommentListCtrl () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (nonatomic , strong) UIView *bottomView;
@property (nonatomic , strong) UIView *topView;
@property (nonatomic , strong) UILabel *commentLab;
@property (nonatomic , strong) UIButton *closeBtn;
@property (nonatomic , strong) UITableView *mainTab;
@property (nonatomic , strong) NSMutableArray *commentArr;
@property (nonatomic , strong) UIButton *commentBtn;
@property (nonatomic , strong) XXTextView *inputTf;
@property (nonatomic , strong) UIView *inputView;
@property (nonatomic , strong) UILabel *labTip;
@property (nonatomic , assign) NSInteger replayIndex;
@property (nonatomic , assign) NSInteger rowIndex;
@property (nonatomic , assign) BOOL isReply;
@property (nonatomic , assign) BOOL isRow;
@end

@implementation XJCommentListCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self initInputView];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)initData
{
    self.commentArr = [NSMutableArray array];
    self.replayIndex = -1;
    self.rowIndex = -1;
    self.isReply = NO;
    self.isRow = NO;
}

- (void)initView
{
    //    self.view.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = mRGBAColor(0, 0, 0, 0.1);
    self.bottomView = [UIView new];

    self.bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomView];

    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@400);
    }];
    
    self.topView = [UIView new];
    [self.bottomView addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bottomView);
        make.height.equalTo(@30);
    }];
    
    self.commentLab = [UILabel new];
    self.commentLab.text = @"0条评论";
    self.commentLab.textColor = mRGBToColor(0x666666);
    self.commentLab.textAlignment = NSTextAlignmentCenter;
    self.commentLab.font = [UIFont systemFontOfSize:12];
    [self.topView addSubview:self.commentLab];
    
    [self.commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self.bottomView);
        make.centerY.equalTo(self.topView);
        make.height.equalTo(@20);
        make.width.equalTo(@130);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"close-btn"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.closeBtn];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).offset(-10);
        make.centerY.equalTo(self.topView);
        make.width.height.equalTo(@30);
    }];
    
    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentBtn.backgroundColor = [UIColor blackColor];
//    self.commentBtn.backgroundColor = [UIColor yellowColor];
    [self.commentBtn setTitle:@"评论一下，说说你的想法~" forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:mRGBToColor(0x555555) forState:UIControlStateNormal];
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.commentBtn addTarget:self action:@selector(beginEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.commentBtn];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.right.bottom.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView.mas_left).offset(10);
        make.right.equalTo(self.bottomView.mas_right).offset(-10);
        make.bottom.equalTo(self.bottomView);
        make.height.equalTo(@40);
    }];
    
    self.mainTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.mainTab.delegate = self;
    self.mainTab.dataSource = self;
    self.mainTab.backgroundColor = [UIColor blackColor];
    self.mainTab.showsVerticalScrollIndicator = NO;
    self.mainTab.showsHorizontalScrollIndicator = NO;
    self.mainTab.backgroundColor = mRGBAColor(0, 0, 0, 0.6);
    self.mainTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bottomView addSubview:self.mainTab];
    
    [self.mainTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.bottomView);
        make.bottom.equalTo(self.commentBtn.mas_top);
    }];
    
    [self performSelector:@selector(borderStyle) withObject:nil afterDelay:0.5];
    
}

- (void)initInputView
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.inputView = [UIView new];
    self.inputView.hidden = YES;
    
    self.inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inputView];
    [self.view bringSubviewToFront:self.inputView];
    
   
    
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        //        make.top.equalTo(self.view.mas_bottom).offset(-216);
        make.height.equalTo(@45);
    }];
    
    
    
    
    self.inputTf = [XXTextView new];
    self.inputTf.xx_placeholder = @"评论一下，说说你的想法~";
    self.inputTf.returnKeyType = UIReturnKeySend;
    self.inputTf.textAlignment = NSTextAlignmentJustified;
    self.inputTf.hidden = YES;
    self.inputTf.delegate = self;
    self.inputTf.font = [UIFont systemFontOfSize:14];
    [self.inputView addSubview:self.inputTf];
    
    [self.inputTf mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.inputView.mas_top).offset(10);
        //        make.bottom.equalTo(self.inputView.mas_bottom).offset(-10);
        make.top.bottom.equalTo(self.inputView);
        make.left.equalTo(self.inputView.mas_left).offset(15);
        make.right.equalTo(self.inputView.mas_right).offset(-15);
    }];
    
    self.labTip = [UILabel new];
    self.labTip.text = @"100字以内";
    self.labTip.textColor = mRGBToColor(0xbbbbbb);
    self.labTip.font = [UIFont systemFontOfSize:12];
    [self.inputView addSubview:self.labTip];
    [self.inputView bringSubviewToFront:self.labTip];
    
    [self.labTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.inputView);
        make.right.equalTo(self.inputView.mas_right).offset(-10);
        make.height.equalTo(@20);
        make.width.equalTo(@60);
    }];
}

- (void)loadData
{
//    [self.commentArr removeAllObjects];
//    XJCommentModel *comment = [XJCommentModel new];
//    comment.type = @"0";
//    comment._id = self.caseId;
//    [GeneralMethods showWaitHint:@"正在加载..." withView:self.view];
//    [comment networkingSuccess:^(id result) {
//        NSMutableArray *resultMubArr = [NSMutableArray array];
//        NSArray *resultArr = [NSArray arrayWithArray:result];
////        [self.commentArr addObjectsFromArray:result];
//        resultArr = [resultArr linq_where:^BOOL(NSDictionary *item) {
//            if ([[item valueForKey:@"imageUrl"] isKindOfClass:[NSNull class]]) {
//                return NO;
//            }
//           return YES;
//        }];
//
//        for (int i = 0 ; i < resultArr.count; i++) {
//            NSDictionary *dic = resultArr[i];
//            if ([dic[@"imageUrl"] isEqualToString:[NSString stringWithFormat:@"%@",self.imgId]]) {
//                [resultMubArr addObject:dic];
//            }
//        }
//
//        resultArr = [NSArray arrayWithArray:resultMubArr];
//
//        resultArr = [resultArr linq_sort:^id(NSDictionary *item) {
//            return [item valueForKey:@"id"];
//        }];
//        self.commentLab.text = [NSString stringWithFormat:@"%lu条评论",(unsigned long)resultArr.count];
//
//        NSMutableDictionary *treeMap = [NSMutableDictionary dictionary];
//        NSMutableArray *groupIDArray = [NSMutableArray array];
//        NSMutableDictionary *groupTree = [NSMutableDictionary dictionary];
//
//        for (int i = 0 ; i < resultArr.count; i++) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: resultArr[i]];
//            NSNumber* mId = dic[@"id"];
//
//            NSNumber* parentComment = dic[@"parentComment"];
//            if (![parentComment isKindOfClass:[NSNull class]]) {
//                NSDictionary* parentComments = treeMap[parentComment];
//                NSNumber* parentID = parentComments[@"groupID"];
//                dic[@"groupID"] = parentID;
//                NSDictionary* group = groupTree[parentID];// [NSMutableDictionary dictionaryWithDictionary: ];;
//
//                NSMutableArray* mArray = [NSMutableArray arrayWithArray:group[@"commentData"]];
//                [mArray addObject:dic];
//                if ([group allKeys].count > 0) {
//                    groupTree[parentID] = [NSMutableDictionary dictionaryWithDictionary:@{@"parentComment":group[@"parentComment"],@"commentData":mArray}];
//                } else {
//                    [groupTree[parentID] setValue:mArray forKey:@"commentData"];
//                }
//                if([parentComment integerValue] != [parentID integerValue]){
//                    dic[@"replayUserName"] = parentComments[@"commentUserName"];
//                }
//            } else {
//                dic[@"groupID"] = mId;
//                [groupIDArray addObject:mId];
//                groupTree[mId] = @{@"parentComment":dic,@"commentData":[NSMutableArray array]};
//            }
//            treeMap[mId] = dic;
//        }
//
//        NSArray *commentData = [groupIDArray linq_select:^id(id item) {
//            return groupTree[item];
//        }];
//
//        [self.commentArr addObjectsFromArray:commentData];
//        NSLog(@"%@",result);
//        [GeneralMethods hideHUDWithView:self.view];
//        [self.mainTab reloadData];
//    } failed:^(NSString *error) {
//        [GeneralMethods hideHUDWithView:self.view];
//        [GeneralMethods showHUDText:error withView:self.view];
//    }];
}

- (void)borderStyle
{
    self.bottomView.clipsToBounds = YES;
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.bottomView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = self.bottomView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.bottomView.layer.mask = maskLayer1;
}

- (void)beginEdit
{
//    if ([GeneralMethods isToLoginPage]) {
//        return;
//    }
    [self showOrHidden:NO];
    [self.inputTf becomeFirstResponder];
    self.isReply = NO;
    self.isRow = NO;
    self.inputTf.xx_placeholder = @"评论一下，说说你的想法~";
}

- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)replayAction:(UITapGestureRecognizer *)tap
{
//    if ([GeneralMethods isToLoginPage]) {
//        return;
//    }
    [self showOrHidden:NO];
    self.isReply = YES;
    [self.inputTf becomeFirstResponder];
    self.replayIndex = tap.view.tag;
    NSDictionary *dic = self.commentArr[tap.view.tag];
    NSDictionary *dicInfo = dic[@"parentComment"];
    self.inputTf.xx_placeholder = [NSString stringWithFormat:@"回复@%@",dicInfo[@"commentUserName"]];
}

- (void)praiseAction: (UIButton *)sender
{
//    if ([GeneralMethods isToLoginPage]) {       //校验token
//        return;
//    }

    UIButton *btn = (UIButton *)sender;
//    COMMENT
    NSMutableDictionary *dic = self.commentArr[btn.tag];
    NSMutableDictionary *dicInfo = dic[@"parentComment"];
    NSString *up = [NSString stringWithFormat:@"%@",dicInfo[@"up"]];
//    if ([up isEqualToString:@"1"]) {
//        return [GeneralMethods showHUDText:@"已点赞！请勿重复操作" withView:self.view];
//    }
//    XJRequestModel *request = [XJRequestModel new];
//    request.sort = @"COMMENT";
//    request.targetId = dicInfo[@"id"];
//    [request networkingSuccess:^(id result) {
//        NSInteger ups = [dicInfo[@"ups"] integerValue];
//        ups = ups + 1;
//        dicInfo[@"ups"] = [NSString stringWithFormat:@"%ld",(long)ups];
//        dicInfo[@"up"] = @"1";
//        [GeneralMethods showHUDText:@"点赞成功!" withView:self.view];
//        [self.mainTab reloadData];
//    } failed:^(NSString *error) {
//        [GeneralMethods showHUDText:error withView:self.view];
//    }];
}

- (void)replayData:(NSString *)replyId
{
    
////    NSDictionary *dicInfo = dic[@"parentComment"];
//    XJCommentSubmitModel *submitModel = [XJCommentSubmitModel new];
//    submitModel.commentType = @"0";
//    submitModel.commentContent = self.inputTf.text;
//    submitModel.imageUrl = self.imgId;
//    submitModel.businessId = self.caseId;
//    submitModel.parentComment = replyId;
//    [submitModel networkingSuccess:^(id result) {
//        [GeneralMethods hideHUDWithView:self.view];
//        [GeneralMethods showHUDText:@"评论发表成功,请等待审核!" withView:self.view];
////        self.commentNums++;
////        [self.numDelegate toChangeComments:self.currentIndex andValue:@(self.commentNums)];
//        [self loadData];
//    } failed:^(NSString *error) {
//        [GeneralMethods hideHUDWithView:self.view];
//        [GeneralMethods showHUDText:error withView:self.view];
//    }];
}

- (void)submitData
{
//    XJCommentSubmitModel *submitModel = [XJCommentSubmitModel new];
//    submitModel.commentType = @"0";
//    submitModel.commentContent = self.inputTf.text;
//    submitModel.imageUrl = self.imgId;
//    submitModel.businessId = self.caseId;
//
//    [GeneralMethods showWaitHint:@"正在提交..." withView:self.view];
//    [submitModel networkingSuccess:^(id result) {
//        [GeneralMethods hideHUDWithView:self.view];
//        [GeneralMethods showHUDText:@"评论发表成功,请等待审核!" withView:self.view];
////        self.commentNums++;
////        [self.numDelegate toChangeComments:self.currentIndex andValue:@(self.commentNums)];
//        [self loadData];
//    } failed:^(NSString *error) {
//        [GeneralMethods hideHUDWithView:self.view];
//        [GeneralMethods showHUDText:error withView:self.view];
//    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.commentArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = self.commentArr[section];
    NSArray *arr = dic[@"commentData"];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 80;
//    NSDictionary *dic = self.commentArr[indexPath.section];
////    NSDictionary *dicInfo = dic[@"commentData"];
//    NSArray *arr = dic[@"commentData"];;
//    NSDictionary *rowInfo = arr[indexPath.row];
//    NSString *text = rowInfo[@"commentContent"];
//    CGFloat textHeight = [GeneralMethods getTheStringHeight:text setFont:14 withWidth:self.view.frame.size.width - 120];
//    return textHeight + 45;
    return 30 + 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    NSDictionary *dic = self.commentArr[section];
//    NSDictionary *dicInfo = dic[@"parentComment"];
//    NSString *text = dicInfo[@"commentContent"];
//    CGFloat textHeight = [GeneralMethods getTheStringHeight:text setFont:14 withWidth:self.view.frame.size.width - 109];
//    textHeight = textHeight + 38;
//    return textHeight;
    
    return 30 + 38;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *dic = self.commentArr[section];
    NSDictionary *dicInfo = dic[@"parentComment"];
    XJSectionFooterView *footerView = [[XJSectionFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    footerView.allBtn.hidden = YES;
    footerView.timeLab.text = dicInfo[@"commentTime"];
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = self.commentArr[section];
    NSDictionary *dicInfo = dic[@"parentComment"];
    NSString *text = dicInfo[@"commentContent"];
//    CGFloat textHeight = [GeneralMethods getTheStringHeight:text setFont:14 withWidth:self.view.frame.size.width - 109];
    CGFloat textHeight = 30 + 38;
    XJSectionHeaderView *headerView = [[XJSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, textHeight)];
    headerView.tag = section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replayAction:)];
    headerView.praiseBtn.tag = section;
    [headerView.praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addGestureRecognizer:tap];
    [headerView setDataToView:dicInfo];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *commentIdentifier = @"commentIdentifier";
//    XJCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
//    if (!commentCell) {
//        commentCell = [[XJCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentIdentifier];
//    }
//    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    commentCell.backgroundColor = mRGBAColor(0, 0, 0, 0.7);
//    NSDictionary *dic = self.commentArr[indexPath.section];
//    NSArray *arr = dic[@"commentData"];
//    NSDictionary *rowInfo = arr[indexPath.row];
//    [commentCell setDataToCell:rowInfo];
//    return commentCell;
    return [[UITableViewCell alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([GeneralMethods isToLoginPage]) {       //校验token
//        return;
//    }

    NSDictionary *dic = self.commentArr[indexPath.section];
    NSArray *arr = dic[@"commentData"];
    NSDictionary *rowInfo = arr[indexPath.row];
    [self showOrHidden:NO];
    self.isRow = YES;
    self.replayIndex = indexPath.section;
    self.rowIndex = indexPath.row;
    [self.inputTf becomeFirstResponder];
    self.inputTf.xx_placeholder = [NSString stringWithFormat:@"回复@%@",rowInfo[@"commentUserName"]];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat animationSec = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardRect = [aValue CGRectValue];
    float height = keyboardRect.size.height;
    self.inputTf.hidden = NO;
    self.inputView.clipsToBounds = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.inputView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.inputView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.inputView.layer.mask = maskLayer;
    
    [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-height);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(45));
    }];
    
//    [UIView animateWithDuration:animationSec animations:^{
//        
//        [self.inputTf.rac_textSignal subscribeNext:^(id x) {
//            NSString *text = [NSString stringWithFormat:@"%@",x];
//            NSLog(@"%lu",(unsigned long)text.length);
//            if (text.length == 0) {
//                self.labTip.hidden = NO;
//            }
//            else {
//                self.labTip.hidden = YES;
//            }
//            if (text.length > 100) {
//                self.inputTf.text = [text substringToIndex:100];
//                return;
//            }
//            
//            CGFloat textHeight = self.inputTf.contentSize.height;
//            if (textHeight > 85) {
//                return;
//            }
//            if (textHeight > 30) {
//                [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.bottom.equalTo(self.view.mas_bottom).offset(-height);
//                    make.left.right.equalTo(self.view);
//                    make.height.equalTo(@(textHeight + 20));
//                }];
//                
//                [self.inputTf mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self.inputView.mas_left).offset(10);
//                    make.top.equalTo(self.inputView.mas_top).offset(10);
//                    make.right.equalTo(self.inputView.mas_right).offset(-10);
//                    make.bottom.equalTo(self.inputView.mas_bottom).offset(-10);
//                }];
//            }
//            
//        }];
//    }];
    
    self.commentBtn.hidden = YES;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"%lu",(unsigned long)textView.text.length);
    if ([text isEqualToString:@"\n"]) {
        if (self.isReply) {
            NSDictionary *dic = self.commentArr[self.replayIndex];
            NSDictionary *dicInfo = dic[@"parentComment"];
            [self replayData:dicInfo[@"id"]];      //回复
        }
        else if (self.isRow) {
            NSDictionary *dic = self.commentArr[self.replayIndex];
            NSArray *arr = dic[@"commentData"];
            NSDictionary *rowInfo = arr[self.rowIndex];
            [self replayData:rowInfo[@"id"]];
        }
        else {
            [self submitData];          //评论
        }
        self.isReply = NO;
        self.isRow = NO;
        [self showOrHidden:YES];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)showOrHidden:(BOOL)isShow
{
    if(isShow) {
        self.commentBtn.hidden = NO;
        self.inputView.hidden = YES;
        self.inputTf.text = @"";
    }
    else {
        self.commentBtn.hidden = YES;
        self.inputView.hidden = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self showOrHidden:YES];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
