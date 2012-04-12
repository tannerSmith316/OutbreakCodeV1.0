//
//  cInfectionManager.m
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/11/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cInfectionManager.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "cPlayerSingleton.h"


@implementation cInfectionManager



- (id)init {
	
	self = [super init];
	if (self != nil)
	{
		
	}
	
	return self;
	
}

- (void)dealloc {
	
	
	[super dealloc];
}


- (void)PersistInfection:(cVirus *)aVirus WithVictim:(cVictim *)aVictim {

	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	NSString *urlappended = [NSString stringWithFormat:@"%@infectPlayer.php", player._serverIP];
	NSURL *url = [NSURL URLWithString:urlappended];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];


	[request setDidFinishSelector:@selector(InfectionDidFinished:)];
	[request setDidFailSelector:@selector(InfectionDidFailed:)];
	
	[request setPostValue:aVictim._username forKey:@"victim_id"];
	[request setPostValue:aVirus._virusName forKey:@"virus_name"];
	[request setPostValue:aVirus._owner forKey:@"username"];
	[request setDelegate:self];
	[request startAsynchronous];
	
	//else

}

- (void)InfectionDidFinished:(ASIHTTPRequest *)request {
	


}

- (void)InfectionDidFailed:(ASIHTTPRequest *)request {
	
	//
}

- (void)LayHotspot {
	
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	NSString *urlappended = [NSString stringWithFormat:@"%@layHotspot.php", player._serverIP];
	NSURL *url = [NSURL URLWithString:urlappended];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	
	
	[request setDidFinishSelector:@selector(HotspotDidFinished:)];
	[request setDidFailSelector:@selector(HotspotDidFailed:)];
	
	
	
	//THIS IS A COMMENT FOR SEAN -------- NEEDS VIRUS ID RIGHT HERE DONT LOOK AWWAY THIS NEEDS YOUR ATTENTION NOW
	//(zone/100)*(max-min) + min
	float rangeFloat = ([player._currentVirus._zonePoints floatValue] / 100) * ([player._MAXHOTSPOTRANGE floatValue] - [player._MINHOTSPOTRANGE floatValue]) + [player._MINHOTSPOTRANGE floatValue];
	NSNumber *range = [NSNumber numberWithFloat:rangeFloat];
	
	NSString *rangeString = [NSString stringWithFormat:@"%@", range];
	
	float durationFloat = ([player._currentVirus._zonePoints floatValue] / 100) * ([player._MAXTIME floatValue] - [player._MINTIME floatValue]) + [player._MINTIME floatValue];
	NSNumber *durationNum = [NSNumber numberWithFloat:durationFloat];
	
	[request setPostValue:[NSString stringWithFormat:@"%@", durationNum] forKey:@"duration"];
	[request setPostValue:rangeString forKey:@"range"];
	[request setPostValue:player._currentVirus._virusName forKey:@"virus_name"];
	[request setPostValue:player._latitude forKey:@"latitude"];
	[request setPostValue:player._longitude forKey:@"longitude"];
	[request setPostValue:player._username forKey:@"username"];
	

	 //	[request setPostValue forKey:
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void)HotspotDidFinished:(ASIHTTPRequest *)request {

	//layed it
	NSLog(@"%@", [request responseString]);
}

- (void)HotspotDidFailed:(ASIHTTPRequest *)request {

	//couldnt connect to server
}

- (void)DefendInfection:(cVirus *)enemyVirus {

	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	//Check immunities
	//Check Stats
	
	//Simulates 100% infection
	if (1)
	{
		cVictim *myself = [[cVictim alloc] init];
		myself._username = player._username;
		
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"INFECTED!" message:[NSString stringWithFormat:@"You have been infect with:%@, by:%@",enemyVirus._virusName, enemyVirus._owner] delegate:nil cancelButtonTitle:@"Ouch!" otherButtonTitles:nil] autorelease];
		[alert addButtonWithTitle:@"Quit it"];
		[alert show];
		player._infectedWith = enemyVirus;
		[self PersistInfection:enemyVirus WithVictim:myself];
	}
}

- (void)AttemptInstant:(cVictim *)aVictim {
	
	cPlayerSingleton *player = [cPlayerSingleton GetInstance];
	//pull immunity
	
	//pull defenses
	
	//calculate distance
	//range = (instant/100) * (MAX - MIN) + MIN
	//% = (-distance/range) + 1
	
	//total% =
	
	//random 0-1
	
	//if rand > %	
	
	//Simulates 100% infection
	if (1)
	{
		[self PersistInfection:player._currentVirus WithVictim:aVictim];
	}
}

@end












