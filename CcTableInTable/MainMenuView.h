//
//  MainMenuView.h
//  GameTutorial
//
//  Created by Ian Fan on 9/01/13.
//
//

#import <UIKit/UIKit.h>
#import "VerticalTableView.h"
#import "TableView.h"
#import "InfoCellOj.h"

@interface MainMenuView : UIView <TableViewDelegate>
{
}

@property (nonatomic, retain) TableView *horizontalView;
@property (nonatomic,retain) TableView *verticalView;

-(void)reLayoutViewsWithInterfaceOrientation:(UIInterfaceOrientation)targetOrientation;

@end
