//
//  GlobalVariables.m
//  iBeacon_Retail
//
//  Created by shruthi on 12/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables
@synthesize hasUserEnteredTheStore , hasUserGotWOmenSectionOffers, hasUserGotKidSectionOffers,hasUserGotMenSectionOffers;

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
        }
    }
    return instance;
}


@end
