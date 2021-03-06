/*$Id: NSNumber_Extensions.m,v 1.2 2003/07/25 16:08:01 phink Exp $*/

// Copyright (c) 1997-2003, Sen:te (Sente SA).  All rights reserved.
//
// Use of this source code is governed by the license in OpenSourceLicense.html
// found in this distribution and at http://www.sente.ch/software/ ,  where the
// original version of this source code can also be found.
// This notice may not be removed from this file.

#import "NSNumber_Extensions.h"
#import <SenFoundation/SenFoundation.h>

@implementation NSNumber (Extensions)
+ (NSNumber *) zero
{
    static NSNumber *zero = nil;
    if (zero == nil) {
        zero = [[NSNumber alloc] initWithInt:0];
    }
    return zero;
}


+ (NSNumber *) one
{
    static NSNumber *one = nil;
    if (one == nil) {
        one = [[NSNumber alloc] initWithInt:1];
    }
    return one;

}
@end
