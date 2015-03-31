//
//  Cart.h
//  iBeacon_Retail
//
//  Created by tavant_sreejit on 3/27/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Products.h"
@interface CartItem : NSObject <NSCoding>

@property (nonatomic,strong) Products* product;
@property (nonatomic,assign) NSInteger quantity;

- (instancetype)initWithDictionary:(NSDictionary*)cartData;

@end
