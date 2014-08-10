//
//  FlickrImageFetchCommand.m
//  iosassignmentmyntra
//
//  Created by Saalis Umer on 10/08/14.
//  Copyright (c) 2014 Saalis Umer. All rights reserved.
//

#import "FlickrImageFetchCommand.h"
#import "Constants.h"
#import "ApplicationModel.h"
#import "FlickrFeedBuilder.h"

@implementation FlickrImageFetchCommand

-(NSString *)commandType
{
    return kCommandTypeFlickrImageFetch;
}

#pragma mark - Command Implementation
- (void)main {
        NSURL *url = [[NSURL alloc] initWithString:kURLTypeFlickrImageFetch];
        
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        urlRequest.HTTPMethod = @"GET";
    
        mURLConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
}

#pragma mark - NSURLConnectionDataDelegate implementation
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:mResponseData options:NSJSONReadingMutableContainers error:&error];
    
    if(error == nil) {
        if([responseObject valueForKey:@"items"] != nil) {
            NSArray * flickrFeeds = [responseObject valueForKey:@"items"];
            NSArray * flickrFeedModelObjects = [FlickrFeedBuilder flickrFeedFromJSON:flickrFeeds];
            [self updateModel:flickrFeedModelObjects];
            [self notifyDidReceiveResponseOnMainThread:flickrFeedModelObjects];
        }
    } else {
        [super notifyDidFailWithErrorOnMainThread:error];
    }
}

-(void)updateModel:(NSArray*)flickrFeeds
{
    ApplicationModel * applicationModel = [ApplicationModel instance];
    [applicationModel.flickrFeeds removeAllObjects];
    [applicationModel.flickrFeeds addObjectsFromArray: flickrFeeds];
}

@end
