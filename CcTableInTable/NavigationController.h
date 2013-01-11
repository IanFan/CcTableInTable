//
//  NavigationController.h
//  CcAccelerometer
//
//  Created by Ian Fan on 27/12/12.
//
//

#import <UIKit/UIKit.h>
#import "MainMenuView.h"

@interface NavigationController : UINavigationController

@property (nonatomic,retain) MainMenuView *mainMenuView;
@property UIInterfaceOrientation interfaceOrientation;

@end
