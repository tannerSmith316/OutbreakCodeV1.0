//
//  cPlayerSingleton.m
//  Outbreak_0_5
//
//  Created by McKenzie Kurtz on 2/19/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import "cPlayerSingleton.h"
//#import "cLocationManager.h"

static cPlayerSingleton *_player = nil;

@implementation cPlayerSingleton
@synthesize _infectedWith;
@synthesize _viruses;
@synthesize _name;
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
		_infectedWith = nil;
		_viruses = nil;
		_name = nil;
		_currentVirus =nil;
		_latitude =nil;
		_longitude =nil;
		_password =nil;
		_username =nil;
		
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
		_MINDISTANCE = [[NSNumber alloc] initWithInt:50000];
		_MAXDISTANCE = [[NSNumber alloc] initWithInt:65000];
		_MINTIME = [[NSNumber alloc] initWithInt:30];
		_MAXTIME = [[NSNumber alloc] initWithInt:300];
		_MINHOTSPOTRANGE = [[NSNumber alloc] initWithInt:50];
		_MAXHOTSPOTRANGE = [[NSNumber alloc] initWithInt:500];
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
	[super dealloc];
}

@end
