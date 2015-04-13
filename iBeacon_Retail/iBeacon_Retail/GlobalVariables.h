//
//  GlobalVariables.h
//  iBeacon_Retail
//
//  Created by shruthi on 12/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreLocationMapViewController.h"
#import "CartViewController.h"
#import "Constants.h"
#import "ESTLocationBuilder.h"
@class CartItem;

typedef enum {
    
    ENTRYBEACON=1,
    MENSECTIONBEACON=135679,
    WOMENSECTIONBEACON=123679,
    KIDSECTIONBEACON=126679,
    MAINENTRANCEBEACON

    
} RegionIdentifier;
typedef enum {
    
    ENTRANCE=0,
    MENSECTION=2,
    WOMENSECTION=1,
    KIDSECTION=4
} SectionIdentifier;

@interface GlobalVariables : NSObject

@property(nonatomic,assign) BOOL hasUserEnteredTheStore;
@property(nonatomic,assign) BOOL hasUserGotWOmenSectionOffers;
@property(nonatomic,assign) BOOL hasUserGotMenSectionOffers;
@property(nonatomic,assign) BOOL hasUserGotKidSectionOffers;
@property(nonatomic,assign) BOOL hasUsercrossedEntrance;
@property(nonatomic,assign) BOOL hasUserEntredEntryBeacon;
@property(nonatomic,assign) BOOL isUserOnTheMapScreen;
@property(nonatomic,strong) NSMutableArray *offersDataArray;
@property(nonatomic,strong) NSMutableArray *productDataArray;
@property(nonatomic,strong) NSMutableArray *cartDataArray;
@property(nonatomic,strong)StoreLocationMapViewController *storeLocationController;
//@property(nonatomic,assign) BOOL hasALreadyLoggedIn;

+( GlobalVariables *) getInstance;
- (void)showOfferPopUpWithTitle:(NSString *)inTitle andMessage:(NSString *)inMessage  ;
- (void)showOfferPopUp:(NSString *)inTitle andMessage:(NSString *)inMessage onController:(id) controller withImage:(UIImage *)image ;
- (void)showOfferPopUpWithTitle:(NSString *)inTitle message:(NSString *)inMessage andDelegate:(id)delegate;
+(NSString *)returnTitleForRegion:(RegionIdentifier)inRegion;
+(NSString*)getBeaconMacAddress:(int)sectionId;
+(int)getSectionId:(NSString *)macAddress;
+(StoreLocationMapViewController*)getStoreMap;
+(NSString *)returnTitleForSection:(SectionIdentifier)sectionId;
-(void) getOffers;

+(void)addItemToCart: (CartItem*) cartItem;
+(void)removeItemFromCart: (CartItem*) cartItem;
+(NSMutableArray*)getCartItems;
-(void)loadCartScreen;

@end
