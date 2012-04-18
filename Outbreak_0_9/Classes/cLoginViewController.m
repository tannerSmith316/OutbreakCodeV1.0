//
//  cLoginViewController.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 2/29/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cPlayerManager.h"
#import "cLoginViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cPlayerSingleton.h"
#import "cRegisterViewController.h"
#import "cMainScreenViewController.h"
#import "JSONKit.h"
#import "cVirus.h"

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
		//custom inits here
		_playerMGR = [[cPlayerManager alloc]init];
		_playerMGR.delegate = self;
	}
	
	return self;
	
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self AttemptAutoLogin];


}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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



- (void)dealloc {
	[_playerMGR release];
    [super dealloc];
}

- (void)AttemptAutoLogin {
	
	//stuff here
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *myFilePath = [docDir stringByAppendingPathComponent:@"credentials.txt"];
	NSString *myFileContents = [NSString stringWithContentsOfFile:myFilePath];
	NSLog(@"Attempting AutoLogin");
	if( [myFileContents length] != 0 )
	{
		NSArray *credentials = [myFileContents componentsSeparatedByString:@"\n"]; 
		self._usernameField.text = [credentials objectAtIndex:0];
		self._passwordField.text = [credentials objectAtIndex:1];
		self._username = [credentials objectAtIndex:0];
		self._password = [credentials objectAtIndex:1];
		NSLog(@"AutoLogin Credentials, Username:%@ ; Password:%@", self._username, self._password);
		//autologin here
		
		[_playerMGR LoginWithUsername:[credentials objectAtIndex:0] Password:[credentials objectAtIndex:1]];
	}
}



- (IBAction)LoginButtonPressed:(id)sender
{
	// TODO: Spawn a login thread
	self._password = _passwordField.text;
	self._username = _usernameField.text;
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];

	_loginIndicator.hidden = FALSE;
	[_loginIndicator startAnimating];
		
		//make call to 
		
	self.navigationItem.backBarButtonItem.enabled = FALSE;
	_loginButton.enabled = FALSE;
	_registerButton.enabled = FALSE;
	[_playerMGR LoginWithUsername:self._username Password:self._password];
	
}

- (void)CallBackLoginDidFinished {
	
	//Response will return TRUE or FALSE
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	cMainScreenViewController *mainScreen = [[cMainScreenViewController alloc] init];
	mainScreen.title = @"Main";
		
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:mainScreen action:@selector(LogoutBackButton)];
		
	mainScreen.navigationItem.leftBarButtonItem = backButton;
	[backButton release];
	NSLog(@"POST: Login Succesful");

	self._usernameField.text = nil;
	self._passwordField.text = nil;
	[player StartUpdateTimer];
	[self.navigationController pushViewController:mainScreen animated:YES];
	[mainScreen release];


	//posted back here
	//if passed login check
	self.navigationItem.backBarButtonItem.enabled = TRUE;
	_loginButton.enabled = TRUE;
	_registerButton.enabled = TRUE;
	[_loginIndicator stopAnimating];
	_loginIndicator.hidden = TRUE;
	
}

- (void)CallBackLoginFailed {
	
	self._loginError.text = @"Bad login credentials";
	_loginButton.enabled = TRUE;
	_registerButton.enabled = TRUE;
	[_loginIndicator stopAnimating];
	_loginIndicator.hidden = TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	[textField resignFirstResponder];
	return NO;
}

- (IBAction)TouchOutsideKeyboard:(id)sender {

	[_usernameField resignFirstResponder];
	[_passwordField resignFirstResponder];
}

- (IBAction)RegisterButtonPressed:(id)sender {
	
	//
	//pushy
	cRegisterViewController *regview = [[cRegisterViewController alloc] init];
	regview.title = @"Register";
	[self.navigationController pushViewController:regview animated:YES];
	[regview release];
	
}



@end
