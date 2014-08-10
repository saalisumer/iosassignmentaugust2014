//
//  ApplicationModel.h
//  iosassignmentmyntra
//
//  Created by Saalis Umer on 10/08/14.
//  Copyright (c) 2014 Saalis Umer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationModel : NSObject

@property(nonatomic, strong) NSMutableArray * flickrFeeds;

//Image Cache
@property(nonatomic, strong) NSCache                            *imageCache;

+ (ApplicationModel *) instance;

- (void)clearModel;

@end
