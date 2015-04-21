//
//  Products.h
//  iBeacon_Retail
//
//  Created by shruthi on 16/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Products : NSObject <NSCoding>

@property(nonatomic,assign) NSInteger productId;
@property(nonatomic,strong) NSString *prodName;
@property(nonatomic,strong) NSString *prodDescription;
//@property(nonatomic,assign) double price;
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) NSString *size;
//@property(nonatomic,strong) NSString *sizeUnit;
@property(nonatomic,strong) NSString *colour;
@property(nonatomic,strong) NSString *beaconId;
@property(nonatomic,strong) NSString *prodImage;
@property(nonatomic,strong) NSData *prodImageData;
@property(nonatomic,assign) NSInteger sectionId;



- (instancetype)initWithDictionary:(NSDictionary*)productData;

@end
