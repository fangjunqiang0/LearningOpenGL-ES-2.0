//
//  GLKEffectPropertyTexture+AGLKAdditions.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/19.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "GLKEffectPropertyTexture+AGLKAdditions.h"

@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID value:(GLint)value;
{
    glBindTexture(self.target, self.name);
    
    glTexParameteri(self.target,
                    parameterID,
                    value);
}
@end
