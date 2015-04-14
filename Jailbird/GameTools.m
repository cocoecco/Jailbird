//
//  GameTools.m
//  Jailbird
//
//  Created by Shachar Udi on 2/20/14.
//  Copyright (c) 2014 Shachar Udi. All rights reserved.
//

#import "GameTools.h"

@implementation GameTools


-(CGSize) currentScreenSize {
    return [[UIScreen mainScreen] bounds].size;
}

-(int) YpointForMainStore {
    int yPoint = 0;
    if ([self currentScreenSize].height > 480) yPoint = [self currentScreenSize].height / 2 - 40;
    if ([self currentScreenSize].height < 481) yPoint = [self currentScreenSize].height / 2 - 25;

    
    return yPoint;
}




@end
