//
//  DBHRootViewController.m
//  DBHSideslipMenu
//
//  Created by 邓毕华 on 2017/11/10.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHRootViewController.h"

#import "DBHWindow.h"

@interface DBHRootViewController ()

@property (nonatomic, assign) BOOL isBestLeft; // 是否为最左边

@end

@implementation DBHRootViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"侧滑Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
}

#pragma mark - UI
- (void)setUI {
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"showLeftView" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToLeftBarButtonItem)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // 添加拖动手势
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPanGR:)];
    [self.navigationController.view addGestureRecognizer:panGR];
}

#pragma mark - Event Responds
/**
 点击showLeftView按钮
 */
- (void)respondsToLeftBarButtonItem {
    DBHWindow *window = (DBHWindow *)[UIApplication sharedApplication].keyWindow;
    [window showLeftViewAnimation];
}
/**
 拖动手势调用的方法
 */
- (void)respondsToPanGR:(UIPanGestureRecognizer *)panGR {
    CGPoint clickPoint = [panGR locationInView:self.navigationController.view];
    CGPoint position = [panGR translationInView:self.navigationController.view];
    
    // 手势触摸开始
    if (panGR.state == UIGestureRecognizerStateBegan) {
        // 判断手势起始点是否在最左边区域
        self.isBestLeft = clickPoint.x < LEFTMAXWIDTH;
    }
    
    DBHWindow *window = (DBHWindow *)[UIApplication sharedApplication].keyWindow;
    
    // 手势触摸结束
    if (panGR.state == UIGestureRecognizerStateEnded) {
        if (position.x > MAXEXCURSION * 0.5) {
            [window showLeftViewAnimation];
        } else {
            [window hiddenLeftViewAnimation];
        }
        
        return;
    }
    
    // 判断是否滑出屏幕外或者拖动手势起始点是否在最左侧区域
    if (position.x < 0 || position.x > MAXEXCURSION || !self.isBestLeft) {
        return;
    }
    
    [window showLeftViewAnimationWithExcursion:position.x];
}

#pragma mark - Getters And Setters
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"点击了第%ld行", _selectedIndex] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
