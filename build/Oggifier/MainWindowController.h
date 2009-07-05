//
//  MainWindowController.h
//  Oggifier
//
//  Created by Taylan Pince on 02/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PathControl.h"


@interface MainWindowController : NSWindowController <PathControlDelegate> {
	IBOutlet PathControl *sourcePath;
	IBOutlet NSPathControl *outputPath;
	IBOutlet NSProgressIndicator *progressIndicator;
	IBOutlet NSButton *convertButton;
	IBOutlet NSButton *cancelButton;
	IBOutlet NSTextField *statusLabel;
	
	BOOL cancelled;
}

@property (nonatomic, retain) IBOutlet PathControl *sourcePath;
@property (nonatomic, retain) IBOutlet NSPathControl *outputPath;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *progressIndicator;
@property (nonatomic, retain) IBOutlet NSButton *convertButton;
@property (nonatomic, retain) IBOutlet NSButton *cancelButton;
@property (nonatomic, retain) IBOutlet NSTextField *statusLabel;
@property (nonatomic, assign) BOOL cancelled;

- (IBAction)chooseSourcePath:(id)sender;
- (IBAction)chooseOutputPath:(id)sender;
- (IBAction)startConversion:(id)sender;
- (IBAction)cancelConversion:(id)sender;
- (void)assignSourcePath:(NSString *)path;

@end
