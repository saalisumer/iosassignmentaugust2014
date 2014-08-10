//
//  FlickrFeedBuilder.m
//  iosassignmentmyntra
//
//  Created by Saalis Umer on 10/08/14.
//  Copyright (c) 2014 Saalis Umer. All rights reserved.
//

#import "FlickrFeedBuilder.h"
#import "FlickrFeed.h"
@implementation FlickrFeedBuilder

+ (NSArray*)flickrFeedFromJSON:(NSArray*)flickerFeeds
{
    NSMutableArray * flickrFeedModelObjects = [[NSMutableArray alloc]initWithCapacity:flickerFeeds.count];
    for (id flickrFeedJSON in flickerFeeds) {
        FlickrFeed * flickrFeed = [[FlickrFeed alloc]init];
        
        id value = [flickrFeedJSON valueForKey:@"media"];
        if(value != nil && value != [NSNull null]) {
            id subValue = [value valueForKey:@"m"];
            if(subValue != nil && subValue != [NSNull null]) {
                flickrFeed.imageURL = subValue;
                [flickrFeedModelObjects addObject:flickrFeed];
            }
        }
        
    }
    return flickrFeedModelObjects;
}
@end
