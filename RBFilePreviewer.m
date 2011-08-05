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

/// An array of QLPreviewItems that can be previewed. 
@property (nonatomic, copy) NSArray * files;

/// A flag to indicate if the toolbar has been loaded and no longer needs to be loaded.
@property (nonatomic, assign) BOOL toolBarLoaded;

/// The previous document button.
@property (nonatomic, retain) UIBarButtonItem * leftButton;

/// the next document button.
@property (nonatomic, retain) UIBarButtonItem * rightButton;

/// Returns true if this view controller was presented modally. False otherwise. 
- (BOOL)isModalViewController;

/// Removes the action button from the navigation bar if desired.
- (void)removeActionButtonIfApplicable;

/// Adds a toolbar to the view if it's needed.
- (void)addToolbarIfApplicable;

/// Updates the enabled/disabled state of the document navigation arrows.
- (void)updateArrows;

@end


@implementation RBFilePreviewer

@synthesize showActionButton, files, toolBarLoaded, leftButton, rightButton;

- (id)initWithFile:(id<QLPreviewItem>)file {
    
    return [self initWithFiles:[NSArray arrayWithObject:file]];
}

- (id)initWithFiles:(NSArray *)theFiles {
	
    NSAssert([theFiles count] > 0, @"Empty file array.");
    
    if ((self = [super init])) {
		
        [self setShowActionButton:YES];
		[self setFiles:theFiles];
        [self setDataSource:self];
        [self setDelegate:self];
        [self setCurrentPreviewItemIndex:0];
    }
	
    return self;
}

- (BOOL)isModalViewController {
    return ([[[self navigationController] parentViewController] modalViewController] || 
            [[self parentViewController] modalViewController]);
}

- (IBAction)dismissView:(id)sender {
    
    if ([self isModalViewController])
        [[self navigationController] dismissModalViewControllerAnimated:YES];
    else
        [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)showPreviousDocument:(id)sender {
    [self setCurrentPreviewItemIndex:[self currentPreviewItemIndex] - 1];
}

- (IBAction)showNextDocument:(id)sender {
    [self setCurrentPreviewItemIndex:[self currentPreviewItemIndex] + 1];
}

- (void)setCurrentPreviewItemIndex:(NSInteger)index {
    
    NSInteger max = [[self files] count];
    
    if (index < 0 || index >= max)
        return;
    
    [super setCurrentPreviewItemIndex:index];
    [self updateArrows];
    [self removeActionButtonIfApplicable];
}

- (void)updateArrows {
    
    NSInteger index = [self currentPreviewItemIndex];
    NSInteger max = [[self files] count];
    
    [[self rightButton] setEnabled:(index < max - 1)];
    [[self leftButton] setEnabled:(index != 0)];
}

- (void)removeActionButtonIfApplicable {
    
    // Hides the action button if not wanted.
    if (![self showActionButton])
        [[self navigationItem] setRightBarButtonItem:nil 
                                            animated:NO];
}

- (void)addToolbarIfApplicable {
    
    // Adds a toolbar to the view so it's available to both pushed views and modal views.
    if (![self toolBarLoaded] && [[self files] count] > 1) {
        
        const CGFloat kStandardHeight = 44.0f;
        CGFloat superViewWidth = self.view.frame.size.width;
        CGFloat superViewHeight = self.view.frame.size.height;
        CGRect frame = CGRectMake(0, 
                                  superViewHeight - kStandardHeight, 
                                  superViewWidth, 
                                  kStandardHeight);
        
        UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:frame];
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow-left.png"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self 
                                                                 action:@selector(showPreviousDocument:)];
        UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow-right.png"]
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self 
                                                                  action:@selector(showNextDocument:)];
        
        UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                        target:nil 
                                                                                        action:nil];
        
        [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, left, flexibleSpace, right, flexibleSpace, nil]];
        [self setLeftButton:left];
        [self setRightButton:right];
        [[self view] addSubview:toolbar];
        [toolbar release];
        [left release];
        [right release];
        [flexibleSpace release];
        
        [self updateArrows];
        [self setToolBarLoaded:YES];
    }
}

+ (BOOL)isFilePreviewingSupported {
	
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
    return [self parentViewController];
}

// TODO: Add more support for UIDocumentInteractionController.


#pragma mark - View Lifetime

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert([self navigationController], @"RBFilePreviewer must be in a nav controller.");
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self setToolBarLoaded:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self removeActionButtonIfApplicable];
    
    // Overrides the original done button if the previewer was presented modally.
    if ([self isModalViewController]) {
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                     target:self 
                                                                                     action:@selector(dismissView:)];
        [[self navigationItem] setLeftBarButtonItem:doneButton];
        [doneButton release];
    }
    
    [self addToolbarIfApplicable];
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[self setFiles:nil];
    [self setLeftButton:nil];
    [self setRightButton:nil];
    [super dealloc];
}

@end
