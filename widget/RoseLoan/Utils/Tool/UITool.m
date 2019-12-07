//
//  UITool.m
//  NativeJialebao
//
//  Created by 0X10 on 16/7/18.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "UITool.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@implementation UITool



+ (UILabel *)withTitle:(NSString * )title
        withTitleColor:( UIColor * )titleColor
          setLabelFont:( CGFloat )font
         initWithFrame:(CGRect)frame{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    label.numberOfLines = 0;
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    
    CGSize size = [title boundingRectWithSize:CGSizeMake(frame.size.width,10000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    if (size.height>frame.size.height) {
        label.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height+1);
    }
    
    label.font = [UIFont systemFontOfSize:font];
    
    //default textColor is blackColor
    
    if (title==nil) {
        label.textColor = [UIColor blackColor];
    }else
        label.textColor  = titleColor;
    
    if (title==nil) {
        label.text = @"";
    }
    
    label.text = title;
    
    return label;
}



+ (UILabel *)numLabelwithTitle:(NSString *)title
                withTitleColor:(UIColor *)titleColor
                 withNumberStr:(NSString *)numStr
                      setColor:(UIColor *)numColor
                  withGoodUnit:(NSString *)unit
                  setLabelFont:(CGFloat)font
                 initWithFrame:(CGRect)frame{
    
    UILabel *goodsLabel = [[UILabel alloc]init];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    label.numberOfLines = 1;
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    
    CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,frame.size.height) options:  NSStringDrawingUsesLineFragmentOrigin  attributes:attribute context:nil].size;
    
    label.text = title;
    
    label.font = [UIFont systemFontOfSize:font ];
    
    label.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width+1, frame.size.height);
    
    label.textColor = titleColor;
    // number lable
    UILabel *numLabel = [[UILabel alloc]init];
    
    numLabel.text = numStr;
    
    numLabel.textColor = numColor;
    
    numLabel.font = [UIFont systemFontOfSize:font];
    
    numLabel.numberOfLines = 1;
    
    CGSize numSize = [title boundingRectWithSize:CGSizeMake(1000,frame.size.height) options: NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    numLabel.frame = CGRectMake(label.frame.origin.x+label.frame.size.width, label.frame.origin.y, numSize.width+1,frame.size.height);
    
    // unit
    UILabel *unitLabel = [[UILabel alloc]init];
    
    unitLabel.text = unit;
    
    unitLabel.textColor = titleColor;
    
    
    unitLabel.font = [UIFont systemFontOfSize:font];
    
    CGSize unitSize = [unit boundingRectWithSize:CGSizeMake(1000,frame.size.height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    unitLabel.numberOfLines = 1;
    
    unitLabel.frame = CGRectMake(numLabel.frame.origin.x+numLabel.frame.size.width, frame.origin.y, unitSize.width+1, frame.size.height);
    
    goodsLabel.frame = CGRectMake(frame.origin.x, frame.origin.y,size.width+numSize.width+unitSize.width+3,frame.size.height);
    
    [goodsLabel addSubview:label];
    [goodsLabel addSubview:numLabel];
    [goodsLabel addSubview:unitLabel];
    
    return goodsLabel;
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                    forStatus:(UIControlState)titleStatus
               withTitleColor:(UIColor *)titleColor
                    forStatus:(UIControlState)titleColorStatus
                 setLabelFont:(CGFloat)font
            setBackgroudImage:(UIImage *)image
                    forStatus:(UIControlState)status
           setBackgroundColor:(UIColor *)bgcolor
                initWithFrame:(CGRect)frame{
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    
    [button setTitle:title forState:titleStatus];
    
    [button setTitleColor:titleColor forState:titleColorStatus];
    
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    
    [button setBackgroundImage:image forState:status];
    
    [button setBackgroundColor:bgcolor];
    
    return button;
}

+ (CGSize)returnLabelSizeWithTitle:(NSString *)title withAttributeSystemFont:(CGFloat)font forMaxSize:(CGSize)maxSize{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    
    CGSize size = [title boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    NSMutableArray *selectArr = [[NSMutableArray alloc]init];
    
    static id myChoose ;
    
    for (id select in selectArr) {
        
        myChoose = select;
        
    }
    
    //相当于
    
    myChoose = selectArr.lastObject;
    
    
    return size;
}


+ (UIButton *)initButtonWithTitle:(NSString *)title
                          withImg:(UIImage *)img
                        forStatus:(UIControlState)status
                        withFrame:(CGRect)frame{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    
    label.text = title ;
    
    [label sizeToFit];
    
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(label.frame.size.height, 0,label.frame.size.height, label.frame.size.height)];
    
    imageview.image = img ;
    
    UIView *btnBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, label.frame.size.width+label.frame.size.height,label.frame.size.height)];
    
    [btnBg addSubview:imageview];
    [btnBg addSubview:label];
    
    btnBg.center = btn.center;
    
    [btn addSubview:btnBg];
    
    
    
    return btn;
}

+ (UIButton *)initWithTitle:(NSString *)title
                  forStatus:(UIControlState)status
                  addAction:(SEL)action
           forControlEvents:(UIControlEvents)controlEvents{
    
    UIButton *btn = [[UIButton alloc]init];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn addTarget:nil action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

+(UITextField *)initWithPlaceholderString:(NSString *)text AddTargetWithAction:(SEL)action {
    
    UITextField *filed = [[UITextField alloc]init];
    
    filed.placeholder = text;
    
    [filed setFont:[UIFont systemFontOfSize:14.f]];
    
    //    [filed setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [filed setValue:kText_Color7 forKeyPath:@"_placeholderLabel.textColor"];
    
    //    [filed setValue:@0.5 forKeyPath:@"_placeholderLabel.alpha"];
    
    
    //    [filed setTextColor:[UIColor whiteColor]];
    [filed setTextColor:[UIColor blackColor]];
    
    [filed addTarget:nil action:action forControlEvents:UIControlEventEditingChanged];
    
    return filed;
}

+(UIView *)initWith:(UITextField *)textFiled WithTitle:(NSString *)title {
    
    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,55)];
    
    textFiled = [[UITextField alloc]initWithFrame:CGRectMake(46,20, SCREEN_WIDTH-2*46, 18)];
    
    textFiled.placeholder = title;
    
    textFiled.rightViewMode = UITextFieldViewModeWhileEditing;
    
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
    
    [textFiled setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    [textFiled setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [textFiled setValue:@0.5 forKeyPath:@"_placeholderLabel.alpha"];
    
    [view addSubview:textFiled];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(46, 54, SCREEN_WIDTH-2*46, 1)];
    
    //    line.backgroundColor = [UIColor whiteColor];
    line.backgroundColor = [UIColor blackColor];
    
    line.alpha = 0.5;
    
    line.tag = 10011;
    
    [textFiled addTarget:nil action:@selector(changelineColor:) forControlEvents:UIControlEventEditingChanged];
    
    [view addSubview:line];
    
    return view;
    
}



+(UITextField *)initWithPlaceholderString:(NSString *)text {
    
    UITextField *filed = [[UITextField alloc]init];
    
    
    filed.placeholder = text;
    
    [filed setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    [filed setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [filed setValue:@0.5 forKeyPath:@"_placeholderLabel.alpha"];
    
    //    [filed setTextColor:[UIColor whiteColor]];
    [filed setTextColor:[UIColor blackColor]];
    
    return filed;
}

- (void)changelineColor:(UITextField *)textfield{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIView *view = [app.window viewWithTag:10011];
    
    
    if (textfield.text.length>0) {
        view.alpha = 1;
    }else
        view.alpha = 0.5;
    
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
    
}

+ (UIButton *)initButtonWithTitle:(NSString *)title andupOfImg:(UIImage *)img addTargetWithAction:(SEL)action{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imgview  = [[UIImageView alloc]initWithFrame:CGRectMake(9, 0, 22, 16)];
    imgview.image = img;
    [btn addSubview:imgview];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,24, 40,16)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:titleLabel];
    
    [btn addTarget:nil action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

+ (UILabel *)initLabelWithTitle:(NSString *)title forFont:(CGFloat)font withTextColor:(UIColor *)textColor{
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:font];
    label.text = title;
    return label;
}



+ (UIButton *)initButtonWithTitle:(NSString *)title {
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    return btn;
}


/**
 *  酒店的Button
 */

+ (UILabel *)initWithTitle:(NSString *)title withFont:(CGFloat)font{
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    [label setTextColor:[UIColor grayColor]];
    return label;
}

+(UIButton *)initButtonWithTitle:(NSString *)title
                  WithSystemFont:(CGFloat)font{
    
    UIButton *button = [[UIButton alloc]init];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:font]];
    
    return button;
}

+(UIButton *)initWithTitle:(NSString *)title addAction:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
    UIButton *button = [[UIButton alloc]init];
    
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:nil action:action forControlEvents:controlEvents];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 20;
    
    button.layer.backgroundColor = kPrimaryColor1.CGColor;
    
    return button;
}

+ (NSString *)strOrEmpty:(NSString *)str{
    
    if ([str isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",str];
    }
    
    if (str == nil | str == NULL | [str isKindOfClass:[NSNull class]] || ![str isKindOfClass:[NSString class]]) {
        return @"";
    }
    return str;
}

+ (id)judgeDataWithClassData:(id)data withClass:(id)dataClass{
    
    if (data == nil | data == NULL | [data isKindOfClass:[NSNull class]] || ![data isKindOfClass:dataClass]) {
        return [dataClass new];
    }
    return data;
}


//返回周几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
//返回多少号
+ (NSString *)dayStringFromDate:(NSDate *)inputDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    return  [formatter stringFromDate:inputDate];
}

+ (NSDate*)returnTimeFromInputDate:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    NSDate *resDate = [formatter dateFromString:dateString];
    
    return resDate;
}

+ (NSString *)returnTimeStringFromDate:(NSDate *)inputDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return  [formatter stringFromDate:inputDate];
}


+ (NSString*)weekdayOrDayStringFromDate:(NSDate*)inputDate {
    
    
    NSDate *currentDate = [[NSDate date]dateByAddingTimeInterval:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00.0"];
    NSString *dayString = [formatter stringFromDate:currentDate];
    
    NSDate *baseDate = [UITool returnTimeFromInputDate:dayString];
    
    NSTimeInterval time = [inputDate timeIntervalSinceDate:baseDate];
    
    if (time>=0 & time<oneDay) {
        return @"今天";
    }else if (time >= oneDay & time<oneDay *2){
        return @"明天";
    }else if (time >= oneDay*2 & time<oneDay*3){
        return @"后天";
    }
    
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (void)dealloc{
    
    
}

@end
