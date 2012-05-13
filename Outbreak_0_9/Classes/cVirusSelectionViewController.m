//
//  cVirusSelectionViewController.m
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/10/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cVirusSelectionViewController.h"
#import "cVirusCreationViewController.h"
#import "cPlayerSingleton.h"
#import "cVirus.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cPlayerManager.h"


@implementation cVirusSelectionViewController

@synthesize _virusStatsText;
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
 * Purpose: Keep the current virus up to date by checking its value
 *    from the playsingleton everytime the view appears
 *
 * Entry: the View has appeared
 *
 * Exit: label and textview set appropriately
 ************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	self._viruses = player._viruses;
	[_virusSelectTable reloadData];
	self._currentVirusLabel.text = player._currentVirus._virusName;
    
    //If the user has a selected virus, display its stats in a textview
    if(player._currentVirus)
        self._virusStatsText.text = [NSString stringWithString:[player._currentVirus GetStats]];
}

/************************************************************
 * Purpose: Checks if the user has less than the max amount of viruses
 *   if so, navigate to the creation view controller, otherwise warn user
 *
 * Entry: UI button pressed
 *
 * Exit: CreationView pushed or error message displayed
 ************************************************************/
- (IBAction)CreateVirusButtonPressed {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    int MAXVIRUSES = [NSLocalizedString(@"MAXPLAYERVIRUSES", nil) intValue];
    
	//Check if there are any spaces left for new viruses
	if ([player._viruses count] < MAXVIRUSES)
	{
		cVirusCreationViewController *createview = [[cVirusCreationViewController alloc] init];
		createview.title = @"Viruses";
		[self.navigationController pushViewController:createview animated:YES];
		[createview release];
	}
    else 
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Maximum Capacity" message:[NSString stringWithFormat:@"Maximum of 5 viruses reached!"] delegate:nil cancelButtonTitle:@"Aww!" otherButtonTitles:nil] autorelease];
        [alert show];
    }
	
}

/************************************************************
 * Purpose: Gets the indexPath from the UITableView and uses that to
 *   index into the viruses array,if data was collected it's sent to 
 *   the virus manager for processing
 *
 * Entry: UI button pressed
 *
 * Exit: Collected data given to virus MGR or no actions taken if
 *   nothing to delete
 ************************************************************/
- (IBAction)DeleteVirusButtonPressed {

    //Get index from tableView which corresponds with viruses array index
	NSIndexPath *indexPath = [self._virusSelectTable indexPathForSelectedRow];
	if (indexPath != nil)
	{
		cVirus *aVirus = [[cVirus alloc] initWithVirus:[_viruses objectAtIndex:indexPath.row]];
		
		self.navigationItem.leftBarButtonItem.enabled = FALSE;
		self._createVirusButton.enabled = FALSE;
		self._deleteVirusButton.enabled = FALSE;
		self._selectVirusButton.enabled = FALSE;
		
		[self._virusMGR DeleteVirus:aVirus];
        [aVirus release];
	}
    self._virusStatsText.text = @"";
}

/************************************************************
 * Purpose: Checks if player has a virus to select, retrieves UITable
 *   indexPath to index viruses array and sends virus to virusManager
 *
 * Entry: UI button pressed
 *
 * Exit: virus to select was sent to virusManager or no actions taken
 *  if the user has no viruses
 ************************************************************/
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

/************************************************************
 * Purpose: Callback for virusManager to tell virusSelectionView that
 *   its done processing along with passing any error messages
 *
 * Entry: Virus manager calls back to UI when done with asynchronous
 *    request
 *
 * Exit: UI has been updated(buttons re-enabled)
 ************************************************************/
- (void)UpdateCallback:(BOOL)asyncSuccess errMsg:(NSString *)errMsg {

	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	self._viruses = player._viruses;
	self._currentVirusLabel.text = player._currentVirus._virusName;
	[self._virusSelectTable reloadData];
	self.navigationItem.leftBarButtonItem.enabled = TRUE;
	self._createVirusButton.enabled = TRUE;
	self._deleteVirusButton.enabled = TRUE;
	self._selectVirusButton.enabled = TRUE;
    
}

/********************NEEDED UITableView Functions BELOW***************/
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

//a Virus has been highlighted on the table(actions occur on button press)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Display stats so user can make choice with the virus
    NSString *buffer = [NSString stringWithString:[[_viruses objectAtIndex:indexPath.row] GetStats]];
    self._virusStatsText.text = buffer;
}
/******************** END NEEDED UITableView Functions ABOVE***************/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Make TextView READ-ONLY
	self._virusStatsText.editable = FALSE;
	
}

/************UNMODIFIED view event handlers BELOW**********/

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

@end
