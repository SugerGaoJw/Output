//
//  NSPropertyMacro.h
//  baseProject
//
//  Created by Suger on 15/10/18.
//  Copyright © 2015年 Li. All rights reserved.
//
//  对于一些通用的属性进行宏定义

#ifndef NSPropertyMacro_h
#define NSPropertyMacro_h

// 懒加载宏定义
#define g_lazyload_func(func_name___,__func_type___) \
- (__func_type___ *)func_name___ { \
    if (_##func_name___ == nil) { \
    _##func_name___ = [[__func_type___ alloc]init]; \
    } \
    return _##func_name___; \
}\


#endif /* NSPropertyMacro_h */
