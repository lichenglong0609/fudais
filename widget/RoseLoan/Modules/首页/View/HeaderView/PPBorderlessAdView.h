//
//  PPBorderlessAdView.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/18.
//  Copyright © 2019 cython. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBorderlessAdView : UIView
@property (nonatomic,strong)NSArray *imageDatas;
@property (nonatomic, strong) void(^clickBanner)(NSInteger index);
-(void)loadData:(NSArray *)banners;
@end

NS_ASSUME_NONNULL_END
