//
//  FlickrCell.m
//  iosassignmentmyntra
//
//  Created by Saalis Umer on 10/08/14.
//  Copyright (c) 2014 Saalis Umer. All rights reserved.
//

#import "FlickrCell.h"

@implementation FlickrCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)prepareForReuse{
    self.imageView.image = nil;
}
@end
