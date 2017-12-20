//
//  Ch3_3_ViewController.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/19.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "Ch3_3_ViewController.h"
#import "AGLKit.h"
#import <GLKit/GLKit.h>
typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}SceneVertex;

static SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

/////////////////////////////////////////////////////////////////
// Define defualt vertex data to reset vertices when needed
static const SceneVertex defaultVertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

/////////////////////////////////////////////////////////////////
// Provide storage for the vectors that control the direction
// and distance that each vertex moves per update when animated
static GLKVector3 movementVectors[3] = {
    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
};

@interface Ch3_3_ViewController ()

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (nonatomic) BOOL shouldUseLinearFilter;
@property (nonatomic) BOOL shouldAnimate;
@property (nonatomic) BOOL shouldRepeatTexture;
@property (nonatomic) GLfloat sCoordinateOffset;
@end

@implementation Ch3_3_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    GLKView *glkView = (GLKView *)self.view;
    
    glkView.context = [[AGLKContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [AGLKContext setCurrentContext:glkView.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    ((AGLKContext *)glkView.context).clearColorRGBA = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:sizeof(SceneVertex)
                                                                numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)
                                                                            data:vertices
                                                                           usage:GL_STATIC_DRAW];
    
    CGImageRef imageRef = [UIImage imageNamed:@"grid"].CGImage;
    
    
    //    此处相对于Ch3_1例子 使用了自定义的 AGLKTextureInfo、AGLKTextureLoader两个类
    AGLKTextureInfo *textInfo = [AGLKTextureLoader textureWithCGImage:imageRef
                                                              options:nil
                                                                error:nil];
    
    self.baseEffect.texture2d0.name   = textInfo.name;
    self.baseEffect.texture2d0.target = textInfo.target;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
}
#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:3];
    
}
/////////////////////////////////////////////////////////////////
// This method is called by a user interface object configured
// in Xcode and updates the value of the sCoordinateOffset
// property to demonstrate how texture coordinates affect
// texture mapping to geometry
- (IBAction)takeSCoordinateOffsetFrom:(UISlider *)sender
{
    self.sCoordinateOffset = [sender value];
}


/////////////////////////////////////////////////////////////////
// This method is called by a user interface object configured
// in Xcode and updates the value of the shouldRepeatTexture
// property to demonstrate how textures are clamped or repeated
// when mapped to geometry with texture coordinates outside the
// range 0.0 to 1.0.
- (IBAction)takeShouldRepeatTextureFrom:(UISwitch *)sender
{
    self.shouldRepeatTexture = [sender isOn];
}


/////////////////////////////////////////////////////////////////
// This method is called by a user interface object configured
// in Xcode and updates the value of the shouldAnimate
// property to demonstrate how texture coordinates affect
// texture mapping and visual distortion as geometry changes.
- (IBAction)takeShouldAnimateFrom:(UISwitch *)sender
{
    self.shouldAnimate = [sender isOn];
}


/////////////////////////////////////////////////////////////////
// This method is called by a user interface object configured
// in Xcode and updates the value.
- (IBAction)takeShouldUseLinearFilterFrom:(UISwitch *)sender
{
    self.shouldUseLinearFilter = [sender isOn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/////////////////////////////////////////////////////////////////
// Update the current OpenGL ES context texture wrapping mode
- (void)updateTextureParameters
{
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_WRAP_S
                                           value:(self.shouldRepeatTexture ? GL_REPEAT : GL_CLAMP_TO_EDGE)];
    
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_MAG_FILTER
                                           value:(self.shouldUseLinearFilter ? GL_LINEAR : GL_NEAREST)];
}


/////////////////////////////////////////////////////////////////
// Update the positions of vertex data to create a bouncing
// animation
- (void)updateAnimatedVertexPositions
{
    if(self.shouldAnimate)
    {  // Animate the triangles vertex positions
        int    i;  // by convention, 'i' is current vertex index
        
        for(i = 0; i < 3; i++)
        {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if(vertices[i].positionCoords.x >= 1.0f ||
               vertices[i].positionCoords.x <= -1.0f)
            {
                movementVectors[i].x = -movementVectors[i].x;
            }
            vertices[i].positionCoords.y += movementVectors[i].y;
            if(vertices[i].positionCoords.y >= 1.0f ||
               vertices[i].positionCoords.y <= -1.0f)
            {
                movementVectors[i].y = -movementVectors[i].y;
            }
            vertices[i].positionCoords.z += movementVectors[i].z;
            if(vertices[i].positionCoords.z >= 1.0f ||
               vertices[i].positionCoords.z <= -1.0f)
            {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
    }
    else
    {  // Restore the triangle vertex positions to defaults
        int    i;  // by convention, 'i' is current vertex index
        
        for(i = 0; i < 3; i++)
        {
            vertices[i].positionCoords.x =
            defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y =
            defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z =
            defaultVertices[i].positionCoords.z;
        }
    }
    
    
    {  // Adjust the S texture coordinates to slide texture and
        // reveal effect of texture repeat vs. clamp behavior
        int    i;  // 'i' is current vertex index
        
        for(i = 0; i < 3; i++)
        {
            vertices[i].textureCoords.s =
            (defaultVertices[i].textureCoords.s +
             self.sCoordinateOffset);
        }
    }
}


/////////////////////////////////////////////////////////////////
// Called automatically at rate defined by view controller’s
// preferredFramesPerSecond property
- (void)update
{
    [self updateAnimatedVertexPositions];
    [self updateTextureParameters];

    [self.vertexBuffer reinitWithAttribStride:sizeof(SceneVertex)
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                                   bytes:vertices];
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
