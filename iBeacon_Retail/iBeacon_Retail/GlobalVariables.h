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
#import "Offers.h"
@class CartItem;
@class MenuViewController;

typedef enum {
    
    ENTRYBEACON=1,
    MENSECTIONBEACON=135679,
    WOMENSECTIONBEACON=123679,
    KIDSECTIONBEACON=126679,
    MAINENTRANCEBEACON

    
} RegionIdentifier;
typedef enum {
    
    ENTRANCE=0,
    MENSECTION=1,
    WOMENSECTION=2,
    KIDSECTION=3
} SectionIdentifier;

@interface GlobalVariables : NSObject

@property(nonatomic,assign) BOOL hasUserEnteredTheStore;
@property(nonatomic,assign) BOOL hasUserGotWOmenSectionOffers;
@property(nonatomic,assign) BOOL hasUserGotMenSectionOffers;
@property(nonatomic,assign) BOOL hasUserGotKidSectionOffers;
@property(nonatomic,assign) BOOL hasUserExited;
@property(nonatomic,assign) BOOL hasUserEntredEntryBeacon;
@property(nonatomic,assign) BOOL isUserOnTheMapScreen;
@property(nonatomic,strong) NSMutableArray *offersDataArray;
@property(nonatomic,strong) NSMutableArray *productDataArray;
@property(nonatomic,strong) NSMutableArray *cartDataArray;
@property(nonatomic,strong) NSMutableArray *productImagesArray;
@property(nonatomic,strong) NSMutableArray *sectionBeaconArray;
@property(nonatomic,strong)StoreLocationMapViewController *storeLocationController;





//@property(nonatomic,assign) BOOL hasALreadyLoggedIn;

+( GlobalVariables *) getInstance;
- (void)showOfferPopUpWithTitle:(NSString *)inTitle andMessage:(NSString *)inMessage  ;
- (void)showOfferPopUp:(Products *)prodInfo andMessage:(NSString *)inMessage onController:(id) controller withImage:(UIImage *)image ;
- (void)showOfferPopUpWithTitle:(NSString *)inTitle message:(NSString *)inMessage andDelegate:(id)delegate;
+(NSString *)returnTitleForRegion:(RegionIdentifier)inRegion;
+(NSString*)getBeaconMacAddress:(int)sectionId;
+(int)getSectionId:(NSString *)macAddress;
+(StoreLocationMapViewController*)getStoreMap;
+(MenuViewController*)getLeftMenu;
+(void)clearLeftMenu;
+(NSString *)returnTitleForSection:(SectionIdentifier)sectionId;
-(void) getOffers;

+(void)addItemToCart: (CartItem*) cartItem;
+(void)removeItemFromCart: (CartItem*) cartItem;
+(void) getAllProductsFromServer;
+(NSMutableArray*)getCartItems;
-(void)loadCartScreen;
+(void)loadStoreMapScreen:(Products *)product fromMenu: (BOOL) loadFromMenu;

+(Products *)getProductWithID:(NSInteger) offerId;
+(Offers *)getOfferWithID:(NSInteger) offerId;
+(void)clearCartItems;
+(void)updateCartItemsWithNewData:(NSArray*)newData;
@end
