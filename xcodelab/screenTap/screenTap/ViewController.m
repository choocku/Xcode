//
//  ViewController.m
//  screenTap
//
//  Created by Peeranon Wattanapong on 11/15/2557 BE.
//  Copyright (c) 2557 Choock. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    UIView * containerView;
    UIButton *b;
    UIBezierPath *path;
    UIBezierPath *path2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    containerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 500, 500)];
    containerView.backgroundColor = [UIColor grayColor];
    containerView.layer.borderWidth = 3.0f;
    containerView.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:containerView];
    
//    UIButton * zeros_b = [[UIButton alloc] initWithFrame:CGRectMake(800, 100, 100, 50)];
//    zeros_b.backgroundColor = [UIColor blueColor];
//    [zeros_b setTitle:@"0,0" forState:UIControlStateNormal];
//    [zeros_b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [zeros_b addTarget:self action:@selector(setZero:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:zeros_b];
//    
//    UIButton * center_b = [[UIButton alloc] initWithFrame:CGRectMake(800, 170, 100, 50)];
//    [center_b setTitle:@"127,127" forState:UIControlStateNormal];
//    [center_b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    center_b.backgroundColor = [UIColor redColor];
//    [center_b addTarget:self action:@selector(setCenter:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:center_b];
//    
//    UIButton * full_b = [[UIButton alloc] initWithFrame:CGRectMake(800, 240, 100, 50)];
//    full_b.backgroundColor = [UIColor yellowColor];
//    [full_b setTitle:@"255,255" forState:UIControlStateNormal];
//    [full_b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [full_b addTarget:self action:@selector(setFull:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:full_b];
//    
//    
//    b = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
//    b.backgroundColor = [UIColor orangeColor];
//    [containerView addSubview:b];
//    
//    path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(containerView.bounds.size.width/2, 0)];
//    [path addLineToPoint:CGPointMake(containerView.bounds.size.width/2, containerView.bounds.size.height)];
//    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.path = [path CGPath];
//    shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
//    shapeLayer.lineWidth = 3.0;
//    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
//    
//    [containerView.layer addSublayer:shapeLayer];
//    
//    path2 = [UIBezierPath bezierPath];
//    [path2 moveToPoint:CGPointMake(0, containerView.bounds.size.height/2)];
//    [path2 addLineToPoint:CGPointMake(containerView.bounds.size.width, containerView.bounds.size.height/2)];
//    
//    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
//    shapeLayer2.path = [path2 CGPath];
//    shapeLayer2.strokeColor = [[UIColor blueColor] CGColor];
//    shapeLayer2.lineWidth = 3.0;
//    shapeLayer2.fillColor = [[UIColor clearColor] CGColor];
//    
//    [containerView.layer addSublayer:shapeLayer2];
//    
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
//    [containerView addGestureRecognizer:panGestureRecognizer];
//    [containerView addGestureRecognizer:tapGestureRecognizer];
}

-(void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint touchLocation = [panGestureRecognizer locationInView:containerView];
    b.center = touchLocation;
    [path addLineToPoint:CGPointMake(containerView.bounds.size.width, containerView.bounds.size.height)];
    if (touchLocation.x<0 ) {
        NSLog(@"%f, %f",0.0,255*touchLocation.y/500);
        b.center = CGPointMake(0.0, touchLocation.y);
        if (touchLocation.y<0) {
            NSLog(@"%f, %f",0.0, 0.0);
            b.center = CGPointMake(0.0, 0.0);
        }
        else if (touchLocation.y>containerView.bounds.size.height) {
            NSLog(@"%f, %f",0.0, 255*containerView.bounds.size.height/500);
            b.center = CGPointMake(0.0, containerView.bounds.size.height);
        }
    }
    else if (touchLocation.x>containerView.bounds.size.width) {
        NSLog(@"%f, %f",255*containerView.bounds.size.width/500,255*touchLocation.y/500);
        b.center = CGPointMake(containerView.bounds.size.width, touchLocation.y);
        if (touchLocation.y<0) {
            NSLog(@"%f, %f",255*containerView.bounds.size.width/500, 0.0);
            b.center = CGPointMake(containerView.bounds.size.width, 0.0);
        }
        else if (touchLocation.y>containerView.bounds.size.height) {
            NSLog(@"%f, %f",255*containerView.bounds.size.width/500, 255*containerView.bounds.size.height/500);
            b.center = CGPointMake(containerView.bounds.size.width, containerView.bounds.size.height);
        }
    }
    else if (touchLocation.y<0 ) {
        NSLog(@"%f, %f",255*touchLocation.x/500,0.0);
        b.center = CGPointMake(touchLocation.x, 0.0);
        if (touchLocation.x<0) {
            NSLog(@"%f, %f",0.0, 0.0);
            b.center = CGPointMake(0.0, 0.0);
        }
        else if (touchLocation.x>containerView.bounds.size.width) {
            NSLog(@"%f, %f",255*containerView.bounds.size.width/500, 0.0);
            b.center = CGPointMake(containerView.bounds.size.width, 0.0);
        }
    }
    else if (touchLocation.y>containerView.bounds.size.height) {
        NSLog(@"%f, %f",255*touchLocation.x/500,255*containerView.bounds.size.height/500);
        b.center = CGPointMake(touchLocation.x, containerView.bounds.size.height);
        if (touchLocation.x<0) {
            NSLog(@"%f, %f",0.0, 255*containerView.bounds.size.height/500);
            b.center = CGPointMake(0.0, containerView.bounds.size.height);
        }
        else if (touchLocation.x>containerView.bounds.size.width) {
            NSLog(@"%f, %f",255*containerView.bounds.size.width/500, 255*containerView.bounds.size.height/500);
            b.center = CGPointMake(containerView.bounds.size.width, containerView.bounds.size.height);
        }
    }
    else {
        NSLog(@"%f, %f",255*touchLocation.x/500,255*touchLocation.y/500);
        b.center = CGPointMake(touchLocation.x, touchLocation.y);
    }
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint touchLocation = [tapGestureRecognizer locationInView:containerView];
    b.center = touchLocation;
}

-(void)setCenter:(id)sender {
    b.center = CGPointMake(containerView.bounds.size.width/2, containerView.bounds.size.height/2);
    NSLog(@"center %f,%f",b.center.x,b.center.y);
}

-(void)setFull:(id)sender {
    b.center = CGPointMake(containerView.bounds.size.width, containerView.bounds.size.height);
    NSLog(@"center %f,%f",b.center.x,b.center.y);
}

-(void)setZero:(id)sender {
    b.center = CGPointMake(0, 0);
    NSLog(@"center %f,%f",b.center.x,b.center.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
