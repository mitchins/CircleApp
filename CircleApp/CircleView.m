//
//  CircleView.m
//  CircleApp
//
//  Created by Mitchell Currie on 2/10/2014.
//  Copyright (c) 2014 Mitchell Currie. All rights reserved.
//

#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CircleView

-(id) initWithFrame:(CGRect)frame {
    if( self = [super initWithFrame:frame]) {
        //Assume all sides are same (we are squre)
        self.layer.cornerRadius = frame.size.width/2.0f;
        //get the label nice and centred
        colourNameLabel = [[UILabel alloc] initWithFrame:self.bounds];
        colourNameLabel.textAlignment = NSTextAlignmentCenter;
        //we never use white for circles
        colourNameLabel.textColor = [UIColor whiteColor];
        //helps readability in some cases by using shadows
        colourNameLabel.shadowColor = [UIColor blackColor];
        colourNameLabel.shadowOffset = CGSizeMake(1, 1);
        //some names are long - make them squish
        colourNameLabel.minimumScaleFactor = 0.3f;
        colourNameLabel.adjustsFontSizeToFitWidth = YES;
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
        
        //since we use network, let's indicate nicely what's going on to the user
        loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingSpinner.hidesWhenStopped = YES;
        [self addSubview:loadingSpinner];
        loadingSpinner.frame = self.bounds;

    }
    
    return self;
}

-(void) setBusyAnimating:(BOOL)busyAnimating {
    _busyAnimating = busyAnimating;
    //Disable these if we are aniamting
    singleTap.enabled = !busyAnimating;
    doubleTap.enabled = !busyAnimating;
}

-(void) setBusyDownloading:(BOOL)busyDownloading {
    _busyDownloading = busyDownloading;
    if(_busyDownloading) {
        [loadingSpinner startAnimating];
        colourNameLabel.alpha = 0.5f;
    } else {
        [loadingSpinner stopAnimating];
        colourNameLabel.alpha = 1.0f;
    }
}

-(CGColorRef) backgroundColour {
    return self.layer.backgroundColor;
}

-(void) setBackgroundColour:(CGColorRef)backgroundColour {
    self.layer.backgroundColor = backgroundColour;
}

-(void) setColour:(UIColor*) colour withName:(NSString*) colourName {
    _busyAnimating = YES;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.backgroundColor = colour;
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

-(void) doDownloadOfColour {
    NSURL *url=[NSURL URLWithString:@"http://www.colourlovers.com/api/colors/random?format=json"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    NSArray *response=[NSJSONSerialization JSONObjectWithData:data options:
                       NSJSONReadingMutableContainers error:&error];

    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(response.count>0) {
            //seems to have gone ok
            NSDictionary *colourDictionary = [response objectAtIndex:0];
            NSString *colourName = [colourDictionary objectForKey:@"title"];
            NSDictionary *rgbDictionary = [colourDictionary objectForKey:@"rgb"];
            NSNumber *blue = [rgbDictionary objectForKey:@"blue"];
            NSNumber *green = [rgbDictionary objectForKey:@"green"];
            NSNumber *red = [rgbDictionary objectForKey:@"red"];
            UIColor *colour = [UIColor colorWithRed:red.floatValue/255.0f green:green.floatValue/255.0f blue:blue.floatValue/255.0f alpha:1.0f];
            [self setColour:colour withName:colourName];
        }
        self.busyDownloading = NO;
    });


}

-(void) randomiseColour {
    //Network operation so keep it safe and don't stack them
    if (!_busyDownloading) {
        self.busyDownloading = YES;
        [self performSelectorInBackground:@selector(doDownloadOfColour) withObject:nil];
        
    }

}


-(void) doubleTapped {
    colourNameLabel.hidden ^= true;
}

@end
