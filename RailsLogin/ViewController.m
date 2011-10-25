//
//  ViewController.m
//  RailsLogin
//
//  Created by Brian Celenza on 10/21/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "ViewController.h"
#import "RegistrationController.h"
#import "RailsUtils.h"

@implementation ViewController

@synthesize usernameField, passwordField, registerButton, waitingView, user;
@synthesize navigationController;

- (void)loginFormSubmitted
{
    self.waitingView = [SpinnerView loadSpinnerIntoView:self.view];
    [AppUser authenticateUser:self.usernameField.text 
                              withPassword:self.passwordField.text
                            requestDelegate:self];
    
}

-(void)loginComplete:(AppUser *)aUser
{
    self.navigationController.user = aUser;
    NSLog(@"user id is: %@", self.navigationController.user.userId);
    [self.waitingView removeFromSuperview];
}

-(void)loginFailed:(NSArray *)errors
{
    [self.waitingView removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[RailsUtils stringFromErrorsArray:errors] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([textField isEqual:self.usernameField]) {
        [self.passwordField becomeFirstResponder];
    } else {
        [self loginFormSubmitted];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIButonDelegate
- (IBAction)registerButtonClicked:(id)sender
{
    RegistrationController *registrationController = [[RegistrationController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    [self presentViewController:registrationController animated:YES completion:nil];
}

#pragma mark - View lifecycle

- (void)releaseOutlets
{
    self.usernameField = nil;
    self.passwordField = nil;
    self.registerButton = nil;
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
