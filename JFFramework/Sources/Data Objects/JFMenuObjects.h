//
//  JFMenuObjects.h
//  Copyright (C) 2015 Jacopo Filié
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//



#import "JFUtilities.h"



@class JFMenuItem;
@class JFMenuSection;



@interface JFMenuNode : NSObject <NSCopying>

#pragma mark Properties

// Data
@property (copy, nonatomic)		NSDictionary*	additionalInfo;
@property (copy, nonatomic)		NSString*		detailText;
@property (copy, nonatomic)		NSString*		title;

// Relationships
@property (strong, nonatomic, readonly)	NSArray<JFMenuItem*>*	subitems;


#pragma mark Methods

// Relationships management
- (JFMenuItem*)				addSubitem:(JFMenuItem*)item;
- (NSArray<JFMenuItem*>*)	addSubitems:(NSArray<JFMenuItem*>*)items;
- (JFMenuItem*)				insertSubitem:(JFMenuItem*)item atIndex:(NSUInteger)index;
- (NSArray<JFMenuItem*>*)	insertSubitems:(NSArray<JFMenuItem*>*)items atIndex:(NSUInteger)index;
- (JFMenuItem*)				removeSubitem:(JFMenuItem*)item;
- (NSArray<JFMenuItem*>*)	removeSubitems:(NSArray<JFMenuItem*>*)items;

@end



#pragma mark



@interface JFMenuItem : JFMenuNode

#pragma mark Properties

// Data
@property (strong, nonatomic)	JFBlockWithObject	actionBlock;
@property (copy, nonatomic)		NSURL*				imageURL;

// Relationships
@property (weak, nonatomic, readonly)	JFMenuSection*	section;
@property (weak, nonatomic, readonly)	JFMenuItem*		superitem;

@end



#pragma mark



@interface JFMenuSection : JFMenuNode

@end
