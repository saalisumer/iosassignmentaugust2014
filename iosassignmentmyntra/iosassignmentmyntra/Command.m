//
//  Command.m
//  iosassignmentmyntra
//
//  Created by Saalis Umer on 22/05/13.
//  Copyright (c) 2014 Saalis Umer. All rights reserved.
//

#import "Command.h"
#import "CommandOperationQueue.h"
#import "Constants.h"
#import "Reachability.h"


@interface Command()

- (void)notifyDidReceiveResponse:(id)response;
- (void)notifyDidReceiveProgressUpdate:(id)progressUpdate;
- (void)notifyDidFailWithError:(NSError *)error;

@end

@implementation Command

@synthesize delegate = mDelegate;

- (id)init:(id<CommandDelegate>)delegate {
    self = [super init];
    
    if(self != nil) {
        mDelegate = delegate;
    }
    
    return self;
}

- (BOOL)isAsynchronous {
    return YES;
}

- (NSString *)commandType {
    return @"";
}

- (void)execute {
    mResponseData = [[NSMutableData alloc] init];
	
    if(self.isAsynchronous == YES) {
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus =  [reach currentReachabilityStatus];
		
		if(networkStatus == NotReachable) {
			NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:EIO userInfo:nil];
			[self performSelector:@selector(notifyDidFailWithError:) withObject:error afterDelay:0.1];
		} else {
			[self start];
		}
    } else {
        [[CommandOperationQueue instance] addOperation:self];
    }    
}

- (void)notifyDidReceiveResponseOnMainThread:(id)response {
    if(self.isAsynchronous == YES) {
        //It is running on main thread
        [self notifyDidReceiveResponse:response];
    } else {
        [self performSelectorOnMainThread:@selector(notifyDidReceiveResponse:) withObject:response waitUntilDone:NO];
    }
}

- (void)notifyDidReceiveProgressUpdateOnMainThread:(id)progressUpdate {
    if(self.isAsynchronous == YES) {
        //It is running on main thread
        [self notifyDidReceiveProgressUpdate:progressUpdate];
    } else {
        [self performSelectorOnMainThread:@selector(notifyDidReceiveProgressUpdate:) withObject:progressUpdate waitUntilDone:NO];
    }
}

- (void)notifyDidFailWithErrorOnMainThread:(NSError *)error {
    if(self.isAsynchronous == YES) {
        //It is running on main thread
        [self notifyDidFailWithError:error];
    } else {
        [self performSelectorOnMainThread:@selector(notifyDidFailWithError:) withObject:error waitUntilDone:NO];
    }
}

#pragma mark - Private Methods
- (void)notifyDidReceiveResponse:(id)response {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(command:didReceiveResponse:)] == YES) {
        [self.delegate command:self didReceiveResponse:response];
    }
    
}

- (void)notifyDidReceiveProgressUpdate:(id)progressUpdate {
    if(self.delegate != nil
	   && [self.delegate respondsToSelector:@selector(command:didReceiveProgressUpdate:)] == YES) {
        [self.delegate command:self didReceiveProgressUpdate:progressUpdate];
    }
}

- (void)notifyDidFailWithError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(command:didFailWithError:)] == YES) {
        [self.delegate command:self didFailWithError:error];
    }
}

#pragma mark - Common Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [mResponseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self notifyDidFailWithErrorOnMainThread:error];
}



//Comment this method while submitting to App Store.
//
//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//	NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//	[challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
//	
//	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
//}



- (void)cancelAndDiscardURLConnection {
    [mURLConnection cancel];
    mURLConnection = nil;
}

@end
