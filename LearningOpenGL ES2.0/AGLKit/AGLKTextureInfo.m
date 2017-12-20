//
//  AGLKTextureInfo.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/18.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "AGLKTextureInfo.h"

@interface AGLKTextureInfo()

@end

@implementation AGLKTextureInfo

- (instancetype)initWithName:(GLuint)name target:(GLenum)target width:(GLuint)width height:(GLuint)height
{
    self = [super init];
    if (self) {
        _name = name;
        _target = target;
        _width = width;
        _height = height;
    }
    return self;
}
@end
