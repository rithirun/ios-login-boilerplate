//
//  RegistrationController.h
//  RailsLogin
//
//  Created by Brian Celenza on 10/22/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *passwordConfirmationField;
    IBOutlet UITextField *firstnameField;
    IBOutlet UITextField *lastnameField;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *registerButton;
}

@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITextField *passwordConfirmationField;
@property (nonatomic, retain) IBOutlet UITextField *firstnameField;
@property (nonatomic, retain) IBOutlet UITextField *lastnameField;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *registerButton;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;
- (void)registerUser;

@end
