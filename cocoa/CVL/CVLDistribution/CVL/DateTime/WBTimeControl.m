/*
    Redistribution and use in source and binary forms, with or without modification,
    are permitted provided that the following conditions are met:

	Redistributions of source code must retain this list of conditions and the following disclaimer.

	The names of its contributors may not be used to endorse or promote products derived from this
    software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTORS "AS IS" AND ANY 
    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
    OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT 
    SHALL THE CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT 
    OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

    06/25/03:
        Fix a bug in acceptNewValueInSelectedCell
        
    10/16/04:
        Fix a bug occurring with double-clicks
        Support for proper tabbing
        Support enable/disable state
*/

#import "WBTimeControl.h"

#define WBTIMECONTROL_LEFT_OFFSET		3.5
#define WBTIMECONTROL_INTERCELL_SPACE	4
#define WBTIMECONTROL_RIGHT_OFFSET		3
#define WBTIMECONTROL_TOP_OFFSET		3
#define WBTIMECONTROL_BOTTOM_OFFSET		9

int _WBTimeControlMax[WBTIMECONTROL_CELL_COUNT]={23,59,59};

@implementation WBTimeControl

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        int i;
        NSRect tCellFrame;
        
        // No cell selected
        
        selected=WBTIMECONTROL_HOUR_ID;
        
        isUsingFieldEditor=NO;
        
        // Set the default date
        
        currentDate=[[NSCalendarDate calendarDate] retain];
        
        // Create the 3 cells
        
        for(i=0;i<WBTIMECONTROL_CELL_COUNT;i++)
        {
            cells[i]=[[NSTextFieldCell alloc] initTextCell:@""];
            [(NSTextFieldCell *) cells[i] setDrawsBackground:YES];
            [(NSTextFieldCell *) cells[i] setEditable:YES];
            [(NSTextFieldCell *) cells[i] setBordered:NO];
            [(NSTextFieldCell *) cells[i] setFont:[NSFont labelFontOfSize:13]];
        }
        
        // Set the default values
        
        [(NSTextFieldCell *) cells[WBTIMECONTROL_HOUR_ID] setStringValue:[NSString stringWithFormat:@"%02d",[currentDate hourOfDay]]];
        [(NSTextFieldCell *) cells[WBTIMECONTROL_MINUTE_ID] setStringValue:[NSString stringWithFormat:@"%02d",[currentDate minuteOfHour]]];
        [(NSTextFieldCell *) cells[WBTIMECONTROL_SECOND_ID] setStringValue:[NSString stringWithFormat:@"%02d",[currentDate secondOfMinute]]];
        
        // Create the 2 colon cells
        
        for(i=0;i<(WBTIMECONTROL_CELL_COUNT-1);i++)
        {
            colonCells[i]=[[NSTextFieldCell alloc] initTextCell:@":"];
            [(NSTextFieldCell *) colonCells[i] setDrawsBackground:NO];
            [(NSTextFieldCell *) colonCells[i] setEditable:NO];
            [(NSTextFieldCell *) colonCells[i] setBordered:NO];
            [(NSTextFieldCell *) colonCells[i] setFont:[NSFont labelFontOfSize:13]];
        }
        
        // Compute the Cells' frame
        
        tCellFrame.origin.x=WBTIMECONTROL_LEFT_OFFSET;
        tCellFrame.origin.y=WBTIMECONTROL_BOTTOM_OFFSET;
        
        tCellFrame.size.width=(NSWidth(frame)-2*WBTIMECONTROL_INTERCELL_SPACE-WBTIMECONTROL_RIGHT_OFFSET-WBTIMECONTROL_LEFT_OFFSET)/3;
        tCellFrame.size.height=NSHeight(frame)-WBTIMECONTROL_TOP_OFFSET-WBTIMECONTROL_BOTTOM_OFFSET;
        
        for(i=0;i<WBTIMECONTROL_CELL_COUNT;i++)
        {
            rects[i]=tCellFrame;
            
            tCellFrame.origin.x=NSMaxX(tCellFrame)+WBTIMECONTROL_INTERCELL_SPACE;
        }
        
        // Compute the Colons' frame
        
        for(i=0;i<(WBTIMECONTROL_CELL_COUNT-1);i++)
        {
        	colonRects[i]=tCellFrame;
            
            colonRects[i].origin.x=NSMaxX(rects[i])-3;
            colonRects[i].size.width=NSMinX(rects[i+1])-NSMinX(colonRects[i])-1;
        }
    }
    
    return self;
}

- (id) date
{
    return [[currentDate retain] autorelease];
}

- (void) setDate:(id) aDate
{
    if ([currentDate isEqualToDate:aDate]==NO)
    {
        if (currentDate!=aDate)
        {
            [currentDate release];
        	currentDate=[aDate copy];
        }
    
        [self editOff];
        
        [cells[WBTIMECONTROL_HOUR_ID] setStringValue:[NSString stringWithFormat:@"%02d",[self hour]]];
        [cells[WBTIMECONTROL_MINUTE_ID] setStringValue:[NSString stringWithFormat:@"%02d",[self minute]]];
        [cells[WBTIMECONTROL_SECOND_ID] setStringValue:[NSString stringWithFormat:@"%02d",[self second]]];
    }
}

#pragma mark -

- (void) setEnabled:(BOOL) enabled
{
    int i;
    
    for(i=0;i<WBTIMECONTROL_CELL_COUNT;i++)
    {
        [cells[i] setEnabled:enabled];
    }

    if (stepper!=nil)
    {
        [stepper setEnabled:enabled];
    }

    [super setEnabled:enabled];
}

#pragma mark -

- (void) setDelegate:(id) aDelegate
{
    if (delegate!=nil)
    {
        [[NSNotificationCenter defaultCenter]  removeObserver:delegate
                                                         name:nil
                                                       object:self];
    }
  
    delegate = aDelegate;

	if ([delegate respondsToSelector: @selector(controlTextDidEndEditing:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver: delegate
                                                 selector: @selector(controlTextDidEndEditing:)
                                                     name: NSControlTextDidEndEditingNotification
                                                   object: self];
    
    }
}

- (void)setHour:(int)aHour
{
    int tHour=[self hour];
    
    if (aHour>=0 && aHour<=_WBTimeControlMax[WBTIMECONTROL_HOUR_ID])
    {
        NSCalendarDate * tDate;
        
        tDate=[currentDate dateByAddingYears:0
                                      months:0
                                        days:0
                                       hours:aHour-tHour
                                     minutes:0
                                     seconds:0];
        
        [currentDate release];
        
        currentDate=[tDate retain];
    
        stepperMidValue=aHour;
        
        if (isUsingFieldEditor==YES && selected==WBTIMECONTROL_HOUR_ID)
        {
            [[self currentEditor] setString:[NSString stringWithFormat:@"%02d",aHour]];
                
            [self editOff];
        }
        else
        {
            [cells[WBTIMECONTROL_HOUR_ID] setStringValue:[NSString stringWithFormat:@"%02d",aHour]];
        }
    }
}

- (int)hour
{
    return [currentDate hourOfDay];
}

- (void)setMinute:(int)aMinute
{
    int tMinute=[self minute];
        
    if (aMinute>=0 && aMinute<=_WBTimeControlMax[WBTIMECONTROL_MINUTE_ID])
    {
        NSCalendarDate * tDate;
        
        tDate=[currentDate dateByAddingYears:0
                                      months:0
                                        days:0
                                       hours:0
                                     minutes:aMinute-tMinute
                                     seconds:0];
        
        [currentDate release];
        
        currentDate=[tDate retain];
    
        stepperMidValue=aMinute;
        
        if (isUsingFieldEditor==YES && selected==WBTIMECONTROL_MINUTE_ID)
        {
            [[self currentEditor] setString:[NSString stringWithFormat:@"%02d",aMinute]];
                
            [self editOff];
        }
        else
        {
            [cells[WBTIMECONTROL_MINUTE_ID] setStringValue:[NSString stringWithFormat:@"%02d",aMinute]];
        }
    }
}

- (int)minute
{
    return [currentDate minuteOfHour];
}

- (void)setSecond:(int)aSecond
{
    int tSecond=[self second];
    
    if (aSecond>=0 && aSecond<=_WBTimeControlMax[WBTIMECONTROL_SECOND_ID])
    {
        NSCalendarDate * tDate;
        
        tDate=[currentDate dateByAddingYears:0
                                      months:0
                                        days:0
                                       hours:0
                                     minutes:0
                                     seconds:aSecond-tSecond];
        
        [currentDate release];
        
        currentDate=[tDate retain];
        
        stepperMidValue=aSecond;
        
        if (isUsingFieldEditor==YES && selected==WBTIMECONTROL_SECOND_ID)
        {
            [[self currentEditor] setString:[NSString stringWithFormat:@"%02d",aSecond]];
                
            [self editOff];
        }
        else
        {
            [cells[WBTIMECONTROL_SECOND_ID] setStringValue:[NSString stringWithFormat:@"%02d",aSecond]];
        }
    }
}

- (int)second
{
    return [currentDate secondOfMinute];
}

- (int)selected
{
    return selected;
}

- (void)setSelected:(int)aSelected
{
    selected=aSelected;
    
    if (stepper!=nil)
    {
        [stepper setMinValue:0];
        [stepper setMaxValue:_WBTimeControlMax[selected]];
        
        switch(selected)
        {
            case WBTIMECONTROL_HOUR_ID:
                [stepper setIntValue:[self hour]];
                break;
            case WBTIMECONTROL_MINUTE_ID:
                [stepper setIntValue:[self minute]];
                break;
            case WBTIMECONTROL_SECOND_ID:
                [stepper setIntValue:[self second]];
                break;
        }
        
        stepperMidValue=[stepper doubleValue];
    }
    
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    [self setSelected:WBTIMECONTROL_HOUR_ID];
}

- (BOOL) isOpaque
{
    return NO;
}

- (void) drawRect:(NSRect) aFrame
{
    int i;
    NSRect tBounds=[self bounds];
    NSRect tRect;
    float savedLineWidth;
    
    [[NSColor whiteColor] set];

    // Draw the background
    
    tRect=tBounds;
    tRect.origin.y=WBTIMECONTROL_BOTTOM_OFFSET-3;
    
    tRect.size.height-=tRect.origin.y;
    
    NSRectFill(tRect);
    
    // Draw the Frame
    
    [[NSColor colorWithDeviceWhite:0.3333 alpha:1.0] set];
    
    [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(tRect)+0.5,NSMinY(tRect)+1) 
                              toPoint:NSMakePoint(NSMinX(tRect)+0.5,NSMaxY(tRect))];
    
    [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(tRect),NSMaxY(tRect)-0.5)
                              toPoint:NSMakePoint(NSMaxX(tRect),NSMaxY(tRect)-0.5)];
    
    [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(tRect)+1.5,NSMinY(tRect)+2) 
                              toPoint:NSMakePoint(NSMinX(tRect)+1.5,NSMaxY(tRect)-1)];
    
    [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(tRect)+1,NSMaxY(tRect)-1.5)
                              toPoint:NSMakePoint(NSMaxX(tRect)-1,NSMaxY(tRect)-1.5)];
    
    [[NSColor colorWithDeviceWhite:0.6667 alpha:1.0] set];
    
    [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(tRect)+1,NSMinY(tRect)+1.5) 
                              toPoint:NSMakePoint(NSMaxX(tRect)-1,NSMinY(tRect)+1.5)];
    
    [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMaxX(tRect)-1.5,NSMinY(tRect)+1) 
                              toPoint:NSMakePoint(NSMaxX(tRect)-1.5,NSMaxY(tRect)-2)];
    
    // Draw the selection thumb
    
    [[NSColor colorWithDeviceWhite:0.5765 alpha:1.0] set];
    
    savedLineWidth=[NSBezierPath defaultLineWidth];
    
    [NSBezierPath setDefaultLineWidth:2];
    
    [NSBezierPath strokeLineFromPoint:NSMakePoint(floor(NSMidX(rects[selected]))-4,WBTIMECONTROL_BOTTOM_OFFSET-8) 
                              toPoint:NSMakePoint(floor(NSMidX(rects[selected])),WBTIMECONTROL_BOTTOM_OFFSET-4)];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(floor(NSMidX(rects[selected])),WBTIMECONTROL_BOTTOM_OFFSET-4)
                              toPoint:NSMakePoint(floor(NSMidX(rects[selected]))+4,WBTIMECONTROL_BOTTOM_OFFSET-8)];
    
    [NSBezierPath setDefaultLineWidth:savedLineWidth];
    
    // Draw the Time Separator
    
    for(i=0;i<(WBTIMECONTROL_CELL_COUNT-1);i++)
    {
        [colonCells[i] drawWithFrame:colonRects[i] inView:self];
    }
    
    // Draw the cells
    
    for(i=0;i<WBTIMECONTROL_CELL_COUNT;i++)
    {
        [cells[i] drawWithFrame:rects[i] inView:self];
    }
}

- (void) mouseDown:(NSEvent *) theEvent
{
    if ([self isEnabled]==YES)
    {
        int i;
        NSPoint tMouseLoc=[self convertPoint:[theEvent locationInWindow] fromView:nil];
        NSRect tThumbRect;
        NSRect tBounds;
        float tWidth;
        
        // Find where the event occurred
        
        tBounds=[self bounds];
        
        tWidth=NSWidth(tBounds)/3;
        
        // Either in the thumb part
        
        for(i=0;i<WBTIMECONTROL_CELL_COUNT;i++)
        {
            tThumbRect=NSMakeRect(tWidth*i,0,tWidth,WBTIMECONTROL_BOTTOM_OFFSET-4);
            
            if (NSMouseInRect(tMouseLoc,tThumbRect,[self isFlipped])==YES)
            {
                if (i!=selected)
                {
                    if (isUsingFieldEditor==YES)
                    {
                        [self editOff];
                    }
                    
                    [self setSelected:i];
                    
                }
                
                break;
            }
        }
        
        // Or in a cell
        
        for(i=0;i<WBTIMECONTROL_CELL_COUNT;i++)
        {
            if (NSMouseInRect(tMouseLoc,rects[i],[self isFlipped])==YES)
            {
                if (i!=selected || isUsingFieldEditor==NO)
                {
                    if (isUsingFieldEditor==YES)
                    {
                        [self editOff];
                    }
                    else
                    {
                        [_window endEditingFor:nil];
                    
                        [_window makeFirstResponder: self];
                    }
            
                    [self editCell:i];
                }
                else
                {
                    if (isUsingFieldEditor==NO)
                    {
                        [cells[selected] editWithFrame:rects[selected]
                                                inView:self
                                                editor:[self currentEditor]
                                              delegate:self
                                                 event:theEvent];
                    }
                }
                
                break;
            }
        }
    }
}

- (BOOL)acceptNewValueInSelectedCell:(id) sender
{
	NSString *string;
    int tValue;
	
    string = [[[[self currentEditor] string] copy] autorelease];

    tValue=[string intValue];
    
    if (tValue<=_WBTimeControlMax[selected])
    {
        [cells[selected] setStringValue: [NSString stringWithFormat:@"%02d",tValue]];
                
        // Set the new date
        
        switch(selected)
        {
            case WBTIMECONTROL_HOUR_ID:
                [self setHour:tValue];
                break;
            case WBTIMECONTROL_MINUTE_ID:
                [self setMinute:tValue];
                break;
            case WBTIMECONTROL_SECOND_ID:
                [self setSecond:tValue];
                break;
        }
        
        return YES;
    }

    
    return NO;
}

- (void)editCell:(int) aSelected
{
    NSText *tObject;
    NSText* t = [_window fieldEditor: YES forObject: self];
    int length;
    id tCell=cells[aSelected];
    
    length = [[tCell stringValue] length];
    
    tObject = [tCell setUpFieldEditorAttributes: t];
    
    [tCell selectWithFrame: rects[aSelected]
                    inView: self
                    editor: tObject
                  delegate: self
                     start: 0
                    length: length];
    
    isUsingFieldEditor=YES;
    
    [self setSelected:aSelected];
}

- (void)editOff
{
    if (isUsingFieldEditor==YES)
    {
        [cells[selected] endEditing: [self currentEditor]];
    
        isUsingFieldEditor=NO;
    }
}

- (void) textDidEndEditing:(NSNotification *) aNotification
{
	NSMutableDictionary * tDictionary;
	id textMovement;
    BOOL wasAccepted;
    
    wasAccepted=[self acceptNewValueInSelectedCell:self];
    
    [cells[selected] endEditing: [aNotification object]];

    if (wasAccepted==YES)
    {
        tDictionary = [[[NSMutableDictionary alloc] initWithDictionary:[aNotification userInfo]] autorelease];
    
        [tDictionary setObject: [aNotification object] forKey: @"NSFieldEditor"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: NSControlTextDidEndEditingNotification
                                                            object: self
                                                          userInfo: tDictionary];
    }
    
    isUsingFieldEditor=NO;
    
    textMovement = [[aNotification userInfo] objectForKey: @"NSTextMovement"];
    
    if (textMovement)
    {
        switch ([(NSNumber *)textMovement intValue])
        {
            case NSReturnTextMovement:
                if ([self sendAction:[self action] to:[self target]] == NO)
                {
                    NSEvent *event = [_window currentEvent];
        
                    if ([self performKeyEquivalent: event] == NO
                        && [_window performKeyEquivalent: event] == NO)
                    {
                        
                    }
                }
                break;
            case NSTabTextMovement:
                if (selected<WBTIMECONTROL_SECOND_ID)
                {
                    [self editCell:selected+1];
                    break;
                }
                
                [_window selectKeyViewFollowingView: self];
                
                if ([_window firstResponder] == _window)
                {
                    [self editCell:WBTIMECONTROL_HOUR_ID];
                }
                break;
            case NSBacktabTextMovement:
                if (selected>WBTIMECONTROL_HOUR_ID)
                {
                    [self editCell:selected-1];
                    break;
                }
                
                [_window selectKeyViewFollowingView: self];
        
                if ([_window firstResponder] == _window)
                {
                    [self editCell:WBTIMECONTROL_SECOND_ID];
                }
                break;
        }
    }
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
    int i,tLength;
    unichar tUniChar;
    
    tLength=[replacementString length];
    
    if (affectedCharRange.location>=2 || affectedCharRange.length>2)
    {
        return NO;
    }
    
    for(i=0;i<tLength;i++)
    {
        tUniChar=[replacementString characterAtIndex:i];
        
        if (tUniChar<'0' || tUniChar>'9')
        {
            return NO;
        }
    }
    
    if (stepper!=nil)
    {
        NSMutableString * tString;
        int tValue;
        
        tString=[[[textView string] mutableCopy] autorelease];
        
        [tString replaceCharactersInRange:affectedCharRange withString:replacementString];
        
        tValue=[tString intValue];
        
        if (tValue>_WBTimeControlMax[selected])
        {
            [stepper setDoubleValue:stepperMidValue];
        }
        else
        {
            [stepper setIntValue:tValue];
        }

    }
    
    return YES;
}

- (BOOL)acceptsFirstResponder
{
    // We want to be able to become first responder
    return [self isEnabled];
}

- (BOOL)needsPanelToBecomeKey
{
    // We want to get focus via mouse down AND tabbing
    
    return YES;
}

- (BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];

    if (result)
    {
        NSSelectionDirection selectionDirection = [[self window] keyViewSelectionDirection];
        if (selectionDirection==NSSelectingNext)
        {
            [self editCell:0];
        }
        else if (selectionDirection==NSSelectingPrevious)
        {
            [self editCell:WBTIMECONTROL_CELL_COUNT-1];
        }
        else
        {
            // Direct selection by clicking.  Let the mouse down code figure out which cell to edit.
        }
    }
    
    return result;
}

@end
