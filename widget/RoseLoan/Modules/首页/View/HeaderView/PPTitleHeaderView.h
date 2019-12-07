//
//  PPTitleHeaderView.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPTitleHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic,strong) NSString *title;
-(instancetype)loadFromNib;
@end

NS_ASSUME_NONNULL_END
