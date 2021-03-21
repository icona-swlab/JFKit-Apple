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

#import "JFPreprocessorMacros.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// MARK: Aliases
// =================================================================================================

#if JF_IOS

/**
 * An alias for the `UIApplication` class.
 */
#	define JFApplication UIApplication

/**
 * An alias for the `UIApplicationDelegate` protocol.
 */
#	define JFApplicationDelegate UIApplicationDelegate

/**
 * An alias for the `UIImage` class.
 */
#	define JFImage UIImage

/**
 * An alias for the `UIWindow` class.
 */
#	define JFWindow UIWindow

#endif

#if JF_MACOS

/**
 * An alias for the `NSApplication` class.
 */
#	define JFApplication NSApplication

/**
 * An alias for the `NSApplicationDelegate` protocol.
 */
#	define JFApplicationDelegate NSApplicationDelegate

/**
 * An alias for the `NSImage` class.
 */
#	define JFImage NSImage

/**
 * An alias for the `NSWindow` class.
 */
#	define JFWindow NSWindow

#endif

// =================================================================================================
// MARK: Features
// =================================================================================================

#if JF_WEAK_ENABLED

/**
 * An alias for the `weak` property attribute.
 */
#	define JF_WEAK_OR_UNSAFE_UNRETAINED_PROPERTY weak

#else

/**
 * An alias for the `unsafe_unretained` property attribute.
 */
#	define JF_WEAK_OR_UNSAFE_UNRETAINED_PROPERTY unsafe_unretained

#endif

////////////////////////////////////////////////////////////////////////////////////////////////////
