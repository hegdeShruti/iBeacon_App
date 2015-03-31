//
//  Cart.m
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/27/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "CartItem.h"

@implementation CartItem

- (instancetype)init
{
    if ((self = [super init])) {
        //
    }
    return self;
}


- (instancetype)initWithDictionary:(NSDictionary*)cartData
{
    
    if ((self = [super init])) {
        self.product = (Products*) [cartData valueForKey:@"product"];
        self.quantity = [[cartData valueForKey:@"quantity"] integerValue];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.product = [decoder decodeObjectForKey:@"product"];
        self.quantity = [decoder decodeIntegerForKey:@"quantity"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.product forKey:@"product"];
    [encoder encodeInteger:self.quantity forKey:@"quantity"];
}

@end
