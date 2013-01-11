//
//  MainMenuView.m
//  GameTutorial
//
//  Created by Ian Fan on 9/01/13.
//
//

#import "MainMenuView.h"

#define SHOW_MULTIPLE_SECTIONS 1		// If commented out, multiple sections with header and footer views are not shown

#define PORTRAIT_WIDTH				1024
#define LANDSCAPE_HEIGHT			(768-20)
#define HORIZONTAL_TABLEVIEW_HEIGHT	768/3
#define VERTICAL_TABLEVIEW_WIDTH	1024/3
#define TABLE_BACKGROUND_COLOR [UIColor clearColor]
#define TABLE_SEPARATOR_COLOR [UIColor clearColor]
#define CELL_SEPARATOR_COLOR [UIColor clearColor]

#define BORDER_VIEW_TAG				10

#ifdef SHOW_MULTIPLE_SECTIONS
#define NUM_OF_CELLS			10
#define NUM_OF_SECTIONS			1
#else
#define NUM_OF_CELLS			21
#endif

@interface MainMenuView (private)
- (void)setupHorizontalView;
- (void)setupVerticalView;
@end

@implementation MainMenuView

@synthesize verticalView,horizontalView;

-(void)reLayoutViewsWithInterfaceOrientation:(UIInterfaceOrientation)targetOrientation {
  NSLog(@"TRUE view = %d",(UIInterfaceOrientationIsLandscape(targetOrientation)));

}

#pragma mark - Utility Methods

- (void)borderIsSelected:(BOOL)selected forView:(UIView *)view {
	UIImageView *borderView		= (UIImageView *)[view viewWithTag:BORDER_VIEW_TAG];
	NSString *borderImageName	= (selected) ? @"selected_border.png" : @"image_border.png";
	borderView.image = [UIImage imageNamed:borderImageName];
}

#pragma mark -
#pragma mark TableViewDelegate

/*
-(NSMutableArray*)infoCellOjWithTableView:(TableView *)tableView {
  NSMutableArray *array = [[NSMutableArray alloc]init];
  InfoCellOj *infoCellOj = [[[InfoCellOj alloc]init]autorelease];
  [infoCellOj setupWithClassStr:@"IntroLayer" pngStr:@"Icon-72.png" titleStr:@"Accelerometer" subTitleStr:@"FREE"];
  [array addObject:infoCellOj];
  
  return array;
}
*/

/*
 - (void)tableView:(TableView *)tableView scrolledToOffset:(CGPoint)contentOffset;//////
 - (CGFloat)tableView:(TableView *)tableView heightOrWidthForCellAtIndexPath:(NSIndexPath *)indexPath;////
 */

// These delegate methods support both example views - first delegate method creates the necessary views

- (UIView *)tableView:(TableView *)tableView viewForRect:(CGRect)rect {
  //request style1
  //request style2
  
  if (tableView == self.verticalView || tableView == self.horizontalView) {
    NSLog(@"YESYES");
  }
  
  //container view
  float viewMargin = 10;
  float viewWidth = rect.size.width - 2*viewMargin;
  float viewHeight = viewWidth;
  CGRect viewFrame = CGRectMake(viewMargin, viewMargin, viewWidth, viewHeight);
  
  UIView *view = [[[UIView alloc]initWithFrame:viewFrame]autorelease];
  
  //imageView
  float imageViewMargin = 10;
  float imageViewWidth = (viewWidth-2*imageViewMargin);
  float imageViewHeight = imageViewWidth*3.0/4.0;
  CGRect imageViewFrame = CGRectMake(imageViewMargin, imageViewMargin, imageViewWidth, imageViewHeight);
  
  UIImageView *imageView = [[[UIImageView alloc] initWithFrame:imageViewFrame]autorelease];
  imageView.tag = CELL_IMAGEVIEW_TAG;
  [imageView setContentMode:UIViewContentModeScaleAspectFill];
  
  [imageView setClipsToBounds:YES];
  
  //titleLabel
  float titleLabelWidth = viewWidth;
  float titleLabelHeight = viewHeight;
	CGRect titleLabelFrame		= CGRectMake(0, 0, titleLabelWidth, titleLabelHeight);
  
	UILabel *titleLabel			= [[[UILabel alloc] initWithFrame:titleLabelFrame]autorelease];
  titleLabel.tag = CELL_TITLE_TAG;
	titleLabel.textAlignment		= UITextAlignmentCenter;
	titleLabel.textColor			= [UIColor whiteColor];
	titleLabel.font				= [UIFont boldSystemFontOfSize:60];
  titleLabel.backgroundColor = [UIColor clearColor];
  
  
  //borderImageView
  UIImageView *borderImageView = [[[UIImageView alloc] initWithFrame:viewFrame]autorelease];
	borderImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	borderImageView.tag = BORDER_VIEW_TAG;
  
  [view addSubview:imageView];
  [view addSubview:titleLabel];
  [view addSubview:borderImageView];
  
	return view;
}

// Second delegate populates the views with data from a data source

- (void)tableView:(TableView *)tableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"index = %d",[indexPath row]);
//	UILabel *label	= (UILabel *)view;
  UIImageView *imageView = (UIImageView*)[view viewWithTag:CELL_IMAGEVIEW_TAG];
  [imageView setImage:[UIImage imageNamed:@"Default-Landscape~ipad.png"]];
  
  UILabel *titleLabel = (UILabel *)[view viewWithTag:CELL_TITLE_TAG];
  titleLabel.text = [NSString stringWithFormat:@"%i", indexPath.row];
}

// Optional delegate to track the selection of a particular cell

- (void)tableView:(TableView *)tableView selectedView:(UIView *)selectedView atIndexPath:(NSIndexPath *)indexPath deselectedView:(UIView *)deselectedView {
	[self borderIsSelected:YES forView:selectedView];
	
	if (deselectedView)
		[self borderIsSelected:NO forView:deselectedView];
	
//	UILabel *label	= (UILabel *)selectedView;
//	bigLabel.text	= label.text;
}

- (void)tableView:(TableView *)tableView selectedView:(UIView *)selectedView atIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"indexPath row = %d",[indexPath row]);
}

#pragma mark -
#pragma mark Optional TableView delegate methods for section headers and footers

#ifdef SHOW_MULTIPLE_SECTIONS

// Delivers the number of sections in the TableView
- (NSUInteger)numberOfSectionsInTableView:(TableView*)tableView{
  return NUM_OF_SECTIONS;
}

// Delivers the number of cells in each section, this must be implemented if numberOfSectionsInTableView is implemented
-(NSUInteger)numberOfCellsForTableView:(TableView *)view inSection:(NSInteger)section {
  return NUM_OF_CELLS;
}

// The height of the header section view MUST be the same as your HORIZONTAL_TABLEVIEW_HEIGHT (horizontal TableView only)
- (UIView *)tableView:(TableView*)tableView viewForHeaderInSection:(NSInteger)section {
  return nil;
  
  UILabel *label = [[[UILabel alloc] init]autorelease];
	label.text = @"HEADER";
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
  
	if (tableView == self.horizontalView) {
		label.frame = CGRectMake(0, 0, 50, HORIZONTAL_TABLEVIEW_HEIGHT);
	}
	if (tableView == self.verticalView) {
		label.frame = CGRectMake(0, 0, VERTICAL_TABLEVIEW_WIDTH, 50);
	}
  
  switch (section) {
    case 0:
      label.backgroundColor = [UIColor redColor];
      break;
    default:
      label.backgroundColor = [UIColor blueColor];
      break;
  }
  return label;
}

// The height of the footer section view MUST be the same as your HORIZONTAL_TABLEVIEW_HEIGHT (horizontal TableView only)
- (UIView *)tableView:(TableView*)tableView viewForFooterInSection:(NSInteger)section {
  return nil;
  
  UILabel *label = [[[UILabel alloc] init]autorelease];
	label.text = @"FOOTER";
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
  
	if (tableView == self.horizontalView) {
		label.frame = CGRectMake(0, 0, 50, HORIZONTAL_TABLEVIEW_HEIGHT);
	}
	if (tableView == self.verticalView) {
		label.frame = CGRectMake(0, 0, VERTICAL_TABLEVIEW_WIDTH, 50);
	}
  
  switch (section) {
    case 0:
      label.backgroundColor = [UIColor redColor];
      break;
    default:
      label.backgroundColor = [UIColor blueColor];
      break;
  }
  
  return label;
}

#endif

#pragma mark - TableView Initialization

- (void)setupHorizontalView {
	CGRect frameRect	= CGRectMake(0, LANDSCAPE_HEIGHT - HORIZONTAL_TABLEVIEW_HEIGHT, PORTRAIT_WIDTH, HORIZONTAL_TABLEVIEW_HEIGHT);
	TableView *view	= [[TableView alloc] initWithFrame:frameRect numberOfColumns:NUM_OF_CELLS ofWidth:VERTICAL_TABLEVIEW_WIDTH];
	self.horizontalView = view;
	
	horizontalView.delegate	= self;
  horizontalView.tableView.pagingEnabled = YES;
	horizontalView.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;
	horizontalView.tableView.allowsSelection = YES;
	horizontalView.tableView.separatorColor = TABLE_SEPARATOR_COLOR;
	horizontalView.cellBackgroundColor = CELL_SEPARATOR_COLOR;
	horizontalView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
  
	[self addSubview:horizontalView];
}

-(void)setupVerticalTableView {
  CGRect frameRect	= CGRectMake(PORTRAIT_WIDTH - VERTICAL_TABLEVIEW_WIDTH, 0, VERTICAL_TABLEVIEW_WIDTH, LANDSCAPE_HEIGHT);
	TableView *view	= [[TableView alloc] initWithFrame:frameRect numberOfRows:NUM_OF_CELLS ofHeight:HORIZONTAL_TABLEVIEW_HEIGHT];
	self.verticalView	= view;
	
	verticalView.delegate = self;
	verticalView.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;
	verticalView.tableView.allowsSelection = YES;
	verticalView.tableView.separatorColor = TABLE_SEPARATOR_COLOR;
	verticalView.cellBackgroundColor = CELL_SEPARATOR_COLOR;
	verticalView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	// Allow verticalView to scroll up and completely clear the horizontalView
	verticalView.tableView.contentInset = UIEdgeInsetsMake(0, 0, HORIZONTAL_TABLEVIEW_HEIGHT, 0);
	
	[self addSubview:verticalView];
}

-(void)setTableViewData {
//  NSMutableArray *dataArray0 = [[NSMutableArray alloc]init];
  // [         ] feature
  // [ ] new
  // [   ] top paid
  // [ ] cocos2d basic (free)
  // [   ] cocos2d essential (100 gold/each)
  // [ ] chipmunk basic (100 gold/each)
  // [   ] chipmunk essential (300 gold/each)
  // [ ] prototype basic (100 gold + 1crystal/each)
  // [   ] prototype advaced (300 gold + 3 crystal/each)
  // suggest a tutorial email
  
  //level exp acheivement
  //gold crystal
  
  
//  vertical
// topic
//enum
//imageName
//title
//subTitle (price)
  
//  NSClassFromString(<#NSString *aClassName#>)
  //enum
  //imageName
  //title
  //subTitle (price)
  //class string
  
  //feature
  //cocos2d basic
  //cocos2d advanced
  //cocos2d prototype
  //chipmunk basic
  //chipmunk advanced
  //chipmunk prototype
  //sale pack popupar tutorial, prototype ...
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      [self setTableViewData];
      
//      [self setupVerticalTableView];
      
      [self setupHorizontalView];
    }
    return self;
}

-(void)dealloc {
  if (self.verticalView != nil) [self.verticalView release], self.verticalView = nil;
  if (self.horizontalView != nil) [self.horizontalView release], self.horizontalView = nil;
  
  [super dealloc];
}

@end
