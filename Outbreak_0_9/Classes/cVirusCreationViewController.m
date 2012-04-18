//
//  cVirusCreationViewController.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/10/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cVirusCreationViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cPlayerSingleton.h"
#import "cVirus.h"


@implementation cVirusCreationViewController

@synthesize _virusMGR;
@synthesize _instantSlider;
@synthesize _zoneSlider;
@synthesize _helpTextView;
@synthesize _virusNameField;
@synthesize _typeSwitcher;
@synthesize _instantValue;
@synthesize _zoneValue;
@synthesize _virusName;
@synthesize _instantPoints;
@synthesize _zonePoints;
@synthesize _virusType;
@synthesize _createButton;


- (id)init {
	
	self = [super init];
	if (self != nil)
	{
		//custom inits here
		_virusMGR = [[cVirusManager alloc]init];
		_virusMGR.delegate = self;
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
	
	int progressAsInt = (int)(_instantSlider.value + 0.5f);
	NSString *newText = [[NSString alloc] initWithFormat:@"%d",progressAsInt];
	_instantValue.text = newText;
	[newText release];
	
	int progressAsInt1 = (int)(_zoneSlider.value + 0.5f);
	NSString *newText2 = [[NSString alloc] initWithFormat:@"%d",progressAsInt1];
	_zoneValue.text = newText2;
	[newText2 release];
	
	self._helpTextView.editable = FALSE;
	
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


-(IBAction)instantSliderChanged:(id)sender
{
	//Update label and 
	UISlider *slider = (UISlider *)sender;
	int progressAsInt = (int)slider.value;
	NSString *newText = [[NSString alloc] initWithFormat:@"%d",progressAsInt];
	_instantValue.text = newText;
	[newText release];
	
	//change zoneSlider acrodingly
	[_zoneSlider setValue: 100 - progressAsInt];
	NSString *newText2 = [[NSString alloc] initWithFormat:@"%d",(100 - progressAsInt)];
	_zoneValue.text = newText2;
	[newText2 release];
	
}

-(IBAction)zoneSliderChanged:(id)sender
{
	//Update label and 
	UISlider *slider = (UISlider *)sender;
	int progressAsInt = (int)slider.value;
	NSString *newText = [[NSString alloc] initWithFormat:@"%d",progressAsInt];
	_zoneValue.text = newText;
	[newText release];
	
	//change instantSlider acrodingly
	[_instantSlider setValue: 100 - progressAsInt];
	NSString *newText2 = [[NSString alloc] initWithFormat:@"%d",(100 - progressAsInt)];
	_instantValue.text = newText2;
	[newText2 release];
}

- (IBAction)CreateButtonPressed {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	//TODO: Need to check name against list of users current viruses locally
	if ([self._virusNameField.text length] == 0)
	{
		self._helpTextView.text = [NSString stringWithString:@"Please enter a virus name"];
	}
	else
	{
		//Save all ui fields to view controller variables
		cVirus *aVirus = [[cVirus alloc]init];
		aVirus._zonePoints =  [NSNumber numberWithInt:(int)self._zoneSlider.value];
		aVirus._instantPoints = [NSNumber numberWithInt:(int)self._instantSlider.value];
		aVirus._virusName = [NSString stringWithString:self._virusNameField.text];
		aVirus._virusType = [NSString stringWithString: [self._typeSwitcher titleForSegmentAtIndex:[self._typeSwitcher selectedSegmentIndex]]];
		
		//disable button
		self._createButton.enabled = FALSE;
		//post call
		[_virusMGR CreateVirus:aVirus]; 

	}

}

- (void)UpdateCallBack:(BOOL)wasCreated {

	self._createButton.enabled = TRUE;
	if (wasCreated)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
	else
	{
		self._helpTextView.text = @"Cannot connect to server";
	}

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	return NO;
}

- (IBAction)HelpButtonPressed:(id)sender {
	
	//Instant Help
	if ([sender tag] == 1 )
	{
		self._helpTextView.text = [NSString stringWithString:@"More instant points means farther range and higher rate for succesful infections on instant spread attempts"];
	}
	else if( [sender tag] == 2 )
	{
		self._helpTextView.text = [NSString stringWithString:@"More zone points means hotspots get laid more often and stay around longer "];
	}
	else if( [sender tag] == 3 )
	{
		self._helpTextView.text = [NSString stringWithString:@"RNA viruses are easier healed but can mutate on succesful infection\nDNA viruses dont mutate but are much harder to create vaccines from"];
	}
}

@end
