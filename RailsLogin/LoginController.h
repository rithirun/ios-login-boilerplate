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
#import "RegistrationController.h"

@interface LoginController : UIViewController <UITextFieldDelegate,AppUserLoginDelegate,UIAlertViewDelegate,RegistrationControllerDelegate>
{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIButton *registerButton;
    IBOutlet UIButton *loginButton;
    IBOutlet UISwitch *rememberSwitch;
    IBOutlet SpinnerView *waitingView;
}

- (void)loginUser;

@property (nonatomic,retain) IBOutlet UITextField *usernameField;
@property (nonatomic,retain) IBOutlet UITextField *passwordField;
@property (nonatomic,retain) IBOutlet UIButton *registerButton;
@property (nonatomic,retain) IBOutlet UIButton *loginButton;
@property (nonatomic,retain) IBOutlet UISwitch *rememberSwitch;
@property (nonatomic,retain) IBOutlet SpinnerView *waitingView;

@end
