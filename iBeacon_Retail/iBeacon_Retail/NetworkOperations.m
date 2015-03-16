//
//  NetworkOperations.m
//  iBeacon_Retail
//
//  Created by shruthi on 11/03/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "NetworkOperations.h"






@implementation NetworkOperations

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}


- (void) fetchDataFromServer:(NSString *)url{
    
    
    //NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sharedSession];
    //NSString * urlString=@"http://192.168.139.26:8080/products";
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", json);
    }];
    
    [dataTask resume];
    
}


#pragma url session delegate methods
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSLog(@"Data is %@",data);
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
  
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}


@end