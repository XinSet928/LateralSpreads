//
//  ViewController.m
//  DEMO
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController (){
    HomeViewController *homeVC;
    CGFloat distance;
    CGFloat FullDistance;
    CGFloat Proportion;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    distance = 0;
    FullDistance = 0.78;
    Proportion = 0.77;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    imageView.image = [UIImage imageNamed:@"11.jpg"];
    imageView.backgroundColor = [UIColor colorWithRed:0.750 green:0.760 blue:1.000 alpha:1.000];
    [self.view addSubview:imageView];
    
    homeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeVC"];
    [self.view addSubview:homeVC.view];
    
    //手势方法
    [homeVC.pan addTarget:self action:@selector(panAction:)];
    
    
    
}

-(void)panAction:(UIPanGestureRecognizer *)pan{
    
    CGFloat x = [pan translationInView:self.view].x;
    CGFloat trueDistance = distance + x;//实时距离
    //如果结束，则激活自动停靠
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (trueDistance > ScreenWidth*(Proportion/3)) {
            //展示左边
            [self showLeft];
        }
        else if (trueDistance < ScreenWidth*-(Proportion/3)){
            //展示右边
            [self showRight];
        }else{
            //展示中间
            [self showHome];
        }
  return;
    }
    
    //计算缩放比例
    CGFloat proportion = pan.view.frame.origin.x>=0?-1:1;
    proportion *= trueDistance/ScreenWidth;
    proportion *= 1-Proportion;
    proportion /= 0.6;
    proportion += 1;
    if (proportion <= Proportion) {//若比例已经达到最小，则不再继续动画
        return;
    }
    
    //执行平移和缩放动画
    pan.view.center = CGPointMake(self.view.center.x+trueDistance,self.view.center.y);
    pan.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
    
   
}

-(void)showLeft{
    
    distance = self.view.center.x *(FullDistance + Proportion/2);
    [self doTheAnimation:Proportion];
}


-(void)showHome{
    distance = 0;
    [self doTheAnimation:1];
}


-(void)showRight{
    
    distance = self.view.center.x * -(FullDistance + Proportion/2);
    [self doTheAnimation:Proportion];
    
}


-(void)doTheAnimation:(CGFloat)proportion{
    
   [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
       homeVC.view.center = CGPointMake(self.view.center.x+distance, self.view.center.y);
       homeVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
       
   } completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showHome];
}







@end
