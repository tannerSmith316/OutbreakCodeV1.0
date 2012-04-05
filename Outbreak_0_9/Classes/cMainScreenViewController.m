//
//  cMainScreenViewController.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/3/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cMainScreenViewController.h"
#import "cPlayerSingleton.h"
#import "cInfectViewController.h"
#import "cVirusSelectionViewController.h"

@implementation cMainScreenViewController

@synthesize _infectScreenButton;
@synthesize _virusScreenButton;
@synthesize _infectedWithLabel;
@synthesize _hotspotButton;


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
- (void)viewWillAppear:(BOOL)animated {

	//
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	if( player._infectedWith != nil ) {
		self.view.backgroundColor = [UIColor redColor];
		self._infectedWithLabel.text = [NSString stringWithFormat:@"infected with %@ - %@", player._infectedWith._virusName, player._infectedWith._owner];
	}
	else
	{
		self.view.backgroundColor = [UIColor whiteColor];
		self._infectedWithLabel.text = nil;
	}
}

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

- (void)LogoutBackButton {

	//TODO:
	//upload all stats to DB
	//clear playersingleton
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	[player ResetInstance];
	[player._updateLocationTimer invalidate];
	//pop viewcontroller
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)InfectScreenButtonPressed {

	//push view
	cInfectViewController *infectionView = [[cInfectViewController alloc] init];
	infectionView.title = @"Infect";
	[self.navigationController pushViewController:infectionView animated:YES];
}

- (IBAction)VirusScreenButtonPressed {
	
	//
	cVirusSelectionViewController *virusview = [[cVirusSelectionViewController alloc] init];
	virusview.title = @"Viruses";
	[self.navigationController pushViewController:virusview animated:YES];
}

- (IBAction)HotspotButtonPressed {

	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	if (player._latitude != nil)
	{
		[player._infectionMGR LayHotspot];
	}
	
}

- (IBAction)HealInfection {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	player._infectedWith = nil;
}

@end
