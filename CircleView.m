//
//  CircleView.m
//  CircleApp
//
//  Created by Mitchell Currie on 2/10/2014.
//  Copyright (c) 2014 Mitchell Currie. All rights reserved.
//

#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>
#include <stdlib.h>

@implementation CircleView

//Colours only need to be static to share them with all instances
+(NSArray*) colours
{
    static NSArray* colours = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        // Here's the list of colours we are going to use
        colours = [NSArray arrayWithObjects:@"black",@"darkGray",@"lightGray",@"gray",@"red",@"green",@"blue",@"cyan",@"yellow",@"magenta",@"orange",@"purple",@"brown", nil];
    });
    
    return colours;
}


-(id) initWithFrame:(CGRect)frame {
    if( self = [super initWithFrame:frame]) {
        //Assume all sides are same (we are squre)
        self.layer.cornerRadius = frame.size.width/2.0f;
        //get the label nice and centred
        colourNameLabel = [[UILabel alloc] initWithFrame:self.bounds];
        colourNameLabel.textAlignment = NSTextAlignmentCenter;
        colourNameLabel.textColor = [UIColor whiteColor]; //we never use white for circles
        colourNameLabel.shadowColor = [UIColor blackColor];
        colourNameLabel.shadowOffset = CGSizeMake(1, 1); //helps readability in some cases
        [self addSubview:colourNameLabel];
        
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(randomiseColour)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        
        doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.delaysTouchesBegan = YES;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:doubleTap];

    }
    
    return self;
}

-(void) setBusyAnimating:(BOOL)busyAnimating {
    _busyAnimating = busyAnimating;
    //Disable these if we are aniamting
    singleTap.enabled = !busyAnimating;
    doubleTap.enabled = !busyAnimating;
}

-(CGColorRef) backgroundColour {
    return self.layer.backgroundColor;
}

-(void) setBackgroundColour:(CGColorRef)backgroundColour {
    self.layer.backgroundColor = backgroundColour;
}

-(void) setColourWithName:(NSString*) colourName {
    NSString *selectorString = [colourName stringByAppendingString:@"Color"];
    SEL selector = NSSelectorFromString(selectorString);
    UIColor *color = [UIColor blackColor];
    if ([UIColor respondsToSelector:selector]) {
        color = [UIColor performSelector:selector];
    }
    _busyAnimating = YES;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.backgroundColor = color;
                     }
                     completion:^(BOOL finished) {
                         _busyAnimating = NO;
                     }];
    colourNameLabel.text =colourName;
}

-(void) setDragged:(BOOL)dragged {
    _dragged = dragged;
    CGFloat desiredScale = _dragged?1.1f:1.0f;
    self.layer.transform = CATransform3DMakeScale(desiredScale, desiredScale, 1);
}

-(void) fadeIn{
    [self setAlpha:0.0f];
    self.busyAnimating = YES;
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self setAlpha:1.0f];
                     }
                     completion:^(BOOL finished) {
                         self.busyAnimating = NO;
                     }];
}

-(void) fadeOut{
    [self setAlpha:1.0f];
    self.busyAnimating = YES;
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self setAlpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         self.busyAnimating = NO;
                     }];
}

-(void) randomiseColour {
    NSInteger colourIndex  = arc4random_uniform((u_int32_t)[CircleView colours].count);
    [self setColourWithName:[[CircleView colours] objectAtIndex:colourIndex]];
}


-(void) doubleTapped {
    colourNameLabel.hidden ^= true;
}

@end
