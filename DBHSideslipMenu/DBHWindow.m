//
//  DBHWindow.m
//  DBHSideslipMenu
//
//  Created by 邓毕华 on 2017/11/10.
//  Copyright © 2017年 邓毕华. All rights reserved.
//

#import "DBHWindow.h"

#import "DBHRootViewController.h"

static NSString * const kDBHTableViewCellIdentifier = @"kDBHTableViewCellIdentifier";

@interface DBHWindow ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView;

@end

@implementation DBHWindow

#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUI {
    [self addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDBHTableViewCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行", indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hiddenLeftViewAnimation];
    DBHRootViewController *rootVC = (DBHRootViewController *)self.rootViewController.childViewControllers.firstObject;
    rootVC.selectedIndex = indexPath.row;
}

#pragma mark - Event Responds
/**
 点击了右侧半透明区域
 */
- (void)respondsToShadeView {
    [self hiddenLeftViewAnimation];
}
/**
 右侧半透明区域的左滑手势
 */
- (void)respondsToPanGR:(UIPanGestureRecognizer *)panGR {
    CGPoint position = [panGR translationInView:self.shadeView];
    
    // 手势触摸结束
    if (panGR.state == UIGestureRecognizerStateEnded) {
        if (- position.x > MAXEXCURSION * 0.5) {
            [self hiddenLeftViewAnimation];
        } else {
            [self showLeftViewAnimation];
        }
        
        return;
    }
    
    // 判断是否滑出屏幕外
    if (position.x < - MAXEXCURSION || position.x > 0) {
        return;
    }
    
    [self showLeftViewAnimationWithExcursion:MAXEXCURSION + position.x];
}

#pragma mark - Public Methdos
/**
 显示左侧视图动画
 */
- (void)showLeftViewAnimation {
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.transform = CGAffineTransformTranslate(weakSelf.rootViewController.view.transform, MAXEXCURSION, 0);
        weakSelf.shadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [weakSelf addSubview:weakSelf.shadeView];
    }];
}
/**
 显示左侧视图
 
 @param excursion 偏移大小
 */
- (void)showLeftViewAnimationWithExcursion:(CGFloat)excursion {
    self.transform = CGAffineTransformTranslate(self.rootViewController.view.transform, excursion, 0);
    self.shadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5 * (excursion / MAXEXCURSION)];
    if (!self.shadeView.superview) {
        [self addSubview:self.shadeView];
    }
}
/**
 隐藏左侧视图动画
 */
- (void)hiddenLeftViewAnimation {
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.transform = CGAffineTransformIdentity;
        [weakSelf.shadeView removeFromSuperview];
    }];
}

#pragma mark - Private Methdos
/**
 重写hitTest方法，点击tableView才会响应
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (!view) {
        CGPoint newPoint = [self.tableView convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.tableView.bounds, newPoint)) {
            view = self.tableView;
        }
    }
    return view;
}

#pragma mark - Getters And Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, -MAXEXCURSION, SCREENHEIGHT)];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDBHTableViewCellIdentifier];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (UIView *)shadeView {
    if (!_shadeView) {
        _shadeView = [[UIView alloc] initWithFrame:self.bounds];
        _shadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToShadeView)];
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPanGR:)];
        [_shadeView addGestureRecognizer:tapGR];
        [_shadeView addGestureRecognizer:panGR];
    }
    return _shadeView;
}

@end
