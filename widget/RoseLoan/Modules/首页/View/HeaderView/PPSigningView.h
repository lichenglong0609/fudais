//
//  PPSigningView.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPSigningView : UIView
@property (nonatomic,strong) void(^signingBlok)(NSString *url);
-(instancetype)loadFromNib;
-(void)setInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
