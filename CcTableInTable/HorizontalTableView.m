//
//  HorizontalTableView.m
//  CcTableInTable
//
//  Created by Ian Fan on 10/01/13.
//
//

#import "HorizontalTableView.h"

@implementation HorizontalTableView

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat tableViewHeight;
  tableViewHeight = 100;
  
  /*
   if(appDelegate.bIsPad==YES){
   if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
   tableViewHeight = 162;
   }else{
   tableViewHeight = 143;
   }
   }else{
   if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
   tableViewHeight = 85.6;
   }else{
   tableViewHeight = 89.3;
   }
   }
   */
  return tableViewHeight;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  cell.textLabel.text = [NSString stringWithFormat:@"%d",[indexPath row]];
//  cell.contentView
  
  
  return cell;
}
/*
 static NSString *CellIdentifier = @"EasyTableViewCell";
 
 UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[EasyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 
 [self setCell:cell boundsForOrientation:_orientation];
 
 cell.contentView.frame = cell.bounds;
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
 // Add a view to the cell's content view that is rotated to compensate for the table view rotation
 CGRect viewRect;
 if (_orientation == EasyTableViewOrientationHorizontal)
 viewRect = CGRectMake(0, 0, cell.bounds.size.height, cell.bounds.size.width);
 else
 viewRect = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height);
 
 UIView *rotatedView				= [[UIView alloc] initWithFrame:viewRect];
 rotatedView.tag					= ROTATED_CELL_VIEW_TAG;
 rotatedView.center				= cell.contentView.center;
 rotatedView.backgroundColor		= self.cellBackgroundColor;
 
 if (_orientation == EasyTableViewOrientationHorizontal) {
 rotatedView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
 rotatedView.transform = CGAffineTransformMakeRotation(M_PI/2);
 }
 else
 rotatedView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
 
 // We want to make sure any expanded content is not visible when the cell is deselected
 rotatedView.clipsToBounds = YES;
 
 // Prepare and add the custom subviews
 [self prepareRotatedView:rotatedView];
 
 [cell.contentView addSubview:rotatedView];
 }
 [self setCell:cell boundsForOrientation:_orientation];
 
 [self setDataForRotatedView:[cell.contentView viewWithTag:ROTATED_CELL_VIEW_TAG] forIndexPath:indexPath];
 return cell;

 */


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  
  //if([indexPath row]==3){return NO;}
  
  //return self.tableView.editing;
  
  return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete)
    {
    // Delete the row from the data source.
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
  else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the item to be re-orderable.
  return YES;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  
  [super setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   [detailViewController release];
   */
  
  NSLog(@"User Select at %d, %d",[indexPath section],[indexPath row]);
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    self.dataSource = self;
    self.delegate = self;
  }
  return self;
}

-(void)dealloc{
  //  if (bookMarkMutableArray != nil) [bookMarkMutableArray release], bookMarkMutableArray = nil;
  [super dealloc];
}

@end
