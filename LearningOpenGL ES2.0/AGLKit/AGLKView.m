//
//  AGLKView.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/15.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "AGLKView.h"
#import <QuartzCore/QuartzCore.h>


@implementation AGLKView

/**
 Cocoa Touch调用此方法来确定创建什么类型的层

 @return CAEAGLLayer类型的CoreAnimation层
 */
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}



/**
 初始化方法

 @param frame frame
 @param aContext 上下文
 @return AGLKView实例
 */
- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext;
{
    if ((self = [super initWithFrame:frame]))
    {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.drawableProperties =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithBool:NO],
         kEAGLDrawablePropertyRetainedBacking,
         kEAGLColorFormatRGBA8,
         kEAGLDrawablePropertyColorFormat,
         nil];
        
        self.context = aContext;
    }
    
    return self;
}



/**
当从xib或stroyboard文件加载， Cocoa Touch 自动调用此方法

 @param coder coder
 @return  AGLKView实例
 */
- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder]))
    {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.drawableProperties =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithBool:NO],
         kEAGLDrawablePropertyRetainedBacking,
         kEAGLColorFormatRGBA8,
         kEAGLDrawablePropertyColorFormat,
         nil];
    }
    
    return self;
}



/**
 重写OpenGL ES 上下文的set方法，删除旧的上下文，创建新的上下文

 @param aContext OpenGl ES 上下文
 */
- (void)setContext:(EAGLContext *)aContext
{
    if(_context != aContext)
    {  // 删除上下文中所有的缓存
        [EAGLContext setCurrentContext:_context];
        
        if (0 != defaultFrameBuffer)
        {
            glDeleteFramebuffers(1, &defaultFrameBuffer); // Step 7
            defaultFrameBuffer = 0;
        }
        
        if (0 != colorRenderBuffer)
        {
            glDeleteRenderbuffers(1, &colorRenderBuffer); // Step 7
            colorRenderBuffer = 0;
        }
        
        if (0 != depthRenderBuffer)
        {
            glDeleteRenderbuffers(1, &depthRenderBuffer); // Step 7
            depthRenderBuffer = 0;
        }
        
        _context = aContext;
        
        if(nil != _context)
        {  //创建新的上下文及缓存
            _context = aContext;
            [EAGLContext setCurrentContext:_context];
            
            glGenFramebuffers(1, &defaultFrameBuffer);    // Step 1
            glBindFramebuffer(                            // Step 2
                              GL_FRAMEBUFFER,
                              defaultFrameBuffer);
            
            glGenRenderbuffers(1, &colorRenderBuffer);    // Step 1
            glBindRenderbuffer(                           // Step 2
                               GL_RENDERBUFFER,
                               colorRenderBuffer);
            
            //将颜色缓存 绑定到绑定帧缓存
            glFramebufferRenderbuffer(
                                      GL_FRAMEBUFFER,
                                      GL_COLOR_ATTACHMENT0,
                                      GL_RENDERBUFFER,
                                      colorRenderBuffer);
            [self layoutSubviews];
        }
    }
}

/**
 重写OpenGL ES Context的get方法

 @return OpenGL ES Context
 */
- (EAGLContext *)context
{
    return _context;
}


/**
 设置试图的上下文为当前上下文，告诉OpenGL ES让渲染填满整个缓存帧
 调用-drawRect：方法实现OpenGL ES函数进行真正的绘图
 然后上下文调整外观并使用Core Animation合成器把帧缓存的像素颜色渲染缓存与其他相关层混合起来
 */
- (void)display;
{
    [EAGLContext setCurrentContext:self.context];
    //glViewport（）函数可以用来控制渲染至帧缓存的子集，但是这个例子中使用的是整个帧缓存
    glViewport(0, 0, _drawableWidth, _drawableHeight);
    
    [self drawRect:[self bounds]];
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}




/**
 当收到需要重新绘制OpenGLES frame缓存时，-drawRect：这个方法会被自动调用
这个方法不应该被直接调用，但是在调用-drawRect之前 调用-disPlay配置OpenGL ES
 @param rect rect
 */
- (void)drawRect:(CGRect)rect
{
    if([self.delegate respondsToSelector:@selector(glkView:drawInRect:)])
    {
        [self.delegate glkView:self drawInRect:[self bounds]];
    }
}


/**
 当UIView被调整大小时 这方法会被自动调用（也包括view被添加到一个window）
 */
- (void)layoutSubviews
{
    CAEAGLLayer     *eaglLayer = (CAEAGLLayer *)self.layer;
    

    [EAGLContext setCurrentContext:self.context];
    
    //调整视图缓存的尺寸以匹配层的新尺寸
    [self.context renderbufferStorage:GL_RENDERBUFFER
                         fromDrawable:eaglLayer];
    
    
    if (0 != depthRenderBuffer)
    {
        glDeleteRenderbuffers(1, &depthRenderBuffer); // Step 7
        depthRenderBuffer = 0;
    }
    
    GLint currentDrawableWidth = _drawableWidth;
    GLint currentDrawableHeight = _drawableHeight;
    
    if(self.drawableDepthFormat !=
       AGLKViewDrawableDepthFormatNone &&
       0 < currentDrawableWidth &&
       0 < currentDrawableHeight)
    {
        glGenRenderbuffers(1, &depthRenderBuffer); // Step 1
        glBindRenderbuffer(GL_RENDERBUFFER,        // Step 2
                           depthRenderBuffer);
        glRenderbufferStorage(GL_RENDERBUFFER,     // Step 3
                              GL_DEPTH_COMPONENT16,
                              currentDrawableWidth,
                              currentDrawableHeight);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER,  // Step 4
                                  GL_DEPTH_ATTACHMENT,
                                  GL_RENDERBUFFER,
                                  depthRenderBuffer);
    }
    

    // 检查配置缓存的错误
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
    
    if(status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete frame buffer object %x", status);
    }
    
    // 使颜色渲染缓存显示当前缓存。
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
}



/**
 drawableWidth 属性get方法

 @return drawableWidth
 */
- (NSInteger)drawableWidth;
{
    GLint backingWidth;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                                 GL_RENDERBUFFER_WIDTH,
                                 &backingWidth);
    
    return (NSInteger)backingWidth;
}



/**
 drawableHeight 属性get方法

 @return drawableHeight
 */
- (NSInteger)drawableHeight;
{
    GLint backingHeight;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                                 GL_RENDERBUFFER_HEIGHT,
                                 &backingHeight);
    
    return (NSInteger)backingHeight;
}



- (void)dealloc
{

    if ([EAGLContext currentContext] == _context)
    {
        [EAGLContext setCurrentContext:nil];
    }

    _context = nil;
}

@end

