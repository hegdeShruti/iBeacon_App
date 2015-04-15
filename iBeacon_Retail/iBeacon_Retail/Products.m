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
        self.prodDescription=[nutrientData valueForKey:@"productDescription"];
        self.price=[nutrientData valueForKey:@"price"];
        self.size=[nutrientData valueForKey:@"size"];
        self.colour=[nutrientData valueForKey:@"colour"];        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.productId = [decoder decodeIntegerForKey:@"productId"];
        self.beaconId = [decoder decodeObjectForKey:@"beaconId"];
        self.sectionId = [decoder decodeIntegerForKey:@"sectionId"];
        self.prodName= [decoder decodeObjectForKey:@"prodName"];
        self.prodDescription= [decoder decodeObjectForKey:@"prodDescription"];
        self.price=[decoder decodeObjectForKey:@"price"];
        self.size=[decoder decodeObjectForKey:@"size"];
        self.colour=[decoder decodeObjectForKey:@"colour"];
        self.prodImage = [decoder decodeObjectForKey:@"productImage"];    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.productId forKey:@"productId"];
    [encoder encodeObject:self.beaconId forKey:@"beaconId"];
    [encoder encodeInteger:self.sectionId forKey:@"sectionId"];
    [encoder encodeObject:self.prodName forKey:@"prodName"];
    [encoder encodeObject:self.prodDescription forKey:@"prodDescription"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.size forKey:@"size"];
    [encoder encodeObject:self.colour forKey:@"colour"];
    [encoder encodeObject:self.prodImage forKey:@"productImage"];

}

@end
