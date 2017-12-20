//
//  Ch2_2_ViewController.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/14.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "Ch2_2_ViewController.h"
#import "AGLKit.h"

@interface Ch2_2_ViewController ()

@end

@implementation Ch2_2_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    AGLKView *aglkView = [[AGLKView alloc]initWithFrame:self.view.frame
                                                 context:[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2]] ;
    
    [self.view addSubview:aglkView];
    
    [aglkView disPlay];
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
