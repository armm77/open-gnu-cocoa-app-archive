//
//  CvsCommitPanelController.m
//  CVL
//
//  Created by William Swats on Fri Jan 16 2004.
//  Copyright (c) 2004 Sente SA. All rights reserved.
//

/*" This class is used to display a panel where the user can type in a commit
    message. If the "Use Templates" checkbox in the preferences is turned on 
    then this class will display that template content in the panel first.
"*/

#import "CvsCommitPanelController.h"

#import <SenFoundation/SenFoundation.h>
#import <NSString+Lines.h>
#import "CVLDelegate.h"
#import "WorkAreaViewer.h"
#import "CVLTextView.h"
#import <CvsCommitRequest.h>



@implementation CvsCommitPanelController


- (id)initWithWindowNibName:(NSString *)windowNibName
    /*" This is the desinated initializer for this class. Since this is a 
        subclass of NSWindowController we first call super's implementation. 
        That implementation returns an NSWindowController object initialized 
        with windowNibName, the name of the nib file 
        (minus the “.nib” extension) that archives the receiver’s window. The 
        windowNibName argument cannot be nil. Sets the owner of the nib file to 
        the receiver. The default initialization turns on cascading, sets the 
        shouldCloseDocument flag to NO, and sets the autosave name for the 
        window’s frame to an empty string. 

        Here in this subclass we set the autosave name for the window’s frame to 
        the name of the window nib name. We also initialize the commitHistory 
        dictionary.
    "*/
{
    self = [super initWithWindowNibName:windowNibName];
    if ( self != nil ) {
        commitHistory = [[NSMutableDictionary alloc] initWithCapacity:1];
        [self setWindowFrameAutosaveName:windowNibName];
    }
    return self;
}

- (void) dealloc
    /*" This method releases our instance variables.
    "*/
{
    RELEASE(committingFiles);
    RELEASE(commitHistory);
    RELEASE(templateFile);
    
    [super dealloc];
}

- (int)showAndRunModal
    /*" This method displays our window, updates it and runs it inside a modal 
        loop. After the modal loop is terminated the window is closed and this 
        method returns the result of the modal loop. That result is either 
        NSOKButton or NSCancelButton depending whether the user clicked on the 
        #Ok buton or the #Cancel button.

        This method should not be called outside of the class.
    "*/
{
    [self showWindow:self];
    [self updateGui];

    modalResult = -1;
    
    modalResult= [NSApp runModalForWindow:[self window]];
    [[self window] orderOut:self];
    return modalResult;
}

- (IBAction)cancel:(id)sender
    /*" This is an action method that terminates the modal loop with a return 
        value of NSCancelButton.
    "*/
{
    modalResult = NSCancelButton;
    [NSApp stopModalWithCode:modalResult];
}


- (IBAction)ok:(id)sender
    /*" This is an action method that terminates the modal loop with a return 
        value of NSOKButton.
    "*/
{
    modalResult = NSOKButton;
    [NSApp stopModalWithCode:modalResult];
}

- (NSString *)commitMessage
    /*" This method returns an autoreleased copy of the commit message that is 
        currently displayed in the commit panel. Note: a copy is returned here 
        instead of a pointer because a pointer would be pointing to nothing 
        after the window closed.
    "*/
{
    NSString *aCommitMessage = nil;

    SEN_ASSERT_NOT_NIL(commitMessageTextView);
    
    aCommitMessage = [commitMessageTextView string];

    return [[aCommitMessage copy] autorelease];
}

- (NSString *) filteredTemplateContent
    /*" When using templates CVS adds a bunch of lines beginning with "CVS:" not
        including the double qoute marks, to the template file content. This 
        method strips those lines away. So the user can decide via preferences
        whether or not he wants to see the commit panel displaying the template
        content with or without the CVS added lines. Note: when committing CVS 
        automatically strips these lines away from the commit message.
    "*/
{
	// First line is always empty (added automatically by cvs) => remove it
	// CVS adds a block beginning with "CVS: ----------------------------------------------------------------------"
	// up to the end; there's a line beginning with "CVS: Modified Files:": following lines are like this:
	// "CVS:    files...".
    NSString        *myTemplateContent = nil;
    NSString        *myFilteredTemplateContent = nil;
    NSString        *aLine = nil;
    NSArray         *someLines = nil;
    NSMutableArray	*filteredLines = nil;
    NSEnumerator    *aLineEnumerator = nil;
    BOOL            filterCvsTemplate = NO;
    
    myTemplateContent = [self templateContent];
    filterCvsTemplate = [[NSUserDefaults standardUserDefaults] 
                            boolForKey:@"FilterCvsTemplate"];
    if ( filterCvsTemplate == NO ) {
        return myTemplateContent;
    }
    
    if ( isNilOrEmpty(myTemplateContent) ) {
        return myTemplateContent;
    }
    
    filteredLines = [NSMutableArray array];    
    someLines = [myTemplateContent lines];
    aLineEnumerator = [someLines objectEnumerator];
    while ( (aLine = [aLineEnumerator nextObject]) ) {
        if ( [aLine hasPrefix:@"CVS:"] == NO ) {
            [filteredLines addObject:aLine];
        }        
    }    
    myFilteredTemplateContent = [filteredLines componentsJoinedByString:@"\n"];
    
    return myFilteredTemplateContent;
}

- (NSArray *)committingFiles
    /*" This is the get method for the instance variable named committingFiles.
        This array contains the relative file paths of the files and/or folders
        to be committed. Here relative means relative to the root of the
        workarea.

        See also #{-setCommittingFiles:}
    "*/
{
	return committingFiles;
}

- (void)setCommittingFiles:(NSArray *)newCommittingFiles
    /*" This is the set method for the instance variable named committingFiles. 
        This array contains the relative file paths of the files and/or folders
        to be committed. Here relative means relative to the root of the
        workarea.

        See also #{-committingFiles}
    "*/
{
    ASSIGN(committingFiles, newCommittingFiles);
}

- (NSDictionary *)commitHistory
    /*" This is the get method for the instance variable named commitHistory. 
        This is the dictionary that contains the commit history. The keys are 
        strings representing the datetime and the values are the commit messages.

        See also #{-setCommitHistory:}
    "*/
{
	return commitHistory;
}

- (void)setCommitHistory:(NSDictionary *)newCommitHistory
    /*" This is the set method for the instance variable named commitHistory. 
        This is the dictionary that contains the commit history. The keys are 
        strings representing the datetime and the values are the commit messages.

        See also #{-commitHistory}
    "*/
{
    NSMutableDictionary *newMutableCommitHistory = nil;
    
    if ( isNotEmpty(newCommitHistory) ) {
        newMutableCommitHistory = [NSMutableDictionary 
                                    dictionaryWithDictionary:newCommitHistory];
    } else {
        newMutableCommitHistory = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    ASSIGN(commitHistory, newMutableCommitHistory);
}

- (NSString *)templateFile
    /*" This is the get method for the instance variable named templateFile. 
        The templateFile is a file path to the file that contains the template 
        plus content automatically added by CVS in terms of lines beginning with 
        "CVS:" without the double qoute marks. This file is a temporary file
        that usually (always?) resides in the /tmp directory.

        See also #{-setTemplateFile:}
    "*/
{
	return templateFile;
}

- (void)setTemplateFile:(NSString *)newTemplateFile
    /*" This is the set method for the instance variable named templateFile. 
        The templateFile is a file path to the file that contains the template 
        plus content automatically added by CVS in terms of lines beginning with 
       "CVS:" without the double qoute marks. This file is a temporary file
        that usually (always?) resides in the /tmp directory.

        See also #{-templateFile}
    "*/
{
    ASSIGN(templateFile, newTemplateFile);
}

- (NSString *)templateContent
    /*" This method returns the content of the template file as a string. If the
        template file could not be opened then an alert panel is displayed to 
        the user.
    "*/
{
    NSString *myTemplateContent = nil;
    NSString *myTemplateFile = nil;
    
    myTemplateFile = [self templateFile];
    if ( isNotEmpty(myTemplateFile) ) {
        myTemplateContent = [NSString stringWithContentsOfFile:myTemplateFile];
        if ( myTemplateContent == nil ) {
            // Could not open the template file.
            (void)NSRunAlertPanel(@"Commit",
                                  @"Could not open the template file at \"%@\".", 
                                  nil, nil, nil, myTemplateFile);            
        }
    }
    return myTemplateContent;
}

- (IBAction)insertCommitMessageFrom:(id)sender
    /*" This action method inserts the commit message from the "Commit History"
        pull down button into the text view of the commit panel.
    "*/
{
    NSMenuItem *theSelectedItem = nil;
    NSString *aCommitMessage = nil;
    
    SEN_ASSERT_CONDITION((commitHistoryPopUpButton == sender));
    
    theSelectedItem = (NSMenuItem *)[commitHistoryPopUpButton selectedItem];
    //aTitle = [theSelectedItem title];
    aCommitMessage = [theSelectedItem representedObject];
    [commitMessageTextView setString:aCommitMessage];
    [self updateControls];
}

- (IBAction)clearCommitMessageHistory:(id)sender
    /*" This action method clears all of the commit messages from the "Commit 
        History" pull down button.
    "*/
{
    int aChoice = NSAlertDefaultReturn;

    aChoice = NSRunAlertPanel(@"CVL Clear Commit History", 
                  @"Do you really want to clear the CVS Commit History?", 
                  @"No", @"Yes", nil);
    if ( aChoice == NSAlertAlternateReturn ) {
        [self setCommitHistory:nil];
        [self updateGui];
    }
}

- (IBAction)clear:(id)sender
    /*" This action method clears the text view in the commit panel of any 
        commit message therein.
    "*/
{
    SEN_ASSERT_NOT_NIL(commitMessageTextView);

    [commitMessageTextView setString:@""];
    [self updateControls];
}

- (void)updateGui
    /*" This method updates the GUI by calling the methods #updatePullDownButton,
        #updateTitle, #updateCommitMessageTextView and #updateControls. Note;
        the method #updateCommitMessageTextView should be called before 
        #updateControls since the controls depend on what is in the commit 
        message TestView.
    "*/
{
    [self updatePullDownButton];
    [self updateTitle];
    if ( doNotUpdateCommitMessageTextView == NO ) {
        [self updateCommitMessageTextView];
    }
    [self updateControls];
    if ( (useCvsTemplates == YES) && (hasShownTemplatesAlert == NO) ) {
        NSBeginAlertSheet(@"Commit", nil, nil, nil, 
                          [self window], nil, NULL, NULL, NULL,
                          @"When using templates this commit panel will appear for each sub-directory. This seems to be a feature of CVS that cannot be turned off.");            
        hasShownTemplatesAlert = YES;
    }
}

- (void)updatePullDownButton
    /*" This method updates the "Commit History" pull down button. It adds all
        of the commit history in the dictionary commitHistory to the pull down 
        button in reverse chronological order (i.e. last items first).
    "*/
{
    NSString *aCommitMessage = nil;
    NSString *aLine = nil;
    NSString *aDateTimeString = nil;
    NSDate *aDateTime = nil;
    NSEnumerator *anEnumerator = nil;
    NSArray *someLines = nil;
    NSArray *allTheKeys = nil;
    NSArray *sortedKeys = nil;
    NSMenuItem *theSelectedItem = nil;
    NSString *aTitle = nil;
    unsigned int aCount = 0;
    BOOL separatorItemEncountered = NO;
    
    // First remove all items between the first one and the item separator.
    // NB: the first one holds the title of the pulldown and the item separator
    // separates the history items from the "Clear Menu" item.
    theSelectedItem = (NSMenuItem *)[commitHistoryPopUpButton itemAtIndex:1];
    separatorItemEncountered = [theSelectedItem isSeparatorItem];
    while ( separatorItemEncountered == NO ) {
        [commitHistoryPopUpButton removeItemAtIndex:1];
        theSelectedItem = (NSMenuItem *)[commitHistoryPopUpButton itemAtIndex:1];
        separatorItemEncountered = [theSelectedItem isSeparatorItem];
    }
    
    if ( isNotEmpty(commitHistory) ) {
        // Sort history into datetime order.
        allTheKeys = [commitHistory allKeys];
        sortedKeys = [allTheKeys sortedArrayUsingSelector:@selector(compare:)];
        aCount = [commitHistory count];
        anEnumerator = [sortedKeys objectEnumerator];
        while ( (aDateTimeString = [anEnumerator nextObject]) ) {
            aCommitMessage = [commitHistory objectForKey:aDateTimeString];
            someLines = [aCommitMessage lines];
            aLine = [someLines objectAtIndex:0];
            aDateTime = [NSDate dateWithString:aDateTimeString];
            aTitle = [NSString stringWithFormat:@"%d. %@",
                aCount, aLine];
            aCount--;
            if ( isNotEmpty(aTitle) ) {
                [commitHistoryPopUpButton insertItemWithTitle:aTitle atIndex:1];
                theSelectedItem = (NSMenuItem *)[commitHistoryPopUpButton 
                                                    itemWithTitle:aTitle];
                [theSelectedItem setRepresentedObject:aCommitMessage];
            }
        }
        isClearMenuItemEnabled = YES;
    } else {
        isClearMenuItemEnabled = NO;
    }
}

- (void)updateControls
    /*" This method updates the controls in the commit panel. The controls in 
        question are the #Clear and #Ok buttons.
    "*/
{
    NSString *aCommitMessage = nil;

    aCommitMessage = [self commitMessage];
    if ( isNotEmpty(aCommitMessage) ) {
        [clearButton setEnabled:YES];
        [okButton setEnabled:YES];
    } else {
        [clearButton setEnabled:NO];
        [okButton setEnabled:NO];
    }
}

- (void)updateTitle
    /*" This method updates the title in the commit panel. The tile includes the
        name of the committing file or folder if there is only one or the number 
        of committing files and/or folders if there is more than one.
    "*/
{
    NSString *aTitle = nil;
    NSString *aPath = nil;
    NSString *aFilename = nil;

    unsigned int aCount = 0;
    
    if ( isNotEmpty(committingFiles) ) {
        aCount = [committingFiles count];
    }
    if ( aCount == 0 ) {
        aTitle = @"Commit Workarea";
    } else if ( aCount == 1 ) {
        aPath = [committingFiles objectAtIndex:0];
        aFilename = [aPath lastPathComponent];
        aTitle = [NSString stringWithFormat:
            @"Commit file/folder \"%@\"", aFilename];
    } else {
        aTitle = [NSString stringWithFormat:
            @"Commit the %d selected files and/or folders", aCount];
    }    
    [titleTextField setStringValue:aTitle];    
}

- (void)updateCommitMessageTextView
    /*" This method updates the commit message text view in the panel. In 
        particular the text view is set to the template or the template after 
        having the "CVS:" lines filtered out depending on the user preferences.
    "*/
{
    NSString *myFilteredTemplateContent = nil;
   
    myFilteredTemplateContent = [self filteredTemplateContent];
    if ( myFilteredTemplateContent != nil ) {
        [commitMessageTextView setString:myFilteredTemplateContent];
    }
}

- (void)textDidChange:(NSNotification *)aNotification;
    /*" This method updates the controls whenever the text changes in the text
        view.
    "*/
{
    [self updateControls];
}

- (void)windowDidLoad
    /*" This method allows subclasses of NSWindowController to perform any 
        required tasks after the window owned by the receiver has been loaded. 
        The default implementation does nothing.

        Here we check to make sure the outlets commitMessageTextView, okButton, 
        clearButton and cancelButton are connected. Then the commit message text
        view is setup since it is a custom view we cannot do the setup in the 
        InterfaceBuilder application.
    "*/
{
    SEN_ASSERT_NOT_NIL(commitMessageTextView);
    SEN_ASSERT_NOT_NIL(okButton);
    SEN_ASSERT_NOT_NIL(clearButton);
    SEN_ASSERT_NOT_NIL(cancelButton);
    
#warning (william 30-Jan-2004) commitMessageTextView has a bug (see note below this line)
    // If a user pastes a bunch of code into this text view an exception of the 
    // following type will be raised.
    //     cvlEditor[6195] *** Uncaught exception: <NSRangeException> 
    //     [NOTE: this exception originated in the server.]
    //     *** NSRunStorage, _NSBlockNumberForIndex(): 
    //     index (2782) beyond array bounds (1000)
    // I think this is an Apple bug in the NSTextView class.
    // I tried this with the nib setup using a NSTextView in place of 
    // CVLTextView and the same thing happened. No known work-around.
    // Also created a test app with just a window and a NSScrollView with an
    // NSTextView inside. Still had the same bug.
    [commitMessageTextView setTarget:okButton];
    [commitMessageTextView setAction:@selector(performClick:)];
    [commitMessageTextView setEscapeTarget:cancelButton];
    [commitMessageTextView setEscapeAction:@selector(performClick:)];
    // We need to perform additional initializations, normally done in IB
    [commitMessageTextView setAllowsUndo:YES];
    [commitMessageTextView setContinuousSpellCheckingEnabled:YES];
    [commitMessageTextView setDrawsBackground:YES];
    [commitMessageTextView setEditable:YES];
    [commitMessageTextView setImportsGraphics:NO];
    [commitMessageTextView setRichText:NO];
    [commitMessageTextView setSelectable:YES];
}

- (BOOL)validateMenuItem:(id <NSMenuItem>)aMenuItem
    /*" This method enables or disables the menu items the Commit History pull 
        down button.
    "*/
{
    SEL anAction= [aMenuItem action];
    NSString* anActionString= NSStringFromSelector(anAction);
    
    // For popup item "1. 13-1-2004 A commit message..."
    if ( [anActionString isEqualToString:@"insertCommitMessageFrom:"] ) {
        return YES;
    }

    // For pulldown item "Clear Menu"
    if ( [anActionString isEqualToString:@"clearCommitMessageHistory:"] ) {
        return isClearMenuItemEnabled;
    }    
    return YES;
}

- (NSString *) showCommitPanelWithFiles:(NSArray *)someFiles usingTemplateFile:(NSString *)aTemplateFile
    /*" This is the method that should be called by other objects. The method 
        #-showAndRunModal: is called by this method. This method will display 
        the commit panel with the appropriate title and template file (if any). 
        After the user clicks on the #OK button then this method checks the 
        commit message to make sure it will not be nil or empty or consist 
        totally of whitespace. If it does then an alert panel is displayed with 
        the error and the commit panel is redisplayed with the old message.
    "*/
{
    NSString    *aCommitMessage = nil;
    int         modalReturnCode = 0;
    BOOL        filterCvsTemplate = NO;
    BOOL        showPanelAgain = NO;
    BOOL        doCommit = NO;

    useCvsTemplates = [[NSUserDefaults standardUserDefaults] 
                                boolForKey:@"UseCvsTemplates"];
    filterCvsTemplate = [[NSUserDefaults standardUserDefaults] 
                                boolForKey:@"FilterCvsTemplate"];
    if ( useCvsTemplates == YES ) {
        [self setTemplateFile:aTemplateFile];
    } else {
        [self setTemplateFile:nil];
    }
    [self setCommittingFiles:someFiles];
    
    do {
        modalReturnCode = [self showAndRunModal];
        showPanelAgain = NO;
        if ( modalReturnCode == NSOKButton ) {
            aCommitMessage = [self commitMessage];
            if( isNilOrEmpty(aCommitMessage) ) {
                // FIXME Allows empty messages (optional)
                NSBeginAlertSheet(@"Commit", nil, nil, nil, 
                                  [self window], nil, NULL, NULL, NULL,
                                  @"You must give a commit message.");
                showPanelAgain = YES;
            }
            if ( showPanelAgain == NO ) {
                // Check that we do not have a message consisting solely of
                // whitspace.
                BOOL            messageWillBeEmpty = YES;
                
                messageWillBeEmpty = [aCommitMessage containsOnlyWhiteSpace];
                if ( messageWillBeEmpty ) {
                    // FIXME Allows empty messages (optional)
                    NSRunAlertPanel(@"Commit",
                                    @"This message has nothing but spaces. Please re-enter a different message.", 
                                    @"OK", nil, nil);    
                    showPanelAgain = YES;
                } 
            }
            if ( (showPanelAgain == NO) && 
                 (useCvsTemplates == YES) && 
                 (filterCvsTemplate == YES) ) {
                // Check that user didn't type lines beginning with "CVS:",
                // because cvs WILL remove them from commit message.
                NSString        *aLine = nil;
                NSArray         *someLines = nil;
                NSEnumerator    *aLineEnumerator = nil;
                int             aChoice = NSAlertDefaultReturn;
                
                someLines = [aCommitMessage lines];
                aLineEnumerator = [someLines objectEnumerator];
                while ( (aLine = [aLineEnumerator nextObject]) ) {
                    if ( [aLine hasPrefix:@"CVS:"] == YES ) {
                        aChoice = NSRunAlertPanel(@"Commit",
                                                  @"CVS will remove lines beginning with CVS:. Commit anyway?", 
                                                  @"No", @"Yes", nil);
                        if ( aChoice == NSAlertDefaultReturn ) {
                            showPanelAgain = YES;
                        }
                    }        
                }    
            }
            if ( (showPanelAgain == NO) &&
                 (useCvsTemplates == YES) ) {
                // Check that after all lines beginning with CVS: have been
                // removed we are not left with an empty message.
                NSString        *aLine = nil;
                NSArray         *someLines = nil;
                NSEnumerator    *aLineEnumerator = nil;
                BOOL            lineIsEmpty = YES;
                BOOL            messageWillBeEmpty = YES;
                
                someLines = [aCommitMessage lines];
                aLineEnumerator = [someLines objectEnumerator];
                while ( (aLine = [aLineEnumerator nextObject]) ) {
                    if ( [aLine hasPrefix:@"CVS:"] == NO ) {
                        lineIsEmpty = [aLine containsOnlyWhiteSpace];
                        if ( lineIsEmpty == NO ) {
                            messageWillBeEmpty = NO;
                            break;
                        }
                    }        
                }
                if ( messageWillBeEmpty ) {
                    NSRunAlertPanel(@"Commit",
                                    @"After CVS removes lines beginning with \"CVS:\", this message will be empty. Please re-enter a different message.", 
                                    @"OK", nil, nil);    
                    showPanelAgain = YES;
                } 
            }
            if ( showPanelAgain == NO ) {
                doCommit = YES;
            }
        } else {
            doCommit = NO;
        }
        if ( showPanelAgain == YES ) {
            doNotUpdateCommitMessageTextView = YES;
        }
    } while ( showPanelAgain == YES );
    
    doNotUpdateCommitMessageTextView = NO;
    if ( doCommit == YES ) {
        NSCalendarDate *aDateTime = nil;
        NSArray *allMatches = nil;
        
        aCommitMessage = [self commitMessage];        
        if ( isNotEmpty(aCommitMessage) ) {
            // First remove any leading blank lines.
            aCommitMessage = [self removeAllLeadingBlankLines:aCommitMessage];
            aCommitMessage = [self removeAllCVSLines:aCommitMessage];
            
            // Check to see if this message is already in the histories dictionary.
            allMatches = [commitHistory allKeysForObject:aCommitMessage];
            if ( isNilOrEmpty(allMatches) ) {
                aDateTime = [NSDate date];
                [commitHistory setObject:aCommitMessage 
                                  forKey:[aDateTime description]];
            }
        }
    } else {
        aCommitMessage = nil;
    }
    return aCommitMessage;
}

- (NSString *)removeAllLeadingBlankLines:(NSString *)aMessage
    /*" This method returns aMessage that has all the leading blank lines 
        removed. It is being used so that the pulldown button on the commit
        panel will not have blank entries.
    "*/
{
    NSMutableString *aNewMessage = nil;
    NSString        *aLine = nil;
    NSArray         *someLines = nil;
    NSEnumerator    *aLineEnumerator = nil;
    unsigned int    aLength = 0;
    BOOL            lineIsEmpty = NO;
    BOOL            isBeginningOfMessage = YES;
    
    aLength = [aMessage length];
    aNewMessage = [NSMutableString stringWithCapacity:aLength];
    someLines = [aMessage lines];
    aLineEnumerator = [someLines objectEnumerator];
    while ( (aLine = [aLineEnumerator nextObject]) ) {
        lineIsEmpty = [aLine containsOnlyWhiteSpace];
        if ( (lineIsEmpty == YES) && (isBeginningOfMessage == YES) ) {
            ; // Skip this blank line.
        } else {
            // Leave blank lines in the middle and at the end untouched.
            isBeginningOfMessage = NO;
            [aNewMessage appendFormat:@"%@\n", aLine];
        }
    }
    [[aNewMessage retain] autorelease];
    return  aNewMessage;
}

- (NSString *)removeAllCVSLines:(NSString *)aMessage
    /*" This method returns aMessage that has all the lines beginning with "CVS:"
    removed. It is being used so that the pulldown button on the commit
    panel will not have these lines in its entries.
    "*/
{
    NSMutableString *aNewMessage = nil;
    NSString        *aLine = nil;
    NSArray         *someLines = nil;
    NSEnumerator    *aLineEnumerator = nil;
    unsigned int    aLength = 0;
    
    aLength = [aMessage length];
    aNewMessage = [NSMutableString stringWithCapacity:aLength];
    someLines = [aMessage lines];
    aLineEnumerator = [someLines objectEnumerator];
    while ( (aLine = [aLineEnumerator nextObject]) ) {
        if ( [aLine hasPrefix:@"CVS:"] == NO ) {
            [aNewMessage appendFormat:@"%@\n", aLine];
        }
    }
    [[aNewMessage retain] autorelease];
    return  aNewMessage;
}

@end
