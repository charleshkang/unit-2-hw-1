//
//  APIManager.h
//  TalkinToTheNet
//
//  Created by Charles Kang on 9/23/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface APIManager : NSObject

+ (void)getRequestWithURL: (NSURL *)URL completionHandler: (void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;


@end
