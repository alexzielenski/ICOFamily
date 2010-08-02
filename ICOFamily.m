//
//  ICOFamily.m
//  ICOFamily
//
//  Created by Alex Zielenski on 8/2/10.
//  Copyright 2010 Alex Zielenski. All rights reserved.
//

#import "ICOFamily.h"

	// We use NSBitmapImageRep so we can get some extra specifications required by the ICO file type

@implementation ICOFamily
- init {
	if ((self = [super init])) {
		elements=[[NSMutableDictionary alloc] init];
		
		//NSImage *im = [NSImage imageNamed:@"NSApplicationIcon"]; // That was for testing
		//[self setElements:kICOFamilyAllElements fromImage:im]; // For Testing
	}
	return self;
}

- initWithImage:(NSImage*)image {
	if ((self = [self init])) {
		[self setImage:image forElement:kICOFamilyAllElements];
	}
	return self;
}
- initWithBitmapImageRep:(NSBitmapImageRep*)rep {
	if ((self = [self init])) {
		[self setBitmapImageRep:rep forElement:kICOFamilyAllElements];
	}
	return self;
}
- initWithData:(NSData*)data {
	if ((self = [self init])) {
			// Use NSImage to read :P
		[self setData:data forElement:kICOFamilyAllElements];
	}
	return self;
}

+ family {
	ICOFamily *newFam = [[[ICOFamily alloc] init] autorelease];
	return newFam;
}
+ familyWithImage:(NSImage*)image {
	ICOFamily *newFam = [ICOFamily family];
	[newFam setImage:image forElement:kICOFamilyAllElements];
	return newFam;
}
+ familyWithBitmapImageRep:(NSBitmapImageRep*)rep {
	ICOFamily *newFam = [ICOFamily family];
	[newFam setBitmapImageRep:rep forElement:kICOFamilyAllElements];
	return newFam;
}
+ familyWithData:(NSData*)data {
	ICOFamily *newFam = [ICOFamily family];
	[newFam setData:data forElement:kICOFamilyAllElements];
	return newFam;
}

- (void)dealloc {
	[elements release];
	[super dealloc];
}
- (void)setElements:(kICOFamilyElement)element fromImage:(NSImage*)im {
	if (!im)
		return;
	NSImage *t = nil;
	if ((element & kICOFamily256Element) == kICOFamily256Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		t = [[NSImage alloc] initWithSize:NSMakeSize(256, 256)];
		[t lockFocus];
		[im drawInRect:NSMakeRect(0, 0, 256, 256) 
			  fromRect:NSZeroRect 
			 operation:NSCompositeSourceOver 
			  fraction:1.0];
		[t unlockFocus];
		[self setImage:t 
			forElement:kICOFamily256Element];
		[t release];
	}
	if ((element & kICOFamily128Element) == kICOFamily128Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		t = [[NSImage alloc] initWithSize:NSMakeSize(128, 128)];
		
		[t lockFocus];
		[im drawInRect:NSMakeRect(0, 0, t.size.width, t.size.height) 
			  fromRect:NSZeroRect 
			 operation:NSCompositeSourceOver 
			  fraction:1.0];
		[t unlockFocus];
		[self setImage:t 
			forElement:kICOFamily128Element];
		[t release];
		
	}
	if ((element & kICOFamily64Element) == kICOFamily64Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		t = [[NSImage alloc] initWithSize:NSMakeSize(64, 64)];
		
		[t lockFocus];
		[im drawInRect:NSMakeRect(0, 0, t.size.width, t.size.height) 
			  fromRect:NSZeroRect 
			 operation:NSCompositeSourceOver 
			  fraction:1.0];
		[t unlockFocus];
		[self setImage:t 
			forElement:kICOFamily64Element];
		[t release];
	}
	if ((element & kICOFamily48Element) == kICOFamily48Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		t = [[NSImage alloc] initWithSize:NSMakeSize(48, 48)];
		
		[t lockFocus];
		[im drawInRect:NSMakeRect(0, 0, t.size.width, t.size.height) 
			  fromRect:NSZeroRect 
			 operation:NSCompositeSourceOver 
			  fraction:1.0];
		[t unlockFocus];
		[self setImage:t 
			forElement:kICOFamily48Element];
		[t release];
	}
	if ((element & kICOFamily32Element) == kICOFamily32Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		t = [[NSImage alloc] initWithSize:NSMakeSize(32, 32)];
		
		[t lockFocus];
		[im drawInRect:NSMakeRect(0, 0, t.size.width, t.size.height) 
			  fromRect:NSZeroRect 
			 operation:NSCompositeSourceOver 
			  fraction:1.0];
		[t unlockFocus];
		[self setImage:t 
			forElement:kICOFamily32Element];
		[t release];
	}
	if ((element & kICOFamily24Element) == kICOFamily24Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		t = [[NSImage alloc] initWithSize:NSMakeSize(24, 24)];
		
		[t lockFocus];
		[im drawInRect:NSMakeRect(0, 0, t.size.width, t.size.height) 
			  fromRect:NSZeroRect 
			 operation:NSCompositeSourceOver 
			  fraction:1.0];
		[t unlockFocus];
		[self setImage:t 
			forElement:kICOFamily24Element];
		[t release];
	}
	if ((element & kICOFamily16Element) == kICOFamily16Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		t = [[NSImage alloc] initWithSize:NSMakeSize(16, 16)];
		[t lockFocus];
		[im drawInRect:NSMakeRect(0, 0, t.size.width, t.size.height) 
			  fromRect:NSZeroRect 
			 operation:NSCompositeSourceOver 
			  fraction:1.0];
		[t unlockFocus];
		[self setImage:t 
			forElement:kICOFamily16Element];
		[t release];
	}	
}
- (NSImage*)imageWithAllReps {
	NSImage *rep = [[[NSImage alloc] init] autorelease];
	[rep addRepresentation:[self bitmapImageRepForElement:kICOFamily256Element]];
	[rep addRepresentation:[self bitmapImageRepForElement:kICOFamily128Element]];
	[rep addRepresentation:[self bitmapImageRepForElement:kICOFamily64Element]];
	[rep addRepresentation:[self bitmapImageRepForElement:kICOFamily48Element]];
	[rep addRepresentation:[self bitmapImageRepForElement:kICOFamily32Element]];
	[rep addRepresentation:[self bitmapImageRepForElement:kICOFamily32Element]];
	[rep addRepresentation:[self bitmapImageRepForElement:kICOFamily16Element]];
	return rep;
}
- (void)setImage:(NSImage*)image forElement:(kICOFamilyElement)element {
	if (!image)
		return;
	if ((element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		[self setElements:element fromImage:image];
	}
	[self setData:image.TIFFRepresentation 
	   forElement:element];
}
- (void)setBitmapImageRep:(NSBitmapImageRep*)rep forElement:(kICOFamilyElement)element {
	if (!rep)
		return;
	if ((element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		[self setElements:element fromImage:[[[NSImage alloc] initWithCGImage:rep.CGImage 
																		 size:NSMakeSize(rep.pixelsWide, rep.pixelsHigh)]
											 autorelease]];
		return;
	}
	if ([self verifyImageOfSize:NSMakeSize(rep.pixelsWide, rep.pixelsHigh) 
					 forElement:element])
		[elements setObject:rep forKey:[NSNumber numberWithInteger:element]];
}
- (void)setData:(NSData*)data forElement:(kICOFamilyElement)element {
	if (!data)
		return;
	if ((element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		[self setElements:element fromImage:[[[NSImage alloc] initWithData:data] autorelease]];
		return;
	}
	NSBitmapImageRep *nr = [NSBitmapImageRep imageRepWithData:data];
	[self setBitmapImageRep:nr forElement:element];
}

- (NSData*)dataForElement:(kICOFamilyElement)element {
	return [[self bitmapImageRepForElement:element] representationUsingType:NSPNGFileType 
																 properties:nil];
}
- (NSImage*)imageForElement:(kICOFamilyElement)element {
	return [[[NSImage alloc] initWithData:[self dataForElement:element]] autorelease];
}
- (NSBitmapImageRep*)bitmapImageRepForElement:(kICOFamilyElement)element {
	return [elements objectForKey:[NSNumber numberWithInteger:element]];
}
- (BOOL)verifyImageOfSize:(NSSize)size forElement:(kICOFamilyElement)element {
	NSSize desiredSize = NSZeroSize;
	switch (element) {
		case kICOFamily256Element:
			desiredSize=NSMakeSize(256, 256);
			break;
		case kICOFamily128Element:
			desiredSize=NSMakeSize(128, 128);
			break;
		case kICOFamily64Element:
			desiredSize=NSMakeSize(64, 64);
			break;
		case kICOFamily48Element:
			desiredSize=NSMakeSize(48, 48);
			break;
		case kICOFamily32Element:
			desiredSize=NSMakeSize(32, 32);
			break;
		case kICOFamily24Element:
			desiredSize=NSMakeSize(24, 24);
			break;
		case kICOFamily16Element:
			desiredSize=NSMakeSize(16, 16);
			break;
		default:
			break;
	}
	return (size.width == desiredSize.width && size.height == desiredSize.height);
}
- (NSData*)data {	
		// Write the BitmapInfoHeader to the data
	NSMutableData *data = [NSMutableData data];
	short zero = 0;
	short type = 1; // 1 for ICO and 2 for CUR cursor file
	short count = elements.count;
		// Write the header to the data
	[data appendBytes:&zero length:sizeof(short)];
	[data appendBytes:&type length:sizeof(short)];
	[data appendBytes:&count length:sizeof(short)];
	

		// Write Image Headers
	NSMutableData *headers = [[NSMutableData alloc] init];
	NSMutableData *images = [[NSMutableData alloc] init];
	
	NSSortDescriptor *high = [NSSortDescriptor sortDescriptorWithKey:@"pixelsHigh" ascending:NO];
	NSSortDescriptor *pixelsWide = [NSSortDescriptor sortDescriptorWithKey:@"pixelsWide" ascending:NO];
		// Sort it so it is pretty
	NSArray *vals = [elements.allValues sortedArrayUsingDescriptors:[NSArray arrayWithObjects:
																	 high, pixelsWide, nil]];
	
	for (NSBitmapImageRep *currentRep in vals) {
		NSData *bitmapData = [currentRep representationUsingType:NSPNGFileType 
													  properties:nil];
			// Image header
		const char *width = [[NSString stringWithFormat:@"%i", currentRep.pixelsWide] UTF8String];
		const char *height = [[NSString stringWithFormat:@"%i", currentRep.pixelsWide] UTF8String];
		const char *palette = "0";
		const char *reserved = "0";
		short planes = currentRep.numberOfPlanes;
		short bpp = currentRep.bitsPerPixel; // bits per pixel
		int size = bitmapData.length;
		[headers appendBytes:width length:sizeof(const char)];
		[headers appendBytes:height length:sizeof(const char)];
		[headers appendBytes:palette length:sizeof(const char)];
		[headers appendBytes:reserved length:sizeof(const char)];
		[headers appendBytes:&planes length:sizeof(short)];
		[headers appendBytes:&bpp length:sizeof(short)];
		[headers appendBytes:&size length:sizeof(int)];
		
			// Calculate the header offset
		int eachheader = 16; // The size of each image header in bytes (including the offset)
		int offset=eachheader*elements.count+images.length+data.length; // Gets the soon-to-be size of the file header and all of the image headers combined so an offset can be calculated for the image. Adding images.length adds the current offset for the image before the image gets added. Because we dont want offset+lengths. Data.lenght would be the root header's size in bytes. (6)
		
		[headers appendBytes:&offset length:sizeof(int)];
		
			// Add the raw image data the the images data
		[images appendBytes:bitmapData.bytes length:bitmapData.length];
	}
	[data appendBytes:headers.bytes length:headers.length];
	[data appendBytes:images.bytes length:images.length];
	[headers release];
	[images release];
	return data;
}
- (void)readFromData:(NSData*)data { // Not yet. Might need help with this one. For now just use NSImage ;) 
	NSData *header = [data subdataWithRange:NSMakeRange(0, 6)];
	
	short count = 0;
	[header getBytes:&count range:NSMakeRange(sizeof(short)*2, sizeof(short))];
	short type = 0;
	[header getBytes:&type range:NSMakeRange(sizeof(short), sizeof(short))];
	short zero = -1;
	[header getBytes:&zero range:NSMakeRange(0, sizeof(short))];
	
	if (zero != 0 || type != 1 || count < 1) {
		return; // FAIL
	}
	NSData *rest = [data subdataWithRange:NSMakeRange(6, data.length-6)];
	for (int x = 1;x<=count;x++) {
			// Each eacher should be 16?
			// Image header
		
		NSData *currentHeader = [rest subdataWithRange:NSMakeRange(16*x, 16)];
		
		const char *width = NULL;
		const char *height = NULL;
		const char *palette = NULL;
		const char *reserved = NULL;
		short planes = 0;
		short bpp = 0;
		int size = 0;
		int offset=0;
				
		[currentHeader getBytes:&width range:NSMakeRange(0, 1)];
		[currentHeader getBytes:&height range:NSMakeRange(1, 1)];
		[currentHeader getBytes:&palette range:NSMakeRange(2, 1)];
		[currentHeader getBytes:&reserved range:NSMakeRange(3, 1)];
		[currentHeader getBytes:&planes range:NSMakeRange(4, 2)];
		[currentHeader getBytes:&bpp range:NSMakeRange(6, 2)];
		[currentHeader getBytes:&size range:NSMakeRange(8, 4)];
		[currentHeader getBytes:&offset range:NSMakeRange(12, 4)];
		
			// bpp, planes, size, and offset are pretty much the only things that could possibly matter to use
		
		NSLog(@"%hi", offset);
	}
}
@end
