//
//  JFXMLParser.h
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



@class JFXMLParser;



@protocol JFXMLParserDelegate <NSObject>

@required

- (void)	xmlParser:(JFXMLParser*)parser didCompleteOperationWithParsedItems:(NSArray*)items;
- (void)	xmlParser:(JFXMLParser*)parser didFailOperationWithError:(NSError*)error alreadyParsedItems:(NSArray*)items;

@end



#pragma mark



@interface JFXMLParser : NSObject

#pragma mark Properties

// Data
@property (copy, nonatomic, readonly)	NSArray*	items;

// Relationships
@property (strong)	id<JFXMLParserDelegate>	delegate;


#pragma mark Methods

// Data management
- (void)	parseXMLData:(NSData*)data;
- (void)	parseXMLFileAtURL:(NSURL*)url;

// Parser management
- (id)		parserDidEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName;
- (void)	parserDidStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict;
- (void)	parserFoundCharacters:(NSString*)string forElement:(NSString*)element;

@end
