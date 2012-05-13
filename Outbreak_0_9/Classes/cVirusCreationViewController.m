//
//  cVirusCreationViewController.m
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/10/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cPlayerSingleton.h"
#import "cVirus.h"
#import "cVirusCreationViewController.h"
#import "cConnectionViewController.h"

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
		_virusMGR = [[cVirusManager alloc]init];
		_virusMGR.delegate = self;
	}
	return self;
}

- (void)dealloc {
    [_virusMGR release];
    [super dealloc];
}

/************************************************************
 * Purpose: Set the UILabels to values based on UISlider values
 *   when the view loads
 *
 * Entry: View loaded
 *
 * Exit: Labels have been updated
 ************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
	
    //Setup labels to indicate value of slider
	int progressAsInt = (int)(_instantSlider.value + 0.5f);
	NSString *newText = [[NSString alloc] initWithFormat:@"%d",progressAsInt];
	_instantValue.text = newText;
	[newText release];
	
	int progressAsInt1 = (int)(_zoneSlider.value + 0.5f);
	NSString *newText2 = [[NSString alloc] initWithFormat:@"%d",progressAsInt1];
	_zoneValue.text = newText2;
	[newText2 release];
	
    //Help textview is READ-ONLY
	self._helpTextView.editable = FALSE;
}

/************************************************************
 * Purpose: Change UILabels to values based on Slider values
 *   Slider values are tied together, sharing 100 points
 *
 * Entry: Everytime the instant slider value changes
 *
 * Exit: Labels and values updated
 ************************************************************/
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

/************************************************************
 * Purpose: Change UILabels to values based on Slider values
 *   Slider values are tied together, sharing 100 points
 *
 * Entry: Everytime the instant slider value changes
 *
 * Exit: Labels and values updated
 ************************************************************/
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

/************************************************************
 * Purpose: Checks the UI fields to be complete and retreives all
 * the inputed data to be sent tot he virus manager for creation
 *
 * Entry: UIButton pressed
 *
 * Exit: Virus sent to manager or error message displayed
 ************************************************************/
- (IBAction)CreateButtonPressed {

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

/************************************************************
 * Purpose: Sets the helpTextView text to the error strings
 *   based on button pressed tag
 *
 * Entry: When any of the help buttons on screen are pressed
 *
 * Exit: Labels updated
 ************************************************************/
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

/************************************************************
 * Purpose: Allows the Manager to alert the ViewController that
 *	 its done and the UI can be updated
 *
 * Entry: Manager asynchronous request has finished
 *
 * Exit: view is popped or error message is displayed
 ************************************************************/
- (void)UpdateCallback:(BOOL)asyncSuccess errMsg:(NSString *)errMsg {
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	self._createButton.enabled = TRUE;
	if (asyncSuccess)
	{
        //If the virus was created, Pop back to SelectionView
		[self.navigationController popViewControllerAnimated:YES];
	}
	else
	{
		self._helpTextView.text = errMsg;
        cConnectionViewController *vc = [[cConnectionViewController alloc] initWithUsername:player._username WithPassword:player._password];
        vc.title = @"Reconnect View";
        [player._appDel.navigationController pushViewController:vc animated:YES];
	}

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

/************ UNMODIFIED view event handlers BELOW *********/

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
