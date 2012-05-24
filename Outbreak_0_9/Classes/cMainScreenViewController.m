//
//  cMainScreenViewController.m
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/3/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "cInfectViewController.h"
#import "cMainScreenViewController.h"
#import "cPlayerSingleton.h"
#import "cVirusSelectionViewController.h"

@implementation cMainScreenViewController
@synthesize _infectScreenButton;
@synthesize _virusScreenButton;
@synthesize _infectedWithLabel;
@synthesize _playerMGR;
@synthesize _enemyStatsView;
@synthesize _tokenLabel;
//debug
@synthesize _healButton;

- (id)init {
    self = [super init];
    if (self)
    {
        _playerMGR = [[cPlayerManager alloc] init];
        _playerMGR.delegate = self;
    }
    return self;
}

- (void)dealloc {
    [_playerMGR release];
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

	[_playerMGR Logout];
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

- (void)UICallback:(BOOL)success errorMsg:(NSString *)errMsg {
    
    if (success)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    self._enemyStatsView.text = @"";
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
    
    self._enemyStatsView.editable = FALSE;
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	if( player._infectedWith != nil ) 
    {
		self.view.backgroundColor = [UIColor redColor];
		self._infectedWithLabel.text = [NSString stringWithFormat:@"infected with %@ - %@", player._infectedWith._virusName, player._infectedWith._owner];
        self._enemyStatsView.text = [player._infectedWith GetStats];
	}
	else
	{
		self.view.backgroundColor = [UIColor whiteColor];
		self._infectedWithLabel.text = nil;
        self._enemyStatsView.text = nil;
	}
    self._tokenLabel.text = [NSString stringWithFormat:@"Tokens:%@", player._tokens];
}

//debug
- (IBAction)HealButtonPressed:(id)sender {
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    //Get url and method strings
	NSString *urlstring = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"URLSERVER", nil),NSLocalizedString(@"InfectionPersister", nil)];
    NSString  *webMethod = [NSString stringWithFormat:@"%@", NSLocalizedString(@"MethodCurePlayer", nil)];
	NSURL *url = [NSURL URLWithString:urlstring];
	
    //Set request attributes
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:webMethod forKey:@"method"];
	[request setPostValue:player._username forKey:@"username"];
	
	[request setDidFinishSelector:@selector(HealDidFinished:)];
	[request setDidFailSelector:@selector(HealDidFailed:)];
	[request setDelegate:self];
    player._infectedWith = nil;
	[request startAsynchronous];
}

- (void)HealDidFinished:(ASIHTTPRequest *)request {
    NSLog(@"Heal did finished:%@", [request responseString]);

    
}

/************************************************************
 * Purpose: Handles the rainy situation when the user has lost 
 *  connection
 *
 * Entry: Asynchronous request times out, FAILED CONNECTION
 *
 * Exit: delegate is alerted of the failed request
 ************************************************************/
- (void)HealDidFailed:(ASIHTTPRequest *)request {
	
    NSLog(@"Heal did failed:%@", [request responseString]);
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
