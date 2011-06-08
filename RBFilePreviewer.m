//
// RBFilePreviewer.h
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

#import "RBFilePreviewer.h"


@interface RBFilePreviewer ()

@property (nonatomic, retain) NSArray * files;

/**
 *  Creates a file previewer from the given files. There must be at least one
 *  QLPreviewItem in the array.
 *
 *  @todo Fix this to work with multiple files. For some reason the arrows in 
 *  the UIToolbar disappear.
 *
 *  @param theFiles An array of QLPreviewItems.
 *
 *  @return self
 */
- (id)initWithFiles:(NSArray *)theFiles;

@end


@implementation RBFilePreviewer

@synthesize files;

- (id)initWithFile:(id<QLPreviewItem>)file {
    
    return [self initWithFiles:[NSArray arrayWithObject:file]];
}

- (id)initWithFiles:(NSArray *)theFiles {
	
    NSAssert([theFiles count] > 0, @"Empty file array.");
    
    if ((self = [super init])) {
		
		[self setFiles:theFiles];
		self.dataSource = self;
        self.delegate = self;
		self.currentPreviewItemIndex = 0;
    }
	
    return self;
}

+ (BOOL) isFilePreviewingSupported {
	
	return NSClassFromString(@"QLPreviewController") != nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - QLPreviewControllerDataSource methods.

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
	return [[self files] count];
}


- (id <QLPreviewItem>) previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
	return [[self files] objectAtIndex:index];
}


#pragma mark - QLPreviewControllerDelegate methods

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item {
	return YES;
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
	//NSLog(@"Quick Look will dismiss");
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
	//NSLog(@"Quick Look did dismiss");
}


#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController {
    return self.parentViewController;
}

// TODO: Add more support for UIDocumentInteractionController.


#pragma mark - View Lifetime

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[files release];
    [super dealloc];
}


@end
