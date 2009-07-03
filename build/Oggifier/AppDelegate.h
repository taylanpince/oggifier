//
//  AppDelegate.h
//  Oggifier
//
//  Created by Taylan Pince on 03/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;

@interface AppDelegate : NSObject {
	IBOutlet MainWindowController *windowController;
}

@property (nonatomic, retain) IBOutlet MainWindowController *windowController;

@end
