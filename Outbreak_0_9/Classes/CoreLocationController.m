
#import "CoreLocationController.h"


@implementation CoreLocationController

@synthesize locMgr, delegate;

- (id)init {
	self = [super init];
	
	if(self != nil) {
		self.locMgr = [[[CLLocationManager alloc] init] autorelease];
		self.locMgr.delegate = self;
		//self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
	}
	return self;
}

- (void)dealloc {
	[self.locMgr release];
	[super dealloc];
}

/************************************************************
 * Purpose: Callback method to retrieve the location acquired by apples 
 *   CoreLocation Framework, if its within desired accuracy, we turn of
 *   the update timer, process the location and resume timer at the
 *   end of processing
 *
 * Entry: CoreLocation has sent a new location
 *
 * Exit: Location is passed on to self made LocationController for 
 *   processing
 ************************************************************/
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) 
    {
		//if (newLocation.horizontalAccuracy < 30.0)
		{
			//Manager restarts after all the data has been processed
			[manager stopUpdatingLocation];
			[self.delegate locationUpdate:newLocation];
		}
		
	}
}

/************************************************************
 * Purpose: Catch error conditions from apples core location framework
 *
 * Entry: Apples corelocation has hit the error callback method
 *
 * Exit: error is passed to the delegate for display
 ************************************************************/
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
    if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
		[self.delegate locationError:error];
	}
}

@end
