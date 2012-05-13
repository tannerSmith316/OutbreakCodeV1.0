//
//  cPlayerManager.h
//  Outbreak_0_9
//
//  Created by iGeek Developers on 2/29/12.
//  Copyright 2012 Oregon Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

//UI callback protocol
@protocol AsyncUICallback
@required
- (void)UICallback:(BOOL)success errorMsg:(NSString *)errMsg;
@end

@protocol RegisterUICallback
@required
- (void)UpdateCallback:(NSString *)msg;
@end

@interface cPlayerManager : NSObject {

    //Represents LoginViewController
	id delegate;
}

@property (nonatomic, assign) id delegate;

//Attempts to automatically log the user in
//To avoid annoying login screen
- (void)AttemptAutoLogin;
//Parses the playerData from the json Dict and saves
//it to the player singleton
- (void)ParsePlayerJson:(NSDictionary *)playerDict;

//Each of these functions sends POST requests asynchronously to our web server
- (void)LoginWithUsername:(NSString *)username Password:(NSString *)password;
- (void)Logout;
- (void)RegisterWithUsername:(NSString *)username Password:(NSString *)password;

@end
