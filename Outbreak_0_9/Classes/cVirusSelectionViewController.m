//
//  cVirusSelectionViewController.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/10/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cVirusSelectionViewController.h"
#import "cVirusCreationViewController.h"
#import "cPlayerSingleton.h"
#import "cVirus.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cPlayerManager.h"
#import "cVirusManager.h"


@implementation cVirusSelectionViewController

@synthesize _virusMGR;
@synthesize _viruses;
@synthesize _deletingVirus;
@synthesize _currentVirusLabel;
@synthesize _createVirusButton;
@synthesize _deleteVirusButton;
@synthesize _selectVirusButton;
@synthesize _virusSelectTable;

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
	
	
}

- (void)viewWillAppear:(BOOL)animated
{
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	self._viruses = player._viruses;
	[_virusSelectTable reloadData];
	self._currentVirusLabel.text = player._currentVirus._virusName;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_viruses count];
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
	
	NSString *str = [[_viruses objectAtIndex:indexPath.row] _virusName];
	
    cell.textLabel.text = str;
	

	
    return cell;
}



//Victim has been chosen for infection attempt
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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

- (IBAction)CreateVirusButtonPressed {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	//Check if there are any spaces left for new viruses
	if ([player._viruses count] < 5)
	{
		cVirusCreationViewController *createview = [[cVirusCreationViewController alloc] init];
		createview.title = @"Viruses";
		[self.navigationController pushViewController:createview animated:YES];
	}
	
}

- (IBAction)DeleteVirusButtonPressed {

	NSIndexPath *indexPath = [self._virusSelectTable indexPathForSelectedRow];
	if (indexPath != nil)
	{
		cVirus *aVirus = [[cVirus alloc] initWithVirus:[_viruses objectAtIndex:indexPath.row]];
		
		self.navigationItem.leftBarButtonItem.enabled = FALSE;
		self._createVirusButton.enabled = FALSE;
		self._deleteVirusButton.enabled = FALSE;
		self._selectVirusButton.enabled = FALSE;
		
		[self._virusMGR DeleteVirus:aVirus];
	}
	

}

- (void)UpdateCallBack {

	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	self._viruses = player._viruses;
	self._currentVirusLabel.text = player._currentVirus._virusName;
	[self._virusSelectTable reloadData];
	self.navigationItem.leftBarButtonItem.enabled = TRUE;
	self._createVirusButton.enabled = TRUE;
	self._deleteVirusButton.enabled = TRUE;
	self._selectVirusButton.enabled = TRUE;
}



- (IBAction)SelectVirusButtonPressed {

	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	//Must check for something in array or retrieving indexPath will crash
	if ([player._viruses count] > 0)
	{
		NSIndexPath *indexPath = [self._virusSelectTable indexPathForSelectedRow];

		//set users current virus to virus at index path
		cVirus *theVirus = [[cVirus alloc] initWithVirus:[_viruses objectAtIndex:indexPath.row]];
	
		//Set current virus to the selected one
		[self._virusMGR SelectVirus:theVirus];
		[theVirus release];
	
		//helper label: Update viewcontrollers label
		self._currentVirusLabel.text = player._currentVirus._virusName;
	}
	
}

@end
