//
//  GesturePasswordViewController.m
//  GesturePasswordDemo
//
//  Created by 杨毅辉 on 15/9/27.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import "GesturePasswordViewController.h"
#import "GesturePasswordForeView.h"

#define PASSWORD_KEY @"passWordKey"

@interface GesturePasswordViewController ()<ResetDelegate,VerificationDelegate>

@property (weak, nonatomic) IBOutlet UIView *gesturePasswordBackView;

@property (weak, nonatomic) IBOutlet GesturePasswordForeView *gesturePasswordForeView;

@property (weak, nonatomic) IBOutlet UILabel *gesturePassTip;


@property (copy, nonatomic) NSString *previousPassword;

@property (copy, nonatomic) NSString *password;

@end

@implementation GesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i=1; i<10; i++) {
        
        [buttonArray addObject:[self.gesturePasswordBackView viewWithTag:i]];
    }
    [self.gesturePasswordForeView setResetDelegate:self];
    [self.gesturePasswordForeView setVerificationDelegate:self];
    [self.gesturePasswordForeView setButtonArray:buttonArray];
    
    self.previousPassword = [self userDefaultValueWithKey:PASSWORD_KEY];
    if (!self.previousPassword ||
        [self.previousPassword isEqualToString:@""]) {
        
        [self.gesturePassTip setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        
        [self gesturePasswordForeViewSetTextWithStyle:1];
    } else {
        
        [self.gesturePassTip setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
       
        [self gesturePasswordForeViewSetTextWithStyle:2];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 按钮处理

- (IBAction)forgetPassword:(id)sender {
    
    //TODO:未实现的方法
}

#pragma mark - ResetDelegate

- (BOOL)resetPassword:(NSString *)result {
    
    if (!self.previousPassword ||
        [self.previousPassword isEqualToString:@""]) {
        
        self.previousPassword = result;
        [self.gesturePasswordForeView enterAgain];
        [self gesturePasswordForeViewSetTextWithStyle:3];
        
        return YES;
        
    } else {
        
        if ([result isEqualToString:self.previousPassword]) {
            
            [self setUserDefaultValue:result WithKey:PASSWORD_KEY];
            [self gesturePasswordForeViewSetTextWithStyle:4];
            [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
            
            return YES;
            
        } else {
            
            self.previousPassword = @"";
            [self gesturePasswordForeViewSetTextWithStyle:5];
            [self.gesturePasswordForeView performSelector:@selector(enterAgain) withObject:nil afterDelay:0.5f];
            
            return NO;
        }
    }
    
    return NO;
}

#pragma mark - VerificationDelegate

- (BOOL)verificationPassword:(NSString *)result {
    
    if ([result isEqualToString:self.previousPassword]) {
        
        [self gesturePasswordForeViewSetTextWithStyle:6];
        [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
        return YES;
    }
    
    [self gesturePasswordForeViewSetTextWithStyle:7];
    [self.gesturePasswordForeView performSelector:@selector(enterAgain) withObject:nil afterDelay:0.5f];
    return NO;
}

#pragma mark - 数据存储

- (void)setUserDefaultValue:(id)obj WithKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
}

- (NSString *)userDefaultValueWithKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

#pragma mark - 逻辑处理

- (void)gesturePasswordForeViewSetTextWithStyle:(NSInteger)style {
    
    switch (style) {
        case 1:
        {
            self.gesturePassTip.text = @"创建手势密码";
            [self.gesturePasswordForeView setStyle:GesturePasswordHandleReset];
        }
            break;
        case 2:
        {
            self.gesturePassTip.text = @"请输入解锁密码";
            [self.gesturePasswordForeView setStyle:GesturePasswordHandleVerification];
        }
            break;
        case 3:
        {
            [self.gesturePassTip setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
            [self.gesturePassTip setText:@"再次输入，验证手势密码"];
        }
            break;
        case 4:
        {
            [self.gesturePassTip setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
            [self.gesturePassTip setText:@"已保存手势密码"];
        }
            break;
        case 5:
        {
            [self.gesturePassTip setTextColor:[UIColor redColor]];
            [self.gesturePassTip setText:@"两次密码不一致，请重新创建"];
        }
            break;
        case 6:
        {
            [self.gesturePassTip setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
            [self.gesturePassTip setText:@"输入正确"];
        }
            break;
        case 7:
        {
            [self.gesturePassTip setTextColor:[UIColor redColor]];
            [self.gesturePassTip setText:@"手势密码错误，请重新输入"];
        }
            break;
        default:
            break;
    }
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
