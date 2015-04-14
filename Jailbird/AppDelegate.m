//
//  AppDelegate.m
//  Jailbird
//
//  Created by Shachar Udi on 2/20/14.
//  Copyright (c) 2014 Shachar Udi. All rights reserved.
//

#import "AppDelegate.h"

#define APP_HANDLED_URL @"fb1452824361614893"

@implementation AppDelegate



-(void)vungleStart
{
    VGUserData*  data  = [VGUserData defaultUserData];
    NSString*    appID = @"826116883";
    
    // set up config data
    data.age             = 36;
    data.gender          = VGGenderFemale;
    data.adOrientation   = VGAdOrientationPortrait;
    data.locationEnabled = TRUE;
    
    // start vungle publisher library
    [VGVunglePub startWithPubAppID:appID userData:data];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    [self vungleStart];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    return wasHandled;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = YES;

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    NSUserDefaults *infoSaved = [NSUserDefaults standardUserDefaults];
    NSString *isRating = [infoSaved objectForKey:@"IsRating"];
    
    if ([isRating isEqualToString:@"YES"]) {
        UIAlertView *noPM = [[UIAlertView alloc] initWithTitle:@"Store" message:@"Thank you for rating us!\n As a thank you we've added 1 'Revive' to your account for free!" delegate:nil cancelButtonTitle:@"Awesome!" otherButtonTitles:nil, nil];
        noPM.delegate = self;
        noPM.tag = 2;
        [noPM show];
        
        [infoSaved setObject:@"NO" forKey:@"IsRating"];
        [infoSaved synchronize];
    }
    
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = NO;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = NO;
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [VGVunglePub stop];
    [FBSession.activeSession close];
}

@end
