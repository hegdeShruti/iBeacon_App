//
//  Section.h
//  iBeacon_Retail
//
//  Created by shruthi on 20/04/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject

@property(nonatomic,assign) NSInteger sectionid;
@property(nonatomic,assign) NSInteger productId;
@property(nonatomic,strong) NSString *sectionName;
@property(nonatomic,strong) NSString *sectionDescription;


-(instancetype) initwithDictionary:(NSDictionary *) sectionData;

@end
