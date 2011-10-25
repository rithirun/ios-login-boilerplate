//
//  RegistrationController.m
//  RailsLogin
//
//  Created by Brian Celenza on 10/22/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "RegistrationController.h"
#import "AppUser.h"
#import "SpinnerView.h"

@implementation RegistrationController

@synthesize emailField, passwordField, passwordConfirmationField, firstnameField, lastnameField, cancelButton, registerButton;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

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
    SpinnerView *spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    AppUser *user = [[AppUser alloc] init];
    user.email = emailField.text;
    user.password = passwordField.text;
    user.passwordConfirmation = passwordConfirmationField.text;
    user.firstname = firstnameField.text;
    user.lastname = lastnameField.text;
    [user register];
    [spinnerView removeFromSuperview];
    [user release];
}

- (void)releaseOutlets
{
    self.emailField = nil;
    self.passwordField = nil;
    self.passwordConfirmationField = nil;
    self.firstnameField = nil;
    self.lastnameField = nil;
    self.cancelButton = nil;
    self.registerButton = nil;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{

    NSArray *fieldArray = [NSArray arrayWithObjects:self.emailField, 
                           self.passwordField, self.passwordConfirmationField, 
                           self.firstnameField, self.lastnameField, nil];
    
    // if not the last field
    if(![textField isEqual:self.lastnameField]) {
        // focus the next field
        UITextField *nextField = [fieldArray objectAtIndex:([fieldArray indexOfObject:textField] + 1)];
        [nextField becomeFirstResponder];
    } else {
        [self registerUser];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

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
