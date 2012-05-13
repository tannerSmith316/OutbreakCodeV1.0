//
//  cInfectionManager.h
//  Outbreak_0_9
//
//  Created by iGeek Developers on 3/11/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cHotspotTimer.h"
#import "cVictim.h"
#import "cVirus.h"

@interface cInfectionManager : NSObject {

    //Timer based on current virus zone points
	cHotspotTimer *_hotspotTimer;
}

@property (nonatomic, retain)cHotspotTimer *_hotspotTimer;

//Makes 
- (void)AttemptInstant:(cVictim *)aVictim;
- (void)DefendInfection:(cVirus *)enemyVirus;
- (void)LayHotspot;
- (void)PersistInfection:(cVirus *)aVirus WithVictim:(cVictim *)aVictim WithTime:(int)timeIntervals;
 
@end
