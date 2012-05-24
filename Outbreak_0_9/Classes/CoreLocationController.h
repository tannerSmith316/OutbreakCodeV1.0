//
//  CoreLocationController.h
//  CoreLocationDemo
//
//  Created by iGeek Developers on 11/1/11.
//  Copyright 2011 Oregon Institute of Technology. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoreLocationControllerDelegate
@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
@end


@interface CoreLocationController : NSObject <CLLocationManagerDelegate> {
	//Apple Core Location Manager
    CLLocationManager *locMgr;
	id delegate;
    BOOL _needsUpdate;
}

@property (nonatomic, assign)BOOL _needsUpdate;
@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, assign) id delegate;

@end
