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
	[player._locationMGR GetNearby];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    //Send victim info to the manager for logical computations
	[player._infectionMGR AttemptInstant:[_victimArray objectAtIndex:indexPath.row]];
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

/******* UNMODIFIED view event handlers BELOW **********/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
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

@end
