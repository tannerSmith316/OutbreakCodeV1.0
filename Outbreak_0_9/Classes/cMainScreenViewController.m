//
//  cMainScreenViewController.m
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/3/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cInfectViewController.h"
#import "cMainScreenViewController.h"
#import "cPlayerSingleton.h"
#import "cVirusSelectionViewController.h"

@implementation cMainScreenViewController
@synthesize _infectScreenButton;
@synthesize _virusScreenButton;
@synthesize _infectedWithLabel;

- (void)dealloc {
    [super dealloc];
}

/************************************************************
 * Purpose: Calls managers to log the user out and pop's the view
 *    back to the login screen
 *
 * Entry: UI Button pressed
 *
 * Exit: Navigationstack pops back to LoginView
 ************************************************************/
- (void)LogoutBackButton {

	//TODO: CALL PHP LOGOUT SCRIPT
	
    //clear playersingleton
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	[player ResetInstance];
	[player._updateLocationTimer invalidate];
	//pop viewcontroller
	[self.navigationController popViewControllerAnimated:YES];
}

/************************************************************
 * Purpose: Menu button to switch to the InfectionViewController
 *
 * Entry: UI button pressed
 *
 * Exit: InfectViewController has been pushed
 ************************************************************/
- (IBAction)InfectScreenButtonPressed {

	cInfectViewController *infectionView = [[cInfectViewController alloc] init];
	infectionView.title = @"Infect";
	[self.navigationController pushViewController:infectionView animated:YES];
}

/************************************************************
 * Purpose: Menu button to switch to the VirusSelectionView
 *
 * Entry: UI button pressed
 *
 * Exit: VirusSelectionView has been pushed
 ************************************************************/
- (IBAction)VirusScreenButtonPressed {
	
	cVirusSelectionViewController *virusview = [[cVirusSelectionViewController alloc] init];
	virusview.title = @"Viruses";
	[self.navigationController pushViewController:virusview animated:YES];
}

/************************************************************
 * Purpose: Creates a UIBarButtonItem programmatically, functions
 *    similarly to Interface Builder tied buttons
 *
 * Entry: The view has been loaded
 *
 * Exit: Button has been created and attached to the view
 ************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set the Navigation Bar's back button programmatically(instead of using IB)
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(LogoutBackButton)];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];
}

/************************************************************
 * Purpose: Change the main screen background color and label to
 *   alert the user if they are infected, everytime the screen appears
 *
 * Entry: View appears on screen
 *
 * Exit: background color and label have been set according to infectedWith
 ************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	if( player._infectedWith != nil ) 
    {
		self.view.backgroundColor = [UIColor redColor];
		self._infectedWithLabel.text = [NSString stringWithFormat:@"infected with %@ - %@", player._infectedWith._virusName, player._infectedWith._owner];
	}
	else
	{
		self.view.backgroundColor = [UIColor whiteColor];
		self._infectedWithLabel.text = nil;
	}
}

/********** UNMODIFIED apple view event handlers BELOW ********/

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
