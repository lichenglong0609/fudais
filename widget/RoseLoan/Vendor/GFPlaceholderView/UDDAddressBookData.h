//
//  UDDAddressBookData.h
//  UddTrip
//
//  Created by Chuan Liu on 16/9/3.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UDDAddressBookData : NSObject

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSArray *phoneArray;

- (NSString *)getFirstLetter;

@end
