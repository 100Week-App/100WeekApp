//
//  iCarouselExampleViewController.h
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface iCarouselExampleViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) IBOutlet UINavigationItem *navItem;
@property (nonatomic, strong) IBOutlet UIBarItem *orientationBarItem;
@property (nonatomic, strong) IBOutlet UIBarItem *wrapBarItem;
@property (nonatomic, strong) IBOutlet UISlider *arcSlider;
@property (nonatomic, strong) IBOutlet UISlider *radiusSlider;
@property (nonatomic, strong) IBOutlet UISlider *tiltSlider;
@property (nonatomic, strong) IBOutlet UISlider *spacingSlider;
@property (strong, nonatomic) IBOutlet UILabel *lblHeading;
@property (strong, nonatomic) IBOutlet UILabel *lblSubHeading;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;


- (IBAction)switchCarouselType;
- (IBAction)toggleOrientation;
- (IBAction)toggleWrap;
- (IBAction)insertItem;
- (IBAction)removeItem;
- (IBAction)reloadCarousel;

@end
