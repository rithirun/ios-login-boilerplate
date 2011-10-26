//
//  LoginController.m
//  RailsLogin
//
//  Created by Brian Celenza on 10/21/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "LoginController.h"
#import "RegistrationController.h"
#import "RootNavigationController.h"
#import "RailsUtils.h"
#import "Inflector.h"
#import "AppDelegate.h"

@implementation LoginController

@synthesize usernameField, passwordField, registerButton, loginButton, waitingView;

- (void)loginUser
{
    if(![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""]) {
        self.waitingView = [SpinnerView loadSpinnerIntoView:self.view];
        [AppUser authenticateUser:self.usernameField.text 
                              withPassword:self.passwordField.text
                            requestDelegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - AppUserLoginDelegate
-(void)loginComplete
{
    [self.waitingView removeFromSuperview];
    
    // load the home view controller
    [(RootNavigationController *)self.navigationController pushHomeController];
}

-(void)loginFailed:(NSArray *)errors
{
    [self.waitingView removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[RailsUtils stringFromErrorsArray:errors] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    
    if(nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self loginUser];
    }
    
    return NO;
}

#pragma mark - UIButonDelegate
- (IBAction)registerButtonClicked:(id)sender
{
    RegistrationController *registrationController = [[RegistrationController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    [self presentViewController:registrationController animated:YES completion:nil];
}

- (IBAction)loginButtonClicked:(id)sender
{
    [self loginUser];
}

#pragma mark - View lifecycle

- (void)releaseOutlets
{
    self.usernameField = nil;
    self.passwordField = nil;
    self.registerButton = nil;
    self.loginButton = nil;
    self.waitingView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self releaseOutlets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
