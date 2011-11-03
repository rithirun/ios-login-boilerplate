//
//  RegistrationController.m
//  RailsLogin
//
//  Created by Brian Celenza on 10/22/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "RegistrationController.h"
#import "RootNavigationController.h"
#import "AppUser.h"
#import "SpinnerView.h"
#import "RailsUtils.h"

@implementation RegistrationController

@synthesize delegate;
@synthesize emailField, passwordField, passwordConfirmationField, firstnameField, lastnameField, cancelButton, registerButton;
@synthesize waitingView;

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)registerButtonPressed:(id)sender
{
    [self registerUser];
}

- (void)registerUser
{
    self.waitingView = [SpinnerView loadSpinnerIntoView:self.view];
    AppUser *user = [AppUser sharedAppUser];
    [user setEmail:[emailField text]];
    [user setPassword:[passwordField text]];
    [user setPasswordConfirmation:[passwordConfirmationField text]];
    [user setFirstname:[firstnameField text]];
    [user setLastname:[lastnameField text]];
    [user registerWithDelegate:self];
}

- (void)registrationComplete
{
    // remove loading view
    [waitingView removeFromSuperview];
    
    // set all fields back to default
    [emailField setText:@""];
    [passwordField setText:@""];
    [passwordConfirmationField setText:@""];
    [firstnameField setText:@""];
    [lastnameField setText:@""];
    
    // dismiss this view
    [self dismissModalViewControllerAnimated:YES];
    
    // call the delegates registrationComplete method
    if (delegate) {
        [delegate registrationComplete];
    }
}

- (void)registrationFailed:(NSArray *)errors
{
    [waitingView removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[RailsUtils stringFromErrorsArray:errors] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)releaseOutlets
{
    [emailField release];
    [passwordField release];
    [passwordConfirmationField release];
    [firstnameField release];
    [lastnameField release];
    [cancelButton release];
    [registerButton release];
    [waitingView release];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = [textField tag] + 1;
    UIResponder *nextResponder = [[textField superview] viewWithTag:nextTag];
    
    if(nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self registerUser];
    }
    return NO;
}

#pragma mark - View lifecycle
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self releaseOutlets];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
