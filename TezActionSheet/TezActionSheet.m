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
                                  cancelBlock:(ActionSheetCancelBlock)cancelBlock {
	// Setting blocks
	self.selectBlock = selectBlock;
	self.cancelBlock = cancelBlock;


	// If already added this view, remove from super view.
    for (id view in [self subviews]) {
        [view removeFromSuperview];
    }
	[self removeFromSuperview];


	// Create background alpha view.
	CGRect frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
	[self setFrame:frame];
	self.backgroundColor = UIColorFromRGBAlpha50(0x000000);
	self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;


	// Calculator originY
	CGFloat originY = self.frame.size.height - (([selectButtonTitles count] * buttonHeight) + largeSeparatorHeight + buttonHeight);


	// Create select buttons
	for (int sIndex = 0; sIndex < [selectButtonTitles count]; sIndex++) {
		UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, originY + (sIndex * buttonHeight), self.frame.size.width, buttonHeight)];
		[selBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
		[selBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0x919191)] forState:UIControlStateHighlighted];
		[selBtn setTitle:[selectButtonTitles objectAtIndex:sIndex] forState:UIControlStateNormal];
		[selBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[selBtn addTarget:self action:@selector(onClickSelect:) forControlEvents:UIControlEventTouchUpInside];
		[selBtn setTag:sIndex];
		[self addSubview:selBtn];

		if ((sIndex + 1) != [selectButtonTitles count]) {
			UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(kMargin(20), CGRectGetMaxY(selBtn.frame) - smallSeparatorHeight, (self.frame.size.width - kMargin(20) * 2), smallSeparatorHeight)];
			[separator setBackgroundColor:[UIColor blackColor]];
			[self addSubview:separator];
		}
	}


	// Create separator between select buttons to cancel button
	UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - buttonHeight - largeSeparatorHeight, self.frame.size.width, largeSeparatorHeight)];
	[separator setBackgroundColor:[UIColor blackColor]];
	[self addSubview:separator];



	// Create cancel button
	UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height - buttonHeight, self.frame.size.width, buttonHeight)];
	[cancelBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
	[cancelBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0x919191)] forState:UIControlStateHighlighted];
	[cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
	[cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[cancelBtn addTarget:self action:@selector(onClickCancel) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:cancelBtn];



	[self show];
}

#pragma mark - Show & Dismiss

- (void)show {
	UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];

	[topWindow addSubview:self];
}

- (void)dismiss {
	[self removeFromSuperview];
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
