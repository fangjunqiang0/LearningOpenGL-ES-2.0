//
//  GLKEffectPropertyTexture+AGLKAdditions.h
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/19.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface GLKEffectPropertyTexture (AGLKAdditions)
- (void)aglkSetParameter:(GLenum)parameterID value:(GLint)value;
@end
