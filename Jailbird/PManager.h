//
//  PManager.h
//  Israelogo3
//
//  Created by Shachar Udi on 12/31/13.
//  Copyright (c) 2013 Shachar Udi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

@protocol PManagerDelegate <NSObject>

-(void) purchaseChangesMade:(NSString*) changeInfo;

@end


@interface PManager : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
    NSMutableSet * _purchasedProductIdentifiers;
    
    SKProductsRequest * productsRequest;
    NSMutableDictionary *productsDB;
}


-(void) returnChangedInfo:(NSString*) changeInfoString;

-(void) buyReviveNow;
-(void) buyThreeRevives;
-(void) buyNoAds;
-(void) restorePurchases;



@property (nonatomic, weak) id<PManagerDelegate> delegate;

@end
