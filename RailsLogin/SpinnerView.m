//
//  SpinnerView.m
//  RailsLogin
//
//  Created by Brian Celenza on 10/23/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "SpinnerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SpinnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)removeFromSuperview
{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[[self superview] layer] addAnimation:animation forKey:@"layerAnimation"];
    [super removeFromSuperview];
}

+ (SpinnerView *)loadSpinnerIntoView:(UIView *)superView
{
    // create a new view with the same frame size as the super view
    SpinnerView *spinnerView = [[[SpinnerView alloc] initWithFrame:[superView bounds]] autorelease];
    // abort if something goes wrong
    if (!spinnerView) {
        return nil;
    }
    
    // set background
    [spinnerView setBackgroundColor:[UIColor blackColor]];
    [spinnerView setAlpha:0.6];
    // add loading indicator
    UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] 
                                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] 
                                          autorelease];
    // set resizing mask so its never stretched
    [indicator setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleBottomMargin |
                                    UIViewAutoresizingFlexibleLeftMargin)];
    // center it in the spinner view
    [indicator setCenter:[spinnerView center]];
    
    // add it to the spinner view
    [spinnerView addSubview:indicator];
    
    // start the indicator spinning
    [indicator startAnimating];
    
    // add spinner view to super view
    [superView addSubview:spinnerView];
    
    // animate in
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    
    [[superView layer] addAnimation:animation forKey:@"layerAnimation"];
    return spinnerView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
