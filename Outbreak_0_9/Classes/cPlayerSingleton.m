//
//  cPlayerSingleton.m
//  Outbreak_0_5
//
//  Created by McKenzie Kurtz on 2/19/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cPlayerSingleton.h"

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
@synthesize _MINDISTANCE;
@synthesize _MAXDISTANCE;
@synthesize _MAXTIME;
@synthesize _MINTIME;
@synthesize _MAXHOTSPOTRANGE;
@synthesize _MINHOTSPOTRANGE;
@synthesize _MINSITTIME;
@synthesize _MAXSITTIME;
@synthesize _MAXMOVEDIST;
@synthesize _UPDATETIMERINTERVAL;

+ (cPlayerSingleton *)GetInstance {
	@synchronized(self) {
		if (_player == nil)
		{
			_player = [[super allocWithZone:NULL] init];
			
		}
	}
	return _player;
}

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

- (id)init {
	
	if (self = [super init])
	{
		_locationMGR = [[cLocationManager alloc] init];
		_infectionMGR = [[cInfectionManager alloc] init];
		_viruses = [[NSMutableArray alloc] init];
        
		_MINDISTANCE = [[NSNumber alloc] initWithInt:100]; //100
		_MAXDISTANCE = [[NSNumber alloc] initWithInt:1000]; //1000
		_MINTIME = [[NSNumber alloc] initWithInt:300]; //300
		_MAXTIME = [[NSNumber alloc] initWithInt:7200]; //7200
		_MINHOTSPOTRANGE = [[NSNumber alloc] initWithInt:10]; //10
		_MAXHOTSPOTRANGE = [[NSNumber alloc] initWithInt:100]; //100
        _MINSITTIME = [[NSNumber alloc] initWithInt:30]; //30
        _MAXSITTIME = [[NSNumber alloc] initWithInt:300]; //300
        _MAXMOVEDIST = [[NSNumber alloc] initWithInt:20]; //20
        _UPDATETIMERINTERVAL = [[NSNumber alloc] initWithInt:30]; //30
	}
	return self;
}
//starts the playersingleton's update timer on main screen init
- (void)StartUpdateTimer {
	
	self._updateLocationTimer = [NSTimer scheduledTimerWithTimeInterval:[_UPDATETIMERINTERVAL integerValue] target:self selector:@selector(locationTimerFired:) userInfo:nil repeats:NO];
}


- (void)locationTimerFired:(NSTimer *)theTimer {
	
	[_locationMGR PollCoreLocation];
}

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
    
    //Do nothing
}

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

- (void)dealloc {
	
    [self ResetInstance];
	[super dealloc];
}

@end
