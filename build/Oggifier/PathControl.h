//
//  PathControl.h
//  Oggifier
//
//  Created by Taylan Pince on 05/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PathControlDelegate;


@interface PathControl : NSPathControl {
	id <PathControlDelegate> subDelegate;
}

@property (nonatomic, assign) id <PathControlDelegate> subDelegate;

@end

@protocol PathControlDelegate
- (void)didChangePathControl:(PathControl *)control toURL:(NSURL *)url;
@end

