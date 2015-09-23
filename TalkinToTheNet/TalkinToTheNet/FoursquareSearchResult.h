//
//  FoursquareSearchResult.h
//  TalkinToTheNet
//
//  Created by Charles Kang on 9/23/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoursquareSearchResult : NSObject

@property (nonatomic) NSString *venueName;
@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSMutableArray *address;
@property (nonatomic) NSString *category;
@property (nonatomic) NSURL *siteURL;
@property (nonatomic) NSURL *menuURL;

@end
