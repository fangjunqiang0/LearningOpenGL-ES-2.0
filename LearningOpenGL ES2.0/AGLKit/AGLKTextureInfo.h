//
//  AGLKTextureInfo.h
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/18.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface AGLKTextureInfo : NSObject
{
    @private
    GLuint _name;
    GLuint _target;
    GLuint _width;
    GLuint _height;
}

@property (nonatomic, readonly) GLuint name;
@property (nonatomic, readonly) GLenum target;
@property (nonatomic, readonly) GLuint width;
@property (nonatomic, readonly) GLuint height;

-(instancetype)initWithName:(GLuint)name target:(GLenum)target width:(GLuint)width height:(GLuint)height;
@end
