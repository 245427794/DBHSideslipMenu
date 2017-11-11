//
//  DBHWindow.h
//  DBHSideslipMenu
//
//  Created by 邓毕华 on 2017/11/10.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBHWindow : UIWindow

/**
 显示左侧视图动画
 */
- (void)showLeftViewAnimation;

/**
 隐藏左侧视图动画
 */
- (void)hiddenLeftViewAnimation;

/**
 显示左侧视图动画
 
 @param excursion 偏移宽度
 */
- (void)showLeftViewAnimationWithExcursion:(CGFloat)excursion;

@end
