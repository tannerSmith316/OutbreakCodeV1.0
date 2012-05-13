//
//  cPlayerSingleton.m
//  Outbreak_0_5
//
//  Created by iGeek Developers on 2/19/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cPlayerSingleton.h"

//Singleton thing;
static cPlayerSingleton *_player = nil;

@implementation cPlayerSingleton
@synthesize _infectedWith;
@synthesize _viruses;
@synthesize _currentVirus;
@synthesize _latitude;
@synthesize _longitude;
@synthesize _serverIP;
@synthesize _updateLocationTimer;
@synthesize _password;
@synthesize _username;
@synthesize _locationMGR;
@synthesize _infectionMGR;
@synthesize _appDel;

- (id)init {
	if (self = [super init])
	{
		_locationMGR = [[cLocationManager alloc] init];
		_infectionMGR = [[cInfectionManager alloc] init];
		_viruses = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
	[_locationMGR release];
	[_infectionMGR release];
	[_viruses release];
    [self ResetInstance];
	[super dealloc];
}

/************************************************************
 * Purpose: Public function allowing us to get a player instance
 *   wherever we are in the program
 *
 * Entry: Most everywhere in the APP we need player data
 *
 * Exit: Player singleton is returned
 ************************************************************/
+ (cPlayerSingleton *)GetInstance {
	@synchronized(self) {
		if (_player == nil)
		{
			_player = [[super allocWithZone:NULL] init];
		}
	}
	return _player;
}

/************************************************************
 * Purpose: Empty or nil all attributes that the player contains
 *   we must reset because you do not release a singleton
 *
 * Entry: Called from logout function
 *
 * Exit: player singleton attributes are all nil or empty
 ************************************************************/
- (void)ResetInstance {

	if (_player != nil)
	{
		self._infectedWith = nil;
		[self._viruses removeAllObjects];
		self._currentVirus =nil;
		self._latitude =nil;
		self._longitude =nil;
		self._password =nil;
		self._username =nil;
        [_player._infectionMGR._hotspotTimer._hotspotTimer invalidate];
        [_player._updateLocationTimer invalidate];
	}
}

/************************************************************
 * Purpose: Starts the timer responsible for firing the updateLocation
 *   to keep the players location accurates
 *
 * Entry: On login, OR when persistLocation finished its process
 *   the timer is restarted
 *
 * Exit: Timer has restarted 
 ************************************************************/
- (void)StartUpdateTimer {
	
    float _UPDATETIMERINTERVAL = [NSLocalizedString(@"UPDATETIMERINTERVAL", nil) floatValue];
	self._updateLocationTimer = [NSTimer scheduledTimerWithTimeInterval:_UPDATETIMERINTERVAL target:self selector:@selector(locationTimerFired:) userInfo:nil repeats:NO];
}

/************************************************************
 * Purpose: We want to start coreLocation and get a new location
 *   when the location timer fires and tells us to update
 *
 * Entry: UpdateLocationTimer has fired
 *
 * Exit: Core Location has started updateing
 ************************************************************/
- (void)locationTimerFired:(NSTimer *)theTimer {
	
	[_locationMGR PollCoreLocation];
}

/************************************************************
 * Purpose: Checks if the passed in virus is contained within
 *   the players array of viruses
 *
 * Entry: CreateVirus will check if the player owns a virus
 *   before attempting to create it
 *
 * Exit: Return true or false if the player owns the virus
 ************************************************************/
- (BOOL)doesOwnVirus:(cVirus *)aVirus {
	
	for( cVirus *virus in self._viruses )
	{
		if ([virus._virusName isEqual:aVirus._virusName])
		{
			return TRUE;
		}
	}
	return FALSE;
}

/**************? SINGLETON THINGS BELOW?************/

+ (id)allocWithZone:(NSZone *)zone {
	return [[self GetInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain
{
	return self;
}

- (unsigned)retainCount {
    
	return UINT_MAX;
}

- (id)autorelease {
	
	return self;
}

- (oneway void)release {
    
    //NEEDS TO DO NOTHING FOR SINGLETON SAKE
}

@end
