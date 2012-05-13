//
//  cLoginViewController.m
//  Outbreak_0_9
//
//  Created by iGeek Developers on 2/29/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "cLoginViewController.h"
#import "cMainScreenViewController.h"
#import "cPlayerManager.h"
#import "cPlayerSingleton.h"
#import "cRegisterViewController.h"
#import "cVirus.h"
#import "JSONKit.h"

@implementation cLoginViewController
@synthesize _playerMGR;
@synthesize _usernameField;
@synthesize _passwordField;
@synthesize _loginButton;
@synthesize _loginIndicator;
@synthesize _loginError;
@synthesize _registerButton;
@synthesize _username;
@synthesize _password;


- (id)init {
	self = [super init];
	if (self != nil)
	{
		//Create the manager and set its delegate for UI update callbacks
		_playerMGR = [[cPlayerManager alloc]init];
		_playerMGR.delegate = self;
	}
	
	return self;
}

- (void)dealloc {
	[_playerMGR release];
    [super dealloc];
}

/************************************************************
 * Purpose: Pass data from the UI to the Player manager for 
 *   logical processing
 *
 * Entry: Button pressed from UI
 *
 * Exit: After data is sent to Manager
 ************************************************************/
- (IBAction)LoginButtonPressed:(id)sender {
	self._password = _passwordField.text;
	self._username = _usernameField.text;

	_loginIndicator.hidden = FALSE;
	[_loginIndicator startAnimating];		
	self.navigationItem.backBarButtonItem.enabled = FALSE;
	_loginButton.enabled = FALSE;
	_registerButton.enabled = FALSE;
    
	[_playerMGR LoginWithUsername:self._username Password:self._password];
	
}

/************************************************************
 * Purpose: Pass data from the UI to the Player manager for 
 *   logical processing
 *
 * Entry: Button pressed from UI
 *
 * Exit: After data is sent to Manager
 ************************************************************/
- (IBAction)RegisterButtonPressed:(id)sender {
	
    //Make and push the view(screen)
	cRegisterViewController *regview = [[cRegisterViewController alloc] init];
	regview.title = @"Register";
	[self.navigationController pushViewController:regview animated:YES];
	[regview release];
	
}

/************************************************************
 * Purpose: Based on the return message from the manager
 *   the UI will update to move to the main screen or display
 *   an error message
 *
 * Entry: Called by the playerManager to alert the UI its done
 *    with its asynchronous process
 *
 * Exit: UI has been updated:view pushed or button re-enabled, etc
 ************************************************************/
- (void)UICallback:(BOOL)loginSuccess errorMsg:(NSString *)errMsg {
 
    if (loginSuccess) 
    {
        if (errMsg) 
        {
            self._loginError.text = errMsg;
        }
        else
        {
            self._usernameField.text = nil;
            self._passwordField.text = nil;
            
            cMainScreenViewController *mainScreen = [[cMainScreenViewController alloc] init];
            mainScreen.title = @"Main";
            [self.navigationController pushViewController:mainScreen animated:YES];
            //Navigation retained its on copy on push, so release ours
            [mainScreen release];
        }
    }
    else 
    {
        self._loginError.text = @"Cannot connect to server";
        //pushing this view Crashes simulator only not phone
        //cConnectionViewController *connVC = [[cConnectionViewController alloc] init];
        //[self.navigationController pushViewController:connVC animated:YES];
    }
    
    //Re-enable UI regardless of success
    self.navigationItem.backBarButtonItem.enabled = TRUE;
	_loginButton.enabled = TRUE;
	_registerButton.enabled = TRUE;
	[_loginIndicator stopAnimating];
	_loginIndicator.hidden = TRUE;
}

/************************************************************
 * Purpose: Hide the keyboard when the user is done with it
 *
 * Entry: UI keyboard Done(return) key hit
 *
 * Exit: Keyboard dissapears
 ************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	[textField resignFirstResponder];
	return NO;
}

/************************************************************
 * Purpose: Apple event handler - During event we try to attempt
 *    an auto login
 *
 * Entry: The view has loaded(not to be confused with viewWillAppear)
 *
 * Exit: view loaded, autologin completed
 ************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    self._loginIndicator.hidesWhenStopped = TRUE;
    
    //Try and log player in automatically to avoid
    //annoying login screen when it loads
	[self._playerMGR AttemptAutoLogin];
}

/*****  UNMODIFIED NEEDED APPLE STUFF BELOW *********/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
