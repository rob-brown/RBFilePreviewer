//
// RBFile.h
//
// Copyright (c) 2011 Robert Brown
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
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

#import "RBFileGenerator.h"

/**
 *  Represents a file created from RBFileGenerator or an existing file. If a 
 *  file is set up for lazy loading, you should be careful about caching the 
 *  file's NSURL. File unloading can be turned off by setting canUnload to NO.
 */
@interface RBFile : NSObject <QLPreviewItem>

/**
 * An optional ivar for holding a file generator for lazy loading files.
 */
@property (nonatomic, strong) id<RBFileGenerator> fileGenerator;

/**
 * An optional title to give to the file. If no title is given, then the title 
 * defaults to the file name.
 */
@property (nonatomic, copy) NSString * title;

/**
 * The MIME type of the file. A MIME type may either be specified or inferred 
 * from a file generator or the file extension, in that order. 
 */
@property (nonatomic, copy) NSString * MIMEType;

/**
 * When set to NO, prevents the file from being unloaded. If you want to 
 * guarantee that a file will be loaded, set this property to NO before 
 * requesting the file's URL. Default value is NO.
 */
@property (nonatomic, assign) BOOL canUnload;

/** 
 *  Creates the file from the given file generator. The underlying file isn't 
 *  created right away. It is lazy loaded when it is accessed through the 
 *  QLPreviewItem protocol. This can be beneficial when you don't want to 
 *  generate large files when you don't need to.
 *
 *  @param generator The file generator to use to create the underlying file.
 */
- (id) initWithFileGenerator:(id<RBFileGenerator>)generator;

/** 
 *  Creates the file from the given URL.
 *
 *  @param fileURL The URL that points to the file.
 */
- (id) initWithURL:(NSURL *)fileURL;

/**
 *  Forces the file to be generated if it isn't already. 
 */
- (void) generateFile;

/**
 *  Deletes the underlying file if a file generator can reload it later. 
 */
- (void) unloadFile;

/**
 *  Returns YES if the file exists.
 *
 *  @return YES if the file exists.
 */
- (BOOL) isFileLoaded;

/**
 * Convenience method. Simply returns the file's URL. Simply calls 
 * -previewItemURL. This name change makes more sense in general use.
 *
 * @return The file's URL.
 */
- (NSURL *)fileURL;

@end
