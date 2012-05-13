//
//  cConnectionManager.m
//  Outbreak_0_9
//
//  Created by Tanner Smith on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cConnectionManager.h"
#import "cConnectionViewController.h"

@implementation cConnectionManager
@synthesize _appNavController;
@synthesize _password;
@synthesize _playerMGR;
@synthesize _username;

- (void)PushReconnectionWithUsername:(NSString *)username WithPassword:(NSString *)password {
    
    cConnectionViewController *vc = [[cConnectionViewController alloc] initWithUsername:username WithPassword:password];
    
}

@end
