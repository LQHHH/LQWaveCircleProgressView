//
//  LQWaveCircleProgressView.m
//  TestDemo
//
//  Created by hongzhiqiang on 2018/10/22.
//  Copyright © 2018 hhh. All rights reserved.
//

#import "LQWaveCircleProgressView.h"

@interface LQWaveCircleProgressView ()

@property (nonatomic, strong) CAShapeLayer * waveSinLayer;
@property (nonatomic, assign) NSInteger phase;
@property (nonatomic, strong) UIView * waveSinView;
@property (nonatomic, strong) UILabel *percentL;

@end

@implementation LQWaveCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)startLoadView {
    [self setupView];
}

- (void)setupView {
    [self addSubview:self.waveSinView];
    self.waveSinView.layer.mask = self.waveSinLayer;
    [self addSubview:self.percentL];
    CGFloat minRadius = MIN(self.bounds.size.width, self.bounds.size.height);
    self.layer.cornerRadius = minRadius/2;
    self.layer.masksToBounds = YES;
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateUI:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (progress > 1.0) {
        return;
    }
    [self creatAnimation];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    if (textColor) {
        self.percentL.textColor = textColor;
    }
}

- (void)setWaveColor:(UIColor *)waveColor {
    _waveColor = waveColor;
    if (waveColor) {
        self.waveSinView.backgroundColor = waveColor;
    }
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    if (textFont) {
        self.percentL.font = textFont;
    }
}


- (void)creatAnimation {
    
    CGPoint position = CGPointMake(self.waveSinLayer.position.x, (1.5-_progress)*self.bounds.size.height);
    CGPoint fromPosition = self.waveSinLayer.position;
    self.waveSinLayer.position = position;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:fromPosition];
    animation.toValue = [NSValue valueWithCGPoint:position];
    animation.duration = 0.25;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.waveSinLayer addAnimation:animation forKey:@"positionWave"];
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.25 animations:^{
        wself.percentL.center = CGPointMake(wself.bounds.size.width/2, wself.waveSinLayer.position.y-wself.bounds.size.height/2);
    } completion:^(BOOL finished) {
        wself.percentL.text = [NSString stringWithFormat:@"%.f%@",wself.progress*100,@"%"];
    }];
}

- (void)updateUI:(CADisplayLink *)displayLink {
    CGFloat scale = self.bounds.size.width/200;
    self.phase += 5*scale;
    self.waveSinLayer.path = [self path].CGPath;
}

- (UIBezierPath *)path {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat width =  CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat lastX = 0;
    for (CGFloat x = 0; x < width+1; x++) {
        CGFloat y = height*0.05*sin(2*M_PI/width*x*0.8+self.phase*2*M_PI/width)+height*0.05;
        if (x == 0) {
            [path moveToPoint:CGPointMake(x, y)];
        }
        else {
            [path addLineToPoint:CGPointMake(x, y)];
        }
        lastX = x;
        if (self.progress >= 1.0) {
           self.percentL.center = CGPointMake( self.percentL.center.x, self.bounds.size.height/2+y/2);
        }
        else {
            self.percentL.center = CGPointMake( self.percentL.center.x, self.waveSinLayer.position.y-self.bounds.size.height/2+y/2);
        }
        
    }
    
    [path addLineToPoint:CGPointMake(lastX, height)];
    [path addLineToPoint:CGPointMake(0, height)];
    return path;
}

#pragma mark - lazy

- (CAShapeLayer *)waveSinLayer {
    if (!_waveSinLayer) {
        CGFloat scale = self.bounds.size.width/200;
        _waveSinLayer = [CAShapeLayer new];
        _waveSinLayer.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-10*scale, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        _waveSinLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _waveSinLayer;
}

- (UIView *)waveSinView {
    if (!_waveSinView) {
        _waveSinView = [UIView new];
        _waveSinView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        _waveSinView.backgroundColor = [UIColor colorWithRed:41/255.0 green:240/255.0 blue:253/255.0 alpha:0.8];
    }
    return _waveSinView;
}

- (UILabel *)percentL {
    if (!_percentL) {
        _percentL = [UILabel new];
        _percentL.textColor = [UIColor whiteColor];
        _percentL.backgroundColor = [UIColor clearColor];
        _percentL.frame = CGRectMake(0, 0, self.bounds.size.width, 30);
        _percentL.textAlignment = NSTextAlignmentCenter;
        _percentL.text = [NSString stringWithFormat:@"%.f%@",self.progress*100,@"%"];
        _percentL.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 10);
    }
    return _percentL;
}

@end
