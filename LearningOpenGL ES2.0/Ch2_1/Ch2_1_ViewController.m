//
//  Ch2_1_ViewController.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/14.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "Ch2_1_ViewController.h"



typedef struct {
    GLKVector3 positionCoords;//GLKVector3 类型保存了3个坐标X Y Z；
    
}SenceVertex;//C结构体

//vertices变量是一个用顶点数据初始化的普通C数组，这个变量用于定义一个三角形
//OpenGL 可见坐标系X、Y、Z轴范围区间为 [-1,1]
static const SenceVertex vertices[] = {
    {-0.5f,-0.5f, 0.0},//左下
    { 0.5f,-0.5f, 0.0},//右下
    {-0.5f, 0.5f, 0.0}//左上
};

@interface Ch2_1_ViewController ()<GLKViewDelegate>
{
    GLuint vertexBufferID;//vertexBufferID变量保存了本例用到的顶点数据的缓存的OpenGL ES 唯一标识符；
}

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) GLKView *glkView;

@end

@implementation Ch2_1_ViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建GLKView 并分配一个新的EAGLContext实例
    //kEAGLRenderingAPIOpenGLES2 使用OpenGL ES2.0 还有1.0/3.0
    _glkView = (GLKView *)self.view;
    _glkView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    
    //设置OpenGL ES运算将要用到的上下文
    [EAGLContext setCurrentContext:_glkView.context];
    

    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);//C数据结构体设置颜色 分别为 R G B A
    
    //设置OpenGL上下文“清除颜色”
    glClearColor(0.0, 0.0, 0.0, 1.0);//不透明黑色
    
    //step 1 为缓存生成一个独一无二的标识符，
    //第一个参数指定要生成的缓存标识符的数量，
    //第二个参数为指针指向生成的标识符的内存保存位置
    glGenBuffers(1, &vertexBufferID);
    
    //step 2 为接下来的运算绑定指定标示符的缓存到当前缓存，
    //第一个参数指定要绑定哪一种类型的缓存（两种缓存 GL_ARRAY_BUFFER和GL_ELEMENT_ARRAY_BUFFER) GL_ARRAY_BUFFER指定一个顶点类型数组
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    
    //step 3 复制顶点数据到当前上下文所绑定的顶点缓存中，
    //第一个参数指定要更新当前上下文中所绑定的是哪一个缓存。
    //第二个参数指定要复制进这个缓存的字节数量。
    //第三个参数是要复制的字节的地址。
    //第四个参数提示这个缓存在将来的运算中被怎么使用。
    //GL_STATIC_DRAW 告诉上下文 缓存中的内容适合复制到GPU控制的内存，因为很少对其修改
    //GL_DYNAMIC_DRAW 告诉上下文 数据会频繁变动 同时提示OPenGL ES以不同的方式处理缓存的存储
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [EAGLContext setCurrentContext:_glkView.context];
    
    if (0 != vertexBufferID) {
        //step 7 删除不在需要的顶点缓存和上下文
        glDeleteBuffers(1, &vertexBufferID);
        //设置vertexBufferID = 0; 避免缓存被删除后还使用无效的标识符
        vertexBufferID = 0;
    }
    
    [_glkView removeFromSuperview];
    [EAGLContext setCurrentContext:nil];
    
}

#pragma mark - GLKView delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    //glClear() 函数会有效地设置帧缓存中的每一个像素的颜色为背景色
    glClear(GL_COLOR_BUFFER_BIT);
    
    //step4 启动顶点缓存渲染操作
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    //step5 glVertexAttribPointer() 函数告诉OpenGl ES 顶点数据在哪里，以及怎么解释为每个顶点保存的数据
    //第一个参数 指示当前绑定的缓存包包含每个顶点的位置信息
    //第二个参数 指示每个位置有3个备份
    //第三个参数 告诉OpenGL ES 每个部分都保存浮点类型的数据
    //第四个参数 告诉OpenGL ES 小数点固定数据是否可以被改变
    //第五个参数叫做“步幅” 他指定每个顶点保存需要多少个字节
    //第六个参数 null告诉OpenGL ES 可以从当前绑定的顶点缓存的开始位置访问顶点数据
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SenceVertex),
                          NULL);
    //step 6 绘图
    //第一个参数 告诉GPU怎么处理在顶点缓存内的顶点数据，这个例子是绘制一个三角形
    //第二个参数 需要渲染的第一个顶点的位置
    //第三个参数 需要渲染的顶点的数量
    glDrawArrays(GL_TRIANGLES,
                 0,
                 3);
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
