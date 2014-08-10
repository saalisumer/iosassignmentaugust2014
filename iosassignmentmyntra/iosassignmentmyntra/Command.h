//
//  Command.h
//  iosassignmentmyntra
//
//  Created by Saalis Umer on 22/05/13.
//  Copyright (c) 2014 Saalis Umer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol CommandDelegate;

@interface Command : NSOperation <NSURLConnectionDataDelegate> {
    NSURLConnection     *mURLConnection;
    NSMutableData       *mResponseData;
}

//Must override this property in extended Class
@property(readonly, strong) NSString *commandType;

//Must override this property for Commands which are asynchronous in nature
@property(readonly) BOOL isAsynchronous;
@property(readonly, weak) id<CommandDelegate> delegate;

	
- (id)init:(id<CommandDelegate>)delegate;

- (void)execute;

- (void)notifyDidReceiveResponseOnMainThread:(id)response;
- (void)notifyDidReceiveProgressUpdateOnMainThread:(id)progressUpdate;
- (void)notifyDidFailWithErrorOnMainThread:(NSError *)error;

- (void)cancelAndDiscardURLConnection;

@end

@protocol CommandDelegate <NSObject>

@optional
- (void)command:(Command *)cmd didReceiveResponse:(id)response;
- (void)command:(Command *)cmd didFailWithError:(NSError *)error;
- (void)command:(Command *)cmd didReceiveProgressUpdate:(id)progressUpdate;

@end