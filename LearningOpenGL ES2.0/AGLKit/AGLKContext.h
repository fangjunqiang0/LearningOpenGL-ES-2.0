//
//  AGLKContext.h
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/18.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKContext : EAGLContext {
    GLKVector4 _clearColorRGBA;
}

@property (nonatomic, assign) GLKVector4 clearColorRGBA;

- (void)clear:(GLbitfield)mask;
@end
