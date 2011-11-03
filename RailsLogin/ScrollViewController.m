//
//  ScrollViewController.m
//  RailsLogin
//
//  Created by Brian Celenza on 10/26/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "ScrollViewController.h"

@implementation ScrollViewController

@synthesize scrollView;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    // gather keyboard size info
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // set the insets based on keyboard height
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    [scrollView setContentInset:contentInsets];
    [scrollView setScrollIndicatorInsets:contentInsets];
    
    // if active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = [[self view] frame];
    aRect.size.height -= kbSize.height;
    if(!CGRectContainsPoint(aRect, [activeField frame].origin)) {
        CGPoint scrollPoint = CGPointMake(0, [activeField frame].origin.y - (kbSize.height-15));
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [scrollView setContentInset:contentInsets];
    [scrollView setScrollIndicatorInsets:contentInsets];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWasShown:) 
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillBeHidden:) 
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake([[self view] frame].size.width, [[self view] frame].size.height)];
    [self registerForKeyboardNotifications];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [scrollView release];
}

@end
