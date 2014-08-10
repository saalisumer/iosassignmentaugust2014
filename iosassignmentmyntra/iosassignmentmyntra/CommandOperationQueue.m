//
//  CommandOperationQueue.m
//  iosassignmentmyntra
//
//  Created by Saalis Umer on 22/05/13.
//  Copyright (c) 2014 Saalis Umer. All rights reserved.
//

#import "CommandOperationQueue.h"

#define kMaxConcurrentOperationCount 10

@implementation CommandOperationQueue

static CommandOperationQueue *singletonInstance = nil;

- (id)init {
	if(self = [super init]) {
        self.maxConcurrentOperationCount = kMaxConcurrentOperationCount;
	}
	return self;
}

+ (CommandOperationQueue *) instance {
	@synchronized(self) {
		if(!singletonInstance) {
			singletonInstance = [[CommandOperationQueue alloc] init];
		}
	}
    
	return singletonInstance;
}

@end
