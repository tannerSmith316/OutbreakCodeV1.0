
//
//  cVirusManager.h
//  Outbreak_0_9
//
//  Created by McKenzie Kurtz on 3/18/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
@class cVirus;

@interface cVirusManager : NSObject {
	
	cVirus *_virus;
	
	//UI delegate to turn of whirligig after asynchronous call
	id delegate;

}

@property (nonatomic, retain)cVirus *_virus;
@property (nonatomic, assign)id delegate;

- (void)CreateVirus:(cVirus *)aVirus;
- (void)DeleteVirus:(cVirus *)aVirus;

//DO WE NEED THIS FUNCTION OR CAN IT BE HANDLED IN THE VIEW CONTROLLER?
- (void)SelectVirus:(cVirus *)aVirus;

@end
