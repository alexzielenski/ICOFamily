//
//  NSMutableData+EndianValues.h
//  iConvertIcons
//
//  Created by Mathew Eis on 22/11/2011.
//  Copyright (c) 2011 Mathew Eis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData (EndianValues)

- (void) appendBESInt8: (SInt8)value;
- (void) appendBESInt16: (SInt16)value;
- (void) appendBESInt32: (SInt32)value;

- (void) appendBEUInt8: (UInt8)value;
- (void) appendBEUInt16: (UInt16)value;
- (void) appendBEUInt32: (UInt32)value;

- (void) appendLESInt8: (SInt8)value;
- (void) appendLESInt16: (SInt16)value;
- (void) appendLESInt32: (SInt32)value;

- (void) appendLEUInt8: (UInt8)value;
- (void) appendLEUInt16: (UInt16)value;
- (void) appendLEUInt32: (UInt32)value;

@end
