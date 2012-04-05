//
//  cRegisterViewController.h
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/1/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface cRegisterViewController : UIViewController<UITextFieldDelegate> {

	IBOutlet UITextField *_usernameField;
	IBOutlet UITextField *_passwordField;
	IBOutlet UITextField *_passwordField2;
	IBOutlet UIButton *_registerButton;
	IBOutlet UILabel *_errorMessage;
	IBOutlet UIActivityIndicatorView *_whirligig;
	
}

@property (nonatomic, retain)UITextField *_usernameField;
@property (nonatomic, retain)UITextField *_passwordField;
@property (nonatomic, retain)UITextField *_passwordField2;
@property (nonatomic, retain)UIButton *_registerButton;
@property (nonatomic, retain)UILabel *_errorMessage;
@property (nonatomic, retain)UIActivityIndicatorView *_whirligig;


- (IBAction)RegisterPost:(id) sender;
@end
