//
//  MarkedImageView.m
//  TidusWWDemo
//
//  Created by Tidus on 17/1/18.
//  Copyright © 2017年 Tidus. All rights reserved.
//

#import "MarkedImageView.h"

@interface MarkedImageView ()

@end

@implementation MarkedImageView

#pragma mark - Life Cycle
- (instancetype)init
{
    self = [super init];
    [self setup];
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    [self setup];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup
{
    
    self.userInteractionEnabled = YES;
    _tagViews = [NSMutableArray array];
    _editable = NO;
    _showed = NO;
    //手势
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage:)];
//    tapGesture.cancelsTouchesInView = YES;
//    [self addGestureRecognizer:tapGesture];
    
}

#pragma mark - setter
- (void)setImage:(UIImage *)image
{
    [super setImage:image];
}
- (void)setEditable:(BOOL)editable
{
    if (_editable) {
        //手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage:)];
        tapGesture.cancelsTouchesInView = YES;
        [self addGestureRecognizer:tapGesture];
    }
}

#pragma mark - 手势、点击
- (void)didTapImage:(UITapGestureRecognizer *)recognizer
{
    
    if(_editable){
        //新建标签
        CGPoint position = [recognizer locationInView:self];
        //判断是否要新建标签，如果任何标签的文字或中心点包含了这个点，则不创建
        if([self pointInsideAnyTagView:position]){
            return;
        }
        //创建TagViewModel
        CGPoint coordinate = CGPointMake(position.x/self.frame.size.width, position.y/self.frame.size.height);
        TagViewModel *viewModel = [[TagViewModel alloc] initWithArray:nil coordinate:coordinate];
        viewModel.index = -1;
        self.markedImageDidTapBlock(viewModel);
    }else{
        //显示、隐藏标签
        if(_showed){
            [self hideTagViews];
        }else{
            [self showTagViews];
        }
    }
}

/**
 *  判断点的位置是否在某个tagView中
 */
- (BOOL)pointInsideAnyTagView:(CGPoint)point
{
    for (TagView *tagView in _tagViews) {
        BOOL inside = [tagView pointInside:point];
        if(inside){
            return YES;
        }
    }
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    //如果当前不可编辑，则拦截所有点击事件，并返回自己，无需继续往下寻找响应view
//    if(!_editable && view){
//        return self;
//    }
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    return inside;
}

#pragma mark - public
- (void)createTagView:(NSMutableArray<TagViewModel *> *)viewModels
{
    [self.tagViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagViews removeAllObjects];
    
    NSUInteger index = 0;
    for(TagViewModel *viewModel in viewModels){
        //重新编号
        viewModel.index = index;
        index++;
        
        //生成标签
        TagView *tagView = [[TagView alloc] initWithTagModel:viewModel];
        __weak typeof(self) wself = self;
        tagView.userInteractionEnabled = YES;
        tagView.textDidTapBlock = ^(TagView *tagView){
            wself.markedImageDidTapBlock(tagView.viewModel);
        };
        tagView.longPressBlock = ^(TagView *tagView){
            wself.deleteTagViewBlock(tagView.viewModel);
        };
        
        //持有标签
        [self.tagViews addObject:tagView];
        [self addSubview:tagView];
        
    }
}

- (void)showTagViews
{
    for(TagView *view in self.tagViews){
        view.viewHidden = NO;
    }
    _showed = YES;
}

- (void)hideTagViews
{
    for(TagView *view in self.tagViews){
        view.viewHidden = YES;
    }
    _showed = NO;
}

@end
