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


- (instancetype)initWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizei)count data:(const GLvoid *)dataPtr usage:(GLenum)usage
{
    NSParameterAssert(0 < stride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    
    self = [super init];
    if (self) {
        self.stride = stride;
        self.bufferSizeBytes = stride * count;
        
        glGenBuffers(1, &_glName);
        
        glBindBuffer(GL_ARRAY_BUFFER, self.glName);
        
        glBufferData(GL_ARRAY_BUFFER, self.bufferSizeBytes, dataPtr, usage);
        
        NSAssert(0 != _glName, @"Failed to generate glName");
    }
    return self;
}

- (void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnble {
    
    NSParameterAssert(0 < count && count < 4);
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != _glName, @"Invalid glName");
    
    glBindBuffer(GL_ARRAY_BUFFER, self.glName);
    
    if (shouldEnble) {
        glEnableVertexAttribArray(index);
    }
    
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, (GLsizei)_stride, NULL + offset);
    
}

- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count {
    NSAssert(self.bufferSizeBytes >= (first + count) * self.stride, @"Attempt to draw more vertex data than available");
    
    glDrawArrays(mode, first, count);
}


- (void)reinitWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr {
    NSParameterAssert(0 < stride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    NSAssert(0 != _glName, @"Invalid name");
    
    self.stride = stride;
    self.bufferSizeBytes = stride * count;
    
    glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
                 self.glName);
    glBufferData(                  // STEP 3
                 GL_ARRAY_BUFFER,  // Initialize buffer contents
                 _bufferSizeBytes,  // Number of bytes to copy
                 dataPtr,          // Address of bytes to copy
                 GL_DYNAMIC_DRAW);
}

@end
