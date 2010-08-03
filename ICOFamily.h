//
//  ICOFamily.h
//  ICOFamily
//
//  Created by Alex Zielenski on 8/2/10.
//  Copyright 2010 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
/** @typedef 
 Some predefined sizes commonly used in ICO files 
 */
typedef enum _kICOFamilyElement {
	kICOFamilyAllElements   = -1,
	kICOFamily256Element    = 0,
	kICOFamily128Element    = 1,
	kICOFamily64Element     = 2,
	kICOFamily48Element     = 4,
	kICOFamily32Element     = 8,
	kICOFamily24Element     = 16,
	kICOFamily16Element     = 32
} kICOFamilyElement;

/**
 A class for saving an ICO file using any size under 256 pixels.
 */
@interface ICOFamily: NSObject <NSCopying> {
	NSMutableDictionary *elements;
}
#pragma mark -
#pragma mark Creating and Initializing ICOFamilies
	//////////////////////////////////////////////////////////////////////////////////////////
	/// @name Creating and Initializing ICOFamilies
	//////////////////////////////////////////////////////////////////////////////////////////
/** Defines an @c ICOFamily and sets an image using the setImage: method
 @param image the image to set.
 @see setImage:forElement:
 @see familyWithImage:
 */
- initWithImage:(NSImage*)image;
/** Defines an @c ICOFamily and sets an image using the setBitmapImageRep: method
 @param rep the @c NSBitmapImageRep to set.
 @see setBitmapImageRep:forElement:
 @see familyWithBitmapImageRep:
 */
- initWithBitmapImageRep:(NSBitmapImageRep*)rep;
/** Defines an @c ICOFamily and sets an image using the setData: method
 @param data the data to set.
 @see setData:forElement:
 @see familyWithData:
 */
- initWithData:(NSData*)data;

/** Creates an @c ICOFamily instance and returns it autoreleased.
 @see familyWithImage:
 @see familyWithBitmapImageRep:
 @see familyWithData:
 */
+ family;
/** Creates an @c ICOFamily instance and returns it autoreleased after setting the image.
 
 @param image The image to initially set.
 @see family:
 @see familyWithBitmapImageRep:
 @see familyWithData:
 @return Returns an autoreleased @c ICOFamily instance.
 */
+ familyWithImage:(NSImage*)image;
/** Creates an @c ICOFamily instance and returns it autoreleased after setting the @c NSBitmapImageRep.
 
 @param rep The @c NSBitmapImageRep to initially set.
 @see family:
 @see familyWithImage:
 @see familyWithData:
 @return Returns an autoreleased @c ICOFamily instance.
 */
+ familyWithBitmapImageRep:(NSBitmapImageRep*)rep;
/** Creates an @c ICOFamily instance and returns it autoreleased after setting the data.
 
 @param data The data to initially set.
 @see family:
 @see familyWithBitmapImageRep:
 @see familyWithImage:
 @return Returns an autoreleased @c ICOFamily instance.
 */
+ familyWithData:(NSData*)data;
#pragma mark -
#pragma mark Using the Family Elements
	//////////////////////////////////////////////////////////////////////////////////////////
	/// @name Using the ICOFamily Elements
	//////////////////////////////////////////////////////////////////////////////////////////
/** Sets the image for the specified @c kICOFamilyElement
 
 @param image The image to set for the specified element.
 @param element The element to set the image as.
 
 @see setBitmapImageRep:forElement:
 @see setData:forElement:
 @see imageForElement:
 @see dataForElement:
 @see bitmapImageRepForElement:
 @return Returns an autoreleased @c ICOFamily instance.
 */
- (void)setImage:(NSImage*)image forElement:(kICOFamilyElement)element;
/** Sets the @ NSBitmapImageRep for the specified @c kICOFamilyElement
 
 @param rep The rep to set for the specified element.
 @param element The element to set the image as.
 
 @see setImage:forElement:
 @see setData:forElement:
 @see imageForElement:
 @see dataForElement:
 @see bitmapImageRepForElement:
 */
- (void)setBitmapImageRep:(NSBitmapImageRep*)rep forElement:(kICOFamilyElement)element;
/** Sets the data for the specified @c kICOFamilyElement
 
 @param data The data to set for the specified element.
 @param element The element to set the image as.
 
 @see setBitmapImageRep:forElement:
 @see setImage:forElement:
 @see imageForElement:
 @see dataForElement:
 @see bitmapImageRepForElement:
 */
- (void)setData:(NSData*)data forElement:(kICOFamilyElement)element;


/** 
  - The size must not be NSZeroSize and the image's size and the specified size must match or this will do nothing. 
 
  - The blitwise OR operator can be used to specify multiple sizes. Additionally you can use the @c kICOFamilyAllElements 
 
 @param element THe Element(s) to resize and set the image to.
 @param image The image to set to Element
 
 @see setBitmapImageRep:forCustomSize:
 @see setData:forCustomSize:
 @see dataForCustomSize:
 @see imageForCustomSize:
 @see bitmapImageRepForCustomSize:
 */
- (void)setElements:(kICOFamilyElement)element fromImage:(NSImage*)image;
	
/** Gets the PNG representation of the specified @c kICOFamilyElement.
 @param element The element of which the returned data is for
 @return Returns the PNG data for the element
 @see imageForElement:
 @see bitmapImageRepForElement:
 @see setData:forElement:
 */
- (NSData*)dataForElement:(kICOFamilyElement)element;
/** Gets the @c NSImage representation of the specified @c kICOFamilyElement.
 @param element The element of which the returned image is for
 @return Returns the @c NSImage value for the specified element.
 @see dataForElement:
 @see bitmapImageRepForElement:
 @see setImage:forElement:
 */
- (NSImage*)imageForElement:(kICOFamilyElement)element;
/** Gets the @c NSBitmapImageRep of the specified @c kICOFamilyElement.
 @param element The element of which the returned @c NSBitmapImageRep is for
 @return Returns the @c NSBitmapImageRep for the specified element
 @see imageForElement:
 @see dataForElement:
 @see setBitmapImageRep:forElement:
 */
- (NSBitmapImageRep*)bitmapImageRepForElement:(kICOFamilyElement)element;

#pragma mark -
#pragma mark Using Custom Sizes
	//////////////////////////////////////////////////////////////////////////////////////////
	/// @name Using Custom Image Sizes
	//////////////////////////////////////////////////////////////////////////////////////////
/** The size must not be NSZeroSize and the image's size and the specified size must match or this will do nothing.
 @param image Image to set to the specified size
 @param size Size to set the image to
 
 @see setBitmapImageRep:forCustomSize:
 @see setData:forCustomSize:
 @see dataForCustomSize:
 @see imageForCustomSize:
 @see bitmapImageRepForCustomSize:
 */
- (void)setImage:(NSImage*)image forCustomSize:(NSSize)size;

/** The size must not be NSZeroSize and the image's pixel size and the specified size must match or this will do nothing.
 @param rep @c NSBitmapImageRep to set to the specified size
 @param size Size to set the image repersentation to
 
 @see setImage:forCustomSize:
 @see setData:forCustomSize:
 @see dataForCustomSize:
 @see imageForCustomSize:
 @see bitmapImageRepForCustomSize:
 */
- (void)setBitmapImageRep:(NSBitmapImageRep*)rep forCustomSize:(NSSize)size;
/** The size must not be NSZeroSize and the image's size and the specified size must match or this will do nothing.
 @param data Data to set to the specified size
 @param size Size to set the image to
 
 @see setBitmapImageRep:forCustomSize:
 @see setImage:forCustomSize:
 @see dataForCustomSize:
 @see imageForCustomSize:
 @see bitmapImageRepForCustomSize:
 */
- (void)setData:(NSData*)data forCustomSize:(NSSize)size;


/** Gets an @c NSData instance for the specified size.
 If the specified size doesn't exist, returns nil.
 @param size The size the get the data for.
 @return Returns the data for the specified size.
 
 @see imageForCustomSize:
 @see bitmapImageRepForCustomSize:
 @see setData:forCustomSize:
 */
- (NSData*)dataForCustomSize:(NSSize)size;
/** If the specified size doesn't exist, returns nil.
 @param size The size the get the image for.
 @return Returns the image for the specified size.
 
 @see dataForCustomSize:
 @see bitmapImageRepForCustomSize:
 @see setImage:forCustomSize:
 */
- (NSImage*)imageForCustomSize:(NSSize)size;
/** If the specified size doesn't exist, returns nil.
 @param size The size the get the @c NSBitmapImageRep for.
 @return Returns the @c NSBitmapImageRep for the specified size.

 
 @see imageForCustomSize:
 @see dataForCustomSize:
 @see setBitmapImageRep:forCustomSize:
 */
- (NSBitmapImageRep*)bitmapImageRepForCustomSize:(NSSize)size;

	//////////////////////////////////////////////////////////////////////////////////////////
	/// @name Writing the ICO.
	//////////////////////////////////////////////////////////////////////////////////////////
/** Gets the raw @c NSData object for the ICO file
 If there are no representations set, this returns nil.
 
 @return Returns the raw data for the ICO file for use when saving.
 */
- (NSData*)data;

	// - (void)readFromData:(NSData*)data; // Not yet. But if done correctly, would read from an ICO file's raw data and set the elements accordingly.

#pragma mark -
#pragma mark Getting Special Representations
	//////////////////////////////////////////////////////////////////////////////////////////
	/// @name Getting Special Representations
	//////////////////////////////////////////////////////////////////////////////////////////
/** Gets an image with all of the representations of the @c ICOFamily instance. 
 If no elements have been set, returns a blank NSImage.
 @return Returns an autoreleased @c NSImage instance with all of the representations retrieved from @c elements
 @see elements 
 */
- (NSImage*)imageWithAllReps;
/**  All of the representations go in here, unless they are null.
 
 @return A dictionary of all of the NSBitmapImageReps that will be used for the ICO file. Keys would either be an @c NSNumber representation of the element used or a size from NSStringFromSize()
 @see imageWithAllReps;
 
 */
@property (nonatomic, retain) NSMutableDictionary *elements;
@end
