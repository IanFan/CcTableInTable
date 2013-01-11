//
//  TableView.h
//  CcTableInTable
//
//  Created by Ian Fan on 10/01/13.
//
//

#import <UIKit/UIKit.h>

#define TABLEVIEW_TAG 800
#define ROTATED_CELL_VIEW_TAG	801
#define CELL_CONTENT_TAG 802
#define CELL_IMAGEVIEW_TAG 803
#define CELL_TITLE_TAG 804
#define CELL_SUBTITLE_TAG 805

typedef enum {
	TableViewOrientationVertical,
	TableViewOrientationHorizontal,
} TableViewOrientation;

@class TableView;

@protocol TableViewDelegate <NSObject>
- (UIView *)tableView:(TableView *)tableView viewForRect:(CGRect)rect;
- (void)tableView:(TableView *)tableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath*)indexPath;
@optional
- (NSUInteger)numberOfSectionsInTableView:(TableView*)TableView;
- (NSUInteger)numberOfCellsForTableView:(TableView *)view inSection:(NSInteger)section;
- (CGFloat)tableView:(TableView *)tableView heightOrWidthForCellAtIndexPath:(NSIndexPath *)indexPath;
- (UIView*)tableView:(TableView*)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView*)tableView:(TableView*)tableView viewForFooterInSection:(NSInteger)section;
- (void)tableView:(TableView *)tableView scrolledToOffset:(CGPoint)contentOffset;
- (void)tableView:(TableView *)tableView selectedView:(UIView *)selectedView atIndexPath:(NSIndexPath *)indexPath;
//- (void)tableView:(TableView *)tableView selectedView:(UIView *)selectedView atIndexPath:(NSIndexPath *)indexPath deselectedView:(UIView *)deselectedView;
@end


@interface TableView : UIView <UITableViewDelegate, UITableViewDataSource> {
@private
  NSUInteger _numItems;
	CGFloat	_cellWidthOrHeight;
}

@property (nonatomic, assign) id <TableViewDelegate> delegate;
@property (nonatomic, readonly) TableViewOrientation orientation;
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) NSArray *visibleViews;
@property (nonatomic, assign) NSUInteger numberOfCells;
@property (nonatomic, assign) UIColor *cellBackgroundColor;
@property (nonatomic, assign) CGPoint contentOffset;

- (id)initWithFrame:(CGRect)frame numberOfColumns:(NSUInteger)numCells ofWidth:(CGFloat)cellWidth;
- (id)initWithFrame:(CGRect)frame numberOfRows:(NSUInteger)numCells ofHeight:(CGFloat)cellHeight;
- (CGPoint)offsetForView:(UIView *)cell;
- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated;
- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (UIView *)viewAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath*)indexPathForView:(UIView *)cell;
- (void)reloadData;

@end
