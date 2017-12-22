//
//  AGLKVertexAttribArrayBuffer.h
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/18.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

//AGLKVertexAttribArrayBuffer类封装了使用OpenGL ES 2.0的顶点属性数组缓存的7个步骤（生成、绑定、缓存数据、启用或禁止、设置指针、绘图、删除）

@interface AGLKVertexAttribArrayBuffer : NSObject {
    GLsizeiptr _stride;
    GLsizeiptr _bufferSizeBytes;
    GLuint     _glName;
}

@property (nonatomic, readonly) GLuint glName;//标识符
@property (nonatomic, readonly) GLsizeiptr bufferSizeBytes;//缓存字节长度
@property (nonatomic, readonly) GLsizeiptr stride;//步幅 每个顶点的字节长度

/**
 初始化
 在当前OpenGL ES线程的上下文，此方法创建一个顶点属性数组缓存

 @param stride 步幅
 @param count 顶点数组元素数量
 @param dataPtr 字节数据地址
 @param usage 怎么使用缓存数据
 @return AGLKVertexAttribArrayBuffer实例
 */
- (instancetype)initWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizei)count data:(const GLvoid *)dataPtr usage:(GLenum)usage;

/**
 准备绘图的操作
 当应用程序使用缓存呈现任何几何图形时，必须准备一个顶点属性数组缓存。
 当你的应用程序准备一个缓存时，一些OpenGL ES状态被改变，允许绑定缓存和配置指针。

 @param index 顶点属性
 @param count 坐标属性数量
 @param offset 访问顶点缓存开始位置的偏移量
 @param shouldEnble 启用或暂停渲染操作（本例子中只包含启用YES）
 */
- (void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnble;

/**
 绘图
 提交由模式标识的绘图命令，并指示OpenGL ES从准备好的缓冲区中的顶点开始，从先前准备好的缓冲区中使用计数顶点

 @param mode 绘图的模式
 @param first 开始顶点的位置
 @param count 顶点的数量
 */
- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count;


/**
 重新加载数据

 @param stride 步幅
 @param count 顶点数组元素数量
 @param dataPtr 字节数据地址
 */
- (void)reinitWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr;
@end
