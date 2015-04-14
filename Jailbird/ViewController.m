//
//  ViewController.m
//  Jailbird
//
//  Created by Shachar Udi on 2/20/14.
//  Copyright (c) 2014 Shachar Udi. All rights reserved.
//

#import "ViewController.h"
#import "GamePlayScene.h"


@implementation ViewController

- (void)authenticateLocalUser:(NSString*) withMenu {
    
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        __weak GKLocalPlayer *blockLocalPlayer = localPlayer;
        
        [localPlayer setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error) {
            if(blockLocalPlayer.isAuthenticated)
            {
                NSLog(@"auth");
            }else{
                if (viewcontroller) {
                    [self presentViewController: viewcontroller animated: YES completion:nil];

                    if ([withMenu isEqualToString:@"1"]) {
                    }
                }
                
            }
        })];
        
    } else {
        
        
        NSLog(@"Already authenticated!");
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)gameCenterViewController {
    UIViewController *vc = self.view.window.rootViewController;
    [vc dismissViewControllerAnimated:YES completion:nil];
}

-(void) setupGameFirstTime {
    NSUserDefaults *infoSaved = [NSUserDefaults standardUserDefaults];
    NSString *savedRevive = [infoSaved objectForKey:@"savedRevive"];
    if (!savedRevive) {
        savedRevive = @"1";
        [infoSaved setObject:savedRevive forKey:@"savedRevive"];
    }
    
    
    NSString *canShowAds = [infoSaved objectForKey:@"CanShowAds"];
    if (!canShowAds) {
        [infoSaved setObject:@"YES" forKey:@"CanShowAds"];
    }
    
    NSString *rateCounter = [infoSaved objectForKey:@"rateCounter"];
    if (!rateCounter) {
        [infoSaved setObject:@"3" forKey:@"rateCounter"];
    }
    
    NSString *fullAdsCounterString = [infoSaved objectForKey:@"fullAdsCounter"];
    if (!fullAdsCounterString) {
        [infoSaved setObject:@"2" forKey:@"fullAdsCounter"];
    }

    NSString *blindCountString = [infoSaved objectForKey:@"blindCount"];
    if (!blindCountString) {
        [infoSaved setObject:@"0" forKey:@"blindCount"];
    }
    
    NSString *blindUnlocked = [infoSaved objectForKey:@"blindUnlocked"];
    if (!blindUnlocked) {
        [infoSaved setObject:@"NO" forKey:@"blindUnlocked"];
    }
    
    
    
    [infoSaved synchronize];

//    savedRevive = @"1";
//    [infoSaved setObject:savedRevive forKey:@"savedRevive"];
//    [infoSaved setObject:@"YES" forKey:@"CanShowAds"];
//
//    [infoSaved synchronize];
    
}


//- (void)viewWillLayoutSubviews {
//    
//    [super viewWillLayoutSubviews];
//    NSUserDefaults *infoSaved = [NSUserDefaults standardUserDefaults];
//    NSString *canShowAds = [infoSaved objectForKey:@"CanShowAds"];
//    if ([canShowAds isEqualToString:@"YES"]) {
//        self.canDisplayBannerAds = YES;
//    }
//    
//}

-(void) interstitialDidDismissScreen:(GADInterstitial *)ad {
    canShowFullScreenAds = NO;
}

-(void) interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    canShowFullScreenAds = NO;
}

-(void) interstitialDidReceiveAd:(GADInterstitial *)ad {
    canShowFullScreenAds = YES;
}


-(void) showFullScreenAds {
    if (!canShowFullScreenAds) return;
    
    NSUserDefaults *infoSaved = [NSUserDefaults standardUserDefaults];
    NSString *canShowAds = [infoSaved objectForKey:@"CanShowAds"];
    if ([canShowAds isEqualToString:@"YES"]) {
        
        NSString *fullAdsCounterString = [infoSaved objectForKey:@"fullAdsCounter"];
        int fullAdsCounterInt = [fullAdsCounterString intValue];
        if (fullAdsCounterInt < 4) {
            fullAdsCounterInt++;
            [infoSaved setObject:[NSString stringWithFormat:@"%d", fullAdsCounterInt] forKey:@"fullAdsCounter"];
        }
        else {
            fullAdsCounterInt = 0;
            [infoSaved setObject:[NSString stringWithFormat:@"%d", fullAdsCounterInt] forKey:@"fullAdsCounter"];
            UIViewController *vc = self.view.window.rootViewController;
            [interstitial_ presentFromRootViewController:vc];
        }
        
        [infoSaved synchronize];
    }
}



-(void) showAds {
    NSUserDefaults *infoSaved = [NSUserDefaults standardUserDefaults];
    NSString *canShowAds = [infoSaved objectForKey:@"CanShowAds"];
    if ([canShowAds isEqualToString:@"YES"]) {
        bannerView_.hidden = NO;//change

    }
}

-(void) hideAds {
    bannerView_.hidden = YES;

}


-(void) openStoreWaitingView {
    storeWaitingView = [[UIView alloc] initWithFrame:self.view.bounds];
    storeWaitingView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:100/255.0f];
    storeWaitingView.layer.opacity = 0.0;
    [self.view addSubview: storeWaitingView];
    
    [UIView animateWithDuration:0.5 delay:0 options:1
        animations:^{
                         storeWaitingView.layer.opacity = 1.0;
                    }
    completion:nil];
    
    
    UIActivityIndicatorView *waitingActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    waitingActivity.frame = CGRectMake((self.view.frame.size.width / 2)-50, (self.view.frame.size.height/2)-50, 100, 100);
    [storeWaitingView addSubview:waitingActivity];
    
    [waitingActivity startAnimating];
}

-(void) closeStoreWaitingView {
    [UIView animateWithDuration:0.5 delay:0 options:1
                     animations:^{
                         storeWaitingView.layer.opacity = 0.0;
                     }
                     completion:^(BOOL finished){
                         [storeWaitingView removeFromSuperview];
                     }];
}



-(void) setupListeners {
    canShowFullScreenAds = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAds)
                                                 name:@"showAds"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideAds)
                                                 name:@"hideAds"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showFullScreenAds)
                                                 name:@"showFullScreenAds"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openStoreWaitingView)
                                                 name:@"openStoreWaitingView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeStoreWaitingView)
                                                 name:@"closeStoreWaitingView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authenticateLocalUser:)
                                                 name:@"authenticateLU"
                                               object:@"1"];
    
    
}


- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    

}

-(void) authenticationChanged {
    //user logged in / out
}


- (BOOL)isGameCenterAvailable {
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    SKView * skView = (SKView *)self.view;
    
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = @"ca-app-pub-3825073358484269/1340345033";
    interstitial_.delegate = self;
    [interstitial_ loadRequest:[GADRequest request]];
    
    
    
    
    NSUserDefaults *infoSaved = [NSUserDefaults standardUserDefaults];
    NSString *canShowAds = [infoSaved objectForKey:@"CanShowAds"];
    if ([canShowAds isEqualToString:@"YES"]) {
        
    //self.canDisplayBannerAds = YES;
        
        
        
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.adUnitID = @"ca-app-pub-3825073358484269/7829360635";
        
        //UIViewController *vc = self.view.window.rootViewController;
        bannerView_.rootViewController = self;
        [self.view addSubview:bannerView_];
        [bannerView_ loadRequest:[GADRequest request]];
    }
    
    if ([self isGameCenterAvailable]) {
        [self authenticateLocalUser:@"0"];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName
                 object:nil];
    }
    

    
    
    [self setupGameFirstTime];
    [self setupListeners];
    
    
    SKScene * scene = [GamePlayScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
}




- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
