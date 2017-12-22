//
//  AGLKVertexAttribArrayBuffer.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/18.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@interface AGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign) GLsizeiptr stride;

@end


@implementation AGLKVertexAttribArrayBuffer

/**
 初始化
 在当前OpenGL ES线程的上下文，此方法创建一个顶点属性数组缓存
 
 @param stride 步幅
 @param count 顶点数组元素数量
 @param dataPtr 字节数据地址
 @param usage 怎么使用缓存数据
 @return AGLKVertexAttribArrayBuffer实例
 */
- (instancetype)initWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizei)count data:(const GLvoid *)dataPtr usage:(GLenum)usage
{
    NSParameterAssert(0 < stride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    
    self = [super init];
    if (self) {
        self.stride = stride;
        self.bufferSizeBytes = stride * count;//缓存数据字节长度 = 步幅 * 数组元素数量
        
        glGenBuffers(1, &_glName);//step 1 生成
        
        glBindBuffer(GL_ARRAY_BUFFER, self.glName);//step 2 绑定数据
        
        glBufferData(GL_ARRAY_BUFFER, self.bufferSizeBytes, dataPtr, usage);//step 3 缓存数据
        
        NSAssert(0 != _glName, @"Failed to generate glName");
    }
    return self;
}
/**
 准备绘图的操作
 当应用程序使用缓存呈现任何几何图形时，必须准备一个顶点属性数组缓存。
 当你的应用程序准备一个缓存时，一些OpenGL ES状态被改变，允许绑定缓存和配置指针。
 
 @param index 顶点属性
 @param count 坐标属性数量
 @param offset 访问顶点缓存开始位置的偏移量
 @param shouldEnble 启用或暂停渲染操作（本例子中只包含启用YES）
 */
- (void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnble {
    
    NSParameterAssert(0 < count && count < 4);
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != _glName, @"Invalid glName");
    
    glBindBuffer(GL_ARRAY_BUFFER, self.glName);
    
    if (shouldEnble) {
        glEnableVertexAttribArray(index);//step 4 启用
    }
    
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, (GLsizei)_stride, NULL + offset);//step 5 设置指针
#ifdef DEBUG
    {  // 报告任何错误
        GLenum error = glGetError();
        if(GL_NO_ERROR != error)
        {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
}
/**
 绘图
 提交由模式标识的绘图命令，并指示OpenGL ES从准备好的缓冲区中的顶点开始，从先前准备好的缓冲区中使用计数顶点
 
 @param mode 绘图的模式
 @param first 开始顶点的位置
 @param count 顶点的数量
 */
- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count {
    NSAssert(self.bufferSizeBytes >= (first + count) * self.stride, @"Attempt to draw more vertex data than available");
    
    glDrawArrays(mode, first, count);//step 6 绘制
}

/**
 重新加载数据
 
 @param stride 步幅
 @param count 顶点数组元素数量
 @param dataPtr 字节数据地址
 */
- (void)reinitWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr {
    NSParameterAssert(0 < stride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    NSAssert(0 != _glName, @"Invalid name");
    
    self.stride = stride;
    self.bufferSizeBytes = stride * count;
    
    glBindBuffer(GL_ARRAY_BUFFER, self.glName); // STEP 2 绑定
    glBufferData(GL_ARRAY_BUFFER, _bufferSizeBytes, dataPtr, GL_DYNAMIC_DRAW); //step 3 缓存数据
}
- (void)dealloc
{
    
    if (0 != _glName)
    {
        glDeleteBuffers (1, &_glName); // Step 7 删除
        _glName = 0;
    }
}
@end
