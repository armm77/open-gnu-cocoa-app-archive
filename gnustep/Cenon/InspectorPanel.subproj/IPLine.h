/* IPLine.h
 * Line Inspector
 *
 * Copyright (C) 1995-2002 by vhf interservice GmbH
 * Author:   Georg Fleischmann
 *
 * created:  1995-12-09
 * modified: 2002-07-20
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

#ifndef VHF_H_IPLINE
#define VHF_H_IPLINE

#include <AppKit/AppKit.h>
#include "IPBasicLevel.h"

@interface IPLine:IPBasicLevel
{
    id	xField;
    id	yField;
    id	angleField;
    id	angleSlider;
    id	lengthField;
    id	endXField;
    id	endYField;

    VGraphic	*graphic;	// the loaded graphic or the first of them if multiple
}

- (void)update:sender;

- (void)setPointX:sender;
- (void)setPointY:sender;
- (void)setAngle:sender;
- (void)setLength:sender;
- (void)setEndX:sender;
- (void)setEndY:sender;

- (void)displayWillEnd;

@end

#endif // VHF_H_IPLINE
