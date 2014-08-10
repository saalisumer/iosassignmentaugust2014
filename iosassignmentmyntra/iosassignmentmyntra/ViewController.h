//
//  ViewController.h
//  iosassignmentmyntra
//
//  Created by Saalis Umer on 08/08/14.
//  Copyright (c) 2014 Saalis Umer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UIImageView *sampleImage;
- (IBAction)reloadGame:(id)sender;
@end
