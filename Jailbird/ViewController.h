//
//  ViewController.h
//  Jailbird
//

//  Copyright (c) 2014 Shachar Udi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>
#import "GADBannerView.h"
#import "vunglepub.embeddedframework/vunglepub.framework/Headers/vunglepub.h"
#import "GADInterstitial.h"
#import <AdSupport/AdSupport.h>



@interface ViewController : UIViewController <GADInterstitialDelegate>
{
    GADBannerView *bannerView_;
    BOOL canShowFullScreenAds;
    GADInterstitial *interstitial_;
    

    UIView *storeWaitingView;
    
}
@end
