//
//  Section.m
//  iBeacon_Retail
//
//  Created by shruthi on 20/04/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "Section.h"

@implementation Section

- (instancetype)init
{
    if ((self = [super init])) {
     
    }
    return self;
}

-(instancetype) initwithDictionary:(NSDictionary *)sectionData{
    if(self==[super init]){
        self.sectionid=(NSInteger) [sectionData valueForKey:@"sectionId"];
        self.sectionName=[sectionData valueForKey:@"beaconName"];
        self.sectionDescription=[sectionData valueForKey:@"sectionDescription"];
    }
    return self;
}

@end
