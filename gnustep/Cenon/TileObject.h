/* TileObject.m
 * Object managing batch production
 *
 * Copyright (C) 1996-2002 by vhf interservice GmbH
 * Author: Georg Fleischmann
 *
 * Created:  1996-05-10
 * Modified: 2002-07-15
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the vhf Public License as
 * published by vhf interservice GmbH. Among other things, the
 * License requires that the copyright notices and this notice
 * be preserved on all copies.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the vhf Public License for more details.
 *
 * You should have received a copy of the vhf Public License along
 * with this program; see the file LICENSE. If not, write to vhf.
 *
 * vhf interservice GmbH, Im Marxle 3, 72119 Altingen, Germany
 * eMail: info@vhf.de
 * http://www.vhf.de
 */

#ifndef VHF_H_TILEOBJECT
#define VHF_H_TILEOBJECT

#include <Foundation/Foundation.h>

@interface TileObject:NSObject
{
    NSPoint	position;
    float	angle;
}

- init;

- (void)setPosition:(NSPoint)p;
- (NSPoint)position;

- (void)setAngle:(float)a;
- (float)angle;

- (void)dealloc;

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end

#endif // VHF_H_TILEOBJECT
