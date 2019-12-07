//
//  NetworkAccessResultView.h
//  wejointoo
//
//  Created by ijointoo on 2017/8/8.
//  Copyright © 2017年 demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkAccessResultView : UIView

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,strong) UIButton *bottomBtn;

@property (nonatomic,strong) void(^bottomBtnAction)(void);

- (instancetype)initWithFrame:(CGRect)frame;

/** 加载动画
 *  loadImages 加载帧动画
 *  tipStr 加载提示文字
 *  btnTitle 按钮的title，如果为空不显示按钮
 */
- (void)loadWith:(NSArray <NSString *>*)loadImages and:(NSString *)tipStr and:(NSString *)btnTitle;

/** 加载失败动画
 *  failedImage 加载帧动画
 *  tipStr 加载提示文字
 */
- (void)failedWith:(NSString *)failedImage and:(NSString *)tipStr;



- (void)noDataWithNoDataImage:(NSString *)noDataImage tipStr:(NSString *)tipStr bottomBtnTitle:(NSString *)btnTitle viewCenterY:(CGFloat)centerY;

@end

