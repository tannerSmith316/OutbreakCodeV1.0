//
//  cLocationManager.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/5/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cLocationManager.h"
#import "cPlayerSingleton.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cVictim.h"
#import "JSONKit.h"
#import "cInfectionManager.h"

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

- (void)PollCoreLocation {
	
	//startupdateloc starts core location
	[CLController.locMgr startUpdatingLocation];
}



- (void)locationUpdate:(CLLocation *)location {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	//Parse latitude and longitude out of location info
	NSString *latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
	NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
	
	player._latitude = latitude;
	player._longitude = longitude;
	
	//persistloc
	
	
	
	NSString *urlstring = [NSString stringWithFormat:@"%@updateLocation.php",player._serverIP];
	NSURL *url = [NSURL URLWithString:urlstring];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:latitude forKey:@"latitude"];
	[request setPostValue:longitude forKey:@"longitude"];
	[request setPostValue:player._username forKey:@"username"];
	
	[request setDidFinishSelector:@selector(PersistLocationDidFinished:)];
	[request setDidFailSelector:@selector(PersistLocationDidFailed:)];
	
	[request setDelegate:self];
	[request startAsynchronous];
	
	NSLog(@"POST: UpdateLocation, Lat:%@ ; Long:%@", latitude, longitude);
	
}

- (void)locationError:(NSError *)error {

	//Unable to update location - Disable game features 
	NSLog(@"CoreLocation Failure Postback hit");
}

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
		//Parse the json
		NSDictionary *deserializedData = [[NSDictionary alloc] init];
		deserializedData = [jsonString objectFromJSONString];
		
		[self parseVirusJson:deserializedData];
		
	}
	//restart timer
	if (player._username != nil)
	{
		[player StartUpdateTimer];
	}
	else
	{
		//player._isTimerActive = FALSE;
		
		NSLog(@"Timer stopped - Invalid Username");
	}

	
	
	
	
}

- (void)PersistLocationDidFailed:(ASIHTTPRequest *)request {
	
}

- (void)dealloc {

	[CLController release];
	[super dealloc];
}

- (void)GetNearby {
	//STUBBED  *****************************************************
	//takes virus range via instant spread
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	//Range Modifier = -(distance/MAXRANGE) + 1
	float rangeFloat = ([player._currentVirus._instantPoints floatValue] / 100) * ([player._MAXDISTANCE floatValue] - [player._MINDISTANCE floatValue]) + [player._MINDISTANCE floatValue];
	NSNumber *range = [NSNumber numberWithFloat:rangeFloat];
	
	//sends to php

	NSString *urlappended = [NSString stringWithFormat:@"%@getNearby.php", player._serverIP];
	NSURL *url = [NSURL URLWithString:urlappended];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setDidFinishSelector:@selector(GetNearbyFinished:)];
	[request setPostValue:player._username forKey:@"username"];
	[request setPostValue:player._latitude forKey:@"latitude"];
	[request setPostValue:player._longitude forKey:@"longitude"];
	[request setPostValue:range forKey:@"range"];
	[request setDelegate:self];
	
	//SET TO SYNCHRONOUS WHEN TESTING
	[request startSynchronous];
	//[request startAsynchronous];
	//recieve json
	//return array of playes
	
}

- (void)GetNearbyFinished:(ASIHTTPRequest *)request
{
	
	NSString *jsonString = [NSString stringWithString:[request responseString]];
	//Parse the json
	NSDictionary *deserializedData = [[NSDictionary alloc] init];
	deserializedData = [jsonString objectFromJSONString];
	
	//Make array
	NSMutableArray *victims = [[NSMutableArray alloc] init];
	//Retrieve information from the deserialized json string
	for (NSDictionary * dataDict in deserializedData) {
		NSString * victimName = [dataDict objectForKey:@"username"];
		NSString * victimDistance = [dataDict objectForKey:@"distance"];
		
		cVictim *aVictim = [[cVictim alloc] init];
		aVictim._username = victimName;
		aVictim._distance = victimDistance;
		[victims addObject:aVictim];
		
		[aVictim release];
	}
	
	//Post Array to viewcontroller delegate for table update
	[delegate UpdateVictimTable:victims];
	
	[victims release];
}

- (void)parseVirusJson:(NSDictionary *)jsonDict {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	
	//Retrieve information from the deserialized json string
	NSDictionary *hotspots = [jsonDict objectForKey:@"hotspots"];
	for ( NSDictionary *hotspot in hotspots )
	{
		//stuff
		NSString *virusName = [NSString stringWithFormat:@"%@", [hotspot objectForKey:@"virus_name"]];
		NSString *virusOwner = [NSString stringWithFormat:@"%@", [hotspot objectForKey:@"virus_owner"]];
		NSString *virusZonePoints = [NSString stringWithFormat:@"%@", [hotspot objectForKey:@"zone_points"]];
		
		cVirus *enemyVirus = [[cVirus alloc] init];
		enemyVirus._virusName = virusName;
		enemyVirus._owner = virusOwner;
		enemyVirus._zonePoints = virusZonePoints;
		
		if (player._infectedWith == nil)
		{
			[player._infectionMGR DefendInfection:enemyVirus];
		}
		
		
		
		
	}
	
	NSDictionary *infectedWithViruses = [jsonDict objectForKey:@"infections"];
	for ( NSDictionary *each_virus in infectedWithViruses )
	{
		NSString *virusName = [NSString stringWithFormat:@"%@",[each_virus objectForKey:@"virus_name"]];
		NSString *virusOwner = [NSString stringWithFormat:@"%@",[each_virus objectForKey:@"virus_owner"]];
		//Needs to retrieve more virus info
		cVirus *virus = [[cVirus alloc] init];
		virus._virusName = virusName;
		virus._owner = virusOwner;
		
		if (player._infectedWith == nil)
		{
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"INFECTED!" message:[NSString stringWithFormat:@"You have been infect with:%@, by:%@",virusName, virusOwner] delegate:nil cancelButtonTitle:@"Ouch!" otherButtonTitles:nil] autorelease];
			[alert addButtonWithTitle:@"Quit it"];
			[alert show];
			
		}
		
		player._infectedWith = virus;
		
		
		[virus release];
	}
	if ([infectedWithViruses count] == 0 )
	{
		player._infectedWith = nil;
	}
	
}

@end
