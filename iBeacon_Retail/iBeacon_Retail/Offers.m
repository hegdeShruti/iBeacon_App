//
//  Offers.m
//  iBeacon_Retail
//
//  Created by shruthi on 18/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "Offers.h"

@implementation Offers
- (instancetype)init
{
    if ((self = [super init])) {
        self.isExitOffer=NO;
    }
    return self;
}


- (instancetype)initWithDictionary:(NSDictionary*)offerData
{
 
    if ((self = [super init])) {
        self.offerId =(NSInteger) [offerData valueForKey:@"offerId"];
        self.offerHeading = [offerData valueForKey:@"offerHeading"];
        self.offerDescription = [offerData valueForKey:@"offerDescription"];
        self.sectionId= (NSInteger)[offerData valueForKey:@"sectionId"];
        self.beaconId =  [offerData valueForKey:@"beaconId"];
        self.productId =(NSInteger) [offerData valueForKey:@"productId"];
        if([[offerData valueForKey:@"onExitOffer"] intValue]>0){
            self.isExitOffer= YES;
        }
        else{
            self.isExitOffer= NO;
        }
        
    }
    return self;
}
@end
