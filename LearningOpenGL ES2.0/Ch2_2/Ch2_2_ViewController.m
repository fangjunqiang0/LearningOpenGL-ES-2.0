//
//  Ch2_2_ViewController.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/14.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "Ch2_2_ViewController.h"
#import "AGLKit.h"

typedef struct {
    GLKVector3 positionCoords;
}SceneVertex;

static const SceneVertex vertices[] = {
    {{-0.5f,-0.5f, 0.0}},//左下
    {{ 0.5f,-0.5f, 0.0}},//右下
    {{-0.5f, 0.5f, 0.0}}//左上
};

@interface Ch2_2_ViewController ()<AGLKViewDelegate>
{
    GLuint vertexBufferID;
}

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@end

@implementation Ch2_2_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    // Verify the type of view created automatically by the
    // Interface Builder storyboard
    AGLKView *view = (AGLKView *)self.view;
    view.delegate = self;
    
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a AGLKView");
    
    // Create an OpenGL ES 2.0 context and provide it to the
    // view
    view.context = [[EAGLContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current
    [EAGLContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
    
    // Set the background color stored in the current context
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f); // background color
    
    // Generate, bind, and initialize contents of a buffer to be
    // stored in GPU memory
    glGenBuffers(1,                // STEP 1
                 &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
                 vertexBufferID);
    glBufferData(                  // STEP 3
                 GL_ARRAY_BUFFER,  // Initialize buffer contents
                 sizeof(vertices), // Number of bytes to copy
                 vertices,         // Address of bytes to copy
                 GL_STATIC_DRAW);  // Hint: cache in GPU memory

}


#pragma mark - AGLKViewDelegate
- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    // Clear back frame buffer (erase previous drawing)
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Enable use of positions from bound vertex buffer
    glEnableVertexAttribArray(      // STEP 4
                              GLKVertexAttribPosition);
    
    glVertexAttribPointer(          // STEP 5
                          GLKVertexAttribPosition,
                          3,                   // three components per vertex
                          GL_FLOAT,            // data is floating point
                          GL_FALSE,            // no fixed point scaling
                          sizeof(SceneVertex), // no gaps in data
                          NULL);               // NULL tells GPU to start at
    // beginning of bound buffer
    
    // Draw triangles using the first three vertices in the
    // currently bound vertex buffer
    glDrawArrays(GL_TRIANGLES,      // STEP 6
                 0,  // Start with first vertex in currently bound buffer
                 3); // Use three vertices from currently bound buffer
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
