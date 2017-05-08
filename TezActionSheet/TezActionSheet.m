//
//  TezActionSheet.m
//  TezActionSheetExample
//
//  Created by Taesun Park on 2015. 5. 28..
//  Copyright (c) 2015년 TezLab. All rights reserved.
//

#import "TezActionSheet.h"
#import "NSString+TezSize.h"

#define font(size)      [UIFont systemFontOfSize: size]
#define kMargin(size)   size
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed: ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green: ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue: ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1]
#define UIColorFromRGBAlpha50(rgbValue) [UIColor colorWithRed: ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green: ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue: ((float)(rgbValue & 0xFF)) / 255.0 alpha: 0.5]

static const CGFloat buttonHeight = 53.0f;
static const CGFloat largeSeparatorHeight = 3.0f;
static const CGFloat smallSeparatorHeight = 1.0f;

@interface TezActionSheet ()
@property (nonatomic, strong) UIView* baseView;
@property (nonatomic, assign) BOOL enableAnimation;
@property (nonatomic, assign) CGFloat contentsHeight;
@end

@implementation TezActionSheet

#pragma mark - Singleton
+ (TezActionSheet *)sharedInstance {
	static TezActionSheet *_sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[TezActionSheet alloc] init];
	});

	return _sharedInstance;
}

- (void)showActionSheetWithSelectButtonTitles:(NSArray *)selectButtonTitles
                            cancelButtonTitle:(NSString *)cancelButtonTitle
                                  selectBlock:(ActionSheetSelectBlock)selectBlock
                                  cancelBlock:(ActionSheetCancelBlock)cancelBlock
                              enableAnimation:(BOOL)enableAnimation {
    // Setting blocks
    self.selectBlock = selectBlock;
    self.cancelBlock = cancelBlock;
    
    // Setting enable animation
    self.enableAnimation = enableAnimation;
    
    // If already added this view, remove from super view.
    for (id view in [self subviews]) {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];
    self.baseView = nil;
    
    // Create background alpha view.
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = UIColorFromRGBAlpha50(0x000000);
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;


    // Calculator contents height
    self.contentsHeight = (([selectButtonTitles count] * buttonHeight) + largeSeparatorHeight + buttonHeight);

    // Make base view
    self.baseView = [[UIView alloc] init];
    CGRect baseViewFrame = self.bounds;
    if (enableAnimation) {
        baseViewFrame.origin.y = baseViewFrame.size.height + _contentsHeight;
    } else {
        baseViewFrame.origin.y = baseViewFrame.size.height - _contentsHeight;
    }
    baseViewFrame.size.height = _contentsHeight;
    _baseView.frame = baseViewFrame;

    // Create select buttons
    for (NSInteger sIndex = 0; sIndex < selectButtonTitles.count; sIndex++) {
        UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                      sIndex * buttonHeight,
                                                                      self.frame.size.width,
                                                                      buttonHeight)];
        [selBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [selBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0x919191)] forState:UIControlStateHighlighted];
        [selBtn setTitle:[selectButtonTitles objectAtIndex:sIndex] forState:UIControlStateNormal];
        [selBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selBtn addTarget:self action:@selector(onClickSelect:) forControlEvents:UIControlEventTouchUpInside];
        [selBtn setTag:sIndex];
        [_baseView addSubview:selBtn];
        
        if ((sIndex + 1) != [selectButtonTitles count]) {
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(kMargin(20),
                                                                         CGRectGetMaxY(selBtn.frame) - smallSeparatorHeight,
                                                                         (self.frame.size.width - kMargin(20) * 2),
                                                                         smallSeparatorHeight)];
            [separator setBackgroundColor:[UIColor blackColor]];
            [_baseView addSubview:separator];
        }
    }

    // Create separator between select buttons to cancel button
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 selectButtonTitles.count * buttonHeight,
                                                                 self.frame.size.width,
                                                                 largeSeparatorHeight)];
    [separator setBackgroundColor:[UIColor blackColor]];
    [_baseView addSubview:separator];

    // Create cancel button
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     _baseView.frame.size.height - buttonHeight,
                                                                     self.frame.size.width,
                                                                     buttonHeight)];
    [cancelBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0x919191)] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onClickCancel) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:cancelBtn];
    [self addSubview:_baseView];
    
    [self show];
}

#pragma mark - Show & Dismiss

- (void)show {
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    [topWindow addSubview:self];
    if (_enableAnimation) {
        CGRect baseViewFrame = _baseView.frame;
        baseViewFrame.origin.y = self.frame.size.height - _contentsHeight;
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _baseView.frame = baseViewFrame;
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

- (void)dismiss {
    if (_enableAnimation) {
        CGRect baseViewFrame = _baseView.frame;
        baseViewFrame.origin.y = self.frame.size.height + _contentsHeight;
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _baseView.frame = baseViewFrame;
                         }
                         completion:^(BOOL finished){
                             [self removeFromSuperview];
                         }];
    } else {
        [self removeFromSuperview];
    }
}

#pragma mark - Click actions
- (void)onClickSelect:(id)sender {
    UIButton *selectedButton = (UIButton *)sender;
    NSInteger index = selectedButton.tag;
    _selectBlock(index);
    
    [self dismiss];
}

- (void)onClickCancel {
    _cancelBlock();
    
    [self dismiss];
}

#pragma mark -  UIImage from a UIColor
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
