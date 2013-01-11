//
//  InfoCellOj.h
//  CcTableInTable
//
//  Created by Ian Fan on 10/01/13.
//
//

#import <Foundation/Foundation.h>

@interface InfoCellOj : NSObject

@property (nonatomic,retain) NSString *classString;
@property (nonatomic,retain) NSString *pngString;
@property (nonatomic,retain) NSString *titleString;
@property (nonatomic,retain) NSString *subTitleString;

@property BOOL isUnlocked;

-(void)setupWithClassStr:(NSString*)classStr pngStr:(NSString*)pngStr titleStr:(NSString*)titleStr subTitleStr:(NSString*)subTitleStr;

@end
