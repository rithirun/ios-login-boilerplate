//
//  ScrollViewController.h
//  RailsLogin
//
//  Created by Brian Celenza on 10/26/11.
//  Copyright (c) 2011 Millennium Dreamworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    UITextField *activeField;
}

@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;

- (void)registerForKeyboardNotifications;
- (void)keyboardWasShown:(NSNotification *)notification;
- (void)keyboardWillBeHidden:(NSNotification *)notification;

@end
