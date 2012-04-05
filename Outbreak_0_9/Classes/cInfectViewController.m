//
//  cInfectViewController.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/7/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cInfectViewController.h"
#import "cVictim.h"
#import "cPlayerSingleton.h"
#import "cInfectionManager.h"


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
	
	//query db
	
	//put into array
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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Configure the cell.
	cVictim *theVictim = [[cVictim alloc] initWithVictim:[_victimArray objectAtIndex:indexPath.row]];
	NSNumber *nm = [NSNumber numberWithFloat:[theVictim._distance floatValue]];
	NSString *str = [NSString stringWithFormat:@"%@ \t\t\t           %-6.1f", theVictim._username, [theVictim._distance floatValue]];
	
    cell.textLabel.text = str;
	[theVictim release];
	
	
    return cell;
}



//Victim has been chosen for infection attempt
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//run virus defenses
	//infectionmanager.infect(currentvirus, username)
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	cInfectionManager *infector = player._infectionMGR;
	[infector AttemptInstant:[_victimArray objectAtIndex:indexPath.row]];
	//POST Infect to web server if success
	//if (infectionSucces)
}

- (void)UpdateVictimTable:(NSArray *)victimArray {
	
	//Insert Victims into table view
	[self._victimArray setArray:victimArray];
	[_victimTable reloadData];
	
}

- (IBAction)RefreshButtonPressed {

	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	player._locationMGR.delegate = self;
	[player._locationMGR GetNearby];
	
}


@end
