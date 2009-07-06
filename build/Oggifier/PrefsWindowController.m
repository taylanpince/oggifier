//
//  PrefsWindowController.m
//  Oggifier
//
//  Created by Taylan Pince on 05/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PrefsWindowController.h"


@implementation PrefsWindowController

- (void)awakeFromNib {
	[[self window] makeKeyAndOrderFront:self];
}

- (void)dealloc {
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[super dealloc];
}

@end
