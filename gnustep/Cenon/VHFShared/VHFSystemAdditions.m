/*
 * VHFSystemAdditions.m
 *
 * Copyright (C) 2000 by vhf interservice GmbH
 * Author:   Georg Fleischmann
 *
 * created:  2000-04-30
 * modified: 
 *
 * This file is part of the vhf Shared Library.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the vhf Public License as
 * published by the vhf interservice GmbH. Among other things,
 * the License requires that the copyright notices and this notice
 * be preserved on all copies.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the vhf Public License for more details.
 *
 * You should have received a copy of the vhf Public License along
 * with this library; see the file LICENSE. If not, write to vhf.
 *
 * If you want to link this library to your proprietary software,
 * or for other uses which are not covered by the definitions
 * laid down in the vhf Public License, vhf also offers a proprietary
 * license scheme. See the vhf internet pages or ask for details.
 *
 * vhf interservice GmbH, Im Marxle 3, 72119 Altingen, Germany
 * eMail: info@vhf.de
 * http://www.vhf.de
 */

#include "VHFSystemAdditions.h"

@implementation NSBundle(VHFBundleAdditions)

/* created:  30.04.00
 * modified:
 */
+ (BOOL)loadModelNamed:(NSString*)fileName owner:(id)owner
{
//#ifdef __linux__
//    return [NSBundle loadGModelNamed:fileName owner:owner];
//#else
    return [NSBundle loadNibNamed:fileName owner:owner];
//#endif
}

@end
