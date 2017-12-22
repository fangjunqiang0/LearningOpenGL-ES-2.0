//
//  Ch3_5_ViewController.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/20.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "Ch3_5_ViewController.h"
#import "AGLKit.h"

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static const SceneVertex vertices[] = {
    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},  // 第一个三角形
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},  // 第二个三角形
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},
};

@interface Ch3_5_ViewController ()

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@end

@implementation Ch3_5_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    GLKView *glkView = (GLKView *)self.view;
    NSAssert([glkView isKindOfClass:[GLKView class]], @"Ch3_5_ViewController`s view is not GLKView!");
    
    glkView.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [AGLKContext setCurrentContext:glkView.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    ((AGLKContext *)glkView.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:sizeof(SceneVertex)
                                                                numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)
                                                                            data:vertices usage:GL_STATIC_DRAW];
    
    CGImageRef imageRef = [UIImage imageNamed:@"leaves.gif"].CGImage;
    
    GLKTextureInfo *textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef
                                                                options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil]
                                                                  error:nil];
    self.baseEffect.texture2d0.name = textureInfo0.name;
    self.baseEffect.texture2d0.target = textureInfo0.target;
    
    CGImageRef imageRef1 = [UIImage imageNamed:@"beetle"].CGImage;
    
    GLKTextureInfo *textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1
                                                                options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil]
                                                                  error:nil];
    self.baseEffect.texture2d1.name = textureInfo1.name;
    self.baseEffect.texture2d1.target = textureInfo1.target;
    self.baseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;
    
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord1
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    [self.baseEffect prepareToDraw];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)];
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
