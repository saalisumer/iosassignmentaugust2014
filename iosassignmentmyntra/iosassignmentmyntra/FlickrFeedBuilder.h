//
//  FlickrFeedBuilder.h
//  iosassignmentmyntra
//
//  Created by Saalis Umer on 10/08/14.
//  Copyright (c) 2014 Saalis Umer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrFeedBuilder : NSObject
+ (NSArray*)flickrFeedFromJSON:(NSArray*)flickerFeeds;
@end
