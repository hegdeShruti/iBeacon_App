//
//  Products.m
//  iBeacon_Retail
//
//  Created by shruthi on 16/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "Products.h"

@implementation Products

- (instancetype)init
{
    if ((self = [super init])) {
        //
    }
    return self;
}


- (instancetype)initWithDictionary:(NSDictionary*)nutrientData
{
    
    if ((self = [super init])) {
        self.productId =(NSInteger) [nutrientData valueForKey:@"productId"];
         self.beaconId =[nutrientData valueForKey:@"beaconId"];
         self.sectionId =(NSInteger) [nutrientData valueForKey:@"sectionId"];
         self.prodName=[nutrientData valueForKey:@"productName"];
        
    }
    return self;
}

@end
