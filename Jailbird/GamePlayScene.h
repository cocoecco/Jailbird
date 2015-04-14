//
//  GamePlayScene.h
//  Jailbird
//
//  Created by Shachar Udi on 2/20/14.
//  Copyright (c) 2014 Shachar Udi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameTools.h"
#import <GameKit/GameKit.h>
#import "SKTUtils.h"
#import "SKTEffects.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PManager.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "vunglepub.embeddedframework/vunglepub.framework/Headers/vunglepub.h"




@interface GamePlayScene : SKScene <SKPhysicsContactDelegate, UIActionSheetDelegate, GKGameCenterControllerDelegate, FBLoginViewDelegate, PManagerDelegate, UIAlertViewDelegate,VGVunglePubDelegate>
{
    SKSpriteNode *playerSprite, *groundSprite, *waitingForTouchView, *gameOverSprite, *lineBar1, *lineBar2;
    SKSpriteNode *finalScoreSprite, *highScoreSprite, *fbOFFTimerView;
    SKLabelNode *scoreCountLabel, *finalScoreLabel, *highScoreLabel;
    SKSpriteNode *topItemImage;
    NSString *currentPlayerCHImageFile;
    
    SKSpriteNode *mainStoreSprite, *gameStoreSprite;

    GameTools *gameTools;
    FBLoginView *loginView;
    
    BOOL isIPhone4;

    SKSpriteNode *faceLoginBtn, *blindModeButton, *highScoreCounterBox, *aboutBtn, *aboutView;

    NSURL *appURL;
        
    SKAction *tapSound, *hitSound, *btnSound, *cashSound, *wallSound, *speedSound;
    
    BOOL gameRunning, addTimerPoints, isFirstInit, tapTheScreen, firstPool, bringBackBirdNormalAnimation;
    
    int screenCenterX, screenCenterY, contactCount;
    int scoreCount, poolDiffSize;
    int initPlusScore;
    int effectWallsCreated, wallsSpeed;
    
    BOOL shouldPauseWalls;
    
    SKEmitterNode *playerSmokeNode;

    SKLabelNode *scoreCounterLabel;
    
    NSUserDefaults *infoSaved;
    
    BOOL fbLoggedIn, blindModeOn, blindStartAnimationOn, showingSpeedIntro;
    
    NSTimer *wallsCreationTimer, *scoreTimer;
    
    PManager *purchaseManager;
    NSString *facebookBuyType, *currentEffectName;
    
    NSMutableArray *flyAnim;
    SKSpriteNode *bgNode, *tapScreenSprite, *speedReadyBox, *speedGoBox, *speedIntroCoverView;
    SKAction *speedAction;
    
}

@property (nonatomic, retain) NSURL *appURL;
@property (nonatomic, retain) SKSpriteNode *gameStoreSprite;



@end

