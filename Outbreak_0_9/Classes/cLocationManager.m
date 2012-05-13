 //
//  cLocationManager.m
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/5/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cInfectionManager.h"
#import "cLocationManager.h"
#import "cPlayerSingleton.h"
#import "cVictim.h"
#import "JSONKit.h"

#import "cConnectionViewController.h"

@implementation cLocationManager
@synthesize CLController;
@synthesize delegate;

- (id)init {
	self = [super init];
	if (self != nil)
	{
		CLController = [[CoreLocationController alloc] init];
		CLController.delegate = self;
	}
	return self;
}

- (void)dealloc {
    
	[CLController release];
	[super dealloc];
}

/************************************************************
 * Purpose: Turn coreLocation back on to get location updates
 *
 * Entry: When the updateLocation timer fires from the playersingleton
 *
 * Exit: CoreLocation has startedUpdatingLocation
 ************************************************************/
- (void)PollCoreLocation {
	
	//startupdateloc starts core location
	[CLController.locMgr startUpdatingLocation];
}

/************************************************************
 * Purpose: Recieve the new location from core location and call
 * the persistlocation POST
 *
 * Entry: CoreLocation has sent a valid location in accuracy range
 *
 * Exit: function that POSTs to web server has started
 ************************************************************/
- (void)locationUpdate:(CLLocation *)location {
	//Parse latitude and longitude out of location info
	NSString *latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
	NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    
    [self PersistLatitude:latitude andLongitude:longitude];
}

/************************************************************
 * Purpose: Handles the rainy situation when core location has
 *   failed internally
 *
 * Entry: CoreLocation error - dunno what happened
 *
 * Exit: Display some errors
 ************************************************************/
- (void)locationError:(NSError *)error {

	//Unable to update location - Disable game features 
	NSLog(@"CoreLocation Failure Postback hit");
}

/************************************************************
 * Purpose: Send asynchronous POST to server requesting that
 *   the player's location been updated to the values passed in
 *
 * Entry: UpdateLocation timer fired and CoreLocation has returned 
 *   a valid location
 *
 * Exit: POST to web server made
 ************************************************************/
- (void)PersistLatitude:(NSString *)latitude andLongitude:(NSString *)longitude {
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    player._latitude = latitude;
	player._longitude = longitude;
	
	NSString *urlstring = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"URLSERVER", nil),NSLocalizedString(@"LocationPersister", nil)];
	NSURL *url = [NSURL URLWithString:urlstring];
	NSString  *webMethod = [NSString stringWithFormat:@"%@", NSLocalizedString(@"MethodPersistLocation", nil)];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:webMethod forKey:@"method"];
	[request setPostValue:latitude forKey:@"latitude"];
	[request setPostValue:longitude forKey:@"longitude"];
	[request setPostValue:player._username forKey:@"username"];
	
	[request setDidFinishSelector:@selector(PersistLocationDidFinished:)];
	[request setDidFailSelector:@selector(PersistLocationDidFailed:)];
	
	[request setDelegate:self];
	[request startAsynchronous];
	
	NSLog(@"POST: UpdateLocation, Lat:%@ ; Long:%@", latitude, longitude);
}

/************************************************************
 * Purpose: After we have persisted our location the web server
 *   will return a json packet containing hotspots the user is in
 *   or virus's they have been infected with, parse and save
 *
 * Entry: succesful connection to web server on persist location
 *
 * Exit: parseVirusJson has begun
 ************************************************************/	
- (void)PersistLocationDidFinished:(ASIHTTPRequest *)request {
    
	NSLog(@"POST: UpdateLocation Succesful");
	//set infected with
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	NSLog(@"%@",[request responseString]);
	if( [[request responseString] isEqualToString:@"FALSE"] )
	{
		//player is not infected
		player._infectedWith = nil;
	}
	else
	{
		//parse json
		NSString *jsonString = [NSString stringWithString:[request responseString]];
		NSDictionary *deserializedData = [[NSDictionary alloc] init];
		deserializedData = [jsonString objectFromJSONString];
		[self parseVirusJson:deserializedData];
	}
	//restart timer if player is still logged in
	if (player._username != nil)
	{
		[player StartUpdateTimer];
	}
	else
	{
		NSLog(@"Timer stopped - Invalid Username");
	}
     
}

/************************************************************
 * Purpose: Handles the rainy situation when the user has lost 
 *  connection
 *
 * Entry: Asynchronous request times out, FAILED CONNECTION
 *
 * Exit: 
 ************************************************************/
- (void)PersistLocationDidFailed:(ASIHTTPRequest *)request {
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    
    cConnectionViewController *vc = [[cConnectionViewController alloc] initWithUsername:player._username WithPassword:player._password];
    [player._appDel.navigationController pushViewController:vc animated:YES];
	
}

/************************************************************
 * Purpose: Send a POST request to server requesting all nearby
 *   victims within range of the users virus, we calculate virus
 *   distance here, before POST
 *
 * Entry: Player has requested the victim for infection table be
 *   refreshed
 *
 * Exit: POST request has been sent
 ************************************************************/
- (void)GetNearby {
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	float _MAXDISTANCE = [NSLocalizedString(@"MAXDISTANCE", nil) floatValue];
    float _MINDISTANCE = [NSLocalizedString(@"MINDISTANCE", nil) floatValue];
	//Range Modifier = -(distance/MAXRANGE) + 1
	float rangeFloat = ([player._currentVirus._instantPoints floatValue] / 100) * (_MAXDISTANCE - _MINDISTANCE) + _MINDISTANCE;
	NSNumber *range = [NSNumber numberWithFloat:rangeFloat];
	
	//sends to php
	NSString *urlstring = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"URLSERVER", nil),NSLocalizedString(@"LocationPersister", nil)];
	NSString  *webMethod = [NSString stringWithFormat:@"%@", NSLocalizedString(@"MethodGetNearby", nil)];
	NSURL *url = [NSURL URLWithString:urlstring];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setDidFinishSelector:@selector(GetNearbyFinished:)];
    [request setDidFailSelector:@selector(GetNearbyDidFailed:)];
    [request setPostValue:webMethod forKey:@"method"];
	[request setPostValue:player._username forKey:@"username"];
	[request setPostValue:player._latitude forKey:@"latitude"];
	[request setPostValue:player._longitude forKey:@"longitude"];
	[request setPostValue:range forKey:@"range"];
	[request setDelegate:self];
	
	//SET TO SYNCHRONOUS WHEN TESTING
	[request startAsynchronous];
	//[request startAsynchronous];	
}

/************************************************************
 * Purpose: Parse the return string from the server which
 *   contains an array of victims( username, distance ) and send
 *   the arary to InfectViewController for table updates
 *
 * Entry: succcessful connection to server
 *
 * Exit: delegate is alerted of the successful connection
 *   and is passed an array of victims
 ************************************************************/
- (void)GetNearbyFinished:(ASIHTTPRequest *)request
{
	
	NSString *jsonString = [NSString stringWithString:[request responseString]];
	//Parse the json
	NSDictionary *deserializedData = [[NSDictionary alloc] init];
	deserializedData = [jsonString objectFromJSONString];
	
	//Make array
	NSMutableArray *victims = [[NSMutableArray alloc] init];
	//Retrieve information from the deserialized json string
	for (NSDictionary * dataDict in deserializedData)
    {
		NSString * victimName = [dataDict objectForKey:@"username"];
		NSString * victimDistance = [dataDict objectForKey:@"distance"];
		
		cVictim *aVictim = [[cVictim alloc] init];
		aVictim._username = victimName;
		aVictim._distance = victimDistance;
		[victims addObject:aVictim];
		
		[aVictim release];
	}
	
	//Post Array to viewcontroller delegate for table update
	if ([delegate conformsToProtocol:@protocol(UILocationAsyncDelegate)]) 
    {
        [delegate UpdateVictimTable:victims];
    }
	
	[victims release];
}

- (void)GetNearbyFailed:(ASIHTTPRequest *)request {
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    
    cConnectionViewController *vc = [[cConnectionViewController alloc] initWithUsername:player._username WithPassword:player._password];
    [player._appDel.navigationController pushViewController:vc animated:YES];
}

/************************************************************
 * Purpose: Parse the data returned from the LocationDidFinished
 *   request. First we check for an infectedWith virus, get all its
 *   stats and save it. Then we check for hotspots and attempt to
 *   infect the user if they are in a hotspot
 *
 * Entry: Only called from PersistLocatonDidFinished for parsing 
 *   the return packet
 *
 * Exit: All data has been saved OR user tries to defend against
 *   a hotspot infection.
 ************************************************************/
- (void)parseVirusJson:(NSDictionary *)jsonDict {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
    NSDictionary *infectedWithViruses = [jsonDict objectForKey:@"infections"];
	for ( NSDictionary *each_virus in infectedWithViruses )
	{
		
		//Needs to retrieve more virus info
		cVirus *virus = [[cVirus alloc] init];
		virus._virusName = [NSString stringWithFormat:@"%@",[each_virus objectForKey:@"virus_name"]];
		virus._owner = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"virus_owner"]];
        virus._instantPoints = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"instant_points"]];
        virus._zonePoints = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"zone_points"]];
        virus._virusType = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"virus_type"]];
        if ([each_virus objectForKey:@"mutation"]) 
        {
            virus._mutation = [NSString stringWithFormat:@"%@", [each_virus objectForKey:@"mutation"]];
        }
        
        
        //Can only infect a player if they are not sick already
		if (player._infectedWith == nil)
		{
            player._infectedWith = virus;
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"INFECTED!" message:[NSString stringWithFormat:@"You have been infect with:%@, by:%@",virus._virusName, virus._owner] delegate:nil cancelButtonTitle:@"Ouch!" otherButtonTitles:nil] autorelease];
			[alert addButtonWithTitle:@"Quit it"];
			[alert show];
		}
        else 
        {
            player._infectedWith = virus;
        }
		
		[virus release];
	}
    
	//If the server says the player has no infectedWith, cure them
	//before running hotspot checks
    if([infectedWithViruses count] == 0)
    {
        //If they are losing an infection alert them
        if (player._infectedWith)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Virus has Perished" message:@"You feel better" delegate:nil cancelButtonTitle:@"Cool" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        player._infectedWith = nil;
    }

	//Retrieve information from the deserialized json string
	NSDictionary *hotspots = [jsonDict objectForKey:@"hotspots"];
	for ( NSDictionary *hotspot in hotspots )
	{
		//Make a virus with that hotspot data
        cVirus *enemyVirus = [[cVirus alloc] init];
		enemyVirus._virusName = [NSString stringWithFormat:@"%@", [hotspot objectForKey:@"virus_name"]];
		enemyVirus._owner = [NSString stringWithFormat:@"%@", [hotspot objectForKey:@"virus_owner"]];
		enemyVirus._zonePoints = [NSString stringWithFormat:@"%@", [hotspot objectForKey:@"zone_points"]];
        enemyVirus._instantPoints = [NSString stringWithFormat:@"%@", [hotspot objectForKey:@"instant_points"]];
        enemyVirus._virusType = [NSString stringWithFormat:@"%@", [hotspot objectForKey:@"virus_type"]];
        if([hotspot objectForKey:@"mutation"]) 
        {
            enemyVirus._mutation = [NSString stringWithFormat:@"%@", [hotspot objectForKey:@"mutation"]];
        }
        
		//Try to infect the player with hotspot virus
		if (player._infectedWith == nil)
		{
            //If someone is logged in(Hopefully fixes alert view showing while logged out)
            if (player._username)
            {
                [player._infectionMGR DefendInfection:enemyVirus];
            }
		}
        [enemyVirus release];
	}
}

@end
