//
//  Ch3_2_ViewController.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/18.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "Ch3_2_ViewController.h"
#import "AGLKit.h"
#import <GLKit/GLKit.h>

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}ScenceVertex;

static const ScenceVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // 左下
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // 右下
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // 左上
};

@interface Ch3_2_ViewController ()<GLKViewDelegate>

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@end

@implementation Ch3_2_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GLKView *glkView = (GLKView *)self.view;
    
    glkView.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];

    [AGLKContext setCurrentContext:glkView.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    ((AGLKContext *)glkView.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:sizeof(ScenceVertex)
                                                                numberOfVertices:sizeof(vertices)/sizeof(ScenceVertex)
                                                                            data:vertices
                                                                           usage:GL_STATIC_DRAW];
    
    CGImageRef imageRef = [UIImage imageNamed:@"leaves"].CGImage;
    
    
//    此处相对于Ch3_1例子 使用了自定义的 AGLKTextureInfo、AGLKTextureLoader两个类
    AGLKTextureInfo *textInfo = [AGLKTextureLoader textureWithCGImage:imageRef
                                                              options:nil
                                                                error:nil];

    self.baseEffect.texture2d0.name   = textInfo.name;
    self.baseEffect.texture2d0.target = textInfo.target;
    

    

}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(ScenceVertex, positionCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(ScenceVertex, textureCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
