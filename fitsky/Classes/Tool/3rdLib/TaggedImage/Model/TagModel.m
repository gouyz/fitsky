//
//  TagModel.m
//  TidusWWDemo
//
//  Created by Tidus on 17/1/18.
//  Copyright © 2017年 Tidus. All rights reserved.
//

#import "TagModel.h"

@implementation TagModel

- (instancetype)initWithName:(NSString *)name value:(NSString *)value valueType:(NSString *)valueType
{

    if(self=[super init]){
        _name = name;
        _value = value;
        _valueType = valueType;
    }
    
    return self;
    
}

@end
