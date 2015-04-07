//
//  iCarouselExampleViewController.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "iCarouselExampleViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface iCarouselExampleViewController () <UIActionSheetDelegate>{
    MPMoviePlayerController *moviePlayer;
    CGPoint lastContentOffset;
    CGSize viewOffset,defaultViewOffset,defaultContentOffset;
}
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) NSMutableArray *items;

@end


@implementation iCarouselExampleViewController

- (void)setUp
{
	//set up data
	_wrap = YES;
	self.items = [NSMutableArray array];
	for (int i = 0; i < 7; i++)
	{
        NSArray *arrayTemp = Nil;
        switch (i) {
            case 0:
                arrayTemp = [NSArray arrayWithObjects:@(i),@"tech.png",@"tech.mp4",@"Today in Tech", nil];
                break;
            case 1:
                arrayTemp = [NSArray arrayWithObjects:@(i),@"Movies.png",@"movie.mp4",@"Today in Movie", nil];
                break;
            case 2:
                arrayTemp = [NSArray arrayWithObjects:@(i),@"Jewellery.png",@"jewellery.mp4",@"Today in Jewellery", nil];
                break;
            case 3:
                arrayTemp = [NSArray arrayWithObjects:@(i),@"mobile.png",@"mobile.mp4",@"Today in Mobile", nil];
                break;
            case 4:
                arrayTemp = [NSArray arrayWithObjects:@(i),@"food.png",@"food.mp4",@"Today in Food", nil];
                break;
            case 5:
                arrayTemp = [NSArray arrayWithObjects:@(i),@"fashion.png",@"fashion.mp4",@"Today in Fashion", nil];
                break;
            case 6:
                arrayTemp = [NSArray arrayWithObjects:@(i),@"Dance.png",@"dance.mp4",@"Today in Dance", nil];
                break;
            default:
                arrayTemp = [NSArray arrayWithObjects:@(i),@"books.png",@"books.mp4",@"Today in Books", nil];
                break;
        }
		[_items addObject:arrayTemp];
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)dealloc
{
	//it's a good idea to set these to nil here to avoid
	//sending messages to a deallocated viewcontroller
	_carousel.delegate = nil;
	_carousel.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle

- (void)updateSliders
{
    switch (_carousel.type)
    {
        case iCarouselTypeLinear:
        {
            _arcSlider.enabled = NO;
        	_radiusSlider.enabled = NO;
            _tiltSlider.enabled = NO;
            _spacingSlider.enabled = YES;
            break;
        }
        case iCarouselTypeCylinder:
        case iCarouselTypeInvertedCylinder:
        case iCarouselTypeRotary:
        case iCarouselTypeInvertedRotary:
        case iCarouselTypeWheel:
        case iCarouselTypeInvertedWheel:
        {
            _arcSlider.enabled = YES;
        	_radiusSlider.enabled = YES;
            _tiltSlider.enabled = NO;
            _spacingSlider.enabled = YES;
            break;
        }
        default:
        {
            _arcSlider.enabled = NO;
        	_radiusSlider.enabled = NO;
            _tiltSlider.enabled = YES;
            _spacingSlider.enabled = YES;
            break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //configure carousel
    _carousel.type = iCarouselTypeCylinder;
    [self updateSliders];
    _navItem.title = @"CoverFlow2";
    [self loadMoviePlayer:_carousel];
    defaultViewOffset = _carousel.viewpointOffset;
    defaultViewOffset = _carousel.contentOffset;
//    CGSize offset = CGSizeMake(0.0f, 131.12);
//    _carousel.viewpointOffset = offset;
//    offset =CGSizeMake(0.0f, 108.0);
//    _carousel.contentOffset = offset;
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
    self.navItem = nil;
    self.orientationBarItem = nil;
    self.wrapBarItem = nil;
    self.arcSlider = nil;
    self.radiusSlider = nil;
    self.tiltSlider = nil;
    self.spacingSlider = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)switchCarouselType
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Carousel Type"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Linear", @"Rotary", @"Inverted Rotary", @"Cylinder", @"Inverted Cylinder", @"Wheel", @"Inverted Wheel", @"CoverFlow", @"CoverFlow2", @"Time Machine", @"Inverted Time Machine", nil];
    [sheet showInView:self.view];
}

- (IBAction)toggleOrientation
{
    //carousel orientation can be animated
    [UIView beginAnimations:nil context:nil];
    _carousel.vertical = !_carousel.vertical;
    [UIView commitAnimations];
    
    //update button
    _orientationBarItem.title = _carousel.vertical? @"Vertical": @"Horizontal";
}

- (IBAction)toggleWrap
{
    _wrap = !_wrap;
    _wrapBarItem.title = _wrap? @"Wrap: ON": @"Wrap: OFF";
    [_carousel reloadData];
}

- (IBAction)insertItem
{
    NSInteger index = MAX(0, _carousel.currentItemIndex);
    [_items insertObject:@(_carousel.numberOfItems) atIndex:index];
    [_carousel insertItemAtIndex:index animated:YES];
}

- (IBAction)removeItem
{
    if (_carousel.numberOfItems > 0)
    {
        NSInteger index = _carousel.currentItemIndex;
        [_carousel removeItemAtIndex:index animated:YES];
        [_items removeObjectAtIndex:index];
    }
}

- (IBAction)reloadCarousel
{
    [_carousel reloadData];
}

#pragma mark -
#pragma mark UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex	>= 0)
    {
        //map button index to carousel type
        iCarouselType type = buttonIndex;
        
        //carousel can smoothly animate between types
        [UIView beginAnimations:nil context:nil];
        _carousel.type = type;
        [self updateSliders];
        [UIView commitAnimations];
        
        //update title
        _navItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIButton *btnPlay = Nil;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310.0f, 310.0f)];
        view.contentMode = UIViewContentModeCenter;
        view.layer.cornerRadius = 155;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.layer.borderWidth = 1.0;
        view.clipsToBounds = YES;
        
        btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPlay.frame = CGRectMake(10, 10, 100, 100);
        CGPoint center = view.center;
//        center.y += (center.y / 2);
        btnPlay.center = center;
        btnPlay.alpha = 0.5;
        btnPlay.tag = 1;
        [btnPlay setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [btnPlay addTarget:self action:@selector(btnPlayTapped:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnPlay];
        
    }
    else
    {
        //get a reference to the label in the recycled view
        btnPlay = (UIButton *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:_items[index][1]] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.backgroundColor = [UIColor colorWithPatternImage:image];
    
//    label.text = [_items[index] stringValue];
    _lblSubHeading.text = [NSString stringWithFormat:@"Episode : 32"];
    
    return view;
}
-(void)carouselWillBeginDragging:(iCarousel *)carousel{
    
    [moviePlayer stop];
    [moviePlayer.view removeFromSuperview];
    moviePlayer = Nil;
    
    [UIView animateWithDuration:1.0 animations:^{
        carousel.currentItemView.alpha = 0.5;
        _lblHeading.alpha = 0.05;
        _lblSubHeading.alpha = 0.05;
        _lblDescription.alpha = 0.05;
    } completion:^(BOOL finished){
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    lastContentOffset = [touch locationInView:_carousel];
    viewOffset = _carousel.viewpointOffset;
    _carousel.perspective = -0.006;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentOffset = [touch locationInView:_carousel];
    
    if (lastContentOffset.y < currentOffset.y) {
        viewOffset.height -= (currentOffset.y - lastContentOffset.y) * 2;
        _carousel.viewpointOffset = viewOffset;
        CGSize contentOffSet= _carousel.contentOffset;
        contentOffSet.height -= (currentOffset.y - lastContentOffset.y);
        _carousel.contentOffset = contentOffSet;
        
        lastContentOffset = currentOffset;
    }else if (lastContentOffset.y > currentOffset.y){
        
        viewOffset.height +=  (lastContentOffset.y - currentOffset.y) * 2;
        _carousel.viewpointOffset = viewOffset;
        
        CGSize contentOffSet= _carousel.contentOffset;
        contentOffSet.height += (lastContentOffset.y - currentOffset.y);
        _carousel.contentOffset = contentOffSet;
        
        lastContentOffset = currentOffset;
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    lastContentOffset = CGPointMake(0, 0);
    _carousel.perspective = -0.002;
    [UIView animateWithDuration:0.5 animations:^{
        _carousel.viewpointOffset = defaultViewOffset;
        _carousel.contentOffset = defaultContentOffset;
        
    }];
//    viewOffset = defaultViewOffset;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    lastContentOffset = CGPointMake(0, 0);
    _carousel.perspective = -0.002;
        [UIView animateWithDuration:0.5 animations:^{
            _carousel.viewpointOffset = defaultViewOffset;
            _carousel.contentOffset = defaultContentOffset;
            
        }];
//    viewOffset = defaultViewOffset;
}
-(void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        
        [self loadMoviePlayer:carousel];
        [self changeContent:carousel];
        
        [UIView animateWithDuration:1.0 animations:^{
            carousel.currentItemView.alpha = 1.0;
            _lblHeading.alpha = 1.0;
            _lblSubHeading.alpha = 1.0;
            _lblDescription.alpha = 1.0;
        } completion:^(BOOL finished){
        }];
    }
    
}
-(void)carouselDidEndDecelerating:(iCarousel *)carousel{
    [self loadMoviePlayer:carousel];
    [self changeContent:carousel];
    [UIView animateWithDuration:1.0 animations:^{
        carousel.currentItemView.alpha = 1.0;
        _lblHeading.alpha = 1.0;
        _lblSubHeading.alpha = 1.0;
        _lblDescription.alpha = 1.0;
    } completion:^(BOOL finished){
    }];
}
-(void)loadMoviePlayer:(iCarousel *)carousel{
    
    moviePlayer = [[MPMoviePlayerController alloc] init];
    [moviePlayer.view setFrame:carousel.currentItemView.bounds];
    moviePlayer.scalingMode = MPMovieScalingModeFill;
    moviePlayer.view.backgroundColor = [UIColor clearColor];
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    [carousel.currentItemView addSubview:moviePlayer.view];
    
    [carousel.currentItemView sendSubviewToBack:moviePlayer.view];
    
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:[_items[carousel.currentItemIndex][2] stringByDeletingPathExtension] ofType:@"mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    [moviePlayer setContentURL:videoURL];
    [moviePlayer prepareToPlay];
    [moviePlayer play];
}
-(void)changeContent:(iCarousel *)carousel{
    _lblHeading.text = _items[carousel.currentItemIndex][3];
}
-(void)btnPlayTapped:(id)sender{

    MPMoviePlayerViewController *movieViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:moviePlayer.contentURL];
    [self presentMoviePlayerViewControllerAnimated:movieViewController];
    
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return _wrap;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionArc:
        {
            return 2 * M_PI * _arcSlider.value;
        }
        case iCarouselOptionRadius:
        {
            return value * _radiusSlider.value;
        }
        case iCarouselOptionTilt:
        {
            return _tiltSlider.value;
        }
        case iCarouselOptionSpacing:
        {
//            return value * _spacingSlider.value;
            return 1.35;
            
        }
        default:
        {
            return value;
        }
    }
}

@end
