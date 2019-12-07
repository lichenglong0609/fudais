//
//  UITool.h
//  NativeJialebao
//
//  Created by 0X10 on 16/7/18.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITool : NSObject


/**
 *
 *  @param title      labelContent
 *  @param titleColor labelTitleColor
 *  @param font       label font
 *  @param frame      label frame
 *
 *  @return label
 */

+ (UILabel *)withTitle:(NSString *)title
        withTitleColor:( UIColor *)titleColor
          setLabelFont:( CGFloat )font
         initWithFrame:(CGRect)frame;


/**
 *
 *   UILabel 中间是数字label，两边正常
 *   设置两边的titleColor 和 中间的数据的颜色
 *
 */
+ (UILabel *)numLabelwithTitle:(NSString *)title
                withTitleColor:(UIColor *)titleColor
                 withNumberStr:(NSString *)numStr
                      setColor:(UIColor *)numColor
                  withGoodUnit:(NSString *)unit
                  setLabelFont:(CGFloat)font
                 initWithFrame:(CGRect)frame;

/**
 *   init button with some frequent attribute incloud title/titlecolor/font/bgColor/frame
 *
 *  @param title            button Content
 *  @param titleStatus      button Status
 *  @param titleColor       button Color
 *  @param titleColorStatus button ColorStatus
 *  @param font             button label of title font
 *  @param image            button backgroundimage
 *  @param status           bgimg status
 *  @param bgcolor          bgColor
 *  @param frame            button frame
 *
 *  @return customer button
 */

+ (UIButton *)buttonWithTitle:(NSString *)title
                    forStatus:(UIControlState)titleStatus
               withTitleColor:(UIColor *)titleColor
                    forStatus:(UIControlState)titleColorStatus
                 setLabelFont:(CGFloat)font
            setBackgroudImage:(UIImage *)image
                    forStatus:(UIControlState)status
           setBackgroundColor:(UIColor *)bgcolor
                initWithFrame:(CGRect)frame;


//返回当前Label 自适应的大小。
+ (CGSize)returnLabelSizeWithTitle:(NSString *)title withAttributeSystemFont:(CGFloat)font forMaxSize:(CGSize)maxSize;

+ (UIButton *)initButtonWithTitle:(NSString *)title
                          withImg:(UIImage *)img
                        forStatus:(UIControlState)status
                        withFrame:(CGRect)frame;

+ (UIButton *)initWithTitle:(NSString *)title
                  forStatus:(UIControlState)status
                  addAction:(SEL)action
           forControlEvents:(UIControlEvents)controlEvents;


+(UITextField *)initWithPlaceholderString:(NSString *)text AddTargetWithAction:(SEL)action;


+(UIView *)initWith:(UITextField *)textFiled WithTitle:(NSString *)title;


+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//我的行程 右上角的BarButtonItem
+ (UIButton *)initButtonWithTitle:(NSString *)title andupOfImg:(UIImage *)img addTargetWithAction:(SEL)action;

+ (UILabel *)initLabelWithTitle:(NSString *)title forFont:(CGFloat)font withTextColor:(UIColor *)textColor;

+ (UIButton *)initButtonWithTitle:(NSString *)title ;


//酒店选择的时候button
+ (UILabel *)initWithTitle:(NSString *)title withFont:(CGFloat)font;

+ (UIButton *)initButtonWithTitle:(NSString *)title
                   WithSystemFont:(CGFloat)font;

+ (NSString *)strOrEmpty:(NSString *)str;

/*判断数据是否符合我们的数据类型
 ---data:表示传入的数据
 ---dataclass:表示希望得到的CLass
 ---返回希望得到的class，如果data数据不符合，就new一个新的对象返回
 */
+ (id)judgeDataWithClassData:(id)data withClass:(id)dataClass;


+(UIButton *)initWithTitle:(NSString *)title addAction:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/* 根据NSDate得到星期*/
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

/*NSDate的到日期多少号*/
+ (NSString *)dayStringFromDate:(NSDate *)inputDate;

/*NSString 转NSDate*/
+ (NSDate*)returnTimeFromInputDate:(NSString *)dateString;

/*NSDate 转NSString*/
+ (NSString *)returnTimeStringFromDate:(NSDate *)inputDate;

/*今天明天后天，超过后天返回周几**/
+ (NSString*)weekdayOrDayStringFromDate:(NSDate*)inputDate;
@end
