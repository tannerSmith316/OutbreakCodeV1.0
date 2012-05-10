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
	
    [self ResetInstance];
	[super dealloc];
}

//Creates a player if one doesnt exists
//Returns player
+ (cPlayerSingleton *)GetInstance {
	@synchronized(self) {
		if (_player == nil)
		{
			_player = [[super allocWithZone:NULL] init];
		}
	}
	return _player;
}

//Empties all non-const attributes 
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
	}
}

//starts the playersingleton's update timer on main screen init
- (void)StartUpdateTimer {
	
    float _UPDATETIMERINTERVAL = [NSLocalizedString(@"UPDATETIMERINTERVAL", nil) floatValue];
	self._updateLocationTimer = [NSTimer scheduledTimerWithTimeInterval:_UPDATETIMERINTERVAL target:self selector:@selector(locationTimerFired:) userInfo:nil repeats:NO];
}

//Start the core location train
- (void)locationTimerFired:(NSTimer *)theTimer {
	
	[_locationMGR PollCoreLocation];
}

//Checks virus passed in against array of player viruses
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
