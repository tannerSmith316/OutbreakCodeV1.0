//
//  cInfectionManager.h
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/11/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cVictim.h"
#import "cVirus.h"


@interface cInfectionManager : NSObject {

	
		
}

- (void)PersistInfection:(cVirus *)aVirus WithVictim:(cVictim *)aVictim;
- (void)LayHotspot;
- (void)DefendInfection:(cVirus *)enemyVirus;
- (void)AttemptInstant:(cVictim *)aVictim;

 
@end
