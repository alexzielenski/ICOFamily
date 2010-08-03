//
//  ICOFamilyAppDelegate.m
//  ICOFamily
//
//  Created by Alex Zielenski on 8/2/10.
//  Copyright 2010 Alex Zielenski. All rights reserved.
//

#import "ICOFamilyAppDelegate.h"
#import "ICOFamily.h"

@implementation ICOFamilyAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
		
	ICOFamily *fam = [ICOFamily familyWithImage:[NSImage imageNamed:@"Iconolatrous"]];
	
	NSImage *ni = [[NSImage alloc] initWithSize:NSMakeSize(57, 57)];
	[ni lockFocus];
	[[NSImage imageNamed:@"NSApplicationIcon"] drawInRect:NSMakeRect(0, 0, 57, 57)
											fromRect:NSZeroRect
										   operation:NSCompositeSourceOver
											fraction:1.0];
	[ni unlockFocus];
	[fam setImage:ni forCustomSize:ni.size];
	[fam.data writeToFile:@"/Users/Alex/Desktop/lol2.ico" atomically:NO];
}

@end
