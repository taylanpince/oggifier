//
//  PathControl.m
//  Oggifier
//
//  Created by Taylan Pince on 05/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PathControl.h"


@implementation PathControl

@synthesize subDelegate;

- (void)setURL:(NSURL *)url {
	[super setURL:url];
	[subDelegate didChangePathControl:self toURL:url];
}

@end
