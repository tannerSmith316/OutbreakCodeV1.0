//
//  cInfectViewController.m
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/7/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cInfectionManager.h"
#import "cInfectViewController.h"
#import "cVictim.h"

@implementation cInfectViewController
@synthesize _victimArray;
@synthesize _virusCooldown;
@synthesize _virusCDTimer;
@synthesize _timerCount;
@synthesize _cooldownProgress;
@synthesize _victimToInfect;
@synthesize _cooldownLabel;
@synthesize _activeVirusLabel;

- (id)init {
	self = [super init];
	if (self)
	{
		_victimArray = [[NSMutableArray alloc] init];
        
	}
	return self;
}

- (void)dealloc {
    [_victimArray release];
    [self._virusCDTimer invalidate];
    [super dealloc];
}

/************************************************************
 * Purpose: Request information from the Location Manager based
 *   on the user pressing a UI button
 *
 * Entry: UI button pressed
 *
 * Exit: Nearby victims have been returned from the location MGR
 ************************************************************/
- (IBAction)RefreshButtonPressed {
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	player._locationMGR.delegate = self;
    if (player._currentVirus || player._infectedWith) 
    {
        [player._locationMGR GetNearby];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need a Virus" message:@"No active virus for infections" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
	
}

/************** UITABLEVIEW DELEGATE REQUIRED FUNCTIONS **********/

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_victimArray count];
}

// Customize the appearance of table view cells to show victim and distance
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Make a regular cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Configure the cell.
	cVictim *theVictim = [[cVictim alloc] initWithVictim:[_victimArray objectAtIndex:indexPath.row]];
	NSString *str = [NSString stringWithFormat:@"%@ \t\t\t           %-6.1f", theVictim._username, [theVictim._distance floatValue]];
	
    cell.textLabel.text = str;
	[theVictim release];
		
    return cell;
}

/************************************************************
 * Purpose: Requests the infection manager to attempt an instant 
 *   infection on the victim located at the table index selected
 *
 * Entry: UITable index.row selected on screen
 *
 * Exit: Vicitm data has been sent to the infection manager
 ************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self._virusCooldown)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Virus is on Cooldown" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else 
    {
        //Send victim info to the manager for logical computations
        self._victimToInfect = [_victimArray objectAtIndex:indexPath.row];
        [self StartCooldownTimer];
    }
}

- (void)StartCooldownTimer {
    
    self._virusCooldown = TRUE;
    self._cooldownLabel.hidden = FALSE;
    //Get time based on virus stats
    self._virusCDTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CDTimerFired) userInfo:nil repeats:YES];
}

- (void)CDTimerFired {
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    int minCooldown = [NSLocalizedString(@"MINCOOLDOWN", nil) intValue];
    int maxCooldown = [NSLocalizedString(@"MAXCOOLDOWN", nil) intValue];
    
    int virusCooldown = ([player._currentVirus._instantPoints floatValue] / 100) * (minCooldown - maxCooldown) + maxCooldown;
    
    _timerCount = _timerCount + 1;
    if(_timerCount == virusCooldown)//Change hard value to timer instant points
    {
        self._cooldownLabel.hidden = TRUE;
        [_virusCDTimer invalidate];
        self._virusCooldown = FALSE;
        [self._cooldownProgress setProgress:0 animated:YES];
        _timerCount = 0;
        
        [player._infectionMGR AttemptInstant:self._victimToInfect];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Infection Sent" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release]; 
    }
    else 
    {
        double aProgress = (double)_timerCount * ((double)1/(double)virusCooldown);
        [self._cooldownProgress setProgress:aProgress animated:YES];
    }
}

/************************************************************
 * Purpose: UICallback when the location manager sends infectionView the
 *   array of victims from its GetNearby
 *
 * Entry: LocationManager has finished asynchronous request and calls
 *   back to the infectView
 *
 * Exit: victimArray has been saved locally and is used to update the UITableView
 ************************************************************/
- (void)UpdateVictimTable:(NSArray *)victimArray {
	
	//retain the sent array in self
	[self._victimArray setArray:victimArray];
    //Tell the UITable to update its data
	[_victimTable reloadData];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    
    if(player._infectedWith)
    {
        self._activeVirusLabel.text = [NSString stringWithFormat:@"Active Virus:%@(Foreign)",player._infectedWith._virusName];
    }
    else
    {
        self._activeVirusLabel.text = [NSString stringWithFormat:@"Active Virus:%@",player._currentVirus._virusName];
    }
    self._cooldownProgress.progress = 0;
    self._cooldownLabel.hidden = TRUE;
    
	
}

/******* UNMODIFIED view event handlers BELOW **********/


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated {
    self._cooldownProgress.progress = 0;
    self._timerCount =0;
    [self._virusCDTimer invalidate];
    self._virusCooldown = FALSE; 
}

- (void)viewDidUnload {
    
    self._cooldownProgress.progress = 0;
    self._timerCount =0;
    [self._virusCDTimer invalidate];
    self._virusCooldown = FALSE;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
