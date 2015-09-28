//
//  GesturePasswordForeView.m
//  GesturePasswordDemo
//
//  Created by 杨毅辉 on 15/9/27.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import "GesturePasswordForeView.h"
#import "GesturePasswordButton.h"

@interface GesturePasswordForeView ()

@property (strong, nonatomic) NSMutableArray *dataArray;//存储数据

@property (strong, nonatomic) NSMutableArray *touchedArray;//是否按过

@property (assign, nonatomic) CGPoint lineStartPoint;

@property (assign, nonatomic) CGPoint lineEndPoint;

@property (assign, nonatomic) BOOL success;

@end

@implementation GesturePasswordForeView

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.dataArray = [[NSMutableArray alloc] init];
        self.touchedArray = [[NSMutableArray alloc] init];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        self.success = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPoint;
    UITouch *touch = [touches anyObject];
    [self.dataArray removeAllObjects];
    [self.touchedArray removeAllObjects];
//    [touchBeginDelegate gestureTouchBegin];
    self.success = YES;
    
    if (touch) {
        
        touchPoint = [touch locationInView:self];
        for (NSInteger i = 0; i < self.buttonArray.count; i++) {
            
            GesturePasswordButton *buttonTemp = ((GesturePasswordButton *)[self.buttonArray objectAtIndex:i]);
            [buttonTemp setSuccess:YES];
            [buttonTemp setSelected:NO];
            
            if (CGRectContainsPoint(buttonTemp.frame,touchPoint)) {
                
                CGRect frameTemp = buttonTemp.frame;
                CGPoint point = CGPointMake(frameTemp.origin.x + frameTemp.size.width/2,frameTemp.origin.y + frameTemp.size.height/2);
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",point.x],@"x",[NSString stringWithFormat:@"%f",point.y],@"y", nil];
                [self.dataArray addObject:dict];
                self.lineStartPoint = touchPoint;
            }
            [buttonTemp setNeedsDisplay];
        }
        
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPoint;
    UITouch *touch = [touches anyObject];
    
    if (touch) {
        
        touchPoint = [touch locationInView:self];
        
        for (NSInteger i = 0; i < self.buttonArray.count; i++) {
            
            GesturePasswordButton *buttonTemp = ((GesturePasswordButton *)[self.buttonArray objectAtIndex:i]);
            
            if (CGRectContainsPoint(buttonTemp.frame,touchPoint)) {
                
                if ([self.touchedArray containsObject:[NSString stringWithFormat:@"num%@",@(i)]]) {
                    
                    self.lineEndPoint = touchPoint;
                    [self setNeedsDisplay];
                    return;
                }
                
                [self.touchedArray addObject:[NSString stringWithFormat:@"num%@",@(i)]];
                [buttonTemp setSelected:YES];
                [buttonTemp setNeedsDisplay];
                
                CGRect frameTemp = buttonTemp.frame;
                CGPoint point = CGPointMake(frameTemp.origin.x + frameTemp.size.width / 2,frameTemp.origin.y + frameTemp.size.height / 2);
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",point.x],@"x",[NSString stringWithFormat:@"%f",point.y],@"y",[NSString stringWithFormat:@"%@",@(i)],@"num", nil];
                [self.dataArray addObject:dict];
                break;
            }
        }
        self.lineEndPoint = touchPoint;
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSMutableString *resultString = [NSMutableString string];
    
    for (NSDictionary *num in self.dataArray) {
        
        if(![num objectForKey:@"num"])break;
        [resultString appendString:[num objectForKey:@"num"]];
    }
    
    if (self.style == GesturePasswordHandleVerification) {
        
        self.success = [self.verificationDelegate verificationPassword:resultString];
    } else {
        
        self.success = [self.resetDelegate resetPassword:resultString];
    }
    
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        
        NSInteger selection = [[[self.dataArray objectAtIndex:i] objectForKey:@"num"] integerValue];
        GesturePasswordButton *buttonTemp = ((GesturePasswordButton *)[self.buttonArray objectAtIndex:selection]);
        [buttonTemp setSuccess:self.success];
        [buttonTemp setNeedsDisplay];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    //    if (touchesArray.count<2)return;
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (![[self.dataArray objectAtIndex:i] objectForKey:@"num"]) { //防止过快滑动产生垃圾数据
            
            [self.dataArray removeObjectAtIndex:i];
            continue;
        }
        
        if (self.success) {
            
            CGContextSetRGBStrokeColor(context, 2/255.f, 174/255.f, 240/255.f, 0.7);//线条颜色
        } else {
            
            CGContextSetRGBStrokeColor(context, 208/255.f, 36/255.f, 36/255.f, 0.7);//红色
        }
        
        CGContextSetLineWidth(context,5);
        CGContextMoveToPoint(context, [[[self.dataArray objectAtIndex:i] objectForKey:@"x"] floatValue], [[[self.dataArray objectAtIndex:i] objectForKey:@"y"] floatValue]);
        
        if (i < self.dataArray.count - 1) {
            
            CGContextAddLineToPoint(context, [[[self.dataArray objectAtIndex:i+1] objectForKey:@"x"] floatValue],[[[self.dataArray objectAtIndex:i+1] objectForKey:@"y"] floatValue]);
        } else {
            
            if (self.success) {
                
                CGContextAddLineToPoint(context,self.lineEndPoint.x,self.lineEndPoint.y);
            }
        }
        CGContextStrokePath(context);
    }
}

- (void)enterAgain {
    
    [self.dataArray removeAllObjects];
    [self.touchedArray removeAllObjects];
    
    for (NSInteger i = 0; i < self.buttonArray.count; i++) {
        
        GesturePasswordButton *buttonTemp = ((GesturePasswordButton *)[self.buttonArray objectAtIndex:i]);
        [buttonTemp setSelected:NO];
        [buttonTemp setSuccess:YES];
        [buttonTemp setNeedsDisplay];
    }
    
    [self setNeedsDisplay];
}

@end
