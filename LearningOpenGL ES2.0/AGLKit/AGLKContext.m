//
//  AGLKContext.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/18.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "AGLKContext.h"

@implementation AGLKContext
- (void)clear:(GLbitfield)mask {
    NSAssert(self == [[self class]currentContext], @"Receiving context required to be current context");
    glClear(mask);
}
- (void)setClearColorRGBA:(GLKVector4)clearColorRGBA {
    _clearColorRGBA = clearColorRGBA;
    
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context");
    
    glClearColor(clearColorRGBA.r, clearColorRGBA.g, clearColorRGBA.b, clearColorRGBA.a);
}

- (GLKVector4)clearColorRGBA
{
    return _clearColorRGBA;
}
@end
