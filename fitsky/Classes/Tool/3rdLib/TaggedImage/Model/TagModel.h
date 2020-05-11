//
//  TagModel.h
//  TidusWWDemo
//
//  Created by Tidus on 17/1/18.
//  Copyright © 2017年 Tidus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TagModel : NSObject

//文本
@property (nonatomic, copy) NSString *name;
// 标签内容ID（tag_type = 1-表示场馆ID）
@property (nonatomic, copy) NSString *value;
// 标签类型（0-自定义文字 1-场馆）
@property (nonatomic, copy) NSString *valueType;

//角度
@property (nonatomic, assign) CGFloat angle;

//文本位置
@property (nonatomic, assign) CGSize textSize;
@property (nonatomic, assign) CGPoint textPosition;

//初始化
- (instancetype)initWithName:(NSString *)name value:(NSString *)value valueType:(NSString *)valueType;

@end
