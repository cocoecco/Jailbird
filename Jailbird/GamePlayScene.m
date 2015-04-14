//
//  GamePlayScene.m
//  Jailbird
//
//  Created by Shachar Udi on 2/20/14.
//  Copyright (c) 2014 Shachar Udi. All rights reserved.
//

#import "GamePlayScene.h"

@implementation GamePlayScene
@synthesize appURL;
@synthesize gameStoreSprite;

static const uint32_t birdObj     =  0x1 << 0;
static const uint32_t wallObj     =  0x1 << 1;
static const uint32_t groundObj   =  0x1 << 2;
static const uint32_t lightningObj   =  0x1 << 3;




-(void) fadeHighScoreCounter {
    SKAction *fadeOut = [SKAction fadeAlphaTo:0.0 duration:1.0];
    [highScoreCounterBox runAction:[SKAction sequence:@[fadeOut, [SKAction runBlock:^(void) {
        [highScoreCounterBox removeFromParent];
        highScoreCounterBox = nil;
    }]]]];
}

-(void)animateScore {
    int addSum = 1;
    if (scoreCount > 10) addSum = 2;
    if (scoreCount > 20) addSum = 4;
    if (scoreCount > 30) addSum = 6;
    if (scoreCount > 40) addSum = 8;
    if (scoreCount > 50) addSum = 10;
    if (scoreCount > 60) addSum = 12;
    if (scoreCount > 70) addSum = 14;
    if (scoreCount > 80) addSum = 16;
    if (scoreCount > 90) addSum = 18;
    if (scoreCount > 100) addSum = 20;
    if (scoreCount > 200) addSum = 40;
    if (scoreCount > 300) addSum = 60;
    if (scoreCount > 400) addSum = 80;
    if (scoreCount > 500) addSum = 100;
    if (scoreCount > 700) addSum = 140;
    if (scoreCount > 1000) addSum = 200;
    if (scoreCount > 2000) addSum = 400;
    if (scoreCount > 5000) addSum = 1000;

    initPlusScore = initPlusScore + addSum;
    if (initPlusScore >= scoreCount) {
        initPlusScore = scoreCount;
        [highScoreCounterBox removeAllActions];
    }
    
    [self runAction:cashSound];
    scoreCounterLabel.text = [NSString stringWithFormat:@"%d",initPlusScore]; //update it with the new oldScore
}


//-(void) removeHighScoreCounterBox {
//    [highScoreCounterBox removeAllActions];
//    scoreCounterLabel.text = [NSString stringWithFormat:@"%d", scoreCount];
//    
//    SKTMoveEffect *moveOut = [SKTMoveEffect effectWithNode:highScoreCounterBox duration:0.7 startPosition:CGPointMake(400, screenCenterY) endPosition:CGPointMake(-330, screenCenterY)];
//    moveOut.timingFunction = SKTTimingFunctionCircularEaseInOut;
//    
//    [highScoreCounterBox runAction:[SKAction sequence:@[[SKAction actionWithEffect:moveOut], [SKAction runBlock:^(void) {
//        [highScoreCounterBox removeFromParent];
//        highScoreCounterBox = nil;
//    }]]]];
//    
//}


-(void) showHighScoreCounterBox {
    int topPoint = -40;
    if (isIPhone4) topPoint +=16;
    
    highScoreCounterBox = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:self.view.frame.size];
    highScoreCounterBox.position = CGPointMake(400, screenCenterY);
    highScoreCounterBox.zPosition = 20;
    highScoreCounterBox.name = @"highScoreCounterBox";
    [self addChild:highScoreCounterBox];
    


    SKSpriteNode *boxNode = [SKSpriteNode spriteNodeWithImageNamed:@"HighScoreBox"];
    boxNode.position = CGPointMake(0, topPoint);
    boxNode.name = @"highScoreCounterBox";
    [highScoreCounterBox addChild:boxNode];
    
    SKSpriteNode *birdFlyingNode = [SKSpriteNode spriteNodeWithImageNamed:@"Bird0.png"];
    birdFlyingNode.position = CGPointMake(-67, -50);
    birdFlyingNode.size = CGSizeMake(117.5, 85);
    [boxNode addChild:birdFlyingNode];
    
    SKAction *flyAnimation = [SKAction animateWithTextures:flyAnim timePerFrame:0.03f];
    SKAction *alwaysFly = [SKAction repeatActionForever:[SKAction sequence:@[flyAnimation, [flyAnimation reversedAction]]]];
    [birdFlyingNode runAction:alwaysFly];
    
    
    SKTMoveEffect *moveIn = [SKTMoveEffect effectWithNode:highScoreCounterBox duration:0.3 startPosition:CGPointMake(400, screenCenterY) endPosition:CGPointMake(screenCenterX, screenCenterY)];
    moveIn.timingFunction = SKTTimingFunctionCircularEaseInOut;
    
    [highScoreCounterBox runAction:[SKAction actionWithEffect:moveIn]];
    
    scoreCounterLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreCounterLabel.position = CGPointMake(70, -70);
    scoreCounterLabel.fontSize = 60;
    scoreCounterLabel.text = @"0";
    scoreCounterLabel.fontColor = [UIColor yellowColor];
    [boxNode addChild:scoreCounterLabel];
    
    //finalScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    
    initPlusScore = 0;
    SKAction *selAction = [SKAction runBlock:^{[self animateScore];}];
    SKAction *delayAction = [SKAction waitForDuration:0.3];
    
    [highScoreCounterBox runAction:[SKAction repeatActionForever:[SKAction sequence:@[selAction, delayAction]]]
     ];
    
    int btnTop = 27;
    
    SKSpriteNode *faceBtnHS = [SKSpriteNode spriteNodeWithImageNamed:@"FacebookBtn.png"];
    faceBtnHS.name = @"facebookHighScore";
    faceBtnHS.size = CGSizeMake(45, 45);
    faceBtnHS.position = CGPointMake(115, btnTop);
    [boxNode addChild:faceBtnHS];
    
}


-(void) showNativeFBShare:(UIImage*) withImage {
    
    NSString *msgText = [NSString stringWithFormat:@"My new High Score on Jailbird is %d!", scoreCount];

    
    NSArray* dataToShare = @[msgText,withImage, @"Like us on Facebook\n http://www.facebook.com/pages/Jailbird/603451879747521", @"Now free on the App Store\n https://itunes.apple.com/us/app/jailbirds/id826116883?ls=1&mt=8"];
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    UIViewController *vc = self.view.window.rootViewController;
    [vc presentViewController: activityViewController animated: YES completion:nil];
    
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL done)
     {
         
         if (done)
         {
             if ([facebookBuyType isEqualToString:@"FBIn"]) {
                 //show thanks to user             }
         }
         else
         {
             // show error
         }
         }
     }];

}

-(UIImage*) getHSScreenshot {
    
    UIGraphicsBeginImageContext(CGSizeMake(320, [gameTools currentScreenSize].height));
    [self.view drawViewHierarchyInRect:CGRectMake(0, -50, 320, [gameTools currentScreenSize].height) afterScreenUpdates:YES];
    UIImage *scrShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scrShot;
}


-(void) showFacebookHighScore {
    
    NSString *msgText = [NSString stringWithFormat:@"My new High Score on Jailbird is %d!", scoreCount];
    UIImage *scrImage = [self getHSScreenshot];

    
    [FBRequestConnection startForUploadStagingResourceWithImage:scrImage completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSMutableDictionary<FBOpenGraphObject> *object = [FBGraphObject openGraphObjectForPost];
            object.provisionedForPost = YES;
            object[@"title"] = @"New High Score!";
            object[@"type"] = @"Jailbird:HS";
            object[@"description"] = msgText;
            object[@"url"] = @"https://itunes.apple.com/us/app/jailbirds/id826116883?ls=1&mt=8";
            object[@"image"] = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"true" }];
        
            
            [FBRequestConnection startForPostOpenGraphObject:object completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error) {
                    // get the object ID for the Open Graph object that is now stored in the Object API
                    //NSString *objectId = [result objectForKey:@"id"];
                    // Further code to post the OG story goes here
                    
                } else {
                    // An error occurred
                    NSLog(@"Error posting the Open Graph object to the Object API: %@", error);
                }
            }];
        
        }
        else {
            [self showNativeFBShare:scrImage];
            return;
        }
    }];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:msgText forKey:@"message"];
    [params setObject:UIImagePNGRepresentation(scrImage) forKey:@"picture"];
    
    [FBRequestConnection startWithGraphPath:@"me/photos"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         if (error)
         {
             //showing an alert for failure
             NSLog(@"no no no");
             [self showNativeFBShare:scrImage];
         }
         else
         {
             //showing an alert for success
             NSLog(@"yes yes yes");
         }

     }];
}


-(void) reportHighScores {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:@"com.cocoecco.Jailbird.lb1"];
        score.value = scoreCount;
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }
        }];
    }
}

-(void) reportBlindHighScores {
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:@"com.cocoecco.Jailbird.lb2"];
        score.value = scoreCount;
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }
        }];
    }
}



-(void) endGame {
    for (SKSpriteNode *wallNode in self.children) {
        if ([wallNode.name isEqualToString:@"wall"]) {
            [wallNode removeFromParent];
        }
        if ([wallNode.name isEqualToString:@"passedWall"]) {
            [wallNode removeFromParent];
        }
        if ([wallNode.name isEqualToString:@"wallup"]) {
            [wallNode removeFromParent];
        }
        if ([wallNode.name isEqualToString:@"lightning"]) {
            [wallNode removeFromParent];
        }
    }
    
    playerSprite.physicsBody.affectedByGravity = YES;
    playerSprite.physicsBody.mass = 0.5;
    playerSprite.physicsBody.velocity = self.physicsBody.velocity;
    
    [playerSmokeNode removeFromParent];
    [self removeActionForKey:@"SpeedAction"];
    [self removeSpeedMode];
    
    addTimerPoints = NO;
    [wallsCreationTimer invalidate];
    wallsCreationTimer = nil;
    
    [self removeAllActions];
    
    [scoreTimer invalidate];
    scoreTimer = nil;
    
    gameRunning = NO;
    scoreCountLabel.text = @"";

    
    [playerSprite runAction:[SKAction moveTo:CGPointMake(screenCenterX-50, screenCenterY) duration:0.1]];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    playerSprite.physicsBody.velocity = CGVectorMake(0, 0);
    
    SKAction *changeTitle = [SKAction setTexture:[SKTexture textureWithImageNamed:@"GameOverCover.png"]];
    [topItemImage runAction:changeTitle];
    topItemImage.hidden = NO;
    
    playerSprite.hidden = YES;
    
    BOOL isHighScore = NO;
    BOOL isBlindHighScore = NO;
    
    int newHSInt = 0;
    int newBHSInt = 0;
    
    if (blindModeOn) {
        NSString *blindHighScore = [infoSaved objectForKey:@"BlindHighScore"];
        if (!blindHighScore) {
            blindHighScore = @"0";
        }
        
        
        int bhsInt = [blindHighScore intValue];
        if (scoreCount > bhsInt) {
            [infoSaved setObject:[NSString stringWithFormat:@"%d", scoreCount] forKey:@"BlindHighScore"];
            [infoSaved synchronize];
            newBHSInt = scoreCount;
            [self reportBlindHighScores];
            isBlindHighScore = YES;
        }
    }
    else {
        NSString *highScore = [infoSaved objectForKey:@"HighScore"];
        if (!highScore) {
            highScore = @"0";
        }
        
        int hsInt = [highScore intValue];
        if (scoreCount > hsInt) {
            [infoSaved setObject:[NSString stringWithFormat:@"%d", scoreCount] forKey:@"HighScore"];
            [infoSaved synchronize];
            newHSInt = scoreCount;
            [self reportHighScores];
            isHighScore = YES;
        }
    }
    
    NSString *topScore = [infoSaved objectForKey:@"topScore"];
    
    if (!topScore) {
        topScore = @"0";
    }
    int topScoreInt = [topScore intValue];
    if (scoreCount > topScoreInt) {
        [infoSaved setObject:[NSString stringWithFormat:@"%d", scoreCount] forKey:@"topScore"];
        topScoreInt = scoreCount;
        [infoSaved synchronize];
        
        if (scoreCount > 5) [self showHighScoreCounterBox];
    }
    
    //[self showHighScoreCounterBox];
    
    
    finalScoreSprite = [SKSpriteNode spriteNodeWithImageNamed:@"Score.png"];
    finalScoreSprite.position = CGPointMake(-80, 30);
    finalScoreSprite.hidden = NO;
    [groundSprite addChild:finalScoreSprite];
    
    highScoreSprite = [SKSpriteNode spriteNodeWithImageNamed:@"Bast.png"];
    highScoreSprite.position = CGPointMake(70, 30);
    highScoreSprite.hidden = NO;
    [groundSprite addChild:highScoreSprite];
    
    
    finalScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    finalScoreLabel.position = CGPointMake(-80, -30);
    finalScoreLabel.fontSize = 40;
    finalScoreLabel.fontColor = [UIColor whiteColor];
    //finalScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    
    finalScoreLabel.zPosition = 13;
    finalScoreLabel.text = [NSString stringWithFormat:@"%d", scoreCount];
    [groundSprite addChild:finalScoreLabel];
    
    
    highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScoreLabel.position = CGPointMake(70, -30);
    highScoreLabel.fontSize = 40;
    highScoreLabel.fontColor = [UIColor whiteColor];
    //highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    highScoreLabel.zPosition = 13;
    
    
    
    highScoreLabel.text = [NSString stringWithFormat:@"%d", topScoreInt];
    [groundSprite addChild:highScoreLabel];
    
    [self runAction:hitSound];

    if (isHighScore) {
        NSLog(@"high score! %d", scoreCount);
    }
    
    [self buildWaitingForTouchView];
    
    [self showAds];

}


-(void) didBeginContact:(SKPhysicsContact *)contact {
    SKSpriteNode *aNode = (SKSpriteNode *)contact.bodyA.node;
    SKSpriteNode *bNode = (SKSpriteNode *) contact.bodyB.node;
    
    if (([aNode.name isEqualToString:@"player"] && [bNode.name isEqualToString:@"lightning"]) ||
        (([aNode.name isEqualToString:@"lightning"] && [bNode.name isEqualToString:@"player"])))
    {
        wallsSpeed = wallsSpeed - 2.1;
        [self runAction:speedSound];
        
        if (!playerSmokeNode) {
            NSString *fliesPath =[[NSBundle mainBundle] pathForResource:@"PlayerSmoke" ofType:@"sks"];
            playerSmokeNode = [NSKeyedUnarchiver unarchiveObjectWithFile:fliesPath];
            playerSmokeNode.name = @"playerSmokeNode";
            playerSmokeNode.position = CGPointMake(playerSprite.position.x-25, playerSprite.position.y);
        }
        
        [self addChild:playerSmokeNode];

      
        for (SKSpriteNode *wallNode in self.children) {
            if ([wallNode.name isEqualToString:@"wall"]) {
                [wallNode removeFromParent];
            }
            if ([wallNode.name isEqualToString:@"passedWall"]) {
                [wallNode removeFromParent];
            }
            if ([wallNode.name isEqualToString:@"wallup"]) {
                [wallNode removeFromParent];
            }
            if ([wallNode.name isEqualToString:@"lightning"]) {
                [wallNode removeFromParent];
            }
        }
        shouldPauseWalls = YES;
        showingSpeedIntro = YES;
        
        
        playerSprite.physicsBody.affectedByGravity = NO;
        playerSprite.physicsBody.velocity = CGVectorMake(0, -0.05);
        playerSprite.physicsBody.mass = 10.0;
        
        
        speedIntroCoverView = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:self.size];
        speedIntroCoverView.position = CGPointMake(screenCenterX, screenCenterY);
        speedIntroCoverView.name = @"introCover";
        speedIntroCoverView.zPosition = 1000;
        [self addChild:speedIntroCoverView];
        
        speedReadyBox = [SKSpriteNode spriteNodeWithImageNamed:@"SpeedReady.png"];
        speedReadyBox.position = CGPointMake(400, 0);
        speedReadyBox.name = @"introCover";

        [speedIntroCoverView addChild:speedReadyBox];
        [speedReadyBox runAction:[SKAction moveTo:CGPointMake(0, 0) duration:0.2]];
        
        
        
        speedAction = [SKAction sequence:@[[SKAction waitForDuration:1.2],[SKAction runBlock:^(void){
            
            speedGoBox = [SKSpriteNode spriteNodeWithImageNamed:@"SpeedGo.png"];
            speedGoBox.position = CGPointMake(400, 0);
            speedGoBox.name = @"introCover";

            [speedIntroCoverView addChild:speedGoBox];
            
            [speedReadyBox runAction:[SKAction moveTo:CGPointMake(-400, 0) duration:0.4]];
            [speedGoBox runAction:[SKAction moveTo:CGPointMake(0, 0) duration:0.4]];
            
        }], [SKAction waitForDuration:1.2], [SKAction runBlock:^(void){
            [speedGoBox runAction:[SKAction moveTo:CGPointMake(-400, 0) duration:0.6]];
            shouldPauseWalls = NO;
        }], [SKAction runBlock:^(void) {
            
            [speedGoBox removeFromParent];
            [speedReadyBox removeFromParent];
            [speedIntroCoverView removeFromParent];
            speedGoBox = nil;
            speedReadyBox = nil;
            speedIntroCoverView = nil;
        }],[SKAction waitForDuration:0.5],[SKAction runBlock:^(void) {
            showingSpeedIntro = NO;
            playerSprite.physicsBody.affectedByGravity = YES;
            playerSprite.physicsBody.velocity = self.physicsBody.velocity;
            playerSprite.physicsBody.mass = 0.5;
            
            [self performSelector:@selector(removeSpeedMode) withObject:nil afterDelay:15.0];
        }]]];
        
        [self runAction:speedAction withKey:@"SpeedAction"];

        
        
    }
    else {
        if (speedIntroCoverView) [speedIntroCoverView removeFromParent];
        [self endGame];

    }
    
}

-(void) removeSpeedMode {
    wallsSpeed = 7.0;
    [playerSmokeNode removeFromParent];
    playerSmokeNode = nil;
}

-(void) startRain {
    NSString *rainPath =[[NSBundle mainBundle] pathForResource:@"RainEffect" ofType:@"sks"];
    SKEmitterNode *rainNode = [NSKeyedUnarchiver unarchiveObjectWithFile:rainPath];
    rainNode.name = @"rainNode";
    currentEffectName = @"rainNode";
    rainNode.position = CGPointMake(screenCenterX, [gameTools currentScreenSize].height);
    [self addChild:rainNode];
}

-(void) startSnow {
    [[self childNodeWithName:@"rainNode"] removeFromParent];
    
    NSString *snowPath =[[NSBundle mainBundle] pathForResource:@"SnowEffect" ofType:@"sks"];
    SKEmitterNode *snowNode = [NSKeyedUnarchiver unarchiveObjectWithFile:snowPath];
    snowNode.name = @"snowNode";
    currentEffectName = @"snowNode";
    snowNode.position = CGPointMake(screenCenterX, [gameTools currentScreenSize].height);
    [self addChild:snowNode];
}

-(void) startFlies {
    [[self childNodeWithName:currentEffectName] removeFromParent];
    
    NSString *fliesPath =[[NSBundle mainBundle] pathForResource:@"Efct" ofType:@"sks"];
    SKEmitterNode *fliesNode = [NSKeyedUnarchiver unarchiveObjectWithFile:fliesPath];
    fliesNode.name = @"fliesNode";
    currentEffectName = @"fliesNode";
    fliesNode.position = CGPointMake(screenCenterX, [gameTools currentScreenSize].height);
    [self addChild:fliesNode];
}

-(void) startSmoke {
    [[self childNodeWithName:currentEffectName] removeFromParent];
    
    NSString *fliesPath =[[NSBundle mainBundle] pathForResource:@"SmokeEffect" ofType:@"sks"];
    SKEmitterNode *smokeNode = [NSKeyedUnarchiver unarchiveObjectWithFile:fliesPath];
    smokeNode.name = @"smokeNode";
    currentEffectName = @"smokeNode";
    smokeNode.position = CGPointMake(screenCenterX, 100);
    [self addChild:smokeNode];
}

-(void) startSparks {
    [[self childNodeWithName:currentEffectName] removeFromParent];
    
    NSString *fliesPath =[[NSBundle mainBundle] pathForResource:@"SparksEffect" ofType:@"sks"];
    SKEmitterNode *sparksNode = [NSKeyedUnarchiver unarchiveObjectWithFile:fliesPath];
    sparksNode.name = @"sparksNode";
    currentEffectName = @"sparksNode";
    sparksNode.position = CGPointMake(screenCenterX, [gameTools currentScreenSize].height);
    [self addChild:sparksNode];
    
    
}


-(void) startFire {
    [[self childNodeWithName:currentEffectName] removeFromParent];
    
    NSString *fliesPath =[[NSBundle mainBundle] pathForResource:@"FireEffect" ofType:@"sks"];
    SKEmitterNode *fireNode = [NSKeyedUnarchiver unarchiveObjectWithFile:fliesPath];
    fireNode.name = @"fireNode";
    currentEffectName = @"fireNode";
    fireNode.position = CGPointMake(screenCenterX, 100);
    [self addChild:fireNode];
    

}

-(void) createDoubleWall {
    if (shouldPauseWalls) return;
    
    contactCount = 0;
    effectWallsCreated++;
    BOOL addLightning = NO;
    
    if (effectWallsCreated == 15) {
        [self startRain];
        addLightning = YES;
    }
    if (effectWallsCreated == 30) {
        [self startSnow];
        addLightning = YES;
    }
    if (effectWallsCreated == 45) {
        [self startFlies];
        addLightning = YES;
    }
    if (effectWallsCreated == 60) {
        [self startSmoke];
        addLightning = YES;
    }
    if (effectWallsCreated == 75) {
        [self startSparks];
        addLightning = YES;
    }
    if (effectWallsCreated == 90) {
        [self startFire];
        addLightning = YES;
    }
    
    if (effectWallsCreated > 90) effectWallsCreated = 0;
    
    int bottomMax = 200;
    if (isIPhone4) bottomMax = 170;
    
    int spriteBottomY = arc4random() % bottomMax;
    int spriteTopY = spriteBottomY + 300 + poolDiffSize;
    
    if (poolDiffSize > 110) {
        poolDiffSize -= 10;
    }
    
    SKSpriteNode *wallNodeBottom = [SKSpriteNode spriteNodeWithImageNamed:@"Wall1.png"];
    wallNodeBottom.position = CGPointMake(800, spriteBottomY);
    wallNodeBottom.zPosition = 1;
    wallNodeBottom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wallNodeBottom.size];
    wallNodeBottom.name = @"wall";
    wallNodeBottom.physicsBody.dynamic = NO;
    [self addChild:wallNodeBottom];
    
    SKSpriteNode *wallNodeTop = [SKSpriteNode spriteNodeWithImageNamed:@"Wall2.png"];
    wallNodeTop.position = CGPointMake(800, spriteTopY);
    wallNodeTop.zPosition = 1;
    wallNodeTop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wallNodeTop.size];
    wallNodeTop.name = @"wallup";
    wallNodeTop.physicsBody.dynamic = NO;
    wallNodeTop.physicsBody.categoryBitMask = wallObj;
    wallNodeTop.physicsBody.collisionBitMask = wallObj | birdObj;
    wallNodeTop.physicsBody.contactTestBitMask = wallObj | birdObj;
    [self addChild:wallNodeTop];
    
    
    SKAction *moveBottom = [SKAction moveToX:-100 duration:wallsSpeed];
    SKAction *moveTop = [SKAction moveToX:-100 duration:wallsSpeed];
    
    [wallNodeBottom runAction:[SKAction sequence:@[moveBottom, [SKAction runBlock:^{
        [wallNodeBottom removeFromParent];
    }]]]];
    
    [wallNodeTop runAction:[SKAction sequence:@[moveTop, [SKAction runBlock:^{
        [wallNodeTop removeFromParent];
    }]]]];
    
    
    if (addLightning) {
        int nodeY = spriteBottomY + (wallNodeBottom.size.height/2) + 35;
        
        SKSpriteNode *lightningNode = [SKSpriteNode spriteNodeWithImageNamed:@"Coin.png"];
        lightningNode.position = CGPointMake(820, nodeY);
        lightningNode.name = @"lightning";
        lightningNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:lightningNode.size];
        lightningNode.physicsBody.dynamic = NO;
        lightningNode.physicsBody.categoryBitMask = lightningObj;
        lightningNode.physicsBody.collisionBitMask = lightningObj | birdObj;
        lightningNode.physicsBody.contactTestBitMask = lightningObj | birdObj;
        [self addChild:lightningNode];
        
        SKAction *moveLightning = [SKAction moveToX:-100 duration:wallsSpeed];
        
        [lightningNode runAction:[SKAction sequence:@[moveLightning, [SKAction runBlock:^{
            [lightningNode removeFromParent];
        }]]]];
        
    }
    
    
    if (addTimerPoints) {
        //scoreCount++;
        //scoreCountLabel.text = [NSString stringWithFormat:@"%d", scoreCount];
    }
    
    //[self performSelector:@selector(initScoreCounter) withObject:nil afterDelay:3.02];

}

-(void) buildWaitingForTouchView {
    
    [gameOverSprite removeFromParent];
    gameOverSprite = nil;
    
    playerSprite.position = CGPointMake(screenCenterX, screenCenterY);
    
    if (waitingForTouchView) {
        [waitingForTouchView removeFromParent];
        waitingForTouchView = nil;
    }
    
    waitingForTouchView = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(300, 250)];
    waitingForTouchView.position = CGPointMake(600, screenCenterY-20);
    waitingForTouchView.zPosition = 12;
    
    NSString *playBtnFile = @"ReplayBtn.png";
    NSString *birdFile = @"BirdInPrison.png";
    if (isFirstInit) {
        birdFile = @"BirdOutPrison.png";
        playBtnFile = @"PlayBtn.png";
    }
    
    SKSpriteNode *birdSprite = [SKSpriteNode spriteNodeWithImageNamed:birdFile];
    birdSprite.position = CGPointMake(0, 0+20);
    
    if (isIPhone4) {
        birdSprite.size = CGSizeMake(146, 100);
        birdSprite.position = CGPointMake(0, 0+30);
    }
    
    if (isFirstInit) {
        //[birdSprite runAction:[SKAction rotateByAngle:-0.2 duration:0.1]];
    }
    [waitingForTouchView addChild:birdSprite];
    
    if (isFirstInit) {
//        SKAction *rotateRightLeft =  [SKAction sequence:@[[SKAction rotateByAngle:0.4 duration:0.5], [SKAction rotateByAngle:-0.4 duration:0.5]]];
//        
//        [birdSprite runAction:[SKAction repeatActionForever:rotateRightLeft]];
        isFirstInit = NO;
    }
    
    int btnTop = -90;
    if (isIPhone4) btnTop = -55;
    
    
    SKSpriteNode *faceBtn = [SKSpriteNode spriteNodeWithImageNamed:@"FacebookBtn.png"];
    faceBtn.name = @"facebook";
    faceBtn.position = CGPointMake(95, btnTop);
    [waitingForTouchView addChild:faceBtn];
    
    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:playBtnFile];
    playButton.name = @"playButton";
    playButton.position = CGPointMake(0, btnTop);
    [waitingForTouchView addChild:playButton];
    
    
    SKSpriteNode *leaderboards = [SKSpriteNode spriteNodeWithImageNamed:@"GameCenterBTN.png"];
    leaderboards.name = @"leaderboards";
    leaderboards.position = CGPointMake(120, 60);
    [waitingForTouchView addChild:leaderboards];
    
    SKSpriteNode *storeBtn = [SKSpriteNode spriteNodeWithImageNamed:@"StoreBTN.png"];
    storeBtn.name = @"store";
    storeBtn.position = CGPointMake(-95, btnTop);
    [waitingForTouchView addChild:storeBtn];
    
    
    faceLoginBtn = [SKSpriteNode spriteNodeWithImageNamed:@"FacebookLogoutBtn.png"];
    faceLoginBtn.name = @"facebookConnect";
    
    CGPoint fbPoint = CGPointMake(95, btnTop);
    if (fbLoggedIn) {
        fbPoint = CGPointMake(-120, 60);
    }
    
    faceLoginBtn.position = fbPoint;
    [waitingForTouchView addChild:faceLoginBtn];
    
    if (fbLoggedIn) {
        faceLoginBtn.size = CGSizeMake(40, 40);

        SKAction *changeTitle = [SKAction setTexture:[SKTexture textureWithImageNamed:@"FacebookLogoutBtn.png"]];
        SKAction *moAction = [SKAction moveTo:CGPointMake(-120, 60) duration:0.1];
        SKAction *fiAction = [SKAction fadeInWithDuration:0.2];
        
        [faceLoginBtn runAction:[SKAction sequence:@[changeTitle,moAction,fiAction]]];
    }
    else {
        faceLoginBtn.size = CGSizeMake(65, 65);
        SKAction *changeTitle = [SKAction setTexture:[SKTexture textureWithImageNamed:@"FacebookBtn.png"]];
        SKAction *moAction = [SKAction moveTo:CGPointMake(95, btnTop) duration:0.1];
        SKAction *fiAction = [SKAction fadeInWithDuration:0.2];
        
        [faceLoginBtn runAction:[SKAction sequence:@[changeTitle,moAction,fiAction]]];
    }
    
    
    [self addChild:waitingForTouchView];
    
    SKTMoveEffect *moveIn = [SKTMoveEffect effectWithNode:waitingForTouchView duration:0.7 startPosition:CGPointMake(600, screenCenterY-20) endPosition:CGPointMake(screenCenterX, screenCenterY-20)];
    moveIn.timingFunction = SKTTimingFunctionCircularEaseInOut;
    [waitingForTouchView runAction:[SKAction actionWithEffect:moveIn]];

    if (scoreCount > 4) {
        [self openInGameStore];
    }
    
    
//    aboutBtn = [SKSpriteNode spriteNodeWithImageNamed:@"StoreBTN.png"];
//    aboutBtn.name = @"aboutBtn";
//    aboutBtn.position = CGPointMake(-140, 15);
//    [waitingForTouchView addChild:aboutBtn];
    
    
}


-(void) storeCloseStore {
    SKTMoveEffect *moveEndBoxOut = [SKTMoveEffect effectWithNode:mainStoreSprite duration:0.5 startPosition:CGPointMake(screenCenterX, [gameTools YpointForMainStore]) endPosition:CGPointMake(-400, [gameTools YpointForMainStore])];
    moveEndBoxOut.timingFunction = SKTTimingFunctionCircularEaseOut;
    
    [mainStoreSprite runAction:[SKAction sequence:@[[SKAction actionWithEffect:moveEndBoxOut], [SKAction runBlock:^{
        mainStoreSprite.alpha = 0.0;
        //[mainStoreSprite removeFromParent];
    }]]]];
}

-(void) openStoreWaitingView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openStoreWaitingView" object:nil];
}


-(void) closeStoreWaitingView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeStoreWaitingView" object:nil];
}

-(void) storeBuyRevive {
    [purchaseManager buyReviveNow];
}

-(void) storeBuyThreeRevives {
    [purchaseManager buyThreeRevives];
}

-(void) storeBuyRemoveAds {
    [purchaseManager buyNoAds];
}


-(void) purchaseChangesMade:(NSString *)changeInfo {
    if ([changeInfo isEqualToString:@"unlockedReviveNow"]) {
        
        NSString *savedRevive = [infoSaved objectForKey:@"savedRevive"];
        int savedReviveInt = [savedRevive intValue];
        savedReviveInt++;
        [infoSaved setObject:[NSString stringWithFormat:@"%d", savedReviveInt] forKey:@"savedRevive"];
        [infoSaved synchronize];
        
        
        UIAlertView *noPM = [[UIAlertView alloc] initWithTitle:@"Store" message:@"Thank you for your purchase!\n As a thank you we've added another 'Revive' to your account for free!" delegate:nil cancelButtonTitle:@"Awesome!" otherButtonTitles:nil, nil];
        noPM.delegate = self;
        noPM.tag = 2;
        [noPM show];
        
        [self closeStoreWaitingView];

    }
    
    else if ([changeInfo isEqualToString:@"unlockedThreeRevives"]) {
        NSString *savedRevive = [infoSaved objectForKey:@"savedRevive"];
        int savedReviveInt = [savedRevive intValue];
        savedReviveInt = savedReviveInt+3;
        [infoSaved setObject:[NSString stringWithFormat:@"%d", savedReviveInt] forKey:@"savedRevive"];
        [infoSaved synchronize];
        
        
        UIAlertView *noPM = [[UIAlertView alloc] initWithTitle:@"Store" message:@"Thank you for your purchase!\n Enjoy the game!" delegate:nil cancelButtonTitle:@"Awesome!" otherButtonTitles:nil, nil];
        noPM.delegate = self;
        noPM.tag = 3;
        [noPM show];
        [self closeStoreWaitingView];

    }
    
    else if ([changeInfo isEqualToString:@"unlockedNoAds"]) {
        [infoSaved setObject:@"NO" forKey:@"CanShowAds"];
        [infoSaved synchronize];
        
        [self hideAds];
        
        
        UIAlertView *noPM = [[UIAlertView alloc] initWithTitle:@"Store" message:@"Thank you for your purchase!\n No more ads for you!\n Enjoy the game!" delegate:nil cancelButtonTitle:@"Awesome!" otherButtonTitles:nil, nil];
        noPM.delegate = self;
        noPM.tag = 3;
        [noPM show];
        [self closeStoreWaitingView];

    }
    
    
    
    if ([changeInfo isEqualToString:@"error"]) {
        UIAlertView *noPM = [[UIAlertView alloc] initWithTitle:@"Store" message:@"Sorry but for some reason you can't make purchases from the store, check your AppStore ID and try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noPM show];
    }
}

-(void) showAds {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAds" object:nil];
    
}


-(void) hideAds {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAds" object:nil];
}




-(void) storeInCloseStore {
    
    [self displayFullScreenAd];
    
    if (blindModeOn) {
        [self removeParticles];
    }
    
    blindModeOn = NO;

    
    SKTMoveEffect *moveEndBoxOut = [SKTMoveEffect effectWithNode:gameStoreSprite duration:1.0 startPosition:CGPointMake(screenCenterX, [gameTools YpointForMainStore]) endPosition:CGPointMake(-400, [gameTools YpointForMainStore])];
    moveEndBoxOut.timingFunction = SKTTimingFunctionCircularEaseOut;
    
    [gameStoreSprite runAction:[SKAction sequence:@[[SKAction actionWithEffect:moveEndBoxOut], [SKAction runBlock:^{
        gameStoreSprite.alpha = 0.0;
        [gameStoreSprite removeFromParent];
        facebookBuyType = @"FBOut";
    }]]]];
}

-(void) canRevive {
    SKTMoveEffect *moveEndBoxOut = [SKTMoveEffect effectWithNode:self.gameStoreSprite duration:1.0 startPosition:CGPointMake(screenCenterX, [gameTools YpointForMainStore]) endPosition:CGPointMake(-400, [gameTools YpointForMainStore])];
    moveEndBoxOut.timingFunction = SKTTimingFunctionCircularEaseOut;
    
    [self.gameStoreSprite runAction:[SKAction sequence:@[[SKAction actionWithEffect:moveEndBoxOut], [SKAction runBlock:^{
        
        self.gameStoreSprite.alpha = 0.0;
        [self.gameStoreSprite removeFromParent];

        
        
        [self startGame:YES];
    }]]]];
    
    
}

-(void) inGameBuyRevive:(NSString*) reviveType {
    BOOL shouldReduce = YES;
    [waitingForTouchView removeFromParent];
    waitingForTouchView = nil;
    
    
    if ([reviveType isEqualToString:@"Saved"]) {

        shouldReduce = YES;
    }

    else if ([reviveType isEqualToString:@"FBIn"]) {
        shouldReduce = NO;
        [infoSaved setObject:[NSDate date] forKey:@"lastFBUseDate"];
        [infoSaved synchronize];
    }
    else if ([reviveType isEqualToString:@"ReviveNow"]) {
        shouldReduce = NO;
    }
    else if ([reviveType isEqualToString:@"VideoBuy"]) {
        shouldReduce = NO;
        //self.paused = NO;
    }
    
    
    if (shouldReduce) {
        NSString *savedRevive = [infoSaved objectForKey:@"savedRevive"];
        int savedReviveInt = [savedRevive intValue];
        savedReviveInt--;
        [infoSaved setObject:[NSString stringWithFormat:@"%d", savedReviveInt] forKey:@"savedRevive"];
        [infoSaved synchronize];
    }
    
    NSLog(@"now");
    [self canRevive];

}






-(void) buyUsingFacebook {
    facebookBuyType = @"FBIn";
    [self startFacebookPost];
}






-(void) vungleViewDidDisappear:(UIViewController *)viewController {
    [self inGameBuyRevive:@"VideoBuy"];
}

-(void) vungleMoviePlayed:(VGPlayData *)playData {
    if ([playData playedFull]) {
        NSLog(@"yes");
    }
    else {
        NSLog(@"no");
    }
}




-(void) reviveByVideo {
    if ([VGVunglePub adIsAvailable]) {
        [VGVunglePub setDelegate:self];
        UIViewController *vc = self.view.window.rootViewController;
        [VGVunglePub playModalAd:vc animated:YES];
    }
    else {
        NSLog(@"no movie");
    }
    
}

-(void) displayFullScreenAd {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showFullScreenAds" object:nil];
}


-(void) useReviveNow {
    [self inGameBuyRevive:@"Saved"];
    
}

-(void) openInGameStore {
    [gameStoreSprite removeFromParent];
    gameStoreSprite = nil;
    
    
    if (!gameStoreSprite) {
        gameStoreSprite = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveBack.png"];
        gameStoreSprite.position = CGPointMake(400, [gameTools YpointForMainStore]);
        gameStoreSprite.zPosition = 15;
        
        SKSpriteNode *closeStoreButton = [SKSpriteNode spriteNodeWithImageNamed:@"StorXBTN.png"];
        closeStoreButton.name = @"closeInStore";
        closeStoreButton.position = CGPointMake(140, 90);
        [gameStoreSprite addChild:closeStoreButton];
        
        NSString *savedRevive = [infoSaved objectForKey:@"savedRevive"];
        int savedReviveInt = [savedRevive intValue];
        
        if (savedReviveInt > 0) {
            SKSpriteNode *useRevive = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveBTN.png"];
            useRevive.name = @"useRevive";
            useRevive.position = CGPointMake(95, -75);
            [gameStoreSprite addChild:useRevive];
            
            NSString *revText = @"Revives";
            if (savedReviveInt == 1) revText = @"Revive";
            
            NSString *reviveText = [NSString stringWithFormat:@"%d %@ Left", savedReviveInt, revText];
            
            SKLabelNode *reviveLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            reviveLabel.position = CGPointMake(-60,-80);
            reviveLabel.fontSize = 20;
            reviveLabel.text = reviveText;
            reviveLabel.fontColor = [UIColor whiteColor];
            [gameStoreSprite addChild:reviveLabel];
            //scoreCountLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
            
        }
        else {
            SKSpriteNode *buyRevive = [SKSpriteNode spriteNodeWithImageNamed:@"Dollar.png"];
            buyRevive.name = @"buyInRevive";
            buyRevive.position = CGPointMake(-90, -75);
            [gameStoreSprite addChild:buyRevive];
            
            SKSpriteNode *reviveVideo = [SKSpriteNode spriteNodeWithImageNamed:@"VideoAdd.png"];
            reviveVideo.name = @"reviveByVideo";
            reviveVideo.position = CGPointMake(0, -75);
            [gameStoreSprite addChild:reviveVideo];
            
            NSDate *lastFBDate = [infoSaved objectForKey:@"lastFBUseDate"];
            NSDate *today = [NSDate date];
            
            NSString *btnImage = @"FacebookBtn.png";
            NSString *btnName = @"buyUsingFacebook";
            
            if (lastFBDate) {
                NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
                NSUInteger units = NSDayCalendarUnit;
                NSDateComponents *components = [gregorian components:units fromDate:lastFBDate toDate:today options:0];
                NSInteger days = [components day];
                if (days < 1) {
                    btnImage = @"FacebookBTNOff.png";
                    btnName = @"FBOff";
                }
            }
            
            
            SKSpriteNode *buyUsingFacebook = [SKSpriteNode spriteNodeWithImageNamed:btnImage];
            buyUsingFacebook.name = btnName;
            buyUsingFacebook.position = CGPointMake(90, -75);
            [gameStoreSprite addChild:buyUsingFacebook];
            
            if (!purchaseManager) {
                purchaseManager = [[PManager alloc] init];
                purchaseManager.delegate = self;
            }
        }
        
        
        

    }
    
    gameStoreSprite.position = CGPointMake(400, [gameTools YpointForMainStore]);
    gameStoreSprite.alpha = 1.0;
    
    [self addChild:gameStoreSprite];
    
    SKTMoveEffect *moveEndBoxOut = [SKTMoveEffect effectWithNode:gameStoreSprite duration:1.0 startPosition:CGPointMake(400, [gameTools YpointForMainStore]) endPosition:CGPointMake(screenCenterX, [gameTools YpointForMainStore])];
    moveEndBoxOut.timingFunction = SKTTimingFunctionBounceEaseOut;
    
    
    [gameStoreSprite runAction:[SKAction actionWithEffect:moveEndBoxOut]];
}

-(void) facebookOFFTimerView {
    if (fbOFFTimerView) {
        [fbOFFTimerView removeFromParent];
        fbOFFTimerView = nil;
    }
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    NSDate *tomorrow = [gregorian dateByAddingComponents:components toDate:today options:0];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    components = [gregorian components:unitFlags fromDate:tomorrow];
    components.hour = 0;
    components.minute = 0;
    
    NSDate *tomorrowMidnight = [gregorian dateFromComponents:components];
    NSTimeInterval diffInte = [tomorrowMidnight timeIntervalSinceNow];
    
    NSInteger ti = (NSInteger)diffInte;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    NSString *hourString = [NSString stringWithFormat:@"Next Facebook Revive in:\n %ld:%ld:%ld", (long)hours, (long)minutes, (long)seconds];
    
    UIAlertView *fbOffAlertView = [[UIAlertView alloc] initWithTitle:@"Facebook Revive" message:hourString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [fbOffAlertView show];
    
}


-(void) openMainGameStore {
    if (!mainStoreSprite) {
        mainStoreSprite = [SKSpriteNode spriteNodeWithImageNamed:@"StorBack.png"];
        mainStoreSprite.position = CGPointMake(400, [gameTools YpointForMainStore]);
        mainStoreSprite.zPosition = 15;
        
        SKSpriteNode *closeStoreButton = [SKSpriteNode spriteNodeWithImageNamed:@"StorXBTN.png"];
        closeStoreButton.name = @"closeStore";
        closeStoreButton.position = CGPointMake(140, 90);
        [mainStoreSprite addChild:closeStoreButton];
        
        SKSpriteNode *buyRevive = [SKSpriteNode spriteNodeWithImageNamed:@"StorRivive.png"];
        buyRevive.name = @"buyRevive";
        buyRevive.position = CGPointMake(0, 10);
        [mainStoreSprite addChild:buyRevive];
        
        SKSpriteNode *buyRemoveAds = [SKSpriteNode spriteNodeWithImageNamed:@"StoreNoAdd.png"];
        buyRemoveAds.name = @"buyRemoveAds";
        buyRemoveAds.position = CGPointMake(0, -70);
        [mainStoreSprite addChild:buyRemoveAds];
        
        SKSpriteNode *restoreButton = [SKSpriteNode spriteNodeWithImageNamed:@"RestoreBTN.png"];
        restoreButton.name = @"restorePurchases";
        restoreButton.position = CGPointMake(0, mainStoreSprite.size.height/2+10);
        [mainStoreSprite addChild:restoreButton];
        
        
        if (!purchaseManager) {
            purchaseManager = [[PManager alloc] init];
            purchaseManager.delegate = self;
        }
        [self addChild:mainStoreSprite];

        
    }
    
    mainStoreSprite.position = CGPointMake(400, [gameTools YpointForMainStore]);
    mainStoreSprite.alpha = 1.0;
    
    SKTMoveEffect *moveEndBoxOut = [SKTMoveEffect effectWithNode:mainStoreSprite duration:0.5 startPosition:CGPointMake(400, [gameTools YpointForMainStore]) endPosition:CGPointMake(screenCenterX, [gameTools YpointForMainStore])];
    moveEndBoxOut.timingFunction = SKTTimingFunctionBounceEaseOut;
    
    
    [mainStoreSprite runAction:[SKAction actionWithEffect:moveEndBoxOut]];
    
    
}


-(void) restorePurchases {
    [purchaseManager restorePurchases];
}



-(void) addScore {
    scoreCount++;
    scoreCountLabel.text = [NSString stringWithFormat:@"%d", scoreCount];
}

-(void) initScoreCounter {
//    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(addScore) onTarget:self],[SKAction waitForDuration:2.0]]]]];

    addTimerPoints = YES;

}


-(void) startNow {
    gameRunning = YES;
    firstPool = YES;
    poolDiffSize = 210;
    blindModeButton.hidden = YES;

    [tapScreenSprite removeFromParent];
    tapScreenSprite = nil;
    
    
    if (blindModeOn) {
        [self addParticals];
    }
    
//    NSString *savedScore = [infoSaved objectForKey:@"VideoSavedScore"];
//    if (savedScore) {
//        int savedScoreInt = [savedScore intValue];
//        scoreCount = savedScoreInt;
//        
//    }
    

    [topItemImage runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.0 duration:0.5], [SKAction runBlock:^{
        topItemImage.hidden = YES;
        scoreCountLabel.text = [NSString stringWithFormat:@"%d", scoreCount];
    }]]]];
    
    self.physicsWorld.gravity = CGVectorMake(0, -5);
    playerSprite.physicsBody.velocity = self.physicsBody.velocity;
    //self.paused = NO; ******
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(createDoubleWall) onTarget:self],[SKAction waitForDuration:2.0]]]]];
}


-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2) {
        [self inGameBuyRevive:@"ReviveNow"];
    }
    else if (alertView.tag == 5) {
        if (buttonIndex == 1) {
            [infoSaved setObject:@"Rated" forKey:@"DidRate"];
            [infoSaved setObject:@"YES" forKey:@"IsRating"];
                        
            NSString *savedRevive = [infoSaved objectForKey:@"savedRevive"];
            int savedReviveInt = [savedRevive intValue];
            savedReviveInt++;
            [infoSaved setObject:[NSString stringWithFormat:@"%d", savedReviveInt] forKey:@"savedRevive"];
            [infoSaved synchronize];
            
            self.appURL = [NSURL URLWithString:@"http://itunes.apple.com/us/app/id826116883?mt=8"];
            [[UIApplication sharedApplication] openURL:appURL];
            
        }
    }
    else if (alertView.tag == 6) {
        [self inGameBuyRevive:@"VideoBuy"];
        [gameStoreSprite removeFromParent];
        gameStoreSprite = nil;

    }
    
    
}


-(void) checkRate {
    NSString *didRate = [infoSaved objectForKey:@"DidRate"];
    if (!didRate) {
        NSString *rateCounter = [infoSaved objectForKey:@"rateCounter"];
        NSLog(@"%@", rateCounter);
        
        int counterInt = [rateCounter intValue];
        if (counterInt < 6) {
            counterInt++;
            [infoSaved setObject:[NSString stringWithFormat:@"%d", counterInt] forKey:@"rateCounter"];
        }
        else {
            counterInt = 0;
            [infoSaved setObject:[NSString stringWithFormat:@"%d", counterInt] forKey:@"rateCounter"];
            
            UIAlertView *rateUsAlert = [[UIAlertView alloc] initWithTitle:@"Rate Jailbird!" message:@"If your enjoying our game,\n please give us 10 seconds of your time and rate our game.\n Thank You!" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Sure!", nil];
            rateUsAlert.tag = 5;
            [rateUsAlert show];
        }
    }
}

-(NSMutableArray*) shuffleLevelCardsArray:(NSMutableArray*) givenCardsArray {
    for (int i = 0; i < [givenCardsArray count]; ++i) {
        int r = (arc4random () % [givenCardsArray count]);
        [givenCardsArray exchangeObjectAtIndex:i withObjectAtIndex:r];
    }
    return givenCardsArray;
}

-(void) blindAnimationEnded {
    blindStartAnimationOn = NO;
}

-(void) removeParticles {
    SKAction *changeTitle = [SKAction setTexture:[SKTexture textureWithImageNamed:@"BGiMAGE.png"]];
    [bgNode runAction:changeTitle];

}


-(void) addParticals {
    UIImage *ship = [UIImage imageNamed:@"BGiMAGE.png"];
    CIImage *shipImage = [[CIImage alloc] initWithImage:ship];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey, shipImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *out = [filter outputImage];
    CGImageRef cg = [context createCGImage:out fromRect:[out extent]];
    SKTexture *texDone = [SKTexture textureWithCGImage:cg];
    
    SKAction *changeTitle = [SKAction setTexture:texDone];
    [bgNode runAction:changeTitle];
    
}

-(void) startBlindMode {
    blindModeOn = YES;
    blindModeButton.hidden = YES;
    [blindModeButton removeFromParent];
    blindModeButton = nil;
    blindStartAnimationOn = YES;
    
    SKAction *fadeDown = [SKAction fadeAlphaTo:0.0 duration:0.05];
    SKAction *fadeUp = [SKAction fadeAlphaTo:1.0 duration:0.05];
    
    SKAction *fadingBird = [SKAction sequence:@[[SKAction waitForDuration:1.0],fadeDown,[SKAction waitForDuration:1.0], fadeUp]];
    [playerSprite runAction:[SKAction repeatAction:fadingBird count:2]];
    
    [self performSelector:@selector(blindAnimationEnded) withObject:nil afterDelay:4.3];
    
    [self addParticals];
    
    //START BLIND MODE
}


-(void) showUnlockedBlindMode {
    __block SKSpriteNode *unlockedBG = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:self.view.frame.size];
    unlockedBG.position = CGPointMake(400, screenCenterY);
    unlockedBG.zPosition = 20;
    [self addChild:unlockedBG];
    
    SKSpriteNode *boxNode = [SKSpriteNode spriteNodeWithImageNamed:@"UBMBack.png"];
    boxNode.position = CGPointMake(0, -40);
    [unlockedBG addChild:boxNode];
    
    SKTMoveEffect *moveIn = [SKTMoveEffect effectWithNode:unlockedBG duration:0.7 startPosition:CGPointMake(400, screenCenterY) endPosition:CGPointMake(screenCenterX, screenCenterY)];
    moveIn.timingFunction = SKTTimingFunctionCircularEaseInOut;
    
    SKAction *fadeOut = [SKAction fadeAlphaTo:0.0 duration:1.0];
    
    
    [unlockedBG runAction:[SKAction sequence:@[[SKAction actionWithEffect:moveIn],[SKAction waitForDuration:2.0] ,fadeOut ,[SKAction runBlock:^{
        [unlockedBG removeFromParent];
        unlockedBG = nil;
    }]]]];
    
}




-(void) showBlindModeButton {
    //[self showUnlockedBlindMode];
    
    NSString *blindCountString = [infoSaved objectForKey:@"blindCount"];
    int blindCountInt = [blindCountString intValue];
    if (blindCountInt < 4) {
        blindCountInt++;
        [infoSaved setObject:[NSString stringWithFormat:@"%d", blindCountInt] forKey:@"blindCount"];
        [infoSaved synchronize];
        
    }
    else {
        NSString *blindCountString = [infoSaved objectForKey:@"blindUnlocked"];
        if (![blindCountString isEqualToString:@"YES"]) {
            [infoSaved setObject:@"YES" forKey:@"blindUnlocked"];
            [infoSaved synchronize];
            // UNLOCKED BLIND MODE
            [self showUnlockedBlindMode];

            
        }
        
        if (!blindModeButton) {
            blindModeButton = [SKSpriteNode spriteNodeWithImageNamed:@"BlindModeBtn.png"];
            int btnBlindTop = 210;
            if (isIPhone4) btnBlindTop = 180;
            
            btnBlindTop = (screenCenterY*2) - 40;
            
            blindModeButton.position = CGPointMake(screenCenterX, btnBlindTop);
            blindModeButton.name = @"blindModeButton";
            [self addChild:blindModeButton];
        }
        
        blindModeButton.hidden = NO;
    
    }
    
    
}


-(void) startGame:(BOOL) revived {
    
    [waitingForTouchView removeFromParent];
    waitingForTouchView = nil;
    addTimerPoints = NO;
    shouldPauseWalls = NO;

    
    [self checkRate];
    [self hideAds];
    
    if (revived) {
        scoreCountLabel.text = [NSString stringWithFormat:@"%d", scoreCount];
        
        finalScoreLabel.text = @"";
        highScoreLabel.text = @"";
       // self.paused = NO;
    }
    else {
        scoreCount = 0;
        scoreCountLabel.text = @"";
        
        finalScoreLabel.text = @"";
        highScoreLabel.text = @"";
        
        effectWallsCreated = 0;
        if (currentEffectName) {
            [[self childNodeWithName:currentEffectName] removeFromParent];

        }
        wallsSpeed = 7.0;

    }
    
    [playerSprite runAction:[SKAction moveTo:CGPointMake(screenCenterX-50, screenCenterY) duration:0.1]];
    playerSprite.hidden = NO;

    
    finalScoreSprite.hidden = YES;
    highScoreSprite.hidden = YES;

    
    flyAnim = [[NSMutableArray alloc] init];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird0.png"]];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird1.png"]];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird2.png"]];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird3.png"]];
    
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird4.png"]];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird5.png"]];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird6.png"]];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird7.png"]];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird8.png"]];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird9.png"]];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird10.png"]];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird11.png"]];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird12.png"]];
    [flyAnim addObject:[SKTexture textureWithImageNamed:@"Bird13.png"]];

    
    SKAction *flyAnimation = [SKAction animateWithTextures:flyAnim timePerFrame:0.03f];
    SKAction *alwaysFly = [SKAction repeatActionForever:[SKAction sequence:@[flyAnimation, [flyAnimation reversedAction]]]];
    [playerSprite runAction:alwaysFly];
    
    tapTheScreen = YES;
    
    SKAction *changeTitle = [SKAction setTexture:[SKTexture textureWithImageNamed:@"TapTheScreen.png"]];
    [topItemImage setAlpha:0.0];
    topItemImage.hidden = NO;
    [topItemImage runAction:[SKAction sequence:@[changeTitle, [SKAction fadeInWithDuration:3.0]]]];
    
    if (!blindModeOn && !revived) {
        [self showBlindModeButton];
    }
    else if (blindModeOn && !revived) {
        blindModeOn = NO;
        [self removeParticles];
        [self showBlindModeButton];
    }
    
    tapScreenSprite = [SKSpriteNode spriteNodeWithImageNamed:@"TAPS.png"];
    tapScreenSprite.position = CGPointMake(screenCenterX, screenCenterY-95);
    [self addChild:tapScreenSprite];
    
    
    
    
}



-(void) buildGame {
    [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
        NSLog(@"%@", leaderboardIdentifier);
    }];
    

    infoSaved = [NSUserDefaults standardUserDefaults];
    
    [gameOverSprite removeFromParent];
    gameOverSprite = nil;
    
    tapTheScreen = NO;
    gameRunning = NO;
    
    gameTools = [[GameTools alloc] init];
    currentPlayerCHImageFile = @"Bird0.png";
    
    screenCenterX = [gameTools currentScreenSize].width / 2;
    screenCenterY = [gameTools currentScreenSize].height / 2;

    bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"BGiMAGE.png"];
    bgNode.position = CGPointMake(screenCenterX, screenCenterY+2);
    [self addChild:bgNode];
    
    lineBar1 = [SKSpriteNode spriteNodeWithImageNamed:@"LineBar.png"];
    lineBar1.position = CGPointMake(0, 100);
    lineBar1.anchorPoint = CGPointZero;
    lineBar1.zPosition = 2;
    [self addChild:lineBar1];
    
    lineBar2 = [SKSpriteNode spriteNodeWithImageNamed:@"LineBar.png"];
    lineBar2.position = CGPointMake(lineBar1.size.width, 0);
    lineBar2.anchorPoint = CGPointZero;
    lineBar2.zPosition = 2;
    [self addChild:lineBar2];
    
    
    groundSprite = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:170/255.0f green:15/255.0f blue:15/255.0f alpha:255/255.0f] size:CGSizeMake(320, 100)];
    groundSprite.position = CGPointMake(screenCenterX, groundSprite.size.height / 2);
    groundSprite.zPosition = 2;
    groundSprite.physicsBody.categoryBitMask = groundObj;
    groundSprite.physicsBody.collisionBitMask = birdObj;
    groundSprite.physicsBody.contactTestBitMask = birdObj;
    groundSprite.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:groundSprite];
    
    
    CGRect groundBoxRect = CGRectMake(0, 100, 320, [gameTools currentScreenSize].height - 120);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:groundBoxRect];
    playerSprite = [SKSpriteNode spriteNodeWithImageNamed:currentPlayerCHImageFile];
    
    CGSize playerSize = playerSprite.size;
    playerSize.width -= 15;
    playerSize.height -= 15;
    playerSprite.size = playerSize;
    
    playerSprite.position = CGPointMake(screenCenterX-50, screenCenterY);
    playerSprite.name = @"player";
    playerSprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(playerSprite.size.width/2)-14];
    playerSprite.physicsBody.mass = 0.5;
    playerSprite.physicsBody.usesPreciseCollisionDetection = YES;
    playerSprite.hidden = YES;
    playerSprite.zPosition = 10;
    playerSprite.physicsBody.allowsRotation = NO;
    playerSprite.physicsBody.categoryBitMask = birdObj;
    playerSprite.physicsBody.collisionBitMask = birdObj | wallObj;
    playerSprite.physicsBody.contactTestBitMask = birdObj | wallObj;
    playerSprite.physicsBody.velocity = CGVectorMake(0, 0);
    
    [playerSprite runAction:[SKAction moveTo:CGPointMake(screenCenterX-50, screenCenterY) duration:0.1]];

    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    int addTop = 100;
    if (isIPhone4) addTop = 90;
    
    scoreCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreCountLabel.position = CGPointMake(screenCenterX, screenCenterY+180);
    scoreCountLabel.fontSize = 50;
    scoreCountLabel.fontColor = [UIColor blackColor];
    //scoreCountLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;

    scoreCountLabel.zPosition = 13;
    scoreCountLabel.text = @"";
    [self addChild:scoreCountLabel];
    
    topItemImage = [SKSpriteNode spriteNodeWithImageNamed:@"TopLogo.png"];
    topItemImage.position = CGPointMake(screenCenterX, [gameTools currentScreenSize].height - addTop);
    [self addChild:topItemImage];

    SKAction *scaleUpDown =  [SKAction sequence:@[[SKAction resizeByWidth:20.0 height:5.0 duration:0.7], [SKAction resizeByWidth:-20.0 height:-5.0 duration:0.7]]];
    [topItemImage runAction:[SKAction repeatActionForever:scaleUpDown]];
    
    
    [self addChild:playerSprite];
    [self buildWaitingForTouchView];
    
}


-(void) startGameCenter {
            
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor redColor];
        isFirstInit = YES;
        blindStartAnimationOn = NO;
        
        tapSound = [SKAction playSoundFileNamed:@"birdTap.mp3" waitForCompletion:NO];
        hitSound = [SKAction playSoundFileNamed:@"birdHit.mp3" waitForCompletion:NO];
        btnSound = [SKAction playSoundFileNamed:@"btnTap.mp3" waitForCompletion:NO];
        cashSound = [SKAction playSoundFileNamed:@"touchMoney.wav" waitForCompletion:NO];
        wallSound = [SKAction playSoundFileNamed:@"BallPop.wav" waitForCompletion:NO];
        speedSound = [SKAction playSoundFileNamed:@"Speeed.wav" waitForCompletion:NO];

        isIPhone4 = YES;
        if (size.height > 480) {
            isIPhone4 = NO;
        }
        
        purchaseManager = [[PManager alloc] init];
        purchaseManager.delegate = self;
        
        facebookBuyType = @"FBOut";
            
        [self buildGame];
        [self startGameCenter];
        [self showAds];
    }
    return self;
}

-(void) didMoveToView:(SKView *)view {
    [self startFacebook];
}


-(void) fbTapped {
    for(id object in loginView.subviews){
        if([[object class] isSubclassOfClass:[UIButton class]]){
            UIButton* button = (UIButton*)object;
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void) startFacebook {
    if (!loginView) {
        loginView = [[FBLoginView alloc] init];
        loginView.frame = self.view.bounds;
        loginView.readPermissions = @[@"basic_info", @"email", @"user_likes"];
        loginView.delegate = self;
        
        for (id obj in loginView.subviews)
        {
            if ([obj isKindOfClass:[UIButton class]])
            {
                UIButton * loginButton =  obj;
                UIImage *loginImage = [UIImage imageNamed:@"FacebookBtn.png"];
                [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
                [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
                [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
                [loginButton sizeToFit];
            }
            if ([obj isKindOfClass:[UILabel class]])
            {
                UILabel *loginLabel =  obj;
                [loginLabel removeFromSuperview];
            }
        }
        
        
        loginView.frame = CGRectMake(-500,500,0,0);
        
    }
    
    [self.view addSubview:loginView];
    [loginView sizeToFit];
    
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
                                 //self.profilePic.profileID = user.id;
                                 NSLog(@"Welcome, %@", user.first_name);
                                 
}


- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    SKAction *foAction = [SKAction fadeOutWithDuration:0.2];
    [faceLoginBtn runAction:foAction];
    faceLoginBtn.size = CGSizeMake(40, 40);
    
    SKAction *changeTitle = [SKAction setTexture:[SKTexture textureWithImageNamed:@"FacebookLogoutBtn.png"]];
    
    SKAction *moAction = [SKAction moveTo:CGPointMake(-120, 60) duration:0.1];
    SKAction *fiAction = [SKAction fadeInWithDuration:0.2];

    [faceLoginBtn runAction:[SKAction sequence:@[changeTitle,[SKAction waitForDuration:0.2],moAction,fiAction]]];
    fbLoggedIn = YES;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    
    SKAction *foAction = [SKAction fadeOutWithDuration:0.2];
    [faceLoginBtn runAction:foAction];
    faceLoginBtn.size = CGSizeMake(65, 65);
    
    int btnTop = -90;
    if (isIPhone4) btnTop = -55;
    
    SKAction *changeTitle = [SKAction setTexture:[SKTexture textureWithImageNamed:@"FacebookBtn.png"]];
    SKAction *moAction = [SKAction moveTo:CGPointMake(95, btnTop) duration:0.1];
    SKAction *fiAction = [SKAction fadeInWithDuration:0.2];
    
    [faceLoginBtn runAction:[SKAction sequence:@[changeTitle,moAction,fiAction]]];
    fbLoggedIn = NO;
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];

        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}



-(void) startFacebookPost {
    //NSString *storeLink = @"https://itunes.apple.com/us/app/jailbirds/id826116883?ls=1&mt=8";
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    
    params.link = [NSURL URLWithString:@"http://www.facebook.com/pages/Jailbird/603451879747521"];
    params.name = @"Jailbird For iPhone";
    params.caption = @"Jailbird iPhone Game";
    params.picture = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/53948100/ShareIcon.png"];
    params.description = [NSString stringWithFormat:@"Free now on the AppStore!"];
    
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {

                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                              NSString *postResaults = [results objectForKey:@"completionGesture"];
                                              if ([postResaults isEqualToString:@"post"]) {
                                                  // sent the post
                                                  //In Game Store
                                                  if ([facebookBuyType isEqualToString:@"FBIn"]) {
                                                      [self inGameBuyRevive:@"FBIn"];
                                                  }
                                                  else {
                                                  // Main Store
                                                      //[self inGameBuyRevive:@"FBOut"];
                                                  }
                                              }
                                              else {
                                                  // cancel
                                              }
                                              
        
                                          }
                                      }];
    } else {
        // Present the feed dialog
        
        
        UIImage* image = [UIImage imageNamed:@"FBImage.png"];
        NSArray* dataToShare = @[@"Jailbird For iPhone",image, @"Like us on Facebook\n http://www.facebook.com/pages/Jailbird/603451879747521", @"Now free on the App Store\n https://itunes.apple.com/us/app/jailbirds/id826116883?ls=1&mt=8"];
        UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
        UIViewController *vc = self.view.window.rootViewController;
        [vc presentViewController: activityViewController animated: YES completion:nil];
        
        [activityViewController setCompletionHandler:^(NSString *activityType, BOOL done)
         {

             if (done)
             {
                 if ([facebookBuyType isEqualToString:@"FBIn"]) {
                     [self inGameBuyRevive:@"FBIn"];
                 }
             }
             else
             {
             }
         }];
             
    }
}


-(void) showBoards {
    if ([GKLocalPlayer localPlayer].authenticated == NO) {

        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"You must enable Game Center!"
                                                          message:@"Sign in through the Game Center app to enable all features"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"authenticateLU" object:nil];

    } else {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            gameCenterController.leaderboardIdentifier = @"com.cocoecco.Jailbird.lb1";
            gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
            UIViewController *vc = self.view.window.rootViewController;
            [vc presentViewController: gameCenterController animated: YES completion:nil];
        }
    }

}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)gameCenterViewController {
    
    UIViewController *vc = self.view.window.rootViewController;
    [vc dismissViewControllerAnimated:YES completion:nil];    
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (gameRunning) {
        playerSprite.physicsBody.velocity = self.physicsBody.velocity;
        [playerSprite.physicsBody applyImpulse:CGVectorMake(0, 150)];
        [self runAction:tapSound];
    }
    else {
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            SKNode *node = [self nodeAtPoint:location];
            
            if ([node.name isEqualToString:@"introCover"]) return;
            
            
            if ([node.name isEqualToString:@"blindModeButton"]) {
                [self runAction:btnSound];
                [self startBlindMode];
                return;
            }
            if ([node.name isEqualToString:@"highScoreCounterBox"]) {
                [self runAction:btnSound];
                [self fadeHighScoreCounter];
                return;
            }
            
            
            
            
            if (tapTheScreen) {
                [self startNow];
                tapTheScreen = NO;
                return;
            }
            
            if ([node.name isEqualToString:@"playButton"]) {
                [self runAction:btnSound];
                [self startGame:NO];
            }
            else if ([node.name isEqualToString:@"buildWaiting"]) {
                [self runAction:btnSound];
                [self buildWaitingForTouchView];
            }
            else if ([node.name isEqualToString:@"facebook"]) {
                [self runAction:btnSound];
                [self startFacebookPost];
            }
            else if ([node.name isEqualToString:@"leaderboards"]) {
                [self runAction:btnSound];
                [self showBoards];
            }
            else if ([node.name isEqualToString:@"facebookConnect"]) {
                [self runAction:btnSound];
                [self fbTapped];
            }
            else if ([node.name isEqualToString:@"store"]) {
                [self runAction:btnSound];
                [self openMainGameStore];
            }
            else if ([node.name isEqualToString:@"closeStore"]) {
                [self runAction:btnSound];
                [self storeCloseStore];
            }
            else if ([node.name isEqualToString:@"buyRevive"]) {
                [self runAction:btnSound];
                [self openStoreWaitingView];
                [self storeBuyThreeRevives];
            }
            else if ([node.name isEqualToString:@"buyRemoveAds"]) {
                [self runAction:btnSound];
                [self openStoreWaitingView];
                [self storeBuyRemoveAds];
            }
            
            else if ([node.name isEqualToString:@"closeInStore"]) {
                [self runAction:btnSound];
                [self storeInCloseStore];
            }
            else if ([node.name isEqualToString:@"buyInRevive"]) {
                [self runAction:btnSound];
                [self openStoreWaitingView];
                [self storeBuyRevive];
            }
            else if ([node.name isEqualToString:@"buyUsingFacebook"]) {
                [self runAction:btnSound];
                [self buyUsingFacebook];
            }
            else if ([node.name isEqualToString:@"useRevive"]) {
                [self runAction:btnSound];
                [self useReviveNow];
            }
            else if ([node.name isEqualToString:@"reviveByVideo"]) {
                [self runAction:btnSound];
                [self reviveByVideo];
            }
            else if ([node.name isEqualToString:@"FBOff"]) {
                [self runAction:btnSound];
                [self facebookOFFTimerView];
            }
            else if ([node.name isEqualToString:@"restorePurchases"]) {
                [self runAction:btnSound];
                [self restorePurchases];
            }
            else if ([node.name isEqualToString:@"facebookHighScore"]) {
                [self runAction:btnSound];
                [self showFacebookHighScore];
            }
            
            
            
            
            
        }

    }
}






-(void)update:(CFTimeInterval)currentTime {
    lineBar1.position = CGPointMake(lineBar1.position.x-4, 100);
    lineBar2.position = CGPointMake(lineBar2.position.x-4, 100);
    
    if (lineBar1.position.x < -lineBar1.size.width){
        lineBar1.position = CGPointMake(lineBar2.position.x + lineBar2.size.width, lineBar1.position.y);
    }
    
    if (lineBar2.position.x < -lineBar2.size.width) {
        lineBar2.position = CGPointMake(lineBar1.position.x + lineBar1.size.width, lineBar2.position.y);
    }
    
    for (SKNode *wallNode in self.children) {
        if ([wallNode.name isEqualToString:@"wall"]) {
            CGFloat nodeX = wallNode.position.x;
            
            if (nodeX < 110) {
                scoreCount++;
                scoreCountLabel.text = [NSString stringWithFormat:@"%d", scoreCount];
                wallNode.name = @"passedWall";
                [self runAction:wallSound];
            }
            
            if (blindModeOn) {
                
                
                if (!blindStartAnimationOn) {
                    if (nodeX < 240) {
                        blindStartAnimationOn = YES;
                        
                        SKAction *fadeDown = [SKAction fadeAlphaTo:0.0 duration:0.05];
                        SKAction *fadeUp = [SKAction fadeAlphaTo:1.0 duration:0.05];
                        
                        SKAction *fadingBird = [SKAction sequence:@[fadeDown,[SKAction waitForDuration:1.0], fadeUp]];
                        [playerSprite runAction:[SKAction repeatAction:fadingBird count:1]];
                        [self performSelector:@selector(blindAnimationEnded) withObject:nil afterDelay:1.1];
                    }
            }
            
            }
            
        }
        
        
        if (playerSmokeNode) {
            playerSmokeNode.position = CGPointMake(playerSprite.position.x-25, playerSprite.position.y);
        }
        
        if (showingSpeedIntro) {
            //playerSprite.position = CGPointMake(playerSprite.position.x, screenCenterY+100);

        }
        else {


        }
        
        
    }
    
    
}


@end















