//
//  NSMutableData+EndianValues.m
//  iConvertIcons
//
//  Created by Mathew Eis on 22/11/2011.
//  Copyright (c) 2011 Mathew Eis. All rights reserved.
//

#import "NSMutableData+EndianValues.h"

@implementation  NSMutableData (EndianValues)

- (void) appendBESInt8: (SInt8)value
{
    [self appendBytes:&(value) length:1];
}
- (void) appendBESInt16: (SInt16)value
{
    UInt16 uvalue = *((UInt16 *)(&value));
    [self appendBEUInt16:uvalue];
}
- (void) appendBESInt32: (SInt32)value
{
    UInt32 uvalue = *((UInt32 *)(&value));
    [self appendBEUInt32:uvalue];
}

- (void) appendBEUInt8: (UInt8)value
{
    [self appendBytes:&(value) length:1];    
}
- (void) appendBEUInt16: (UInt16)value
{
    UInt8   b[2];
    b[0] = value >> 8;
    b[1] = value;
    [self appendBytes:&b[0] length:2];    
}
- (void) appendBEUInt32: (UInt32)value
{
    UInt8   b[4];
    b[0] = value >> 24;
    b[1] = value >> 16;
    b[2] = value >> 8;
    b[3] = value;
    [self appendBytes:&b[0] length:4];    
}

- (void) appendLESInt8: (SInt8)value
{
    [self appendBytes:&(value) length:1];
}
- (void) appendLESInt16: (SInt16)value
{
    UInt16 uvalue = *((UInt16 *)(&value));
    [self appendLEUInt16:uvalue]; 
}
- (void) appendLESInt32: (SInt32)value
{
    UInt32 uvalue = *((UInt32 *)(&value));
    [self appendLEUInt32:uvalue];    
}

- (void) appendLEUInt8: (UInt8)value
{
    [self appendBytes:&(value) length:1];    
}
- (void) appendLEUInt16: (UInt16)value
{
    UInt8   b[2];
    b[0] = value;
    b[1] = value >> 8;
    [self appendBytes:&b[0] length:2];        
}
- (void) appendLEUInt32: (UInt32)value
{
    UInt8   b[4];
    b[0] = value;
    b[1] = value >> 8;
    b[2] = value >> 16;
    b[3] = value >> 24;
    [self appendBytes:&b[0] length:4];
}

@end
