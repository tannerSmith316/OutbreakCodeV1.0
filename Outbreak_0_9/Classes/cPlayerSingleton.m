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
		//LAN : 192.168.10.200
		//WAN : 66.189.145.171
		self._serverIP = [NSString stringWithFormat:@"http://66.189.145.171/"];
		_locationMGR = [[cLocationManager alloc] init];
		_infectionMGR = [[cInfectionManager alloc] init];
		_viruses = [[NSMutableArray alloc] init];
		_MINDISTANCE = [[NSNumber alloc] initWithInt:100]; //100
		_MAXDISTANCE = [[NSNumber alloc] initWithInt:1000]; //1000
		_MINTIME = [[NSNumber alloc] initWithInt:300]; //300
		_MAXTIME = [[NSNumber alloc] initWithInt:7200]; //7200
		_MINHOTSPOTRANGE = [[NSNumber alloc] initWithInt:10]; //10
		_MAXHOTSPOTRANGE = [[NSNumber alloc] initWithInt:100]; //100
        _MAXSITTIME = [[NSNumber alloc] initWithInt:300]; //30
        _MINSITTIME = [[NSNumber alloc] initWithInt:3]; //300
        _MAXMOVEDIST = [[NSNumber alloc] initWithInt:20];
		//_isTimerActive = FALSE;
	}
	return self;
}
//starts the playersingleton's update timer on main screen init
- (void)StartUpdateTimer {
	
	//_isTimerActive = TRUE;
	self._updateLocationTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(locationTimerFired:) userInfo:nil repeats:NO];
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

- (void)release {

	//do nothing
}

- (id)autorelease {
	
	return self;
}

/*
- (BOOL)_isTimerActive {
	
	return _isTimerActive;
}

- (void)set_isTimerActive:(BOOL)isActive {
	
	_isTimerActive = isActive;
}
 */

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
	
	[_viruses release];
	[_locationMGR release];
	[_updateLocationTimer release];
	[_serverIP release];
	[_username release];
	[_password release];
	[_MINHOTSPOTRANGE release];
	[_MAXHOTSPOTRANGE release];
	[_MAXTIME release];
	[_MINTIME release];
	[_MAXDISTANCE release];
	[_MINDISTANCE release];
    [_MAXSITTIME release];
    [_MINSITTIME release];
    [_MAXMOVEDIST release];
	[super dealloc];
}

@end
