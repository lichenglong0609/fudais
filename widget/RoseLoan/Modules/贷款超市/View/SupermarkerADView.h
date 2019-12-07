//
//  SupermarkerADView.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/14.
//  Copyright © 2019 cython. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SupermarkerADView : UIView
@property (nonatomic, strong) void(^clickBanner)(NSInteger index);
@property (nonatomic,strong)NSArray *imageDatas;
-(void)loadData:(NSArray *)banners;
@end
