//
//  GlobalVariables.m
//  iBeacon_Retail
//
//  Created by shruthi on 12/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "GlobalVariables.h"
#import "NetworkOperations.h"
#import "CartItem.h"
#import "OfferPopupViewController.h"
#import "MenuViewController.h"

@interface GlobalVariables()
    @property (nonatomic,strong)  MenuViewController * leftMenu;
@end


@implementation GlobalVariables

@synthesize hasUserEnteredTheStore , hasUserGotWOmenSectionOffers, hasUserGotKidSectionOffers,hasUserGotMenSectionOffers,isUserOnTheMapScreen,offersDataArray,productDataArray;
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
            instance.productImagesArray=nil;
           instance.productImagesArray=[[NSMutableArray alloc ]initWithObjects:@"jacket.png",@"perfume.png",@"gown.png",@"watch.png",@"dryer.png",@"shoes.png",@"jacket.png",nil];
           // instance.hasALreadyLoggedIn=NO;
        }
    }
    return instance;
}

//- (void)showOfferPopUpWithTitle:(NSString *)inTitle andMessage:(NSString *)inMessage{
//    [self showOfferPopUpWithTitle:inTitle message:inTitle andDelegate:nil];
//   }
//- (void)showOfferPopUpWithTitle:(NSString *)inTitle message:(NSString *)inMessage andDelegate:(id)delegate{
//}

// method that presents popup on existing screen on any beacon notification
- (void)showOfferPopUp:(Products *)prodInfo  andMessage:(NSString *)inMessage onController:(id) controller withImage:(UIImage *)sourceImage {
  
    OfferPopupViewController *offerPopup=[[OfferPopupViewController alloc] initWithNibName:@"OfferPopupViewController" bundle:[NSBundle mainBundle]];
    offerPopup.productObject=prodInfo;
   
    [controller presentViewController:offerPopup animated:YES completion:^{
        // Adding blur effect on the snapshot taken
        offerPopup.backgroundImage.image=sourceImage;
       offerPopup.offerHeader.text=inMessage;
         offerPopup.productName.text=prodInfo.prodName;
        offerPopup.offerDescription.text=prodInfo.prodDescription;
        if(prodInfo.prodImage){
        offerPopup.productImage.image=[UIImage imageNamed:prodInfo.prodImage];
        }
        UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = offerPopup.backgroundImage.bounds;
        effectView.alpha=0.95;
        [offerPopup.backgroundImage addSubview:effectView];
        
    }];
    
    
    
}
- (void)blurWithCoreImage:(UIImageView *)baseImageView withSource:(UIImage *)sourceImage
{
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = baseImageView.bounds;
    [baseImageView addSubview:effectView];
   
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
    
    NSMutableArray* cartItems = [NSMutableArray arrayWithArray:[self getCartItems]];
    if([cartItems count] != 0){
        NSInteger index=0;
        for(CartItem* item in cartItems)
        {
            if([item.product.prodName isEqualToString:cartItem.product.prodName]){
               
                    
                    index = [cartItems indexOfObject:item];
                [cartItems removeObjectAtIndex:index];
                NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:cartItems];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:archivedObject forKey:@"CartItems"];
                [defaults synchronize];

                break;
                
            }
        }
//        if ([cartItems containsObject:cartItem]) {
//            
//             index = [cartItems indexOfObject:cartItem];
//        } else {
//            NSLog(@"is not present in cart item arry");
//        }
      
        
    }

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

+(StoreLocationMapViewController*)getStoreMap{
    StoreLocationMapViewController* vc;
    //TODO:Bandhavi
   // if(instance.storeLocationController == nil){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"json"];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        ESTLocation *location = [ESTLocationBuilder parseFromJSON:content];
        vc = [[StoreLocationMapViewController alloc] initWithLocation:location];        
    //}
    instance.storeLocationController = vc;
    return vc;
}

+(void)getAllProductsFromServer{
    NetworkOperations *networks;
    networks=[[NetworkOperations alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"The product Api is %@",[dict objectForKey:@"Offers_Api"]);
    // send block as parameter to get callbacks
    [networks fetchDataFromServer:[dict objectForKey:@"Offers_Api"] withreturnMethod:^(NSMutableArray* data){
        instance.offersDataArray=data;
        NSLog(@"The product Api is %lu",(unsigned long)[instance.offersDataArray count]);
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           
                           [networks fetchDataFromServer:[dict objectForKey:@"Prod_Api"] withreturnMethod:^(NSMutableArray* data){
                               instance.productDataArray=data;
                               NSLog(@"The product Api is %lu",(unsigned long)[instance.offersDataArray count]);
                               dispatch_async(dispatch_get_main_queue(), ^
                                              {
                                                  
                                                  
                                                  
                                                  
                                              });
                           }];
                          
                           
                       });
    }];
}

+(Products *) getProductWithID:(NSInteger)id{
      NSArray *productsArray = [instance.productDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(offerid == %d)",id]];
      Products *prodObject;
    // tentetive for demo purpose
    
    if([productsArray count]>0){
        prodObject=[[Products alloc]  initWithDictionary:[productsArray objectAtIndex:0]];
        prodObject.prodImage=[NSString stringWithFormat:@"%@.png",prodObject.prodName];
    }
    return prodObject;
}

+(Offers *) getOfferWithID:(NSInteger)id{
    NSArray *offersArray = [instance.offersDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(offerId == %d)", id]];
    Offers *offerObject;
    if([offersArray count]>0){
        offerObject=[[Offers alloc]  initWithDictionary:[offersArray objectAtIndex:0]];
    }
    return offerObject;

}


-(void)loadCartScreen{
    CartViewController* cartScreen = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
//    MenuViewController* menuvc = (MenuViewController*)[SlideNavigationController sharedInstance].leftBarButtonItem;
    NSIndexPath* path = [NSIndexPath indexPathForRow: BeaconRetailCartIndex inSection:0];
    [instance.leftMenu.tableview selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    [[SlideNavigationController sharedInstance] pushViewController:cartScreen animated:YES];
}

+(MenuViewController *)getLeftMenu{
    if(instance.leftMenu == nil ){
        instance.leftMenu = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    }
    return instance.leftMenu;
}



@end
