//
//  TableView.m
//  CcTableInTable
//
//  Created by Ian Fan on 10/01/13.
//
//

#import "TableView.h"
#import <QuartzCore/QuartzCore.h>

#define ANIMATION_DURATION	0.30

@interface TableViewCell : UITableViewCell
- (void)prepareForReuse;
@end

@implementation TableViewCell
- (void) prepareForReuse {
  UIView *content = [self viewWithTag:CELL_CONTENT_TAG];
  
  if ([content respondsToSelector:@selector(prepareForReuse)] == YES) {
    [content performSelector:@selector(prepareForReuse)];
  }
}
@end


@interface TableView (private)
- (void)createTableWithOrientation:(TableViewOrientation)orientation;
- (void)prepareRotatedView:(UIView *)rotatedView;
- (void)setDataForRotatedView:(UIView *)rotatedView forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TableView
@synthesize delegate, cellBackgroundColor;
@synthesize orientation = _orientation;
@synthesize numberOfCells = _numItems;

#pragma mark -
#pragma mark Selection

- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
	CGPoint defaultOffset	= CGPointMake(0, indexPath.row  *_cellWidthOrHeight);
	
	[self.tableView setContentOffset:defaultOffset animated:animated];
}

- (void)setSelectedIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *selectedCell	= (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
  
  if ([delegate respondsToSelector:@selector(tableView:selectedView:atIndexPath:)]) {
    UIView *selectedView = [selectedCell viewWithTag:CELL_CONTENT_TAG];
    [delegate tableView:self selectedView:selectedView atIndexPath:indexPath];
  }
}

#pragma mark -
#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[self setSelectedIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([delegate respondsToSelector:@selector(tableView:heightOrWidthForCellAtIndexPath:)]) {
    return [delegate tableView:self heightOrWidthForCellAtIndexPath:indexPath];
  }
  return _cellWidthOrHeight;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([delegate respondsToSelector:@selector(tableView:scrolledToOffset:)])
		[delegate tableView:self scrolledToOffset:self.contentOffset];
}

#pragma mark -
#pragma mark TableViewDataSource

- (void)setCell:(UITableViewCell *)cell boundsForOrientation:(TableViewOrientation)theOrientation {
	if (theOrientation == TableViewOrientationHorizontal) {
		cell.bounds	= CGRectMake(0, 0, self.bounds.size.height, _cellWidthOrHeight);
	}
	else {
		cell.bounds	= CGRectMake(0, 0, self.bounds.size.width, _cellWidthOrHeight);
	}
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"TableViewCell";
  
  UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
		
		[self setCell:cell boundsForOrientation:_orientation];
		
		cell.contentView.frame = cell.bounds;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		// Add a view to the cell's content view that is rotated to compensate for the table view rotation
		CGRect viewRect;
		if (_orientation == TableViewOrientationHorizontal) viewRect = CGRectMake(0, 0, cell.bounds.size.height, cell.bounds.size.width);
		else viewRect = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height);
		
		UIView *rotatedView	= [[[UIView alloc] initWithFrame:viewRect]autorelease];
		rotatedView.tag	= ROTATED_CELL_VIEW_TAG;
		rotatedView.center = cell.contentView.center;
		rotatedView.backgroundColor	= self.cellBackgroundColor;
		
		if (_orientation == TableViewOrientationHorizontal) {
			rotatedView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			rotatedView.transform = CGAffineTransformMakeRotation(M_PI/2);
		} else rotatedView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		// We want to make sure any expanded content is not visible when the cell is deselected
		rotatedView.clipsToBounds = YES;
		
		// Prepare and add the custom subviews
		[self prepareRotatedView:rotatedView];
		
		[cell.contentView addSubview:rotatedView];
	}
  
	[self setCell:cell boundsForOrientation:_orientation];
	
	[self setDataForRotatedView:[cell.contentView viewWithTag:ROTATED_CELL_VIEW_TAG] forIndexPath:indexPath];
  
  return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSUInteger numOfItems = _numItems;
	
	if ([delegate respondsToSelector:@selector(numberOfCellsForTableView:inSection:)]) {
		numOfItems = [delegate numberOfCellsForTableView:self inSection:section];
		
		// Animate any changes in the number of items
		[tableView beginUpdates];
		[tableView endUpdates];
	}
	
  return numOfItems;
}

-(void)reloadData{
  [self.tableView reloadData];
}

#pragma mark -
#pragma mark Rotation

- (void)prepareRotatedView:(UIView *)rotatedView {
	UIView *content = [delegate tableView:self viewForRect:rotatedView.bounds];
	
	// Add a default view if none is provided
	if (content == nil)
		content = [[[UIView alloc] initWithFrame:rotatedView.bounds]autorelease];
	
	content.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	content.tag = CELL_CONTENT_TAG;
	[rotatedView addSubview:content];
}


- (void)setDataForRotatedView:(UIView *)rotatedView forIndexPath:(NSIndexPath *)indexPath {
	UIView *content = [rotatedView viewWithTag:CELL_CONTENT_TAG];
	
  [delegate tableView:self setDataForView:content forIndexPath:indexPath];
}

#pragma mark -
#pragma mark Multiple Sections

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
  if ([delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
    UIView *headerView = [delegate tableView:self viewForHeaderInSection:section];
		if (_orientation == TableViewOrientationHorizontal)
			return headerView.frame.size.width;
		else
			return headerView.frame.size.height;
  }
  return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  if ([delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
    UIView *footerView = [delegate tableView:self viewForFooterInSection:section];
		if (_orientation == TableViewOrientationHorizontal)
			return footerView.frame.size.width;
		else
			return footerView.frame.size.height;
  }
  return 0.0;
}

- (UIView *)viewToHoldSectionView:(UIView *)sectionView {
	// Enforce proper section header/footer view height abd origin. This is required because
	// of the way UITableView resizes section views on orientation changes.
	if (_orientation == TableViewOrientationHorizontal)
		sectionView.frame = CGRectMake(0, 0, sectionView.frame.size.width, self.frame.size.height);
	
	UIView *rotatedView = [[[UIView alloc] initWithFrame:sectionView.frame]autorelease];
	
	if (_orientation == TableViewOrientationHorizontal) {
		rotatedView.transform = CGAffineTransformMakeRotation(M_PI/2);
		sectionView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	}
	else {
		sectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	}
	[rotatedView addSubview:sectionView];
	return rotatedView;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if ([delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
		UIView *sectionView = [delegate tableView:self viewForHeaderInSection:section];
		return [self viewToHoldSectionView:sectionView];
  }
  return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  if ([delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
		UIView *sectionView = [delegate tableView:self viewForFooterInSection:section];
		return [self viewToHoldSectionView:sectionView];
  }
  return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if ([delegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
    return [delegate numberOfSectionsInTableView:self];
  }
  return 1;
}

#pragma mark - Properties

- (UITableView *)tableView {
	return (UITableView *)[self viewWithTag:TABLEVIEW_TAG];
}

- (NSArray *)visibleViews {
	NSArray *visibleCells = [self.tableView visibleCells];
	NSMutableArray *visibleViews = [NSMutableArray arrayWithCapacity:[visibleCells count]];
	
	for (UIView *aView in visibleCells) {
		[visibleViews addObject:[aView viewWithTag:CELL_CONTENT_TAG]];
	}
  
	return visibleViews;
}

- (CGPoint)contentOffset {
	CGPoint offset = self.tableView.contentOffset;
  
	if (_orientation == TableViewOrientationHorizontal) offset = CGPointMake(offset.y, offset.x);
	
	return offset;
}

- (void)setContentOffset:(CGPoint)offset {
	if (_orientation == TableViewOrientationHorizontal) self.tableView.contentOffset = CGPointMake(offset.y, offset.x);
	else self.tableView.contentOffset = offset;
}

- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated {
	CGPoint newOffset;
	
	if (_orientation == TableViewOrientationHorizontal) newOffset = CGPointMake(offset.y, offset.x);
	else newOffset = offset;
  
	[self.tableView setContentOffset:newOffset animated:animated];
}


#pragma mark - Location and Paths

- (UIView *)viewAtIndexPath:(NSIndexPath *)indexPath {
	UIView *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	return [cell viewWithTag:CELL_CONTENT_TAG];
}

- (NSIndexPath *)indexPathForView:(UIView *)view {
	NSArray *visibleCells = [self.tableView visibleCells];
	
	__block NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	
	[visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		UITableViewCell *cell = obj;
    
		if ([cell viewWithTag:CELL_CONTENT_TAG] == view) {
      indexPath = [self.tableView indexPathForCell:cell];
			*stop = YES;
		}
	}];
  
	return indexPath;
}

- (CGPoint)offsetForView:(UIView *)view {
	// Get the location of the cell
	CGPoint cellOrigin = [view convertPoint:view.frame.origin toView:self];
	
	// No need to compensate for orientation since all values are already adjusted for orientation
	return cellOrigin;
}

#pragma mark - Setup 

- (void)createTableWithOrientation:(TableViewOrientation)orientation {
	// Save the orientation so that the table view cell knows how to set itself up
	_orientation = orientation;
	
	UITableView *tableView;
	if (orientation == TableViewOrientationHorizontal) {
		int xOrigin	= (self.bounds.size.width - self.bounds.size.height)/2;
		int yOrigin	= (self.bounds.size.height - self.bounds.size.width)/2;
		tableView	= [[UITableView alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, self.bounds.size.height, self.bounds.size.width)];
	}
  else tableView	= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
	
	tableView.tag = TABLEVIEW_TAG;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	// Rotate the tableView 90 degrees so that it is horizontal
	if (orientation == TableViewOrientationHorizontal) tableView.transform	= CGAffineTransformMakeRotation(-M_PI/2);
	
	tableView.showsVerticalScrollIndicator = NO;
	tableView.showsHorizontalScrollIndicator = NO;
	
	[self addSubview:tableView];
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame numberOfColumns:(NSUInteger)numCols ofWidth:(CGFloat)width {
  if (self = [super initWithFrame:frame]) {
		_numItems			= numCols;
		_cellWidthOrHeight	= width;
		
		[self createTableWithOrientation:TableViewOrientationHorizontal];
	}
  
  return self;
}

- (id)initWithFrame:(CGRect)frame numberOfRows:(NSUInteger)numRows ofHeight:(CGFloat)height {
  if (self = [super initWithFrame:frame]) {
		_numItems			= numRows;
		_cellWidthOrHeight	= height;
		
		[self createTableWithOrientation:TableViewOrientationVertical];
  }
  
  return self;
}

-(void)dealloc {
  [self.tableView release];
  
  [super dealloc];
}

@end
