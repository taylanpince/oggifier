//
//  MainWindowController.m
//  Oggifier
//
//  Created by Taylan Pince on 02/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainWindowController.h"
#import "PrefsWindowController.h"


@implementation MainWindowController

@synthesize sourcePath, outputPath, progressIndicator, convertButton, cancelButton, statusLabel, cancelled;

- (void)awakeFromNib {
	[cancelButton setHidden:YES];
	[progressIndicator setHidden:YES];
	[convertButton setEnabled:NO];
	[sourcePath setSubDelegate:self];
	[[self window] makeKeyAndOrderFront:self];
}

-(NSRect)newFrameForNewContentView:(NSView *)view {
    NSWindow *window = [self window];
    NSRect newFrameRect = [window frameRectForContentRect:[view frame]];
    NSRect oldFrameRect = [window frame];
    NSSize newSize = newFrameRect.size;
    NSSize oldSize = oldFrameRect.size;
    
    NSRect frame = [window frame];
    frame.size = newSize;
    frame.origin.y -= (newSize.height - oldSize.height);
    
    return frame;
}

- (void)updateOutputPath {
	[outputPath setURL:[NSURL fileURLWithPath:[[[[sourcePath URL] path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"ogv"]]];
	[convertButton setEnabled:YES];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"auto_convert"] == YES)
		[self startConversion:self];
}

- (void)assignSourcePath:(NSString *)path {
	[sourcePath setURL:[NSURL fileURLWithPath:path]];
}

- (void)didChangePathControl:(PathControl *)control toURL:(NSURL *)url {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"prompt_output"] == YES) {
		[self chooseOutputPath:self];
	} else {
		[self updateOutputPath];
	}
}

- (void)openPanelDidEnd:(NSOpenPanel*)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[panel orderOut:self];
	
	if (returnCode != NSOKButton)
		return;
	
	[sourcePath setURL:[[panel URLs] objectAtIndex:0]];
}

- (IBAction)chooseSourcePath:(id)sender {
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	
	[panel setAllowedFileTypes:[NSArray arrayWithObjects:@"m4v", @"dv", @"mov", @"mp4", @"3g2", @"m2v", nil]];
	[panel setAllowsMultipleSelection:NO];
	[panel setCanChooseDirectories:NO];
	[panel setCanChooseFiles:YES];
	[panel setResolvesAliases:YES];
	[panel setTitle:@"Pick a movie file"];
	[panel setPrompt:@"Choose"];
	
	[panel beginSheetForDirectory:nil file:nil types:nil modalForWindow:[self window]
					modalDelegate:self
					didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
					contextInfo:self];
}

- (void)savePanelDidEnd:(NSSavePanel *)panel returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	[panel orderOut:self];
	
	if (returnCode != NSOKButton)
		return;
	
	[outputPath	setURL:[panel URL]];

	if ([sourcePath URL])
		[convertButton setEnabled:YES];

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"auto_convert"] == YES)
		[self startConversion:self];
}

- (IBAction)chooseOutputPath:(id)sender {
	NSSavePanel *panel = [NSSavePanel savePanel];
	
	NSString *directory = nil;
	NSString *file = nil;
	
	if ([sourcePath URL]) {
		directory = [[[sourcePath URL] path] stringByDeletingLastPathComponent];
		file = [[[[sourcePath URL] path] lastPathComponent] stringByDeletingPathExtension];
	}
	
	[panel setAllowedFileTypes:[NSArray arrayWithObject:@"ogv"]];
	[panel setCanSelectHiddenExtension:YES];
	[panel setCanCreateDirectories:YES];
	[panel setTitle:@"Select a destination for the output file"];
	[panel setPrompt:@"Save"];
	
	[panel beginSheetForDirectory:directory file:file modalForWindow:[self window] 
					modalDelegate:self 
				    didEndSelector:@selector(savePanelDidEnd:returnCode:contextInfo:) 
					contextInfo:self];
}

- (void)updateStatus:(NSData *)data {
	NSString *status = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSRange range = [status rangeOfString:@"time remaining"];
	
	if (range.location != NSNotFound) {
		[statusLabel setTitleWithMnemonic:[[status substringFromIndex:range.location] capitalizedString]];
	} else {
		[statusLabel setTitleWithMnemonic:@"Calculating…"];
	}

	[status release];
}

- (void)runTask {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSTask *task = [[NSTask alloc] init];
	NSPipe *pipe = [NSPipe pipe];
	NSFileHandle *handle = [pipe fileHandleForReading];
	NSData *data = nil;
	
	[task setStandardOutput:pipe];
	[task setStandardError:pipe];
	[task setLaunchPath:[NSBundle pathForResource:@"ffmpeg2theora" ofType:nil inDirectory:[[NSBundle mainBundle] bundlePath]]];
	[task setArguments:[NSArray arrayWithObjects:[[sourcePath URL] path], @"-o", [[outputPath URL] path], nil]];
	
	[task launch];
	
	while ((data = [handle availableData]) && [data length]) {
		if (cancelled == YES) [task terminate];
		
		[self performSelectorOnMainThread:@selector(updateStatus:) withObject:data waitUntilDone:NO];
	}
	
	[self performSelectorOnMainThread:@selector(taskDidEnd) withObject:nil waitUntilDone:NO];
	
	[task release];
	[pool release];
}

- (IBAction)startConversion:(id)sender {
	[convertButton setHidden:YES];
	[convertButton setEnabled:NO];
	[cancelButton setHidden:NO];
	[progressIndicator setHidden:NO];
	[progressIndicator startAnimation:self];
	
	cancelled = NO;
	
	[self performSelectorInBackground:@selector(runTask) withObject:nil];
}

- (void)taskDidEnd {
	cancelled = NO;
	
	[convertButton setHidden:NO];
	[convertButton setEnabled:YES];
	[cancelButton setHidden:YES];
	[progressIndicator setHidden:YES];
	[progressIndicator stopAnimation:self];
	
	[statusLabel setTitleWithMnemonic:@"Done!"];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"quit_complete"] == YES)
		[[NSApplication sharedApplication] terminate:self];
}

- (IBAction)cancelConversion:(id)sender {
	cancelled = YES;
}

- (IBAction)openPreferences:(id)sender {
	PrefsWindowController *controller = [[PrefsWindowController alloc] init];
	
	[NSBundle loadNibNamed:@"PrefsWindow" owner:controller];
	[controller release];
}

- (void)dealloc {
	[sourcePath release];
	[outputPath release];
	[progressIndicator release];
	[convertButton release];
	[cancelButton release];
	[statusLabel release];
	[super dealloc];
}

@end
