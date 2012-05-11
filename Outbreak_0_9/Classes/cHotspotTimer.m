//
//  cHotspotTimer.m
//  Outbreak_0_9
//
//  Created by Tanner Smith on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cHotspotTimer.h"
#import "cPlayerSingleton.h"

@implementation cHotspotTimer
@synthesize  _hotspotTimer;
@synthesize _latitude;
@synthesize _longitude;
@synthesize _interval;

- (id)init {
    self = [super init];
	if (self != nil)
	{
        _latitude = [[NSString alloc] init];
        _longitude = [[NSString alloc] init];
        _interval = [[NSNumber alloc] init];
	}
	return self;
}
 
- (void)dealloc {
    [_latitude release];
    [_longitude release];
    [_interval release];
    [super dealloc];
}


- (void)StopTimer {
    
    [_hotspotTimer invalidate];
}

/************************************************************
 * Purpose: Resets the hotspot timer with the active virus(current or infectedWith
 *   based on stats
 *
 * Entry: Timer has fired and either fails or succeeds at laying a hotspot
 *   then the request to resettimer happens
 *
 * Exit: timer is re-initialized with value based on virus stats
 ************************************************************/
- (void)ResetTimer {
    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    
    //Will use enemy virus if the player is infect
    cVirus *activeVirus;
    if (player._infectedWith) 
    {
        activeVirus = [[cVirus alloc] initWithVirus:player._infectedWith];
    }
    else 
    {
        activeVirus = [[cVirus alloc] initWithVirus:player._currentVirus];
    }
    
    float _MINSITTIME = [NSLocalizedString(@"MINSITTIME", nil) floatValue];
    float _MAXSITTIME = [NSLocalizedString(@"MAXSITTIME", nil) floatValue];
    
	//SitTime - Amount of time needed to spend in one spot for virus to lay hotspot
    float sitTime = ([activeVirus._zonePoints floatValue] / 100) * (_MINSITTIME - _MAXSITTIME) + _MAXSITTIME;
    self._interval = [NSNumber numberWithFloat:sitTime];
    if([self._hotspotTimer isValid])
    {
        [self._hotspotTimer invalidate];
        
    }

    [activeVirus release];
    
    self._hotspotTimer = [NSTimer scheduledTimerWithTimeInterval:[_interval intValue] target:player._infectionMGR selector:@selector(LayHotspot) userInfo:nil repeats:NO];
    
}

@end
