//
//  cHotspotTimer.m
//  Outbreak_0_9
//
//  Created by Tanner Smith on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cHotspotTimer.h"

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
    _hotspotTimer = [NSTimer scheduledTimerWithTimeInterval:_interval target:NULL selector:@selector userInfo:<#(id)#> repeats:<#(BOOL)#>
}

- (void)ResetTimer {
    
}

@end
