//
//  NetworkOperations.h
//  iBeacon_Retail
//
//  Created by shruthi on 11/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkOperations : NSObject<NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property(nonatomic,strong) NSMutableArray *dataArray;
-( void) fetchDataFromServer : (NSString *) url withreturnMethod:(void(^)(NSMutableArray *)) completionHandlerBlock;
@end