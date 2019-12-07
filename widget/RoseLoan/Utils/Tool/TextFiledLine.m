//
//  TextFiledLine.m
//  UddTrip
//
//  Created by uddtrip on 16/8/6.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "TextFiledLine.h"

@interface TextFiledLine ()

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UIView *line;

@property (nonatomic,copy) UIColor *highColor;

@property (nonatomic,copy) UIColor *normalColor;

@end

@implementation TextFiledLine

-(instancetype)initWithHighStatusColor:(UIColor *)highColor withNormalColor:(UIColor *)color
{
    if (self) {
        
        self.textField = [[UITextField alloc]init];
        
        [self.textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        
        self.line = [[UIView alloc]init];
        
        [self addSubview:self.line];
        
        [self addSubview:self.textField];
        
        self.highColor = highColor;
        
        self.normalColor = color;
        
    }
    return self;
}

- (void)textFieldChange:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""]) {
        [self.line setBackgroundColor:self.normalColor];
    }else
        [self.line setBackgroundColor:self.highColor];
}

@end
