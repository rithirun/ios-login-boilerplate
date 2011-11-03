//
//  LoginController.m
//  RailsLogin
//
//  Created by Brian Celenza on 10/21/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "LoginController.h"
#import "RootNavigationController.h"
#import "RailsUtils.h"
#import "Inflector.h"
#import "AppDelegate.h"

@implementation LoginController

@synthesize usernameField, passwordField, registerButton, loginButton, rememberSwitch, waitingView;

- (void)loginUser
{
    if(![[usernameField text] isEqualToString:@""] && ![[passwordField text] isEqualToString:@""]) {
        waitingView = [SpinnerView loadSpinnerIntoView:self.view];
        [AppUser authenticateUser:[usernameField text] 
                     withPassword:[passwordField text]
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
    // if remember me is on, persist
    if ([rememberSwitch isOn]) {
        [[AppUser sharedAppUser] persist];
    }
    
    // remove the waiting view
    [waitingView removeFromSuperview];
    
    // remove loggin information, set back to default
    [usernameField setText:@""];
    [passwordField setText:@""];
    [rememberSwitch setOn:YES];
    
    // load the home view controller
    [(RootNavigationController *)[self navigationController] pushHomeController];
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
    [registrationController setDelegate:self];
    [self presentViewController:registrationController animated:YES completion:nil];
}

- (IBAction)loginButtonClicked:(id)sender
{
    [self loginUser];
}

#pragma mark - RegistrationControllerDelegate
- (void)registrationComplete
{
    [(RootNavigationController *)self.navigationController pushHomeController];
}

#pragma mark - View lifecycle

- (void)releaseOutlets
{
    [usernameField release];
    [passwordField release];
    [registerButton release];
    [loginButton release];
    [rememberSwitch release];
    [waitingView release];
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
