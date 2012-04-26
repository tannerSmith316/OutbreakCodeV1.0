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
	
	NSNumber *_MAXDISTANCE; //range of instant spread in meters
	NSNumber *_MINDISTANCE;
	NSNumber *_MAXHOTSPOTRANGE; //range of hotspot zone in meters
	NSNumber *_MINHOTSPOTRANGE;
	NSNumber *_MAXTIME; //time hotspot lingers in seconds
	NSNumber *_MINTIME;
    NSNumber *_MAXSITTIME; //amount of time to sit before a hotspot it laid
    NSNumber *_MINSITTIME;
    NSNumber *_MAXMOVEDIST; //amount of distance to move before player is considered no longer sitting
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
@property (nonatomic, retain)NSNumber *_MINSITTIME;
@property (nonatomic, retain)NSNumber *_MAXSITTIME;
@property (nonatomic, retain)NSNumber *_MAXMOVEDIST;

//@property (nonatomic, getter=_isTimerActive)BOOL _isTimerActive;

//Public accesor for singleton class
- (void)ResetInstance;
+ (cPlayerSingleton *)GetInstance;
- (void)StartUpdateTimer;


@end
