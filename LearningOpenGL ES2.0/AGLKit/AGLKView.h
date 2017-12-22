//
//  AGLKView.h
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/15.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@class EAGLContext;
@protocol AGLKViewDelegate;



//深度缓存格式类型
typedef enum
{
    AGLKViewDrawableDepthFormatNone = 0,
    AGLKViewDrawableDepthFormat16,
} AGLKViewDrawableDepthFormat;


//创建一个AGLKView类继承于UIView，下面接口的声明于GLKView类似
@interface AGLKView : UIView
{
    EAGLContext   *_context;
    GLuint        defaultFrameBuffer;//frame缓存
    GLuint        colorRenderBuffer;//color缓存
    GLuint        depthRenderBuffer;
    GLint         _drawableWidth;
    GLint         _drawableHeight;
}

@property (nonatomic, weak)  id<AGLKViewDelegate> delegate;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, readonly) NSInteger drawableWidth;
@property (nonatomic, readonly) NSInteger drawableHeight;
@property (nonatomic) AGLKViewDrawableDepthFormat drawableDepthFormat;

/**
 设置试图的上下文为当前上下文，告诉OpenGL ES让渲染填满整个缓存帧
 调用-drawRect：方法实现OpenGL ES函数进行真正的绘图
 然后上下文调整外观并使用Core Animation合成器把帧缓存的像素颜色渲染缓存与其他相关层混合起来
 */
- (void)display;

@end


#pragma mark - AGLKViewDelegate

@protocol AGLKViewDelegate <NSObject>

@required
- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect;

@end
