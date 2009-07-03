//
//  AppDelegate.m
//  Oggifier
//
//  Created by Taylan Pince on 03/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"


@implementation AppDelegate

@synthesize windowController;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
	return YES;
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path {
	[windowController assignSourcePath:path];
	
	return YES;
}

@end
