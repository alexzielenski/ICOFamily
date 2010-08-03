//
//  ICOFamily.h
//  ICOFamily
//
//  Created by Alex Zielenski on 8/2/10.
//  Copyright 2010 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum {
	kICOFamilyAllElements   = -1,
	kICOFamily256Element    = 0,
	kICOFamily128Element    = 1,
	kICOFamily64Element     = 2,
	kICOFamily48Element     = 4,
	kICOFamily32Element     = 8,
	kICOFamily24Element     = 16,
	kICOFamily16Element     = 32
};

typedef NSUInteger kICOFamilyElement;

@interface ICOFamily: NSObject <NSCopying> {
	NSMutableDictionary *elements;
}
- initWithImage:(NSImage*)image;
- initWithBitmapImageRep:(NSBitmapImageRep*)rep;
- initWithData:(NSData*)data;

+ family;
+ familyWithImage:(NSImage*)image;
+ familyWithBitmapImageRep:(NSBitmapImageRep*)rep;
+ familyWithData:(NSData*)data;

- (void)setImage:(NSImage*)image forElement:(kICOFamilyElement)element;
- (void)setBitmapImageRep:(NSBitmapImageRep*)rep forElement:(kICOFamilyElement)element;
- (void)setData:(NSData*)data forElement:(kICOFamilyElement)element;

- (NSData*)dataForElement:(kICOFamilyElement)element;
- (NSImage*)imageForElement:(kICOFamilyElement)element;
- (NSBitmapImageRep*)bitmapImageRepForElement:(kICOFamilyElement)element;

- (void)setImage:(NSImage*)image forCustomSize:(NSSize)size;
- (void)setBitmapImageRep:(NSBitmapImageRep*)rep forCustomSize:(NSSize)size;
- (void)setData:(NSData*)data forCustomSize:(NSSize)size;

- (NSData*)dataForCustomSize:(NSSize)size;
- (NSImage*)imageForCustomSize:(NSSize)size;
- (NSBitmapImageRep*)bitmapImageRepForCustomSize:(NSSize)size;

- (void)setElements:(kICOFamilyElement)element fromImage:(NSImage*)image;
- (NSImage*)imageWithAllReps;

- (BOOL)verifyImageOfSize:(NSSize)size forElement:(kICOFamilyElement)element;
- (NSData*)data;

	// - (void)readFromData:(NSData*)data; // Not yet. But if done correctly, would read from an ICO file's raw data and set the elements accordingly.

@end
