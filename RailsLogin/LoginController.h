//
//  LoginController.h
//  RailsLogin
//
//  Created by Brian Celenza on 10/21/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUser.h"
#import "SpinnerView.h"

@interface LoginController : UIViewController <UITextFieldDelegate,AppUserLoginDelegate,UIAlertViewDelegate>
{
    AppUser *user;
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIButton *registerButton;
    IBOutlet SpinnerView *waitingView;
}

- (void)loginFormSubmitted;

@property (retain) IBOutlet UITextField *usernameField;
@property (retain) IBOutlet UITextField *passwordField;
@property (retain) IBOutlet UIButton *registerButton;
@property (retain) IBOutlet SpinnerView *waitingView;
@property (nonatomic,retain) AppUser *user;

@end
