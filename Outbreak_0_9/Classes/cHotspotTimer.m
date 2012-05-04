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
        self._latitude = [[NSString alloc] init];
        self._longitude = [[NSString alloc] init];
        self._interval = [[NSNumber alloc] init];
	}
	
	return self;
}

- (void)StopTimer {
    
    [_hotspotTimer invalidate];
}

- (void)ResetTimer {

    cPlayerSingleton *player = [cPlayerSingleton GetInstance];
    float sitTime = ([player._currentVirus._zonePoints floatValue] / 100) * ([player._MAXSITTIME floatValue] - [player._MINSITTIME floatValue]) + [player._MINSITTIME floatValue];
    self._interval = [NSNumber numberWithFloat:sitTime];
    if([self._hotspotTimer isValid])
    {
        [self._hotspotTimer invalidate];
        
    }

    self._hotspotTimer = [NSTimer scheduledTimerWithTimeInterval:[_interval intValue] target:player._infectionMGR selector:@selector(LayHotspot) userInfo:nil repeats:NO];
    
}

@end
