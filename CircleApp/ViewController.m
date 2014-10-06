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
    
    CircleView *newCircle = [self createCircleAt:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
    [newCircle fadeIn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    UIView* touchedView = [self.view hitTest:locationPoint withEvent:event];
    
    if ([touchedView isKindOfClass:[CircleView class]]) {
        viewBeingDragged = (CircleView*)touchedView;
        viewBeingDragged.dragged = YES;
    } else {
        //it's a circle view, see if dragging will start
        //the view's backdrop was touched, so create a new circle view
        CircleView *newCircle = [self createCircleAt:locationPoint];
        [newCircle fadeIn];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //Dragging may have continued, let's check
    if (viewBeingDragged) {
        CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
        viewBeingDragged.frame = CGRectMake(locationPoint.x - viewBeingDragged.frame.size.width/2.0f, locationPoint.y - viewBeingDragged.frame.size.height/2.0f, viewBeingDragged.frame.size.width, viewBeingDragged.frame.size.height);
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //dragging must have ended
    if (viewBeingDragged) {
        viewBeingDragged.dragged = NO;
        viewBeingDragged = nil;
    }
}

@end
