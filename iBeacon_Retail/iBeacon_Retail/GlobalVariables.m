//
//  GlobalVariables.m
//  iBeacon_Retail
//
//  Created by shruthi on 12/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "GlobalVariables.h"
#import "OfferPopupMenu.h"
#import "NetworkOperations.h"
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

- (void)showOfferPopUpWithTitle:(NSString *)inTitle andMessage:(NSString *)inMessage{
    [self showOfferPopUpWithTitle:inTitle message:inTitle andDelegate:nil];
   }
- (void)showOfferPopUpWithTitle:(NSString *)inTitle message:(NSString *)inMessage andDelegate:(id)delegate{
    OfferPopupMenu *popup = [[OfferPopupMenu alloc]initWithTitle:inTitle message:inMessage];
    popup.menuStyle = MenuStyleOval;
    popup.delegate=delegate;
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
+(NSString*)getBeaconMacAddress:(int)sectionId{
    NSString *mac = @"";
    switch (sectionId) {
        case 1:
            mac = KIDSSECTION_MAC;
            break;
        case 2:
            mac = MENSECTION_MAC;
            break;
        case 3:
            mac = WOMENSECTION_MAC;
            break;
        default:
            break;
    }
    return mac;
}
+(int)getSectionId:(NSString *)macAddress{
    int secId=0;
    if([macAddress isEqualToString:KIDSSECTION_MAC])
        secId=4;
    if([macAddress isEqualToString:MENSECTION_MAC])
        secId=2;
    if([macAddress isEqualToString:WOMENSECTION_MAC])
        secId=1;
    return secId;
}
+(NSString *)returnTitleForSection:(SectionIdentifier)sectionId{
    NSString *sectionTitle = @"";
    switch (sectionId) {
        case WOMENSECTION:
            sectionTitle = @"Women's Section";
            break;
        case MENSECTION:
            sectionTitle = @"Men's Section";
            break;
        case KIDSECTION:
            sectionTitle = @"Kid's Section";
            break;
        default:
            sectionTitle = @"SALE! SALE! SALE!";
            break;
    }
    return sectionTitle;
}
-(void) getOffers{
    NetworkOperations *networks=[[NetworkOperations alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"The product Api is %@",[dict objectForKey:@"Offers_Api"]);
    // send block as parameter to get callbacks
    [networks fetchDataFromServer:[dict objectForKey:@"Offers_Api"] withreturnMethod:^(NSMutableArray* data){
        instance.offersDataArray=data;
        NSLog(@"The product Api is %lu",(unsigned long)[instance.offersDataArray count]);
    }];
}

+(void)addItemToCart: (CartItem*) cartItem{
    NSMutableArray* cartItems = (NSMutableArray*)[self getCartItems];
    if([cartItems count] != 0){
        BOOL itemExists = NO;
        for(CartItem* item in cartItems)
        {
            if([item.product.prodName isEqualToString:cartItem.product.prodName]){
                UIAlertView* alreadyExistsAlert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Item already in cart" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [alreadyExistsAlert show];    
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

+(void)removeItemFromCart: (CartItem*) cartItem{
    
}

+(NSMutableArray*)getCartItems{
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
