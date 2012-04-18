//
//  cPlayerSingleton.h
//  Outbreak_0_5
//
//  Created by McKenzie Kurtz on 2/19/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cVirus.h"
#import "cLocationManager.h"
#import "cInfectionManager.h"

@interface cPlayerSingleton : NSObject {
	
	NSNumber *_MAXDISTANCE;
	NSNumber *_MINDISTANCE;
	NSNumber *_MAXHOTSPOTRANGE;
	NSNumber *_MINHOTSPOTRANGE;
	NSNumber *_MAXTIME;
	NSNumber *_MINTIME;
	//login username
	NSString *_username;
	//login password
	NSString *_password;
	
	//This array hols each of the users self created viruses
	NSMutableArray *_viruses;
	
	//This may be a virus that the user has contracted
	cVirus *_infectedWith;
	
	//This is the virus the player is currently playing with
	cVirus *_currentVirus;
	
	//These variables hold the players GPS coordinates
	NSString *_latitude;
	NSString *_longitude;
	
	//this variable holds the server ip adress
	NSString *_serverIP;
	
	NSTimer *_updateLocationTimer;
	
	cLocationManager *_locationMGR;
	cInfectionManager *_infectionMGR;
	
	//BOOL _isTimerActive;
}

@property (nonatomic, retain)NSMutableArray *_viruses;
@property (nonatomic, retain)cVirus *_infectedWith;
@property (nonatomic, retain)cVirus *_currentVirus;
@property (nonatomic, retain)NSString *_latitude;
@property (nonatomic, retain)NSString *_longitude;
@property (nonatomic, retain)NSString *_serverIP;
@property (nonatomic, retain)NSTimer *_updateLocationTimer;
@property (nonatomic, retain)NSString *_username;
@property (nonatomic, retain)NSString *_password;
@property (nonatomic, retain)cLocationManager *_locationMGR;
@property (nonatomic, retain)cInfectionManager *_infectionMGR;
@property (nonatomic, retain)NSNumber *_MAXDISTANCE;
@property (nonatomic, retain)NSNumber *_MINDISTANCE;
@property (nonatomic, retain)NSNumber *_MAXTIME;
@property (nonatomic, retain)NSNumber *_MINTIME;
@property (nonatomic, retain)NSNumber *_MAXHOTSPOTRANGE;
@property (nonatomic, retain)NSNumber *_MINHOTSPOTRANGE;

//@property (nonatomic, getter=_isTimerActive)BOOL _isTimerActive;

//Public accesor for singleton class
- (void)ResetInstance;
+ (cPlayerSingleton *)GetInstance;
- (void)StartUpdateTimer;


@end
