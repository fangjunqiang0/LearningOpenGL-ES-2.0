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
@class AGLKView;


@protocol AGLKViewDelegate<NSObject>

@required
- (void)aglkView:(AGLKView *)view drawInRect:(CGRect)rect;

@end


@interface AGLKView : UIView{
    GLuint      defaultFrameBuffer;
    GLuint      colorRenderBuffer;
}


@property (nonatomic, weak) id<AGLKViewDelegate> delegate;
@property (nonatomic, retain) EAGLContext *aContext;
@property (nonatomic, readonly) NSInteger drawableWidth;
@property (nonatomic, readonly) NSInteger drawableHeight;

- (void)disPlay;
- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext;
@end


