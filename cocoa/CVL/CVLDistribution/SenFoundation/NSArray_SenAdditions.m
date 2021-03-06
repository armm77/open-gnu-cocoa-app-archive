/*$Id: NSArray_SenAdditions.m,v 1.11 2005/02/28 13:32:29 stephane Exp $*/

// Copyright (c) 1997-2003, Sen:te (Sente SA).  All rights reserved.
//
// Use of this source code is governed by the license in OpenSourceLicense.html
// found in this distribution and at http://www.sente.ch/software/ ,  where the
// original version of this source code can also be found.
// This notice may not be removed from this file.

#import "NSArray_SenAdditions.h"
#import "SenEmptiness.h"




@implementation NSArray (SenAdditions)

- (id) senFirstObject
{
    return ([self isEmpty]) ? nil : [self objectAtIndex: 0];
}

- (BOOL) containsObjectIdenticalTo:(id) anObject
{
    return [self indexOfObjectIdenticalTo:anObject] != NSNotFound;
}

- (id) senDeepMutableCopy
{
    NSMutableArray	*aCopy = [[NSMutableArray alloc] initWithCapacity:[self count]];
    NSEnumerator	*anEnum = [self objectEnumerator];
    id				anObject;
    NSZone          *aZone = NSDefaultMallocZone();

    // Do not use -copy/mutableCopy, because they are defined in NSObject!
    while ( (anObject = [anEnum nextObject]) ) {
        id	anObjectCopy;

        if([anObject respondsToSelector:@selector(senDeepMutableCopy)])
            anObjectCopy = [anObject senDeepMutableCopy];
        else if([anObject respondsToSelector:@selector(mutableCopyWithZone:)])
            anObjectCopy = [anObject mutableCopyWithZone:aZone];
        else if([anObject respondsToSelector:@selector(copyWithZone:)])
            anObjectCopy = [anObject copyWithZone:aZone];
        else
            anObjectCopy = [anObject retain];
        [aCopy addObject:anObjectCopy];
        [anObjectCopy release];
    }
    return aCopy;
}


- (NSArray *) reversedArray
{
	NSMutableArray *reversedArray = [NSMutableArray arrayWithCapacity:[self count]];
	NSEnumerator *enumerator = [self reverseObjectEnumerator];
	id each;
	while ( (each = [enumerator nextObject]) ) {
		[reversedArray addObject:each];
	}
	return reversedArray;
}

@end
