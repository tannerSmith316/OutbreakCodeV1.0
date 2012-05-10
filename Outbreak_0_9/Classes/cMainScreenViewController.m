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

//Calls managers to log the user out and pop's the
//view back to the login screen
- (void)LogoutBackButton {

	//TODO: CALL PHP LOGOUT SCRIPT
	
    //clear playersingleton
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	[player ResetInstance];
	[player._updateLocationTimer invalidate];
	//pop viewcontroller
	[self.navigationController popViewControllerAnimated:YES];
}

//Changes the view when user presses the button
- (IBAction)InfectScreenButtonPressed {

	cInfectViewController *infectionView = [[cInfectViewController alloc] init];
	infectionView.title = @"Infect";
	[self.navigationController pushViewController:infectionView animated:YES];
}

//Changes the view when the user presses the button
- (IBAction)VirusScreenButtonPressed {
	
	cVirusSelectionViewController *virusview = [[cVirusSelectionViewController alloc] init];
	virusview.title = @"Viruses";
	[self.navigationController pushViewController:virusview animated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set the Navigation Bar's back button programmatically(instead of using IB)
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(LogoutBackButton)];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];
}

//Check everytime the user go's to the main screen if the user is infected
//If so - Display it to the screen somehow
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
