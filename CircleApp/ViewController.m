//
//  ViewController.m
//  CircleApp
//
//  Created by Mitchell Currie on 2/10/2014.
//  Copyright (c) 2014 Mitchell Currie. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"

@interface ViewController ()

@end

@implementation ViewController

-(CircleView*) createCircleAt:(CGPoint) location {
    CGSize circleSize = CGSizeMake(96, 96);
    CircleView *newCircle = [[CircleView alloc] initWithFrame:CGRectMake(location.x - circleSize.width/2.0f, location.y - circleSize.height/2.0f, circleSize.width, circleSize.height)];
    [newCircle randomiseColour];
    
    [self.view addSubview:newCircle];
    
    return newCircle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    CircleView *newCircle = [self createCircleAt:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
    [newCircle fadeIn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapRecognized:(UITapGestureRecognizer*)gesture{
    CircleView *tapCircle = [self createCircleAt:[gesture locationInView:self.view]];
    [tapCircle fadeIn];
}

@end
