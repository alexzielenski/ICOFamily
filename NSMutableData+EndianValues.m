// Copyright 2013 Mathew Eis <mathew@eisbox.net>
//  
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSMutableData+EndianValues.h"

@implementation NSMutableData (EndianValues)

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
    UInt8 b[2];
    b[0] = value >> 8;
    b[1] = value;
    [self appendBytes:&b[0] length:2];
}

- (void) appendBEUInt32: (UInt32)value
{
    UInt8 b[4];
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
    UInt8 b[2];
    b[0] = value;
    b[1] = value >> 8;
    [self appendBytes:&b[0] length:2];
}

- (void) appendLEUInt32: (UInt32)value
{
    UInt8 b[4];
    b[0] = value;
    b[1] = value >> 8;
    b[2] = value >> 16;
    b[3] = value >> 24;
    [self appendBytes:&b[0] length:4];
}

@end
