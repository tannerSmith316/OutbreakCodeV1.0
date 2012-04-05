//
//  cLoginViewController.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 2/29/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cLoginViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cPlayerSingleton.h"
#import "cRegisterViewController.h"
#import "cMainScreenViewController.h"
#import "JSONKit.h"
#import "cVirus.h"

@implementation cLoginViewController
@synthesize _usernameField;
@synthesize _passwordField;
@synthesize _loginButton;
@synthesize _loginIndicator;
@synthesize _loginError;
@synthesize _registerButton;
@synthesize _username;
@synthesize _password;

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
		
		[self LoginWithUsername:[credentials objectAtIndex:0] Password:[credentials objectAtIndex:1]];
		
	}
}

- (void)LoginWithUsername:(NSString *)username Password:(NSString *)password {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	//Moves variables out to view controller
	NSString *urlstring = [NSString stringWithFormat:@"%@login.php",player._serverIP];
	NSURL *url = [NSURL URLWithString:urlstring];
	
	NSLog(@"POST: Login; Username=%@ ; Password=%@", username, password);
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:username forKey:@"device_id"];
	[request setPostValue:password forKey:@"password"];
	
	[request setDidFinishSelector:@selector(LoginDidFinished:)];
	[request setDidFailSelector:@selector(LoginDidFailed:)];
	
	[request setDelegate:self];
	[request startAsynchronous];
	
	
	_loginIndicator.hidden = FALSE;
	[_loginIndicator startAnimating];
	
	//make call to 
	
	_loginButton.enabled = FALSE;
	_registerButton.enabled = FALSE;
}

- (IBAction)LoginButtonPressed:(id)sender
{
	// TODO: Spawn a login thread
	self._password = _passwordField.text;
	self._username = _usernameField.text;
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	//if (player._isTimerActive)
	{
		//self._loginError.text = @"Try again later";
	}
	//else
	{
		[self LoginWithUsername:self._username Password:self._password];
	}

	

}

- (void)LoginDidFinished:(ASIHTTPRequest *)request {
	
	//Response will return TRUE or FALSE
	NSString *loginSuccess = [request responseString];
	
	//If the login doesnt fail
	if ( ![loginSuccess isEqualToString:@"FALSE"] )
	{
		
		cPlayerSingleton *player = [cPlayerSingleton GetInstance];
		player._username = self._username;
		player._password = self._password;
		//Save succesful credentials to flat file for auto-login
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *myFilePath = [docDir stringByAppendingPathComponent:@"credentials.txt"];
		NSString *successfulCredentials = [NSString stringWithFormat:@"%@\n%@", self._username, self._password];
		[successfulCredentials writeToFile:myFilePath atomically:YES];
		
		
		//Load JSON data into singleton
		NSString *jsonString = [NSString stringWithString:[request responseString]];
		//Parse the json
		NSLog(@"Login Succesful Return Packet: %@", jsonString);
		NSDictionary *deserializedData = [[NSDictionary alloc] init];
		deserializedData = [jsonString objectFromJSONString];
		
		[self parsePlayerJson:deserializedData];
				
		
		//Push main VC
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
	}
	else
	{
		NSLog(@"Invalid Login Credentials");
		_loginError.text = @"Invalid Login Credentials";
	}


	//posted back here
	//if passed login check
	_loginButton.enabled = TRUE;
	_registerButton.enabled = TRUE;
	[_loginIndicator stopAnimating];
	_loginIndicator.hidden = TRUE;
	
}
										  
- (void)LoginDidFailed:(ASIHTTPRequest *)request {
	
	_loginButton.enabled = TRUE;
	_registerButton.enabled = TRUE;
	_loginError.text = @"FAILED CONNECTION";
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

//Parses returned json and sets playsingleton with data retrieved
- (void)parsePlayerJson:(NSDictionary *)playerDict {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	NSMutableArray *viruses = [[NSMutableArray alloc] init];
	
	//Retrieve information from the deserialized json string
	NSDictionary *playerViruses = [playerDict objectForKey:@"viruses"];
	//Iterate through virus data
	for ( NSDictionary * each_virus in playerViruses ) 
	{
		NSString *virusName = [NSString stringWithFormat:@"%@",[each_virus objectForKey:@"virus_name"]];
		//Needs to retrieve more virus info
		cVirus *virus = [[cVirus alloc] init];
		virus._virusName = virusName;
		virus._owner = player._username;
		
		[viruses addObject:virus];
		[virus release];
	}
	//Set playerSingleton viruses
	player._viruses = viruses;
	

		
	NSDictionary *playerInfectedWith = [playerDict objectForKey:@"infected_with"];
	
	for( NSDictionary *each_virus in playerInfectedWith )
	{
		NSString *virusName = [NSString stringWithFormat:@"%@",[each_virus objectForKey:@"virus_name"]];
		NSString *virusOwner = [NSString stringWithFormat:@"%@",[each_virus objectForKey:@"virus_owner"]];
		//Needs to retrieve more data
		
		cVirus *infectedWith = [[cVirus alloc] init];
		infectedWith._virusName = virusName;
		infectedWith._owner = virusOwner;
		//Set playersingleton infectedWith
		player._infectedWith = infectedWith;
	}

	
}

@end
