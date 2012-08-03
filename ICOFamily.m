// Copyright (c) 2011 Alex Zielenski
// All Rights Reserved
//
// Permission is hereby granted, free of charge, to any person obtaining 
// a copy of this software and associated documentation files (the 
// "Software"), to deal in the Software without restriction, including 
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense,  and/or sell copies of the Software, and to 
// permit persons to whom the Software is furnished to do so, subject to 
// the following conditions:
//
// The above copyright notice and this permission notice shall be 
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Accelerate/Accelerate.h>
#import "NSMutableData+EndianValues.h"

#import "ICOFamily.h"

// According to http://msdn.microsoft.com/en-us/library/dd183376.aspx
typedef struct BitMapInfoHeader
{
    uint32_t     biSize;          // bitmap header size - should be 40
    int32_t      biWidth;         // bitmap pixel width
    int32_t      biHeight;        // bitmap pixel height; double for ico due to and map
    uint16_t     biPlanes;        // should be 1, 0 may work also
    uint16_t     biBitCount;      // Bits per pixel
    uint32_t     biCompression;   // 0 = uncompressed RGB/RGBA, 1 = run-length-encoded 8bpp, 2 = rle 4bpp
    uint32_t     biSizeImage;     // bitmap data size
    int32_t      biXPelsPerMeter; // usually 2835
    int32_t      biYPelsPerMeter; // usually 2835
    uint32_t     biClrUsed;       // 0 = 32 bit
    uint32_t     biClrImportant;  // 0
} __attribute__ ((__packed__)) BitMapInfoHeader;

// According to http://msdn.microsoft.com/en-us/library/ms997538.aspx
typedef struct IconDirEntry
{
    uint8_t      bWidth;          // Width, in pixels, of the image
    uint8_t      bHeight;         // Height, in pixels, of the image
    uint8_t      bColorCount;     // Number of colors in image (0 if >=8bpp)
    uint8_t      bReserved;       // Reserved
    uint16_t     wPlanes;         // Color Planes
    uint16_t     wBitCount;       // Bits per pixel
    uint32_t     dwBytesInRes;    // how many bytes in this resource?
    uint32_t     dwImageOffset;   // Where in the file is this image?
} __attribute__ ((__packed__)) IconDirEntry;

// According to http://msdn.microsoft.com/en-us/library/ms997538.aspx
typedef struct IconDir
{
    uint16_t     idReserved;      // Reserved (must be 0)
    uint16_t     idType;          // Resource type (1 for icons)
    uint16_t     idCount;         // How many images?
    IconDirEntry idEntries[1];    // // The entries for each image
} __attribute__ ((__packed__)) IconDir;

@interface ICOFamily (Private)

- (BOOL)verifyImageOfSize:(NSSize)size forElement:(kICOFamilyElement)element;

@end

@implementation ICOFamily
@synthesize elements;
#pragma mark -
#pragma mark Initializers
- init {
	if ((self = [super init])) {
		elements=[[NSMutableDictionary alloc] init];
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

#pragma mark -
#pragma mark Getting and Setting Representations
- (void)setImage:(NSImage*)image forCustomSize:(NSSize)size {
	if (!image)
		return;
	[self setData:image.TIFFRepresentation 
	forCustomSize:size];
}
- (void)setBitmapImageRep:(NSBitmapImageRep*)rep forCustomSize:(NSSize)size {
	if (!rep)
		return;
	if (size.width<1||size.height<1)
		return;
	if (rep.pixelsWide!=size.width||rep.pixelsHigh!=size.height)
		return;
	if (size.width<=0||size.height>256||size.height<=0||size.width>256)
		return; // Maximum dimensions
	
	if ([rep respondsToSelector:@selector(bitmapImageRepByConvertingToColorSpace:renderingIntent:)]) {	// 10.6+ runtime only
		rep = [rep bitmapImageRepByConvertingToColorSpace:[NSColorSpace genericRGBColorSpace]
                                          renderingIntent:NSColorRenderingIntentPerceptual];
	}
	[elements setObject:rep forKey:NSStringFromSize(size)];
}
- (void)setData:(NSData*)data forCustomSize:(NSSize)size {
	if (!data)
		return;
	
	NSBitmapImageRep *nr = [NSBitmapImageRep imageRepWithData:data];
	[self setBitmapImageRep:nr forCustomSize:size];
}
- (NSData*)dataForCustomSize:(NSSize)size {
	return [[self bitmapImageRepForCustomSize:size] representationUsingType:NSPNGFileType 
																 properties:nil];
}
- (NSImage*)imageForCustomSize:(NSSize)size {
	return [[[NSImage alloc] initWithData:[self dataForCustomSize:size]] autorelease];
}
- (NSBitmapImageRep*)bitmapImageRepForCustomSize:(NSSize)size {
	return [elements objectForKey:NSStringFromSize(size)];
}
- (void)setElements:(kICOFamilyElement)element fromImage:(NSImage*)im {
	if (!im)
		return;
	
	if ((element & kICOFamily256Element) == kICOFamily256Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		[im setSize:NSMakeSize(256, 256)];
		[self setImage:im
			forElement:kICOFamily256Element];
	}
	if ((element & kICOFamily128Element) == kICOFamily128Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		[im setSize:NSMakeSize(128, 128)];
		[self setImage:im
			forElement:kICOFamily128Element];
	}
	if ((element & kICOFamily64Element) == kICOFamily64Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		[im setSize:NSMakeSize(64, 64)];
		[self setImage:im
			forElement:kICOFamily64Element];
	}
	if ((element & kICOFamily48Element) == kICOFamily48Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		[im setSize:NSMakeSize(48, 48)];
		[self setImage:im
			forElement:kICOFamily48Element];
	}
	if ((element & kICOFamily32Element) == kICOFamily32Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		[im setSize:NSMakeSize(32, 32)];
		[self setImage:im
			forElement:kICOFamily32Element];
	}
	if ((element & kICOFamily24Element) == kICOFamily24Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		[im setSize:NSMakeSize(24, 24)];
		[self setImage:im
			forElement:kICOFamily24Element];
	}
	if ((element & kICOFamily16Element) == kICOFamily16Element || (element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		[im setSize:NSMakeSize(16, 16)];
		[self setImage:im
			forElement:kICOFamily16Element];
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
		return;
	}
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
																	pixelsWide:image.size.width
																	pixelsHigh:image.size.height
																 bitsPerSample:8 
															   samplesPerPixel:4 
																	  hasAlpha:YES 
																	  isPlanar:NO 
																colorSpaceName:NSDeviceRGBColorSpace
																  bitmapFormat:NSAlphaFirstBitmapFormat
																   bytesPerRow:4 * image.size.width 
																  bitsPerPixel:32];
	NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:ctx];
	[image drawAtPoint:NSZeroPoint 
			  fromRect:NSZeroRect 
			 operation:NSCompositeCopy 
			  fraction:1.0];
	[NSGraphicsContext restoreGraphicsState];
	
	[self setBitmapImageRep:rep forElement:element];
	[rep release];
}
- (void)setBitmapImageRep:(NSBitmapImageRep*)rep forElement:(kICOFamilyElement)element {
	if (!rep)
		return;
	if ((element & kICOFamilyAllElements)==kICOFamilyAllElements) {
		NSBitmapImageRep *bitmapRep = [[[NSBitmapImageRep alloc] initWithCGImage:rep.CGImage] autorelease];
		NSImage *image = [[[NSImage alloc] init] autorelease];
		[image addRepresentation:bitmapRep];
		[self setElements:element fromImage:image];
		return;
	}
	if ([self verifyImageOfSize:NSMakeSize(rep.pixelsWide, rep.pixelsHigh) 
					 forElement:element])
		{
		if ([rep respondsToSelector:@selector(bitmapImageRepByConvertingToColorSpace:renderingIntent:)])	// 10.6+ runtime only
			{
			rep = [rep bitmapImageRepByConvertingToColorSpace:[NSColorSpace genericRGBColorSpace]
											  renderingIntent:NSColorRenderingIntentPerceptual];
			}
		[elements setObject:rep forKey:[NSNumber numberWithInteger:element]];
		}
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

#pragma mark -
#pragma mark Handling Data
- (NSData*)data {
	NSMutableData *data = [NSMutableData data];
    IconDir        iconDir;
    
    iconDir.idReserved = 0;
    iconDir.idType = 1;
    iconDir.idCount = elements.count;
    
    // Write ico header (icon directory)
    [data appendLEUInt16:iconDir.idReserved];
    [data appendLEUInt16:iconDir.idType];
    [data appendLEUInt16:iconDir.idCount];
    
    // Prepare image headers & image data
	NSMutableData *headers = [[NSMutableData alloc] init];
	NSMutableData *images = [[NSMutableData alloc] init];
	
    // Sort the elements
	NSSortDescriptor *sortHigh = [[[NSSortDescriptor alloc] initWithKey:@"pixelsHigh" ascending:NO] autorelease];
	NSSortDescriptor *sortWide = [[[NSSortDescriptor alloc] initWithKey:@"pixelsWide" ascending:NO] autorelease];
	NSArray *vals = [elements.allValues sortedArrayUsingDescriptors:[NSArray arrayWithObjects: sortHigh, sortWide, nil]];
	
    // Work through each icon
	for (NSBitmapImageRep *currentRep in vals) {
        BitMapInfoHeader    bitmapHeader;
        IconDirEntry        entryHeader;
        
        uint32_t            bmpSize = (uint32_t) (currentRep.pixelsHigh * currentRep.bytesPerRow);
        uint32_t            andSize = (uint32_t) ((((currentRep.pixelsWide) + 31) >> 5) << 2);
        
        vImage_Buffer       bmpBuf;
        vImage_Buffer       tmpBuf;
        vImage_Buffer       andBuf;
        
        // Initialize the image buffers
        bmpBuf.height = currentRep.pixelsHigh;
        bmpBuf.width = currentRep.pixelsWide;
        bmpBuf.rowBytes = currentRep.bytesPerRow;
        bmpBuf.data =  malloc(bmpSize);
        
        tmpBuf.height = currentRep.pixelsHigh;
        tmpBuf.width = currentRep.pixelsWide;
        tmpBuf.rowBytes = currentRep.bytesPerRow;
        tmpBuf.data =  malloc(bmpSize);
        
        andBuf.height = currentRep.pixelsHigh;
        andBuf.width = currentRep.pixelsWide;
        andBuf.rowBytes = currentRep.bytesPerRow;
        andBuf.data = malloc(andSize);
		
        memcpy(bmpBuf.data, currentRep.bitmapData, bmpSize);
        memset(andBuf.data, 0, andSize);
		
        // Initialize the ICO bitmap header
        bitmapHeader.biSize = 40; // 40 byte header
        bitmapHeader.biWidth = (int32_t) currentRep.pixelsWide;
        bitmapHeader.biHeight = (int32_t) currentRep.pixelsHigh * 2; // double height due to and map
        bitmapHeader.biPlanes = 1;
        bitmapHeader.biBitCount = currentRep.bitsPerPixel;
        bitmapHeader.biCompression = 0;
        bitmapHeader.biSizeImage = bmpSize + andSize;
        bitmapHeader.biXPelsPerMeter = 0;//2835;
        bitmapHeader.biYPelsPerMeter = 0;//2835;
        bitmapHeader.biClrUsed = 0;
        bitmapHeader.biClrImportant = 0;
        
        // Initialize the ICO directory entry
        entryHeader.bWidth = (currentRep.pixelsWide == 256 ? 0 : currentRep.pixelsWide);
        entryHeader.bHeight = (currentRep.pixelsHigh == 256 ? 0 : currentRep.pixelsHigh);
        entryHeader.bColorCount = 0;
        entryHeader.bReserved = 0;
        entryHeader.wPlanes = currentRep.numberOfPlanes; // must be 1
        entryHeader.wBitCount = currentRep.bitsPerPixel; // must be 32
        entryHeader.dwBytesInRes = bitmapHeader.biSizeImage + 40;
        entryHeader.dwImageOffset = (int32_t) (16 * elements.count+images.length+data.length);
        
        // "Write" the ICO header data
        [headers appendLEUInt8:entryHeader.bWidth];
        [headers appendLEUInt8:entryHeader.bHeight];
        [headers appendLEUInt8:entryHeader.bColorCount];
        [headers appendLEUInt8:entryHeader.bReserved];
        [headers appendLEUInt16:entryHeader.wPlanes];
        [headers appendLEUInt16:entryHeader.wBitCount];
        [headers appendLEUInt32:entryHeader.dwBytesInRes];
        [headers appendLEUInt32:entryHeader.dwImageOffset];
        
        // "Write" the bitmap header data
        [images appendLEUInt32:bitmapHeader.biSize];
        [images appendLESInt32:bitmapHeader.biWidth];
        [images appendLESInt32:bitmapHeader.biHeight];
        [images appendLEUInt16:bitmapHeader.biPlanes];
        [images appendLEUInt16:bitmapHeader.biBitCount];
        [images appendLEUInt32:bitmapHeader.biCompression];
        [images appendLEUInt32:bitmapHeader.biSizeImage];
        [images appendLESInt32:bitmapHeader.biXPelsPerMeter];
        [images appendLESInt32:bitmapHeader.biYPelsPerMeter];
        [images appendLEUInt32:bitmapHeader.biClrUsed];
        [images appendLEUInt32:bitmapHeader.biClrImportant];
        
        // Fix the bitmap image data to be compatible
        const uint8_t permuteMap[4] = {3,2,1,0};
        vImagePermuteChannels_ARGB8888 (&bmpBuf,&tmpBuf,permuteMap,kvImageDoNotTile);
        vImageVerticalReflect_ARGB8888 (&tmpBuf,&bmpBuf,kvImageDoNotTile);
        
        // "Write" the bitmap image/mask data
        [images appendBytes:bmpBuf.data length:bmpSize];
        [images appendBytes:andBuf.data length:andSize];
        
		free(bmpBuf.data);
        free(tmpBuf.data);
        free(andBuf.data);
	}
    
    // Copy images & headers into ico data
	[data appendBytes:headers.bytes length:headers.length];
	[data appendBytes:images.bytes length:images.length];
    
	[headers release];
	[images release];
	
    return data;
}

- (void)readFromData:(NSData*)data { // Not yet. Might need help with this one. For now just use NSImage ;) 
	return;
}

#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone*)zone {
	ICOFamily *nf = [[ICOFamily allocWithZone:zone] init];
	nf.elements=self.elements;
	return nf;
}
@end
