//
//  CircleView.h
//  CircleApp
//
//  Created by Mitchell Currie on 2/10/2014.
//  Copyright (c) 2014 Mitchell Currie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView {
    //UI elements
    UILabel *colourNameLabel;
    
    //gesture recognisers make life easier
    UITapGestureRecognizer *singleTap ;
    UITapGestureRecognizer *doubleTap;
    
    //Data elements
    NSArray *colourNames;
    
    //Loading indicator
    UIActivityIndicatorView *loadingSpinner;
}
//sets both the bg colour and the label name
-(void) setColour:(UIColor*) colour withName:(NSString*) colourName;
//Convenience methods to fade in/out
-(void) fadeIn;
-(void) fadeOut;

-(void) randomiseColour;

@property (nonatomic,readonly) BOOL busyAnimating;
@property (nonatomic,readonly) BOOL busyDownloading;
@property (nonatomic,assign) BOOL dragged;

@end
