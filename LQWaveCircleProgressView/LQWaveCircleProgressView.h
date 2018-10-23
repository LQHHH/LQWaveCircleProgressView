//
//  LQWaveCircleProgressView.h
//  TestDemo
//
//  Created by hongzhiqiang on 2018/10/22.
//  Copyright © 2018 hhh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQWaveCircleProgressView : UIView

@property (nonatomic, assign) CGFloat progress; //0.0 - 1
@property (nonatomic, strong) UIColor * waveColor; //水浪颜色,默认浅蓝色
@property (nonatomic, strong) UIColor * textColor; //字体颜色,默认白色
@property (nonatomic, strong) UIFont * textFont; //字体大小,默认大小

- (void)startLoadView;


@end


