//
//  Created by Saalis Umer on 05/06/13.
//  Copyright (c) 2014 Saalis Umer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownloadManager.h"

@interface ImageDownloadOperation : NSOperation

@property(readonly, copy) NSURL *url;
@property(strong , readonly) NSString *imageId;

@property(readonly, weak) id<ImageDownloadManagerDelegate> delegate;

- (id)initWithURL:(NSURL *)url imageId:(NSString *)imageId delegate:(id<ImageDownloadManagerDelegate>)delegate;

@end
