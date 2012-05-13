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

#import "cReconnectViewController.h"

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

/************************************************************
 * Purpose: This will use the victim's defenses to attempt a
 *   instant spread infection against. If they player has penetrated
 *   the victims defenses, we make a POST to persist infection
 *
 * Entry: User has selected a victim from a table to attempt an
 *   infection on
 *
 * Exit: victim defended against infection or POST persistInfection happens
 ************************************************************/
- (void)AttemptInstant:(cVictim *)aVictim {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	//pull immunity
	//pull defenses
	//random 0-1
	//if rand > %
    
    //Will attempt infection with enemy virus if the user is infected
    cVirus *activeVirus;
    if (player._infectedWith) 
    {
        activeVirus = [[cVirus alloc] initWithVirus:player._infectedWith];
    }
    else
    {
        activeVirus = [[cVirus alloc] initWithVirus:player._currentVirus];
    }
	
	//Simulates 100% infection
	if (1)
	{
        int minTime = [NSLocalizedString(@"MININFECTIONTIME", nil) intValue];
        int maxTime = [NSLocalizedString(@"MAXINFECTIONTIME", nil) intValue];
        int theTime = ([activeVirus._instantPoints floatValue] / 100) * (maxTime - minTime) + minTime;
        
		[self PersistInfection:activeVirus WithVictim:aVictim WithTime:theTime];
	}
    [activeVirus release];
}

/************************************************************
 * Purpose: Run the enemy virus stats against the players defenses
 *   if the player cannot defend against the virus, we POST persistInfection
 *   with the player being the victim
 *
 * Entry: User was sitting in a hotspot
 *
 * Exit: Player succesfully defends enemyVirus or POST to 
 *   server requesting to PersistInfection if enemy virus gets through
 ************************************************************/
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
            int minTime = [NSLocalizedString(@"MININFECTIONTIME", nil) intValue];
            int maxTime = [NSLocalizedString(@"MAXINFECTIONTIME", nil) intValue];
            int theTime = ([enemyVirus._zonePoints floatValue] / 100) * (maxTime - minTime) + minTime;
            
            [self PersistInfection:enemyVirus WithVictim:myself WithTime:theTime];
            
            //Alert the user of the bad news
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"INFECTED!" message:[NSString stringWithFormat:@"You have been infect with:%@, by:%@",enemyVirus._virusName, enemyVirus._owner] delegate:nil cancelButtonTitle:@"Ouch!" otherButtonTitles:nil] autorelease];
            [alert addButtonWithTitle:@"Quit it"];
            [alert show];
        }
	}
}

/************************************************************
 * Purpose: send POST request saving an infection to the database
 *
 * Entry: The player has infected a victim OR enemenyVirus has infected
 *   the player and we persist with the player as victim
 *
 * Exit: POST request sent
 ************************************************************/
- (void)PersistInfection:(cVirus *)aVirus WithVictim:(cVictim *)aVictim WithTime:(int)timeIntervals {

    NSString *timeInterval = [NSString stringWithFormat:@"%d", timeIntervals];
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
    [request setPostValue:timeInterval forKey:@"time"];
    if (aVirus._mutation) 
    {
        [request setPostValue:aVirus._mutation forKey:@"mutation"];
    }
	[request setDelegate:self];
	[request startAsynchronous];
}

/************************************************************
 * Purpose: Check if the server has responded that the infection
 *   was succesful or not, if so alert the user
 *
 * Entry: successful connection to server InfectionPersister
 *
 * Exit: delegate is alerted of the failed request
 ************************************************************/
- (void)InfectionDidFinished:(ASIHTTPRequest *)request {
    NSLog(@"%@", [request responseString]);

}


/************************************************************
 * Purpose: Handles the rainy situation when the user has lost 
 *  connection
 *
 * Entry: Asynchronous request times out, FAILED CONNECTION
 *
 * Exit: delegate is alerted of the failed request
 ************************************************************/
- (void)InfectionDidFailed:(ASIHTTPRequest *)request {
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    [player ResetInstance];
    
    cReconnectViewController *vc = [[cReconnectViewController alloc] initWithUsername:player._username WithPassword:player._password];
    [player._appDel.navigationController pushViewController:vc animated:YES];
}

/************************************************************
 * Purpose: sends POST to web server persisting a hotspot with the
 *   active virus(users currentVirus OR users infectedWith based on its stats
 *
 * Entry: Timer based on virus zone_points has triggered and user
 *   has staying the the hotspot zone for enough updates to LAYHOTSPOT
 *
 * Exit: Asynchronous POST sent
 ************************************************************/
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
    
    if (activeVirus._mutation) 
    {
        [request setPostValue:activeVirus._mutation forKey:@"mutation"];
    }
    
    //Were done with this guy now
    [activeVirus release];

	[request setDelegate:self];
	[request startAsynchronous];
}

/************************************************************
 * Purpose: Reset the hotspot timer and alert the user one was laid
 *   if true
 *
 * Entry: web server callback when finished with LayHotspot
 *
 * Exit: hotspot timer reset and/or user is alerted they laid a hotspot
 ************************************************************/
- (void)HotspotDidFinished:(ASIHTTPRequest *)request {
	NSLog(@"%@", [request responseString]);
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    
    cVirus *activeVirus = [[cVirus alloc] init];
    activeVirus = (player._infectedWith ? player._infectedWith : player._currentVirus);
    //Restart hotspot timer
    [player._infectionMGR._hotspotTimer ResetTimer];
    
    //Alert the user
    if ([[request responseString] isEqualToString:@"TRUE"]) 
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Virus:%@", activeVirus._virusName] message:@"Hotspot Laid!" delegate:nil cancelButtonTitle:@"Ok!" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

/************************************************************
 * Purpose: Handles the rainy situation when the user has lost 
 *  connection
 *
 * Entry: Asynchronous request times out, FAILED CONNECTION
 *
 * Exit: delegate is alerted of the failed request
 ************************************************************/
- (void)HotspotDidFailed:(ASIHTTPRequest *)request {

	//couldnt connect to server
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    [player ResetInstance];
    
    cReconnectViewController *vc = [[cReconnectViewController alloc] initWithUsername:player._username WithPassword:player._password];
    [player._appDel.navigationController pushViewController:vc animated:YES];
}

@end












