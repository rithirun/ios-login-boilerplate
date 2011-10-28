//
//  HomeController.m
//  RailsLogin
//
//  Created by Brian Celenza on 10/25/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import "HomeController.h"
#import "AppDelegate.h"
#import "AppUser.h"

@implementation HomeController

@synthesize userIdField, emailField, firstnameField, lastnameField, logoutButton;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)logoutPressed:(UIButton *)sender
{
    [[AppUser sharedAppUser] logout];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)releaseOutlets
{
    userIdField = nil;
    emailField = nil;
    firstnameField = nil;
    lastnameField = nil;
    logoutButton = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AppUser *user = [AppUser sharedAppUser];
    self.userIdField.text = [user.userId stringValue];
    self.emailField.text = ([user.email isEqual:[NSNull null]]) ? @"" : user.email;
    self.firstnameField.text = ([user.firstname isEqual:[NSNull null]]) ? @"" : user.firstname;
    self.lastnameField.text = ([user.lastname isEqual:[NSNull null]]) ? @"" : user.lastname;
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
