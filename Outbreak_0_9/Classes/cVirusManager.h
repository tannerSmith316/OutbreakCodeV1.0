
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
@property (nonatomic, retain)NSOperationQueue *_virusOperations;
@property (nonatomic, retain)NSNumber *ISTESTING;

- (void)CreateVirus:(cVirus *)aVirus;
- (void)DeleteVirus:(cVirus *)aVirus;
- (void)SelectVirus:(cVirus *)aVirus;

@end
