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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self._loginIndicator.hidesWhenStopped = TRUE;
    
    //Try and log player in automatically to avoid
    //annoying login screen when it loads
	[self AttemptAutoLogin];
}

//Looks for and opens credentials.txt from the local Document directory
//Parses data in credentials.txt and uses it to attempt to login automatically
- (void)AttemptAutoLogin {
	
    //Get local phone documents directory
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //Retrieve the document containing auto-login credentials
	NSString *myFilePath = [docDir stringByAppendingPathComponent:@"credentials.txt"];
	NSString *myFileContents = [NSString stringWithContentsOfFile:myFilePath encoding:NSUTF8StringEncoding error:nil];
	NSLog(@"Attempting AutoLogin");
    
    //If the file contains data, use it for logging in.
	if( [myFileContents length] != 0 )
	{
		NSArray *credentials = [myFileContents componentsSeparatedByString:@"\n"]; 
		self._usernameField.text = [credentials objectAtIndex:0];
		self._passwordField.text = [credentials objectAtIndex:1];
		self._username = [credentials objectAtIndex:0];
		self._password = [credentials objectAtIndex:1];
		NSLog(@"AutoLogin Credentials, Username:%@ ; Password:%@", self._username, self._password);
		
		[_playerMGR LoginWithUsername:[credentials objectAtIndex:0] Password:[credentials objectAtIndex:1]];
	}
}

//Calls the player managers login function using
//the data from the UI supplied by the user
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

- (void)UICallback:(BOOL)loginSuccess errorMsg:(NSString *)errMsg {
 
    if (loginSuccess) 
    {
        
        cMainScreenViewController *mainScreen = [[cMainScreenViewController alloc] init];
        mainScreen.title = @"Main";
		
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:mainScreen action:@selector(LogoutBackButton)];
		
        mainScreen.navigationItem.leftBarButtonItem = backButton;
        [backButton release];
        NSLog(@"POST: Login Succesful");
        
        self._usernameField.text = nil;
        self._passwordField.text = nil;
        //[player StartUpdateTimer];
        [self.navigationController pushViewController:mainScreen animated:YES];
        [mainScreen release];
    }
    else 
    {
        self._loginError.text = @"Bad login credentials";
    }
    self.navigationItem.backBarButtonItem.enabled = TRUE;
	_loginButton.enabled = TRUE;
	_registerButton.enabled = TRUE;
	[_loginIndicator stopAnimating];
	_loginIndicator.hidden = TRUE;
}

- (void)CallBackLoginDidFinished {
	
	//Response will return TRUE or FALSE
	


	//posted back here
	//if passed login check
	
	
}

- (void)CallBackLoginFailed {
	
	
	_loginButton.enabled = TRUE;
	_registerButton.enabled = TRUE;
	[_loginIndicator stopAnimating];
	_loginIndicator.hidden = TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	[textField resignFirstResponder];
	return NO;
}


- (IBAction)RegisterButtonPressed:(id)sender {
	
	cRegisterViewController *regview = [[cRegisterViewController alloc] init];
	regview.title = @"Register";
	[self.navigationController pushViewController:regview animated:YES];
	[regview release];
	
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
