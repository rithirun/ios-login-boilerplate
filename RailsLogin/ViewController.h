//
//  ViewController.h
//  RailsLogin
//
//  Created by Brian Celenza on 10/21/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUser.h"
#import "SpinnerView.h"
#import "RootNavigationController.h"

@interface ViewController : UIViewController <UITextFieldDelegate,AppUserLoginDelegate,UIAlertViewDelegate>
{
    AppUser *user;
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIButton *registerButton;
    IBOutlet SpinnerView *waitingView;
}

- (void)loginFormSubmitted;
- (void)loginComplete:(AppUser *)aUser;
- (void)loginFailed:(NSArray *)errors;

@property (retain) IBOutlet UITextField *usernameField;
@property (retain) IBOutlet UITextField *passwordField;
@property (retain) IBOutlet UIButton *registerButton;
@property (retain) IBOutlet SpinnerView *waitingView;
@property (nonatomic,retain) AppUser *user;
@property (retain) RootNavigationController *navigationController;

@end
