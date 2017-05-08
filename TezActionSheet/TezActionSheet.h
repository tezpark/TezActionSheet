//
//  TezActionSheet.h
//  TezActionSheetExample
//
//  Created by Taesun Park on 2015. 5. 28..
//  Copyright (c) 2015년 TezLab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionSheetSelectBlock) (NSInteger index);
typedef void (^ActionSheetCancelBlock) (void);

@interface TezActionSheet : UIView

@property (nonatomic, copy) ActionSheetSelectBlock selectBlock;
@property (nonatomic, copy) ActionSheetCancelBlock cancelBlock;

/**
 *  TezActionSheet singleton
 *
 *  @return Singleton object
 */
+(TezActionSheet *)sharedInstance;

/**
 *  Show action sheet with select & cancel button titles and select & cancel blocks.
 *
 *  @param selectButtonTitles Select button titles text
 *  @param cancelButtonTitle  Cancel button title text
 *  @param selectBlock        Select block (return selected index)
 *  @param cancelBlock        Cancel block
 */
- (void)showActionSheetWithSelectButtonTitles:(NSArray *)selectButtonTitles
                            cancelButtonTitle:(NSString *)cancelButtonTitle
                                  selectBlock:(ActionSheetSelectBlock)selectBlock
                                  cancelBlock:(ActionSheetCancelBlock)cancelBlock
                              enableAnimation:(BOOL)enableAnimation;

@end
