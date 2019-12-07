//
// GFPlaceholderView.h
// Version 1.0
//
// Copyright (c) 2014 - 2015 Giovanni Filaferro ( http://www.nanotek.it/ ). All Rights Reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

#define kGRAY_COLOR [UIColor colorWithRed:0.56 green:0.56 blue:0.58 alpha:1.0]

#import "GFPlaceholderView.h"


@interface GFPlaceholderView () {
    UILabel *titleLabel;
    UITextView *descriptionTextView;
    
    UILabel *loadingLabel;
    UIImageView *loadImageView;
    
    UIImageView *imageView;
}

@end

@implementation GFPlaceholderView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.hidden = YES;
        
        self.backgroundColor = [UIColor whiteColor];

        [self commonInit];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.hidden = YES;
        
        self.backgroundColor = [UIColor whiteColor];

        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.hidden = YES;
        
        self.backgroundColor = [UIColor whiteColor];

        [self commonInit];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self commonInit];
}

#pragma mark - My Methods
- (void)commonInit {
    
    self.autoresizesSubviews = NO;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    //[self drawBorder:nil];
    
    
    
    loadImageView = [[UIImageView alloc]init];
    loadImageView.frame = CGRectMake((self.frame.size.width - 36)/2, (self.frame.size.height - 36 - 60)/2, 36, 36);
    
    NSArray *imageArray = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"Loading.bundle/loading1.png"],[UIImage imageNamed:@"Loading.bundle/loading2.png"],[UIImage imageNamed:@"Loading.bundle/loading3.png"],[UIImage imageNamed:@"Loading.bundle/loading4.png"],[UIImage imageNamed:@"Loading.bundle/loading5.png"],[UIImage imageNamed:@"Loading.bundle/loading6.png"],[UIImage imageNamed:@"Loading.bundle/loading7.png"],[UIImage imageNamed:@"Loading.bundle/loading8.png"],[UIImage imageNamed:@"Loading.bundle/loading9.png"],[UIImage imageNamed:@"Loading.bundle/loading10.png"],[UIImage imageNamed:@"Loading.bundle/loading11.png"],[UIImage imageNamed:@"Loading.bundle/loading12.png"],[UIImage imageNamed:@"Loading.bundle/loading13.png"], nil];
    loadImageView.animationImages = imageArray;
    [self addSubview:loadImageView];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [loadingLabel setText:@"正在努力加载..."];
    [loadingLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [loadingLabel setTextColor:kGRAY_COLOR];

    loadingLabel.textAlignment = NSTextAlignmentCenter;
    
    loadingLabel.frame = CGRectMake(0, loadImageView.frame.size.height + loadImageView.frame.origin.y, self.frame.size.width, 60);
    loadingLabel.alpha = 0.0f;
    [self addSubview:loadingLabel];
    
    
//    Placeholder View
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.frame.size.height/2-20, self.frame.size.width-50, 20)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:kGRAY_COLOR];
    [titleLabel setFont:[UIFont systemFontOfSize:22.0f]];
    titleLabel.alpha = 0.0f;
    [self addSubview:titleLabel];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 80)/2, self.frame.size.height/2 - 50, 80, 80)];
    imageView.alpha = 0.0f;
    [self addSubview:imageView];
        
    descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, imageView.frame.size.height+imageView.frame.origin.y , self.frame.size.width-40, 20)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        descriptionTextView.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.58 alpha:0.7];
        [descriptionTextView setFont:[UIFont systemFontOfSize:16.0f]];
        [descriptionTextView setUserInteractionEnabled:NO];
        [descriptionTextView setBackgroundColor:[UIColor clearColor]];
        [descriptionTextView setTextAlignment:NSTextAlignmentCenter];
        [descriptionTextView setContentInset:UIEdgeInsetsZero];
        CGFloat fixedWidth = descriptionTextView.frame.size.width;
        CGSize newSize = [descriptionTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = descriptionTextView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        descriptionTextView.frame = newFrame;
    });
    
    [self addSubview:descriptionTextView];
    [descriptionTextView layoutIfNeeded];
    
}

- (void)showLoadingView {
    
    self.hidden = NO;
    
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.alpha = 1.0f;
        loadingLabel.alpha = 1.0f;
        loadImageView.alpha = 1.0f;
        [loadImageView startAnimating];
        
        descriptionTextView.alpha = 0.0f;
        titleLabel.alpha = 0.0f;
        imageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)showViewWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle {
    
    self.hidden = NO;

    titleLabel.text = title;
    descriptionTextView.text = subtitle;
    
    CGFloat fixedWidth = descriptionTextView.frame.size.width;
    CGSize newSize = [descriptionTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = descriptionTextView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    descriptionTextView.frame = newFrame;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1.0f;
        loadingLabel.alpha = 0.0f;
        loadImageView.alpha = 0.0f;
        [loadImageView stopAnimating];
        
        descriptionTextView.alpha = 1.0f;
        titleLabel.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showViewWithImage:(UIImage *)image andSubtitle:(NSString *)subtitle{
    
    self.hidden = NO;
    
    
    imageView.image = image;
    descriptionTextView.text = subtitle;
    descriptionTextView.alpha = 0.0f;
    
    CGFloat fixedWidth = descriptionTextView.frame.size.width;
    CGSize newSize = [descriptionTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = descriptionTextView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    descriptionTextView.frame = newFrame;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1.0f;
        loadingLabel.alpha = 0.0f;
        loadImageView.alpha = 0.0f;
        imageView.alpha = 1.0;
        [loadImageView stopAnimating];
        
        descriptionTextView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)showViewWithNoImageWithSubtitle:(NSString *)subtitle{

    
    self.hidden = NO;
    
    
    descriptionTextView.text = subtitle;
    descriptionTextView.alpha = 0.0f;
    imageView.alpha = 0.0;
    
    CGFloat fixedWidth = descriptionTextView.frame.size.width;
    CGSize newSize = [descriptionTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = descriptionTextView.frame;
    newFrame.origin = CGPointMake(newFrame.origin.x, (self.frame.size.height - newFrame.size.height)/2);
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    descriptionTextView.frame = newFrame;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1.0f;
        loadingLabel.alpha = 0.0f;
        loadImageView.alpha = 0.0f;
        [loadImageView stopAnimating];
        descriptionTextView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showEmptyDataViewWithSubtitle:(NSString*)subtitle{
    
    [self showViewWithImage:[UIImage imageNamed:@"Main.bundle/pic_search"] andSubtitle:subtitle];
    
}

- (void)showEmptyDataViewNotImageWithSubtitle:(NSString*)subtitle{

    [self showViewWithNoImageWithSubtitle:subtitle];
}

- (void)showNoNetWorkViewWithSubtitle:(NSString *)subtitle{
    [self showViewWithImage:[UIImage imageNamed:@"Book.bundle/loading_failed"] andSubtitle:subtitle];
}

- (void)hide {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.0f;
        [loadImageView stopAnimating];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)hideNoAnimation{

    self.alpha = 0.0f;
    [loadImageView stopAnimating];
    self.hidden = YES;
}

@end
