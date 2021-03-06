/*
     Copyright (C) 2010-2015 Marvell International Ltd.
     Copyright (C) 2002-2010 Kinoma, Inc.

     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
*/
#define __FSKWINDOW_PRIV__
#import "FskCocoaApplication.h"
#import "FskCocoaWindow.h"
#import "Fsk.h"
#import "FskErrors.h"
#import "FskWindow.h"

@implementation FskCocoaApplication

#pragma mark --- init ---
- (id)init
{
	self = [super init];

	return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark --- NSMenu delegate ---
- (void)menuNeedsUpdate:(NSMenu *)menu
{
	NSEnumerator	*enumerator;
	NSMenuItem		*menuItem, *nextMenuItem;
	UInt32 			commandID;
	FskEvent 		fskEvent;
	FskWindow		fskWindow;

	fskWindow = [(FskCocoaWindow *)[NSApp mainWindow] fskWindow];
	enumerator = [[menu itemArray] objectEnumerator];
	menuItem = [enumerator nextObject];

	if (menuItem)
	{
		while (nextMenuItem = [enumerator nextObject])
		{
			commandID = [menuItem tag];

			if (!FskEventNew(&fskEvent, kFskEventMenuStatus, NULL, kFskEventModifierNotSet))
			{
				FskEventParameterAdd(fskEvent, kFskEventParameterCommand, sizeof(commandID), &commandID);
				FskWindowEventQueue(fskWindow, fskEvent);
			}

			menuItem = nextMenuItem;
		}

		commandID = [menuItem tag];

		if (!FskEventNew(&fskEvent, kFskEventMenuStatus, NULL, kFskEventModifierNotSet))
		{
			FskEventParameterAdd(fskEvent, kFskEventParameterCommand, sizeof(commandID), &commandID);
			FskWindowEventQueue(fskWindow, fskEvent);
		}
	}
}

#pragma mark --- methods ---
- (void)enterMultiThreadedMode
{
	// do nothing
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	NSApplicationTerminateReply	terminateReply = NSTerminateNow;
	NSWindow					*frontWindow;
	FskWindow					fskWindow;
	FskEvent 					fskEvent;
	UInt32						commandID = 0;

	frontWindow = [NSApp keyWindow];

	if (frontWindow)
	{
		fskWindow = [(FskCocoaWindow *)frontWindow fskWindow];

		// send Fsk quit event
		if (kFskErrNone == FskEventNew(&fskEvent, kFskEventMenuCommand, NULL, kFskEventModifierNotSet))
		{
			FskEventParameterAdd(fskEvent, kFskEventParameterCommand, sizeof(commandID), &commandID);
			FskWindowEventQueue(fskWindow, fskEvent);
			terminateReply = NSTerminateCancel;
		}
	}

	return terminateReply;
}

@end
