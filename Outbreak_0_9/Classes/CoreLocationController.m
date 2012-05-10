
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

//Callback for Apple Core Location to give my Controller the new location
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

//Callback for apple core location Error
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
    if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
		[self.delegate locationError:error];
	}
}

@end
