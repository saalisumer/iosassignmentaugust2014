//
//  ViewController.m
//  iosassignmentmyntra
//
//  Created by Saalis Umer on 08/08/14.
//  Copyright (c) 2014 Saalis Umer. All rights reserved.
//

#import "ViewController.h"
#import "FlickrImageFetchCommand.h"
#import "ApplicationModel.h"
#import "ImageDownloadManager.h"
#import "FlickrFeed.h"
#import "FlickrCell.h"
#include <stdlib.h>
#import "MBProgressHUD.h"

@interface ViewController ()<CommandDelegate, ImageDownloadManagerDelegate,UIAlertViewDelegate>
{
    NSArray * mDataSource;
    ApplicationModel * mApplicationModel;
    ImageDownloadManager *mImageDownloadManager;
    
    NSUInteger mTimerCount;
    
    NSUInteger mSampleImageIndex;
    NSMutableString *mImagesRevealed;
    
    NSUInteger mClickCounter;
    
    BOOL mGameStarted;
    
    NSTimer * mTimer;
    
    MBProgressHUD * mHUD;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    mApplicationModel = [ApplicationModel instance ];
    mImageDownloadManager = [ImageDownloadManager instance];
    mHUD = [[MBProgressHUD alloc]initWithView:self.view ];
    [self.view addSubview:mHUD];
    
    [mHUD hide:NO];
    
    [self reloadGame];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CommandDelegate
- (void)command:(Command *)cmd didReceiveResponse:(id)response
{
    [mHUD hide:YES];
    [self.collectionView reloadData];
}

- (void)command:(Command *)cmd didFailWithError:(NSError *)error
{
    [mHUD hide:YES];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark UICollectionView Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (mApplicationModel.flickrFeeds.count>9) {
        return 9;
    }
    
    return mApplicationModel.flickrFeeds.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlickrCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    [cell prepareForReuse];
    cell.flippedImageView.layer.borderColor = cell.imageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.flippedImageView.layer.borderWidth =  cell.imageView.layer.borderWidth = 1.0;
    
    cell.flippedImageView.hidden = YES;
    FlickrFeed* feed = mApplicationModel.flickrFeeds[indexPath.row];
    
    UIImage * image = [mImageDownloadManager loadImageForURL:[NSURL URLWithString:feed.imageURL] imageId:[NSString stringWithFormat:@"%d", indexPath.row] delegate:self];

    if (image != nil)
    cell.imageView.image = image;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.collectionView.bounds.size.height - 20)/3.0;
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (mGameStarted == YES) {
        FlickrCell* cell = (FlickrCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if (mSampleImageIndex == indexPath.row) {
            [self flipCell:cell];
            [mImagesRevealed appendFormat:@"%d",indexPath.row];
            [self loadNextSampleImage];
        }
        mClickCounter ++;
    }
}

-(void)flipCell:(FlickrCell*)cell{
    __block BOOL hideFlippedImageViewAfterAnimation = NO;
    [UIView animateWithDuration:1.0
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^
         {

             UIView * sourceView, * destinationView;
             if (cell.flippedImageView.hidden == YES) {
                 cell.flippedImageView.hidden = NO;
                 sourceView = cell.imageView;
                 destinationView = cell.flippedImageView;
             }
             else
             {
                 sourceView = cell.flippedImageView;
                 destinationView = cell.imageView;
                 hideFlippedImageViewAfterAnimation = YES;
             }
         
             [UIView transitionFromView:sourceView
                                 toView:destinationView
                               duration:.5
                                options:(UIViewAnimationOptionTransitionFlipFromRight|UIViewAnimationOptionShowHideTransitionViews)
                             completion:nil];
         }
                         completion:^(BOOL finished)
         {
             cell.flippedImageView.hidden = hideFlippedImageViewAfterAnimation;
         }
     ];

}

- (void)startTimer
{
    self.lblHeader.hidden = NO;
    self.lblHeader.text = [NSString stringWithFormat:@"%d",mTimerCount];
    
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
}

- (void)timerMethod:(NSTimer*)timer
{
    if (mTimerCount>0) {
        mTimerCount--;
        self.lblHeader.text = [NSString stringWithFormat:@"%d",mTimerCount];
    }
    
    if (mTimerCount == 0) {
        [timer invalidate];
        for (FlickrCell * cell in self.collectionView.visibleCells) {
            [self flipCell:cell];
            self.lblHeader.hidden = YES;
            self.sampleImage.hidden = NO;
            mGameStarted = YES;
            [self loadNextSampleImage];
        }
    }
}

-(void)loadNextSampleImage
{
    NSUInteger dataSourceCount = mApplicationModel.flickrFeeds.count>=9?9:mApplicationModel.flickrFeeds.count;
    mSampleImageIndex = arc4random() % dataSourceCount;
    NSString * sampleIndex = [NSString stringWithFormat:@"%d",mSampleImageIndex];
    if ([mImagesRevealed rangeOfString:sampleIndex].location != NSNotFound) {
        if (mImagesRevealed.length<9) {
            [self loadNextSampleImage];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Game Ended" message:[NSString stringWithFormat: @"You completed game in %d taps",mClickCounter] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Reload", nil ];
            alert.tag = -101;
            [alert show];
            self.sampleImage.hidden = YES;
        }
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        self.sampleImage.image = [mImageDownloadManager loadImageForURL:[NSURL URLWithString:((FlickrFeed*)mApplicationModel.flickrFeeds[mSampleImageIndex]).imageURL] imageId:[NSString stringWithFormat:@"%d",mSampleImageIndex] delegate:nil];

    });
    
}

-(void)reloadGame
{
    [mTimer invalidate];
    mTimer = nil;
    
    [mApplicationModel clearModel];
    [self.collectionView reloadData];
    
    FlickrImageFetchCommand * flickrImageCommand = [[FlickrImageFetchCommand alloc]init:self];
    [mHUD show:YES];
    [flickrImageCommand execute];

    mImagesRevealed = [[NSMutableString alloc]init];
    
    self.lblHeader.hidden = YES;
    self.sampleImage.hidden = YES;
    self.sampleImage.image = nil;
    
    mGameStarted = NO;
    mTimerCount = 15;
    
    mClickCounter = 0;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == -101) {
        [self reloadGame];
    }
}

#pragma mark ImageDownloadManagerDelegate
- (void)loadImageForURL:(NSURL *)url imageId:(NSString *)imageId
            didComplete:(UIImage *)image
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:imageId.integerValue inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    
    if (mImageDownloadManager.numberOfImageOperationsRunning == 1) {
        [self startTimer];
    }
}

- (void)loadImageForURL:(NSURL *)url imageId:(NSString *)imageId
       didFailWithError:(NSError *)error
{
    if (mImageDownloadManager.numberOfImageOperationsRunning == 1) {
        [self startTimer];
    }
}
- (IBAction)reloadGame:(id)sender {
    [self reloadGame];
}
@end
