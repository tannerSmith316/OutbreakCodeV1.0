//
//  cVirus.h
//  Outbreak_0_5
//
//  Created by McKenzie Kurtz on 2/19/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface cVirus : NSObject {
	
	NSString *_virusName;
	NSString *_owner;
	NSString *_virusType;
	NSNumber *_instantPoints;
	NSNumber *_zonePoints;
}

@property (nonatomic, retain)NSString *_owner;
@property (nonatomic, retain)NSString *_virusType;
@property (nonatomic, retain)NSNumber *_instantPoints;
@property (nonatomic, retain)NSNumber *_zonePoints;
@property (nonatomic, retain)NSString *_virusName;

//- (cVictim *)initWithVirus:(cVirus *)aVirus;

@end
