//
//  NSObject+automatic.m
//  AutoDoSomething
//
//  Created by xiaomanwang on 14-2-25.
//  Copyright (c) 2014年 xiaomanwang. All rights reserved.
//
/*
 automatic do something
 somthing like log when an new instance was created,
 something like log when an object is released.
 */
#import <objc/runtime.h>
#import "NSObject+automatic.h"


static void swizzle(Class s, SEL sSelector, SEL tSelector)
{
    Method originalMethod = class_getInstanceMethod(s, sSelector);
	Method oldMethod = class_getInstanceMethod(s, tSelector);
	method_exchangeImplementations(originalMethod,oldMethod);
}


@implementation NSObject (automatic)
+ (void)load
{
	swizzle(NSClassFromString(@"NSObject"), @selector(init),@selector(selfDefinedInit));
	
#if __has_feature(objc_arc)
	
#else
	swizzle(NSClassFromString(@"NSObject"), @selector(dealloc),@selector(selfDefinedDealloc));
#endif
}

- (void)selfDefinedInit
{
	NSLog(@"%@,%@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	[self selfDefinedInit];
}

- (void)selfDefinedDealloc
{
	NSLog(@"%@,%@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	[self selfDefinedDealloc];
}

@end
