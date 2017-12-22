//
//  AGLKContext.h
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/18.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import <GLKit/GLKit.h>



@interface AGLKContext : EAGLContext {
    GLKVector4 _clearColor;
}


/**
 通过调用glClearColor（）方法设置属性
 */
@property (nonatomic, assign) GLKVector4 clearColor;

/**
 通过调用 glclear（）方法实现
 设置帧缓存中的每一个像素的颜色为背景色
 @param mask GLbitfield类型
 */
- (void)clear:(GLbitfield)mask;
@end
