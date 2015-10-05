//
//  JFMenuController.h
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



#pragma mark - Typedefs

typedef void (^JFMenuItemBlock) (id sender);



#pragma mark



@interface JFMenuController : UIViewController

@end



#pragma mark



@interface JFMenuItem : NSObject <NSCopying>

#pragma mark Properties

// Data
@property (strong, nonatomic)	JFMenuItemBlock	actionBlock;
@property (copy, nonatomic)		NSDictionary*	additionalInfo;
@property (copy, nonatomic)		NSString*		detailText;
@property (copy, nonatomic)		NSURL*			imageURL;
@property (copy, nonatomic)		NSString*		title;

// Relationships
@property (strong, nonatomic, readonly)	NSArray<JFMenuItem*>*	subitems;
@property (weak, nonatomic, readonly)	JFMenuItem*				superitem;


#pragma mark Methods

// Relationships management
- (void)	addSubitem:(JFMenuItem*)item;
- (void)	addSubitems:(NSArray<JFMenuItem*>*)items;
- (void)	insertSubitem:(JFMenuItem*)item atIndex:(NSUInteger)index;
- (void)	insertSubitems:(NSArray<JFMenuItem*>*)items atIndex:(NSUInteger)index;
- (void)	removeSubitem:(JFMenuItem*)item;
- (void)	removeSubitems:(NSArray<JFMenuItem*>*)items;

@end
