//
//  JFTypes.h
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



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Typedefs

typedef NS_ENUM(NSInteger, JFConnectionState) {
	JFConnectionStateUnknown		= -1,
	JFConnectionStateReady			= 0,
	JFConnectionStateConnecting,
	JFConnectionStateConnected,
	JFConnectionStateDisconnecting,
	JFConnectionStateDisconnected,
	JFConnectionStateLost,
	JFConnectionStateReconnecting,
	JFConnectionStateResetting,
};

typedef NS_ENUM(UInt8, JFRelation) {
	JFRelationLessThan,
	JFRelationLessThanOrEqual,
	JFRelationEqual,
	JFRelationGreaterThanOrEqual,
	JFRelationGreaterThan,
};

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Blocks

typedef void	(^JFBlock)					(void);
typedef void	(^JFBlockWithArray)			(NSArray* array);
typedef void	(^JFBlockWithBOOL)			(BOOL value);
typedef void	(^JFBlockWithDictionary)	(NSDictionary* dictionary);
typedef void	(^JFBlockWithError)			(NSError* error);
typedef void	(^JFBlockWithInteger)		(NSInteger value);
typedef void	(^JFBlockWithNotification)	(NSNotification* notification);
typedef void	(^JFBlockWithObject)		(id object);
typedef void	(^JFBlockWithSet)			(NSSet* set);
typedef void	(^JFCompletionBlock)		(BOOL succeeded, id object, NSError* error);
typedef void	(^JFSimpleCompletionBlock)	(BOOL succeeded, NSError* error);

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Math

typedef double	JFDegrees;
typedef double	JFRadians;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Metrics

typedef NS_ENUM(UInt64, JFMetrics) {
	
	// Binary
	JFKibi	= 1024ULL,
	JFMebi	= JFKibi * JFKibi,
	JFGibi	= JFMebi * JFKibi,
	JFTebi	= JFGibi * JFKibi,
	
	// Decimal
	JFKilo	= 1000ULL,
	JFMega	= JFKilo * JFKilo,
	JFGiga	= JFMega * JFKilo,
	JFTera	= JFGiga * JFKilo,
};

////////////////////////////////////////////////////////////////////////////////////////////////////
