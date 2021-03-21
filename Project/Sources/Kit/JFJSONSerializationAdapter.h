//
//	The MIT License (MIT)
//
//	Copyright © 2018-2021 Jacopo Filié
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//

////////////////////////////////////////////////////////////////////////////////////////////////////

@import Foundation;

#import "JFJSONValue.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Classes implementing the JSON serialization adapter protocol can be used to convert JSON data/strings to JSON nodes and viceversa.
 */
@protocol JFJSONSerializationAdapter <NSObject>

// =================================================================================================
// MARK: Methods - Data (Arrays)
// =================================================================================================

/**
 * Converts a JSON data to JSON array.
 * @param jsonData The JSON data to convert.
 * @return The result of the conversion.
 */
- (NSArray<id<JFJSONConvertibleValue>>* __nullable)arrayFromData:(NSData* __nullable)jsonData;

/**
 * Converts a JSON string to JSON array.
 * @param jsonString The JSON string to convert.
 * @return The result of the conversion.
 */
- (NSArray<id<JFJSONConvertibleValue>>* __nullable)arrayFromString:(NSString* __nullable)jsonString;

/**
 * Converts a JSON array to JSON data.
 * @param array The JSON array to convert.
 * @return The result of the conversion.
 */
- (NSData* __nullable)dataFromArray:(NSArray<id<JFJSONConvertibleValue>>* __nullable)array;

/**
 * Converts a JSON array to JSON string.
 * @param array The JSON array to convert.
 * @return The result of the conversion.
 */
- (NSString* __nullable)stringFromArray:(NSArray<id<JFJSONConvertibleValue>>* __nullable)array;

// =================================================================================================
// MARK: Methods - Data (Dictionaries)
// =================================================================================================

/**
 * Converts a JSON dictionary to JSON data.
 * @param dictionary The JSON dictionary to convert.
 * @return The result of the conversion.
 */
- (NSData* __nullable)dataFromDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* __nullable)dictionary;

/**
 * Converts a JSON data to JSON dictionary.
 * @param jsonData The JSON data to convert.
 * @return The result of the conversion.
 */
- (NSDictionary<NSString*, id<JFJSONConvertibleValue>>* __nullable)dictionaryFromData:(NSData* __nullable)jsonData;

/**
 * Converts a JSON string to JSON dictionary.
 * @param jsonString The JSON string to convert.
 * @return The result of the conversion.
 */
- (NSDictionary<NSString*, id<JFJSONConvertibleValue>>* __nullable)dictionaryFromString:(NSString* __nullable)jsonString;

/**
 * Converts a JSON dictionary to JSON string.
 * @param dictionary The JSON dictionary to convert.
 * @return The result of the conversion.
 */
- (NSString* __nullable)stringFromDictionary:(NSDictionary<NSString*, id<JFJSONConvertibleValue>>* __nullable)dictionary;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_END

////////////////////////////////////////////////////////////////////////////////////////////////////
