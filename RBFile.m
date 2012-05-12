//
// RBFile.m
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

#import "RBFile.h"
#import "NSURL+RBExtras.h"

@interface RBFile ()

/**
 * The URL of the underlying file. May be lazy loaded.
 */
@property (nonatomic, strong) NSURL * url;

@end


@implementation RBFile

@synthesize canUnload, fileGenerator, url, title, MIMEType;

- (id) initWithFileGenerator:(id<RBFileGenerator>)generator {
	
	if ((self = [self init])) {
		[self setFileGenerator:generator];
	}
	
	return self;
}

- (id) initWithURL:(NSURL *)fileURL {
    
    if ((self = [self init])) {
        [self setUrl:fileURL];
    }
    
    return self;
}

- (id) init {
    
    if ((self = [super init])) {
        [self setCanUnload:NO];
    }
    
    return self;
}

- (void) generateFile {
    
    // Lazy loads the file if applicable.
    if (![self url] && [self fileGenerator])
        [self setUrl:[NSURL fileURLWithPath:[[self fileGenerator] generateFile]]];
}

- (void) unloadFile {
    
    if ([self canUnload] && [self fileGenerator] && [self url]) {
        
        NSError * error = nil;
        [[NSFileManager defaultManager] removeItemAtURL:[self url] 
                                                  error:&error];
        if (error) {
            NSLog(@"Error unloading file: %@. Error: %@", 
                  [self url], 
                  [error localizedDescription]);
            return;
        }
        
        [self setUrl:nil];
    }
}

- (BOOL) isFileLoaded {
    
    return [self url] != nil;
}

- (NSURL *)fileURL {
    return [self previewItemURL];
}

- (NSString *)MIMEType {
    
    if (MIMEType) {
        return MIMEType;
    }
    else if ([self fileGenerator]) {
        return [[self fileGenerator] MIMEType];
    }
    else {
        return [[self fileURL] MIMEType];
    }
}

- (void)setFileGenerator:(id<RBFileGenerator>)aFileGenerator {
    
    if (![fileGenerator isEqual:aFileGenerator]) {
        
        [self willChangeValueForKey:@"fileGenerator"];
        [fileGenerator release];
        fileGenerator = [aFileGenerator retain];
        [self setUrl:nil];
        [self didChangeValueForKey:@"fileGenerator"];
    }
}


#pragma mark - QLPreviewItem methods

- (NSURL *) previewItemURL {
    
    [self generateFile];
    
    return [self url];
}

- (NSString *) previewItemTitle {
    
    [self generateFile];
    
    if (![self title])
        return [[self url] lastPathComponent];
    
    return [self title];
}


#pragma mark - Memory Management

- (void) dealloc {
    [fileGenerator release];
	[url release];
    [title release];
	[super dealloc];
}

@end
