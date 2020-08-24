#import <Foundation/Foundation.h>

/* Localization strings for Draw */

#define SAVE NSLocalizedString(@"Save", "Save button on alerts")
#define DONT_SAVE NSLocalizedString(@"Don't Save", "Save button on alerts")
#define YES_BUTTON NSLocalizedString(@"Yes", "Yes button on alerts")
#define NO_BUTTON NSLocalizedString(@"No", "No button on alerts")
#define CANCEL NSLocalizedString(@"Cancel", "Cancel button on alerts")
#define REVERT NSLocalizedString(@"Revert", "Button choice which allows the user to revert his changes to what was last saved on disk.")
#define CLOSE NSLocalizedString(@"Close", "The operation of closing a window usually generated by choosing the Close Window option in the Windows menu.")
#define OPEN_ERROR NSLocalizedString(@"I/O error.  Can't open file '%@'.", "Message in alert given to user when he tries to open a draw document and there is an I/O error.  This usually happens when the document being opened is not really a draw document but somehow got renamed to have the .draw extension.")
#define FORM_WARNING NSLocalizedString(@"This document has Form Entries in it.  Do you wish to save them with the document?", "Message asking user whether the form entries in a document should be saved along with the document.")
#define CANT_CREATE_BACKUP NSLocalizedString(@"Can't create backup file.", "Message indicating that a backup file could not be created during save.")
#define DIR_NOT_WRITABLE NSLocalizedString(@"Directory is not writeable.", "Message indicating that the directory the user is trying to save to is not writable.")
#define CANT_SAVE NSLocalizedString(@"Can't save file.", "This alert appears when the user has asked to save his file somewhere, but Draw was unable to create that file.  This can occur for many reasons, the most common of which is that the file or directory is not writable.")
#define HIDE_RULER  NSLocalizedString(@"&Hide Ruler",nil)
#define SHOW_RULER  NSLocalizedString(@"&Show Ruler",nil)
#define SAVE_CHANGES NSLocalizedString(@"%@ has changes. Save them?", "Question asked of user when he tries to close a window, either by choosing close from the menu or clicking the close box or quitting the application, and the contents of the window have not been saved.  The %@ is the name of the document.")
#define SURE_TO_REVERT NSLocalizedString(@"%@ has been edited.  Are you sure you want to undo changes?", "This is the message of the alert which asks the user if he is sure he wants to revert a document he has edited back to its last-saved state. %@ is the document name.")
#define BAD_MARGINS NSLocalizedString(@"The margins or paper size specified are invalid.", "Message in alert when user specifies bad margins")
#define SERVICE NSLocalizedString(@"Service", "Title of panel asking whether doc should be saved before service")
#define SAVE_FOR_SERVICE NSLocalizedString(@"Do you wish to save this document before your request is serviced?", "Message of panel asking whether doc should be saved before service")
#define INVALID_PATH NSLocalizedString(@"Invalid path: %@", "Message of alert shown to user when he has tried to open up the file named %@ and has specified a file in a directory which is inaccessible.  The directory is either unreadable or does not exist for some reason.")
#define UNSAVED_DOCUMENTS NSLocalizedString(@"You have unsaved documents.", "Message given to user when he tries to quit the application without saving all of his documents.")
#define REVIEW_UNSAVED NSLocalizedString(@"Review Unsaved", "Choice (on a button) given to user which allows him to review all his unsaved documents if he quits the application without saving them all first.")
#define QUIT_ANYWAY NSLocalizedString(@"Quit Anyway", "Choice (on a button) given to user which allows him to quit the application even though he has not saved all of his documents first.")
#define LOAD_IMAGE NSLocalizedString(@"Import Data", "Title of the alert which lets the user know that the image he has incorporated into his document does not fit.")
#define IMAGE_TOO_LARGE NSLocalizedString(@"The imported data is too large to fit on the page.  Resize it to fit?", "Alert message which asks user if he wants to scale an image or some text that he is incorporating into his document to fit within the size of the document.")
#define SCALE NSLocalizedString(@"Resize", "Button choice which allows the user to scale an image he is incorporating into his document so that it will fit within the size of the document")
#define DONT_SCALE NSLocalizedString(@"Don't Resize", "Button choice which allows the user to leave an image he is incorporating into his document the same size even though it will not fit within the size of his document.")
#define FILE_ICON_OR_LINK_BUTTON NSLocalizedString(@"Do you want the link to this file to appear as a Link Button or as the icon of the file?", "Question asked of a user when he drags a file icon into Draw.")
#define FILE_ICON NSLocalizedString(@"File Icon", "Button choice if user wants a file dragged into Draw to appear as an icon.")
#define LINK_BUTTON NSLocalizedString(@"Link Button", "Button choice if user wants a file dragged into Draw to appear as a link button.")
#define FILE_CONTENTS_OR_ICON_OR_LINK_BUTTON NSLocalizedString(@"Do you want the contents of this file to appear in Draw, or would you like to create only a link to this data, in which case, do you want the link to appear as a Link Button or as the icon of the file?", "Question asked of a user when he drags a file which can be imaged directly in Draw into Draw.")
#define FILE_CONTENTS NSLocalizedString(@"File Contents", "Button choice if user wants a file dragged into Draw to appear as the contents of the file.")
#define IMPORT_LINK NSLocalizedString(@"Import Link", "Title of alert which comes up during import of a link")
#define UNABLE_TO_IMPORT_LINK NSLocalizedString(@"Unable to import linked data.", "Message given to user when import of linked data fails.")
#define FILE_ERROR NSLocalizedString(@"File Error", "Title of alert which comes up on unknown file errors")
#define PROCEED_AFTER_FILE_ERROR NSLocalizedString(@"Proceed", "Button on alert which comes up on unknown file errors")
#define ABORT_AFTER_FILE_ERROR NSLocalizedString(@"Abort", "Button on alert which comes up on unknown file errors")
#define BAD_IMAGE @"Unable to import that image into Draw."
#define FAX_NOTE NSLocalizedString(@"Notes", "Fax Cover Sheet item which allows the user to type in any thing he/she wants.")
#define NO_HELP NSLocalizedString(@"Couldn't find any help!  Sorry ...", "Message given to the user when the help document could not be found.")
#define HELP NSLocalizedString(@"Help", "The title of the help document.")
#define UNTITLED NSLocalizedString(@"UNTITLED", "Title of new, unsaved document")
#define HIDE_GRID NSLocalizedString(@"Hide &Grid", "Menu item which hides the background grid which the user can overlay on his document.")
#define SHOW_GRID NSLocalizedString(@"Show &Grid", "Menu item which shows a background grid which the user can overlay on his document.");
#define TURN_GRID_OFF NSLocalizedString(@"&Turn Grid Off", "Menu item which turns off the background grid so that items do not move and resize on even grid boundaries.  It does not hide the grid if it is currently showing.");
#define TURN_GRID_ON NSLocalizedString(@"&Turn Grid On", "Menu item which turns a background grid on so that the user's actions are rounded to even grid boundaries.  It does not show the grid if the grid is currently hidden.");
#define SHOW_LINKS NSLocalizedString(@"Show &Links", "Menu item which turns on the borders around linked items (using Object Links).");
#define HIDE_LINKS NSLocalizedString(@"Hide &Links", "Menu item which turns off the borders around linked items (using Object Links).");

/* In these next few items the space in the name is intentional, to distinguish them from the same strings which occur on buttons */
#define SAVE_TITLE NSLocalizedString(@"Save ", "Title of alerts which come up during save.")
#define OPEN_TITLE NSLocalizedString(@"Open ", "Title of alerts which come up during open.")
#define REVERT_TITLE NSLocalizedString(@"Revert ", "This is the title of the alert which asks the user if he is sure he wants to revert a document he has edited back to its last-saved state.")
#define QUIT_TITLE NSLocalizedString(@"Quit ", "Title of alert which comes up when exiting the application.")

/* Operations */
#define FONT_OP NSLocalizedStringFromTable(@"Font", @"Operations", "The user action of changing the font of a bunch of selected graphical entities (for the undo/redo menu).")
#define SERVICE_CALL_OP NSLocalizedStringFromTable(@"Service Call", @"Operations", "The user action of selecting an item in the Services menu (for the undo/redo menu).")
#define TEXT_OP NSLocalizedStringFromTable(@"Text", @"Operations", "The user action of creating an area to type into.")

/* Cover sheet entries... */
/*
   NSLocalizedStringFromTable(@"To", @"CoverSheet", "Fax cover sheet entry")
   NSLocalizedStringFromTable(@"From", @"CoverSheet", "Fax cover sheet entry")
   NSLocalizedStringFromTable(@"Date", @"CoverSheet", "Fax cover sheet entry")
   NSLocalizedStringFromTable(@"Pages", @"CoverSheet", "Fax cover sheet entry")
   NSLocalizedStringFromTable(@"Address", @"CoverSheet", "Fax cover sheet entry")
*/

/* Tool names  (basically the names of the various classes) */
/*
   NSLocalizedString(@"Scribble", "Name of the tool that draws scribbles")
   NSLocalizedString(@"Rectangle", "Name of the tool that draws rectangles")
   NSLocalizedString(@"Polygon", "Name of the tool that draws polygons")
   NSLocalizedString(@"Line", "Name of the tool that draws lines")
   NSLocalizedString(@"Curve", "Name of the tool that draws curves")
   NSLocalizedString(@"Circle", "Name of the tool that draws circles")   
*/