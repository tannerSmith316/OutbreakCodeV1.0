//
//  cRegisterViewController.mfile://localhost/Users/mckenziekurtz/Documents/TannerFolder/JP/Outbreak_0_9/Classes/cRegisterViewController.xib
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/1/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cPlayerSingleton.h"
#import "cRegisterViewController.h"

@implementation cRegisterViewController

@synthesize _playerMGR;
@synthesize _usernameField;
@synthesize _passwordField;
@synthesize _passwordField2;
@synthesize _registerButton;
@synthesize _errorMessage;
@synthesize _whirligig;

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

- (void)dealloc {
    [_playerMGR release];
    [super dealloc];
}

//Checks if the information in the UI fields is valid, if so
//It sends the data off to the player manager for logical computations
- (IBAction)RegisterButtonPressed:(id)sender {
	
	//Checks that user doesnt have an "empty string" password
	if ( [self._usernameField.text length] != 0 && [self._passwordField.text length] != 0 && [self._passwordField2.text length] != 0 )
	{
		//Check if the user re-typed the password correctly in second field
		if( [self._passwordField.text isEqualToString:self._passwordField2.text] ) 
		{
			//UI Indicates a process occurring with whirligig animation
			self._whirligig.hidden = FALSE;
			[_whirligig startAnimating];
			_registerButton.enabled = FALSE;
            self.navigationItem.backBarButtonItem.enabled = FALSE;
		
			
			[self._playerMGR RegisterWithUsername:self._usernameField.text Password:self._passwordField.text];
		}
		else
		{
			self._errorMessage.text = NSLocalizedString(@"BadPasswordRetype", nil);
		}
	}
	else
	{
		self._errorMessage.text = NSLocalizedString(@"EmptyFields", nil);
	}
}

//Callback when PlayerManager tells RegisterView its done processing
- (void)UICallback:(BOOL)asyncSuccess errorMsg:(NSString *)errMsg {
	//Re-Enable the UI elements
	self._errorMessage.text = errMsg;
	self._whirligig.hidden = TRUE;
    self._registerButton.enabled = TRUE;
    self.navigationItem.backBarButtonItem.enabled = TRUE;
	[_whirligig stopAnimating];
}

//Makes keyboard dissapear when Return button pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self._whirligig.hidesWhenStopped = TRUE;
}

/****** UNMODIFIED NEEDED view event handlers BELOW*******/

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
