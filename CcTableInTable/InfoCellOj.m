//
//  InfoCellOj.m
//  CcTableInTable
//
//  Created by Ian Fan on 10/01/13.
//
//

#import "InfoCellOj.h"

@implementation InfoCellOj

-(void)setupWithClassStr:(NSString *)classStr pngStr:(NSString *)pngStr titleStr:(NSString *)titleStr subTitleStr:(NSString *)subTitleStr {
  self.classString = classStr;
  self.pngString = pngStr;
  self.titleString = titleStr;
  self.subTitleString = subTitleStr;
}

-(void)dealloc {
  self.classString = nil;
  self.pngString = nil;
  self.titleString = nil;
  self.subTitleString = nil;
  [super dealloc];
}

@end
