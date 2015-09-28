//
//  GesturePasswordButton.m
//  GesturePasswordDemo
//
//  Created by 杨毅辉 on 15/9/27.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import "GesturePasswordButton.h"

@implementation GesturePasswordButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.success = YES;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.selected) {
        
        if (self.success) {
            
            CGContextSetRGBStrokeColor(context, 2/255.f, 174/255.f, 240/255.f,1);//线条颜色
            CGContextSetRGBFillColor(context,2/255.f, 174/255.f, 240/255.f,1);
        } else {
            CGContextSetRGBStrokeColor(context, 208/255.f, 36/255.f, 36/255.f,1);//线条颜色
            CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,1);
        }
        CGRect frame = CGRectMake(self.bounds.size.width / 2 - self.bounds.size.width / 8 + 1,
                                  self.bounds.size.height / 2 - self.bounds.size.height / 8,
                                  self.bounds.size.width / 4, self.bounds.size.height / 4);
        
        CGContextAddEllipseInRect(context,frame);
        CGContextFillPath(context);
    } else {
        
        CGContextSetRGBStrokeColor(context, 1,1,1,1);//线条颜色
    }
    
    CGContextSetLineWidth(context,2);
    CGRect frame = CGRectMake(2, 2, self.bounds.size.width - 3, self.bounds.size.height - 3);
    CGContextAddEllipseInRect(context,frame);
    CGContextStrokePath(context);
    if (self.success) {
        
        CGContextSetRGBFillColor(context,30/255.f, 175/255.f, 235/255.f,0.3);
    } else {
        
        CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,0.3);
    }
    CGContextAddEllipseInRect(context,frame);
    if (self.selected) {
        
        CGContextFillPath(context);
    }
    
}

@end
