//
//  cInfectionManager.m
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/11/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cInfectionManager.h"
#import "cPlayerSingleton.h"

@implementation cInfectionManager
@synthesize _hotspotTimer;

- (id)init {
	self = [super init];
	if (self != nil)
	{
		_hotspotTimer = [[cHotspotTimer alloc] init];
	}
	return self;
}

- (void)dealloc {
	[_hotspotTimer release];
	[super dealloc];
}

//Run's the victims defenses, if infection succesful it
//calls PersistInfection
- (void)AttemptInstant:(cVictim *)aVictim {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	//pull immunity
	//pull defenses
	//random 0-1
	//if rand > %
	
	//Simulates 100% infection
	if (1)
	{
		[self PersistInfection:player._currentVirus WithVictim:aVictim];
	}
}

//Runs the users defenses against the Passed in virus, if the user
//Gets infected, persistInfection is called passing in the user as
//theVictim
- (void)DefendInfection:(cVirus *)enemyVirus {
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	//Check immunities
	//Check Stats
	
	//Simulates 100% infection
	if (1)
	{
		cVictim *myself = [[cVictim alloc] init];
		myself._username = player._username;
		
        if(player._infectedWith == nil)
        {
            //Set the infection
            player._infectedWith = enemyVirus;
            [self PersistInfection:enemyVirus WithVictim:myself];
            
            //Alert the user of the bad news
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"INFECTED!" message:[NSString stringWithFormat:@"You have been infect with:%@, by:%@",enemyVirus._virusName, enemyVirus._owner] delegate:nil cancelButtonTitle:@"Ouch!" otherButtonTitles:nil] autorelease];
            [alert addButtonWithTitle:@"Quit it"];
            [alert show];
        }
	}
}

//Sends an asynchronous POST request saving an infection to the database
- (void)PersistInfection:(cVirus *)aVirus WithVictim:(cVictim *)aVictim {

	NSString *urlstring = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"URLSERVER", nil),NSLocalizedString(@"InfectionPersister", nil)];
	NSURL *url = [NSURL URLWithString:urlstring];
	NSString  *webMethod = [NSString stringWithFormat:@"%@", NSLocalizedString(@"MethodInfectPlayer", nil)];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];


	[request setDidFinishSelector:@selector(InfectionDidFinished:)];
	[request setDidFailSelector:@selector(InfectionDidFailed:)];
	[request setPostValue:webMethod forKey:@"method"];
	[request setPostValue:aVictim._username forKey:@"victim_id"];
	[request setPostValue:aVirus._virusName forKey:@"virus_name"];
	[request setPostValue:aVirus._owner forKey:@"username"];
    if ( aVirus._mutation != nil ) {
        
        [request setPostValue:aVirus._mutation forKey:@"mutation"];
    }
	[request setDelegate:self];
	[request startAsynchronous];
}

//Callback indicating a succesful connection to the server
- (void)InfectionDidFinished:(ASIHTTPRequest *)request {
    NSLog(@"%@", [request responseString]);
}

//Callback indicating a failed connection to the server
- (void)InfectionDidFailed:(ASIHTTPRequest *)request {
	
}

//Sends an asynchronous POST to the web server persisting a hotspot
//With the users current virus based on its stats
- (void)LayHotspot {
    NSLog(@"Laying some hotspots(before POST)");
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    
    //ActiveVirus is the one laying the hotspot, if your infected you spread
    //the enemy virus
    cVirus *activeVirus;
    if (player._infectedWith) 
    {
        activeVirus = [[cVirus alloc] initWithVirus:player._infectedWith];
    }
    else
    {
        activeVirus = [[cVirus alloc] initWithVirus:player._currentVirus];
    }
    
    //Calculate hotspot values based on virus stats on linear math formulas
    float _MINTIME = [NSLocalizedString(@"MINTIME", nil) floatValue];
    float _MAXTIME = [NSLocalizedString(@"MAXTIME", nil) floatValue];
    float _MINHOTSPOTRANGE = [NSLocalizedString(@"MINHOTSPOTRANGE", nil) floatValue];
    float _MAXHOTSPOTRANGE = [NSLocalizedString(@"MAXHOTSPOTRANGE", nil) floatValue];
    float rangeFloat = ([activeVirus._zonePoints floatValue] / 100) * (_MAXHOTSPOTRANGE - _MINHOTSPOTRANGE) + _MINHOTSPOTRANGE;
	NSNumber *range = [NSNumber numberWithFloat:rangeFloat];
	
	NSString *rangeString = [NSString stringWithFormat:@"%@", range];
	
	float durationFloat = ([activeVirus._zonePoints floatValue] / 100) * (_MAXTIME - _MINTIME) + _MINTIME;
	NSNumber *durationNum = [NSNumber numberWithFloat:durationFloat];
    
    //Setup POST request
	NSString *urlstring = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"URLSERVER", nil),NSLocalizedString(@"InfectionPersister", nil)];
	NSURL *url = [NSURL URLWithString:urlstring];
	NSString  *webMethod = [NSString stringWithFormat:@"%@", NSLocalizedString(@"MethodLayHotspot", nil)];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	
	[request setDidFinishSelector:@selector(HotspotDidFinished:)];
	[request setDidFailSelector:@selector(HotspotDidFailed:)];
    [request setPostValue:webMethod forKey:@"method"];
	[request setPostValue:[NSString stringWithFormat:@"%@", durationNum] forKey:@"duration"];
	[request setPostValue:rangeString forKey:@"range"];
	[request setPostValue:activeVirus._virusName forKey:@"virus_name"];
	[request setPostValue:player._latitude forKey:@"latitude"];
	[request setPostValue:player._longitude forKey:@"longitude"];
	[request setPostValue:activeVirus._owner forKey:@"username"];
    [request setPostValue:activeVirus._mutation forKey:@"mutation"];

    //Were done with this guy now
    [activeVirus release];

	[request setDelegate:self];
	[request startAsynchronous];
}

//Callback indicating succesful connection with server
//If server returns TRUE string, then alert user they have
//Laid a hotspot
- (void)HotspotDidFinished:(ASIHTTPRequest *)request {
	NSLog(@"%@", [request responseString]);
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    
    //Restart hotspot timer
    [player._infectionMGR._hotspotTimer ResetTimer];
    
    //Alert the user
    if ([[request responseString] isEqualToString:@"TRUE"]) 
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Hotspot Laid!"] delegate:nil cancelButtonTitle:@"Ok!" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

//Callback indicates failed connection with server
- (void)HotspotDidFailed:(ASIHTTPRequest *)request {

	//couldnt connect to server
}

@end












