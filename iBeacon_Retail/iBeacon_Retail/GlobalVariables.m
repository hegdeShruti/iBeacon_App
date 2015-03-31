//
//  GlobalVariables.m
//  iBeacon_Retail
//
//  Created by shruthi on 12/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "GlobalVariables.h"
#import "OfferPopupMenu.h"
#import "CartItem.h"

@implementation GlobalVariables
@synthesize hasUserEnteredTheStore , hasUserGotWOmenSectionOffers, hasUserGotKidSectionOffers,hasUserGotMenSectionOffers,isUserOnTheMapScreen;

static GlobalVariables *instance = nil;

+(GlobalVariables *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [GlobalVariables new];
            instance.hasUserGotMenSectionOffers=NO;
            instance.hasUserEnteredTheStore=NO;
            instance.hasUserGotKidSectionOffers=NO;
            instance.hasUserGotWOmenSectionOffers=NO;
            instance.hasUsercrossedEntrance=NO;
            instance.hasUserEntredEntryBeacon=NO;
            instance.productDataArray=nil;
            instance.offersDataArray=nil;
            instance.isUserOnTheMapScreen = NO;
           // instance.hasALreadyLoggedIn=NO;
        }
    }
    return instance;
}

- (void)showOfferPopUpWithTitle:(NSString *)inTitle andMessage:(NSString *)inMessage {
    OfferPopupMenu *popup = [[OfferPopupMenu alloc]initWithTitle:inTitle message:inMessage];
    popup.menuStyle = MenuStyleOval;
    [popup showMenuInParentViewController:self.storeLocationController withCenter:self.storeLocationController.indoorLocationView.center];
}
- (void)showOfferPopUp:(NSString *)inTitle andMessage:(NSString *)inMessage onController:(id) controller centrvalue:(CGPoint) refValue{
    OfferPopupMenu *popup = [[OfferPopupMenu alloc]initWithTitle:inTitle message:inMessage];
    popup.menuStyle = MenuStyleOval;
    [popup showMenuInParentViewController:controller withCenter:refValue];

}

+(NSString *)returnTitleForRegion:(RegionIdentifier)inRegion{
    NSString *regionTitle = @"";
    switch (inRegion) {
        case WOMENSECTIONBEACON:
            regionTitle = @"Women's Section";
            break;
        case MENSECTIONBEACON:
            regionTitle = @"Men's Section";
            break;
        case KIDSECTIONBEACON:
            regionTitle = @"Kid's Section";
            break;
        default:
            break;
    }
    return regionTitle;
}

+(void)addItemToCart: (CartItem*) cartItem
{
    NSMutableArray* cartItems = (NSMutableArray*)[self getCartItems];
    if([cartItems count] != 0){
        BOOL itemExists = NO;
        for(CartItem* item in cartItems)
        {
            if([item.product.prodName isEqualToString:cartItem.product.prodName]){
                UIAlertView* alreadyExistsAlert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Item already in cart" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alreadyExistsAlert show];
                itemExists = YES;
                break;
            }
        }
        if(!itemExists){
            NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:[cartItems arrayByAddingObjectsFromArray:[NSArray arrayWithObject:cartItem]]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:archivedObject forKey:@"CartItems"];
            [defaults synchronize];
        }
    }else{
        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:[cartItems arrayByAddingObjectsFromArray:[NSArray arrayWithObject:cartItem]]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:archivedObject forKey:@"CartItems"];
        [defaults synchronize];
    }
    
    
    
}

+(void)removeItemFromCart: (CartItem*) cartItem
{
    
}

+(NSMutableArray*)getCartItems
{
    NSMutableArray *obj;
    // Read from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *archivedObject = [defaults objectForKey:@"CartItems"];
    if(archivedObject == nil){
        obj = [[NSMutableArray alloc] init];
    }else{
        obj = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:archivedObject];
    }
    return obj;
}

@end
