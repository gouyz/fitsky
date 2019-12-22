//
//  QUProgressView.m
//  AliyunVideo
//
//  Created by dangshuai on 17/3/7.
//  Copyright (C) 2010-2017 Alibaba Group Holding Limited. All rights reserved.
//

#import "QUProgressView.h"

@implementation QUProgressView {
    NSTimer *_timer;
    NSInteger _times;
    CGFloat _progress;
    CGFloat _lineWidth;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.34];
        [self defaultParam];
    }
    return self;
}

- (void)defaultParam {
    _pointArray = [NSMutableArray arrayWithCapacity:0];
    _lineWidth = CGRectGetHeight(self.bounds) * [UIScreen mainScreen].scale;
    _colorNotice = [UIColor whiteColor];
    _colorProgress = [UIColor grayColor];
    _colorSepatorPoint = [UIColor whiteColor];
    _colorSelect = [UIColor orangeColor];
    _selectedIndex = -1;
}

- (void)setShowBlink:(BOOL)showBlink {
    _showBlink = showBlink;
    [self destroyTimer];
    if (_showBlink) {
        [self startTimer];
    }
}

- (void)setShowNoticePoint:(BOOL)showNoticePoint {
    _showNoticePoint = showNoticePoint;
}

- (void)destroyTimer {
    [_timer invalidate];
    _timer = nil;
    
}

- (void)setVideoCount:(NSInteger)videoCount {
    
    if (!_showBlink) {
        if(videoCount == _videoCount-1) {
            return;
        }
    }
    if (_videoCount-1 < videoCount) {
        [_pointArray addObject:@(_progress)];
    } else {
        [_pointArray removeLastObject];
    }
    NSLog(@"_progressArr:%@",_pointArray);
    _videoCount = videoCount < 0 ? 0 : _pointArray.count;
    _selectedIndex = -1;
}

- (void)updateProgress:(CGFloat)progress {
    _progress = progress;
    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
}

- (void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self
                                            selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, _lineWidth);
    if (_pointArray.count <=0) {
        [_pointArray addObject:@(0)];
        _videoCount =1;
    }
    CGFloat w = CGRectGetWidth(self.superview.bounds);
    for (int i = 0; i < _pointArray.count; i++) {
        CGFloat sp = [_pointArray[i] floatValue];
        if (i == _selectedIndex) {
            CGContextSetStrokeColorWithColor(context, _colorSelect.CGColor);
        } else {
            CGContextSetStrokeColorWithColor(context, _colorProgress.CGColor);
        }
        CGFloat x = sp / _maxDuration * w;
        CGContextMoveToPoint(context, x, 0);
        x = _progress / _maxDuration * w;
        CGContextAddLineToPoint(context, x, 0);
        CGContextStrokePath(context);
    }
    for (int i = 0; i < _pointArray.count; i++) {
        CGFloat p = [_pointArray[i] floatValue];
        CGContextSetStrokeColorWithColor(context, _colorSepatorPoint.CGColor);
        CGFloat x = p / _maxDuration * w;
        CGContextMoveToPoint(context, x - 1, 0);
        CGContextAddLineToPoint(context, x, 0);
        CGContextStrokePath(context);
    }
    
    if (_showNoticePoint && [self shouldShowNotice]) {
        CGContextSetStrokeColorWithColor(context, _colorNotice.CGColor);
        CGContextMoveToPoint(context, w * _minDuration/_maxDuration, 0);
        CGContextAddLineToPoint(context, w * _minDuration/_maxDuration + 1,0);
        CGContextStrokePath(context);
    }
    
    if ( _showBlink && (_showBlink ? ++_times : (_times=1)) && (_times%2 == 1)) {
        
        CGFloat x = [self endPointX];
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.34].CGColor);
        CGContextMoveToPoint(context, x + 0.5, 0);
        CGContextAddLineToPoint(context, x + 4, 0);
        CGContextStrokePath(context);
    }
}

- (CGFloat)endPointX {
    return _progress / _maxDuration * CGRectGetWidth(self.bounds);
}

- (BOOL)shouldShowNotice {
    return _progress < _minDuration;
}

-(void)reset {
    [_pointArray removeAllObjects];
    [self updateProgress:0];
}

@end
