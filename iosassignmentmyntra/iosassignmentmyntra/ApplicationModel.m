//
//  ApplicationModel.m
//  iosassignmentmyntra
//
//  Created by Saalis Umer on 10/08/14.
//  Copyright (c) 2014 Saalis Umer. All rights reserved.
//

#import "ApplicationModel.h"

@implementation ApplicationModel
static ApplicationModel *singletonInstance = nil;

+ (ApplicationModel *) instance {
	@synchronized(self) {
		if(!singletonInstance) {
			singletonInstance = [[ApplicationModel alloc] init];
            singletonInstance.flickrFeeds = [[NSMutableArray alloc]init];
            singletonInstance.imageCache = [[NSCache alloc]init];
        }
	}
    
	return singletonInstance;
}

- (void)clearModel
{
    [self.flickrFeeds removeAllObjects];
}

@end
