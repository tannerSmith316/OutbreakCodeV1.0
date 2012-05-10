//
//  cVirus.h
//  Outbreak_0_5
//
//  Created by iGeek Developers on 2/19/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface cVirus : NSObject {
	
	NSString *_virusName;
	NSString *_owner;
	NSString *_virusType;
	NSNumber *_instantPoints;
	NSNumber *_zonePoints;
    
    //Mutation is an ID to identify a mutated RNA strain
    NSNumber *_mutation;
}

@property (nonatomic, retain)NSString *_owner;
@property (nonatomic, retain)NSString *_virusType;
@property (nonatomic, retain)NSNumber *_instantPoints;
@property (nonatomic, retain)NSNumber *_zonePoints;
@property (nonatomic, retain)NSString *_virusName;
@property (nonatomic, retain)NSNumber *_mutation;

//copy constructor
- (cVirus *)initWithVirus:(cVirus *)aVirus;
//Returns stats formatted for Textview display
- (NSString *)GetStats;

@end
