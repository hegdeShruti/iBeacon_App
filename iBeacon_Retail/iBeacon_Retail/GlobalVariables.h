//
//  GlobalVariables.h
//  iBeacon_Retail
//
//  Created by shruthi on 12/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVariables : NSObject

@property(nonatomic,assign) BOOL hasUserEnteredTheStore;
@property(nonatomic,assign) BOOL hasUserGotWOmenSectionOffers;
@property(nonatomic,assign) BOOL hasUserGotMenSectionOffers;
@property(nonatomic,assign) BOOL hasUserGotKidSectionOffers;
@property(nonatomic,assign) BOOL hasUsercrossedEntrance;
@property(nonatomic,assign) BOOL hasUserEntredEntryBeacon;

+( GlobalVariables *) getInstance;

@end
