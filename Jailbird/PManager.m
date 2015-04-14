//
//  PManager.m
//  Israelogo3
//
//  Created by Shachar Udi on 12/31/13.
//  Copyright (c) 2013 Shachar Udi. All rights reserved.
//

#import "PManager.h"

@implementation PManager

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

#pragma mark PManager Delegate

-(void) returnChangedInfo:(NSString*) changeInfoString {
if ([self.delegate respondsToSelector:@selector(purchaseChangesMade:)]) {
    [self.delegate purchaseChangesMade:changeInfoString];
    }
}



- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"%@",error);
}

// Call This Function
- (void) checkPurchasedItems
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    //NSLog(@"received restored transactions: %i", queue.transactions.count);
    /*
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
//        NSString *productIdentifier = transaction.payment.productIdentifier;
//        
//        if ([productIdentifier isEqualToString:@"com.cocoecco.Jailbird.3xrevive"]) {
//            [self returnChangedInfo:@"unlockedThreeRevives"];
//        }
//        if ([productIdentifier isEqualToString:@"com.cocoecco.Jailbird.revivenow"]) {
//            [self returnChangedInfo:@"unlockedReviveNow"];
//        }
//        if ([productIdentifier isEqualToString:@"com.cocoecco.Jailbird.noadsnow"]) {
//            [self returnChangedInfo:@"unlockedNoAds"];
//        }
    }
     */
}


-(void) restorePurchases {
    [self checkPurchasedItems];
}



-(void) buyReviveNow {
    SKProduct *reviveNowObj = [productsDB objectForKey:@"Pkg2"];
    if (reviveNowObj) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        _purchasedProductIdentifiers = [NSMutableSet set];
        
        SKPayment * payment = [SKPayment paymentWithProduct:reviveNowObj];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else {
        [self returnChangedInfo:@"error"];
    }
}


-(void) buyThreeRevives {
    SKProduct *threeRevives = [productsDB objectForKey:@"Pkg1"];
    if (threeRevives) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        _purchasedProductIdentifiers = [NSMutableSet set];
        
        SKPayment * payment = [SKPayment paymentWithProduct:threeRevives];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else {
        [self returnChangedInfo:@"error"];
    }
}

-(void) buyNoAds {
    SKProduct *noAds = [productsDB objectForKey:@"Pkg3"];
    if (noAds) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        _purchasedProductIdentifiers = [NSMutableSet set];
        
        SKPayment * payment = [SKPayment paymentWithProduct:noAds];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else {
        [self returnChangedInfo:@"error"];
    }

}


#pragma mark Public Class Methods


- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
    if ([productIdentifier isEqualToString:@"com.cocoecco.Jailbird.3xrevive"]) {
        [self returnChangedInfo:@"unlockedThreeRevives"];
    }
    if ([productIdentifier isEqualToString:@"com.cocoecco.Jailbird.revivenow"]) {
        [self returnChangedInfo:@"unlockedReviveNow"];
    }
    if ([productIdentifier isEqualToString:@"com.cocoecco.Jailbird.noadsnow"]) {
        [self returnChangedInfo:@"unlockedNoAds"];
    }

    
    NSLog(@"%@", productIdentifier);

    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
       // NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
       // NSLog(@"Transaction error: %d", transaction.error.code);

    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [self returnChangedInfo:@"Error"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeStoreWaitingView" object:nil];

}



- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}


-(void) getProducts {
    productsDB = [[NSMutableDictionary alloc] init];

    if ([SKPaymentQueue canMakePayments]) {
        NSSet *productIdentifiers = [NSSet setWithObjects:
                                     @"com.cocoecco.Jailbird.3xrevive",
                                     @"com.cocoecco.Jailbird.revivenow",
                                     @"com.cocoecco.Jailbird.noadsnow",
                                     nil];
        
        productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
        
        productsRequest.delegate = self;
        [productsRequest start];
    }
    else {
        UIAlertView *cantMakePayments = [[UIAlertView alloc] initWithTitle:@"Jailbird" message:@"Purchases can't be made using this Apple ID" delegate:nil cancelButtonTitle:@"אישור" otherButtonTitles:nil, nil];
        [cantMakePayments show];
    }
    
    
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    productsRequest = nil;
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSString *productID = skProduct.productIdentifier;
        if ([productID isEqualToString:@"com.cocoecco.Jailbird.3xrevive"]) [productsDB setObject:skProduct forKey:@"Pkg1"];
        if ([productID isEqualToString:@"com.cocoecco.Jailbird.revivenow"]) [productsDB setObject:skProduct forKey:@"Pkg2"];
        if ([productID isEqualToString:@"com.cocoecco.Jailbird.noadsnow"]) [productsDB setObject:skProduct forKey:@"Pkg3"];

        
        
        NSLog(@"%@", productsDB);
        
    }
}


- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    NSLog(@"Error - %@", error.description);
    productsRequest = nil;
}



-(id) init {
    if (self == [super init]) {
        [self getProducts];
    }
    return self;
}



@end






