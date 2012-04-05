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

@synthesize _usernameField;
@synthesize _passwordField;
@synthesize _passwordField2;
@synthesize _registerButton;
@synthesize _errorMessage;
@synthesize _whirligig;


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

- (IBAction)RegisterPost:(id)sender {
	
	//check if password fields are the same
	if ( [self._usernameField.text length] != 0 && [self._passwordField.text length] != 0 && [self._passwordField2.text length] != 0 )
	{
		
		if( [self._passwordField.text isEqualToString:self._passwordField2.text] ) 
		{
			self._errorMessage.text = @"";
			//whirligig start
			self._whirligig.hidden = FALSE;
			[_whirligig startAnimating];
		
			//disable button
			_registerButton.enabled = FALSE;
		
			//post call
			cPlayerSingleton *player = [cPlayerSingleton GetInstance];
			NSString *urlstring = [NSString stringWithFormat:@"%@createAccount.php",player._serverIP];
			NSURL *url = [NSURL URLWithString:urlstring];
		
			ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
			[request setPostValue:_usernameField.text forKey:@"device_id"];
			[request setPostValue:_passwordField.text forKey:@"password"];
		
			[request setDidFinishSelector:@selector(RegisterDidFinished:)];
			[request setDidFailSelector:@selector(RegisterDidFailed:)];
		
			[request setDelegate:self];
			[request startAsynchronous];
		
		}
		else
		{
			self._errorMessage.text = @"PASSWORDS DONUT MATCH";
		}
	}
	else
	{
		self._errorMessage.text = @"FILL IN YOUR SHIT";
	}


	
}

- (void)RegisterDidFinished:(ASIHTTPRequest *)request {
	
	_whirligig.hidden = TRUE;
	[_whirligig stopAnimating];
	_registerButton.enabled = TRUE;
	NSString *accountMade = [NSString stringWithString:[request responseString]];
	
	//Account name was not taken and has been registered for the user
	if ([accountMade isEqualToString:@"TRUE"])
	{
		_errorMessage.text = @"HURRY UP AND LOGIN YOU COW";
	}
	//The request account name is already in use, advise user to choose another
	else
	{
		_errorMessage.text = @"PICK ANOTHER";
	}

}

- (void)RegisterDidFailed:(ASIHTTPRequest *)request {

	_errorMessage.text = @"Cannot Connect to SERVER";
	_registerButton.enabled = TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	return NO;
}

@end
