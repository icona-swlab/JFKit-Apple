//
//  JFXMLParser.m
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



#import "JFXMLParser.h"

#import "JFUtilities.h"



@interface JFXMLParser () <NSXMLParserDelegate>

// Data
@property (assign, nonatomic, readonly)	NSString*		currentElement;
@property (retain)						NSMutableArray*	elementsStack;
@property (retain)						NSMutableArray*	parsedItems;
@property (retain)						NSXMLParser*	rssParser;

// Data management
- (void)	notifyDelegateWithError:(NSError*)error;
- (void)	popElement;
- (void)	pushElement:(NSString*)elementName;

@end



@implementation JFXMLParser

#pragma mark - Properties

// Data
@synthesize	elementsStack	= _elementsStack;
@synthesize	parsedItems		= _parsedItems;
@synthesize	rssParser		= _rssParser;

// Targets
@synthesize	delegate	= _delegate;


#pragma mark - Properties accessors

// Data

- (NSArray*)items
{
	return [self.parsedItems copy];
}

// Targets

-(NSString*)currentElement
{
	if(!self.elementsStack || ([self.elementsStack count] == 0))
		return nil;
	
	return [self.elementsStack lastObject];
}


#pragma mark - Data management

- (void)notifyDelegateWithError:(NSError*)error
{
	if(!self.delegate)
		return;
	
	if(error)
		[self.delegate xmlParser:self didFailOperationWithError:error alreadyParsedItems:self.items];
	else
		[self.delegate xmlParser:self didCompleteOperationWithParsedItems:self.items];
}

- (void)parseXMLData:(NSData*)data
{
	if(!data)
		return;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		self.rssParser = [[NSXMLParser alloc] initWithData:data];
		self.rssParser.delegate = self;
		
		self.rssParser.shouldProcessNamespaces = NO;
		self.rssParser.shouldReportNamespacePrefixes = NO;
		self.rssParser.shouldResolveExternalEntities = NO;
		
		[self.rssParser parse];
	});
}

- (void)parseXMLFileAtURL:(NSURL*)url
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self parseXMLData:[NSData dataWithContentsOfURL:url]];
	});
}

- (void)popElement
{
	if(self.elementsStack && ([self.elementsStack count] > 0))
		[self.elementsStack removeLastObject];
}

- (void)pushElement:(NSString*)elementName
{
	if(!self.elementsStack)
		self.elementsStack = [NSMutableArray array];
	
	[self.elementsStack addObject:elementName];
}


#pragma mark - Parser delegate

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
{
	if(self.rssParser != parser)
		return;
	
	if([self shouldLog])
	{
		NSString* logMessage = [NSString stringWithFormat:@"XML Parser: did end to parse element with name '%@'.", elementName];
		[self.logger logMessage:logMessage level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
	
	id item = [self parserDidEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
	if(item)
		[self.parsedItems addObject:item];
	
	[self popElement];
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict
{
	if(self.rssParser != parser)
		return;
	
	if([self shouldLog])
	{
		NSString* logMessage = [NSString stringWithFormat:@"XML Parser: did start to parse element with name '%@'.", elementName];
		[self.logger logMessage:logMessage level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
	
	[self parserDidStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
	
	[self pushElement:elementName];
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string
{
	if(self.rssParser != parser)
		return;
	
	if([self shouldLog])
	{
		NSString* logMessage = [NSString stringWithFormat:@"XML Parser: found characters for element with name '%@': '%@'.", self.currentElement, string];
		[self.logger logMessage:logMessage level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
	
	[self parserFoundCharacters:string forElement:self.currentElement];
}

- (void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError
{
	if(self.rssParser != parser)
		return;
	
	if([self shouldLog])
	{
		NSString* logMessage = [NSString stringWithFormat:@"XML Parser: stopped document parsing for error '%@'.", parseError];
		[self.logger logMessage:logMessage level:JFLogLevel3Error hashtags:JFLogHashtagError];
	}
	
	[self performSelectorOnMainThread:@selector(notifyDelegateWithError:) withObject:parseError waitUntilDone:NO];
}

- (void)parserDidEndDocument:(NSXMLParser*)parser
{
	if(self.rssParser != parser)
		return;
	
	if([self shouldLog])
	{
		NSString* logMessage = @"XML Parser: ended document parsing.";
		[self.logger logMessage:logMessage level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
	
	[self performSelectorOnMainThread:@selector(notifyDelegateWithError:) withObject:nil waitUntilDone:NO];
}

- (void)parserDidStartDocument:(NSXMLParser*)parser
{
	if(self.rssParser != parser)
		return;
	
	if([self shouldLog])
	{
		NSString* logMessage = @"XML Parser: started document parsing.";
		[self.logger logMessage:logMessage level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}


#pragma mark - Parser management

- (id)parserDidEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
{
	return nil;
}

- (void)parserDidStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict
{}

- (void)parserFoundCharacters:(NSString*)string forElement:(NSString*)element
{}

@end
