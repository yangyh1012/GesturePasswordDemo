//
//  GesturePasswordMainView.m
//  GesturePasswordDemo
//
//  Created by 杨毅辉 on 15/9/27.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import "GesturePasswordMainView.h"

@implementation GesturePasswordMainView

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        134 / 255.0, 157 / 255.0, 147 / 255.0, 1.00,
        3 / 255.0,  3 / 255.0, 37 / 255.0, 1.00,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
                                kCGGradientDrawsBeforeStartLocation);
}

@end
