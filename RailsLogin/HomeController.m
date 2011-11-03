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
    [userIdField release];
    [emailField release];
    [firstnameField release];
    [lastnameField release];
    [logoutButton release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AppUser *user = [AppUser sharedAppUser];
    [userIdField setText:[[user userId] stringValue]];
    [emailField setText:([[user email] isEqual:[NSNull null]]) ? @"" : [user email]];
    [firstnameField setText:([[user firstname] isEqual:[NSNull null]]) ? @"" : [user firstname]];
    [lastnameField setText:([[user lastname] isEqual:[NSNull null]]) ? @"" : [user lastname]];
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
