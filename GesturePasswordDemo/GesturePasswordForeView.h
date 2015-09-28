//
//  GesturePasswordForeView.h
//  GesturePasswordDemo
//
//  Created by 杨毅辉 on 15/9/27.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GesturePasswordHandle) {
    
    GesturePasswordHandleReset,
    GesturePasswordHandleVerification,
};

@protocol ResetDelegate <NSObject>

- (BOOL)resetPassword:(NSString *)result;

@end

@protocol VerificationDelegate <NSObject>

- (BOOL)verificationPassword:(NSString *)result;

@end

/**
 *  这个类负责按钮变色和数据传输
 */
@interface GesturePasswordForeView : UIView

@property (nonatomic, strong) NSArray *buttonArray;

@property (nonatomic, assign) GesturePasswordHandle style;

@property (nonatomic, assign) id<VerificationDelegate> verificationDelegate;

@property (nonatomic, assign) id<ResetDelegate> resetDelegate;

- (void)enterAgain;

@end
