/* NSTextView_SenPanelAdditions.h created by ja on Thu 05-Mar-1998 */

// Copyright (c) 1997-2001, Sen:te Ltd.  All rights reserved.
//
// Use of this source code is governed by the license in OpenSourceLicense.html
// found in this distribution and at http://www.sente.ch/software/ ,  where the
// original version of this source code can also be found.
// This notice may not be removed from this file.

#import <AppKit/AppKit.h>

@interface NSTextView (SenPanelAdditions)
- (NSCell *)selectedCell;
- (id)objectValue;
- (void)setObjectValue:(id)aValue;
- (BOOL)hasValidObjectValue;
@end

