//
//  ViewController.m
//  TestDemo
//
//  Created by hongzhiqiang on 2018/10/22.
//  Copyright © 2018 hhh. All rights reserved.
//

#import "ViewController.h"
#import "LQWaveCircleProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) LQWaveCircleProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.progressView startLoadView];
    
    //模拟进度
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [timer fire];
    });
    
}


- (void)onTimer{
    if (self.progressView.progress >= 1.0) {
        return;
    }
    self.progressView.progress += 0.1;
}

- (LQWaveCircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [LQWaveCircleProgressView new];
        _progressView.frame = CGRectMake(0, 0, 200, 200);
        _progressView.center = self.view.center;
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

@end
