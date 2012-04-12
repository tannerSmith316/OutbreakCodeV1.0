//
//  cRegisterViewController.mfile://localhost/Users/mckenziekurtz/Documents/TannerFolder/JP/Outbreak_0_9/Classes/cRegisterViewController.xib
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/1/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cRegisterViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cPlayerSingleton.h"

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

- (IBAction)RegisterButtonPressed:(id)sender {
	
	//check if password fields are the same
	if ( [self._usernameField.text length] != 0 && [self._passwordField.text length] != 0 && [self._passwordField2.text length] != 0 )
	{
		
		if( [self._passwordField.text isEqualToString:self._passwordField2.text] ) 
		{
			//UI Indicates a process occurring with whirligig animation
			self._whirligig.hidden = FALSE;
			[_whirligig startAnimating];
			_registerButton.enabled = FALSE;
		
			//post call
			[self._playerMGR RegisterWithUsername:self._usernameField.text Password:self._passwordField.text];
		
		}
		else
		{
			self._errorMessage.text = @"PASSWORDS DONUT MATCH";
		}
	}
	else
	{
		self._errorMessage.text = @"FILL IN YOUR fields";
	}
}

- (void)UpdateCallBack:(NSString *)msg {
	
	self._errorMessage.text = msg;
	self._whirligig.hidden = TRUE;
	[_whirligig stopAnimating];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	return NO;
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

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

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

@end
