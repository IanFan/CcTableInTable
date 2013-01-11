//
//  NavigationController.m
//  CcAccelerometer
//
//  Created by Ian Fan on 27/12/12.
//
//

#import "NavigationController.h"

#define SUPPORTED_INTERFACE_ORIENTATIONS_MASK UIInterfaceOrientationMaskLandscape
//#define SUPPORTED_INTERFACE_ORIENTATIONS_MASK UIInterfaceOrientationMaskPortrait
//#define SUPPORTED_INTERFACE_ORIENTATIONS_MASK UIInterfaceOrientationMaskAll //do not use it with Cocos2d

@interface NavigationController ()
-(void)reLayoutViewsWithInterfaceOrientation:(UIInterfaceOrientation)targetOrientation;
@end

@implementation NavigationController

@synthesize mainMenuView = mainMenuView_;

-(NSUInteger)supportedInterfaceOrientations{
  if ([self returnIsSupportedWithInterFaceOrientationMask:SUPPORTED_INTERFACE_ORIENTATIONS_MASK] == YES) {
    self.interfaceOrientation = [[UIDevice currentDevice] orientation];
    [self reLayoutViewsWithInterfaceOrientation:self.interfaceOrientation];
  }
  
  return SUPPORTED_INTERFACE_ORIENTATIONS_MASK;
}

-(BOOL)returnIsSupportedWithInterFaceOrientationMask:(UIInterfaceOrientationMask)mask {
  BOOL isSupported = NO;
  UIInterfaceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
  
  switch (mask) {
    case UIInterfaceOrientationMaskPortrait:
      if (currentOrientation == UIInterfaceOrientationPortrait) isSupported = YES; break;
    case UIInterfaceOrientationMaskLandscapeLeft:
      if (currentOrientation == UIInterfaceOrientationLandscapeLeft) isSupported = YES; break;
    case UIInterfaceOrientationMaskLandscapeRight:
      if (currentOrientation == UIInterfaceOrientationLandscapeRight) isSupported = YES; break;
    case UIInterfaceOrientationMaskPortraitUpsideDown:
      if (currentOrientation == UIInterfaceOrientationPortraitUpsideDown) isSupported = YES; break;
    case UIInterfaceOrientationMaskLandscape:
      if (UIInterfaceOrientationIsLandscape(currentOrientation) == YES) isSupported = YES; break;
    case UIInterfaceOrientationMaskAll:
      isSupported = YES; break;
    case UIInterfaceOrientationMaskAllButUpsideDown:
      if (UIInterfaceOrientationIsLandscape(currentOrientation) == YES || currentOrientation == UIInterfaceOrientationPortrait) isSupported = YES; break;
    default: break;
  }
  
  return isSupported;
}

- (BOOL)shouldAutorotate {
  return YES;
}

-(void)reLayoutViewsWithInterfaceOrientation:(UIInterfaceOrientation)targetOrientation {
//  if (mainMenuView_ != nil) [mainMenuView_ reLayoutViewsWithInterfaceOrientation:targetOrientation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  [self setMainMenuView];
}

-(void)setMainMenuView {
  
  CGRect screenFrame = [UIScreen mainScreen].bounds;
  CGRect viewFrame;
  float width;
  float height;
  
  UIInterfaceOrientationMask mask = SUPPORTED_INTERFACE_ORIENTATIONS_MASK;
  
  if (mask == UIInterfaceOrientationMaskLandscape || mask == UIInterfaceOrientationMaskLandscapeLeft || mask == UIInterfaceOrientationMaskLandscapeRight) {
    width = MAX(screenFrame.size.width, screenFrame.size.height);
    height = MIN(screenFrame.size.width, screenFrame.size.height);
  }else if (mask == UIInterfaceOrientationMaskPortrait || mask == UIInterfaceOrientationMaskPortraitUpsideDown) {
    width = MIN(screenFrame.size.width, screenFrame.size.height);
    height = MAX(screenFrame.size.width, screenFrame.size.height);
  }else {
    if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]) == YES){
      width = MAX(screenFrame.size.width, screenFrame.size.height);
      height = MIN(screenFrame.size.width, screenFrame.size.height);
    }else {
      width = MIN(screenFrame.size.width, screenFrame.size.height);
      height = MAX(screenFrame.size.width, screenFrame.size.height);
    }
  }
  
  viewFrame = CGRectMake(0, 0, width, height);
  
  self.mainMenuView = [[MainMenuView alloc]initWithFrame:viewFrame];
  
  [self.view addSubview:self.mainMenuView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

@end
