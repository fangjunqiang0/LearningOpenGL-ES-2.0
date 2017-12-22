//
//  AGLKContext.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/18.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "AGLKContext.h"

@implementation AGLKContext


/**
设置帧缓存中的每一个像素的颜色为背景色

 @param mask GLbitfield类型
 */
- (void)clear:(GLbitfield)mask {
    NSAssert(self == [[self class]currentContext], @"Receiving context required to be current context");
    glClear(mask);
}

/**
 clearColor属性set方法
 这个方法设置清晰的RGBA背景颜色

 @param clearColor GLKVector4类型
 */
- (void)setClearColor:(GLKVector4)clearColor {
    _clearColor = clearColor;
    
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context");
    
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
}


/**
 clearColor属性get方法

 @return GLKVector4类型
 */
- (GLKVector4)clearColor
{
    return _clearColor;
}
@end
