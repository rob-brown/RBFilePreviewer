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
#import "UIImage+BBlock.h"


@interface RBFilePreviewer ()

/// An array of QLPreviewItems that can be previewed. 
@property (nonatomic, copy) NSArray * files;

/// A custom toolbar to replace QLPreviewController's irregular toolbar.
@property (nonatomic, strong) UIToolbar * toolbar;

/// The previous document button.
@property (nonatomic, strong) UIBarButtonItem * leftButton;

/// the next document button.
@property (nonatomic, strong) UIBarButtonItem * rightButton;

/// Returns true if this view controller was presented modally. False otherwise. 
- (BOOL)isModalViewController;

/// Removes the action button from the navigation bar if desired.
- (void)removeActionButtonIfApplicable;

/// Adds a toolbar to the view if it's needed.
- (void)addToolbarIfApplicable;

/// Updates the enabled/disabled state of the document navigation arrows.
- (void)updateArrows;

- (UIImage *)leftArrow;

- (UIImage *)rightArrow;

@end


@implementation RBFilePreviewer

@synthesize showActionButton   = _showActionButton;
@synthesize files              = _files;
@synthesize leftButton         = _leftButton;
@synthesize rightButton        = _rightButton;
@synthesize rightBarButtonItem = _rightBarButtonItem;
@synthesize toolbar            = _toolbar;
@synthesize navBarTintColor    = _navBarTintColor;
@synthesize toolBarTintColor   = _toolBarTintColor;
@synthesize block              = _block;


#pragma mark - Initializers

- (id)initWithFile:(id<QLPreviewItem>)file {
    
    RBFilePreviewer * result = [self initWithFiles:[NSArray arrayWithObject:file]];
    [result setCurrentPreviewItemIndex:0];
    
    return result;
}

- (id)initWithFiles:(NSArray *)files  {
    NSAssert([files count] > 0, @"Empty file array.");
    
    if ((self = [super init])) {
        [self setShowActionButton:YES];
        [self setFiles:files];
        [self setDataSource:self];
        [self setDelegate:self];
        [self setCurrentPreviewItemIndex:0];
    }
    
    return self;
}

#pragma mark - Utilities

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
    
    if ([self currentPreviewItemIndex] - 1 < 0)
        return;
    
    [self setCurrentPreviewItemIndex:[self currentPreviewItemIndex] - 1];
}

- (IBAction)showNextDocument:(id)sender {
    
    if ([self currentPreviewItemIndex] >= [[self files] count])
        return;
    
    [self setCurrentPreviewItemIndex:[self currentPreviewItemIndex] + 1];
}

- (void)setCurrentPreviewItemIndex:(NSInteger)index {
    
    NSInteger max = [[self files] count];
    
    if (index < 0 || index >= max)
        return;
    
    [super setCurrentPreviewItemIndex:index];
    self.showActionButton = [[[self.files objectAtIndex:index] previewItemURL] isFileURL];
    
    [self updateArrows];
    [self removeActionButtonIfApplicable];
}

- (void)updateArrows {
    
    NSInteger index = [self currentPreviewItemIndex];
    NSInteger max = [[self files] count];
    
    [[self rightButton] setEnabled:(index < max - 1)];
    [[self leftButton] setEnabled:(index != 0)];
}

- (void)removeActionButtonIfApplicable  {
    // Replaces the action button if desired.
    if ([self rightBarButtonItem])
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    // Hides the action button if not wanted.
    else if (!self.showActionButton)
        [self.navigationItem setRightBarButtonItem:nil 
                                          animated:NO];
}

- (void)addToolbarIfApplicable {
    // Adds a toolbar to the view so it's available to both pushed views and modal views.
    if (![self toolbar] && [[self files] count] > 1) {
        
        const CGFloat kStandardHeight = 44.0f;
        CGFloat superViewWidth = self.view.frame.size.width;
        CGFloat superViewHeight = self.view.frame.size.height;
        CGRect frame = CGRectMake(0, 
                                  superViewHeight - kStandardHeight, 
                                  superViewWidth, 
                                  kStandardHeight);
        
        UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:frame];
        UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithImage:[self leftArrow]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self 
                                                                 action:@selector(showPreviousDocument:)];
        
        UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithImage:[self rightArrow]
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
        [self setToolbar:toolbar];
        
        [self updateArrows];
        
        if (nil != self.toolBarTintColor)
            [[self toolbar] setTintColor:[self toolBarTintColor]];
    }
}

+ (BOOL)isFilePreviewingSupported {
	return (nil != NSClassFromString(@"QLPreviewController"));
}


#pragma mark - Images

- (UIImage *)leftArrow {
    return [UIImage imageWithIdentifier:@"RBFilePreviewerLeftArrow"
                                forSize:CGSizeMake(26.0f, 21.0f)
                        andDrawingBlock:
            ^{
                //// Bezier Drawing
                UIBezierPath * bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint:CGPointMake(23, 10.48)];
                [bezierPath addLineToPoint:CGPointMake(3, 10.48)];
                [bezierPath addLineToPoint:CGPointMake(9.91, 3.84)];
                [bezierPath addLineToPoint:CGPointMake(3, 10.48)];
                [bezierPath addLineToPoint:CGPointMake(9.91, 17.28)];
                [bezierPath addLineToPoint:CGPointMake(3, 10.48)];
                bezierPath.lineCapStyle = kCGLineCapRound;
                bezierPath.lineJoinStyle = kCGLineJoinRound;
                [[UIColor whiteColor] setStroke];
                bezierPath.lineWidth = 4.0f;
                [bezierPath stroke];
            }];
}

- (UIImage *)rightArrow {
    return [UIImage imageWithIdentifier:@"RBFilePreviewerRightArrow"
                                forSize:CGSizeMake(26.0f, 21.0f)
                        andDrawingBlock:
            ^{
                UIBezierPath * bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint:CGPointMake(3, 10.48)];
                [bezierPath addLineToPoint:CGPointMake(23, 10.48)];
                [bezierPath addLineToPoint:CGPointMake(16.09, 3.84)];
                [bezierPath addLineToPoint:CGPointMake(23, 10.48)];
                [bezierPath addLineToPoint:CGPointMake(16.09, 17.28)];
                [bezierPath addLineToPoint:CGPointMake(23, 10.48)];
                bezierPath.lineCapStyle = kCGLineCapRound;
                bezierPath.lineJoinStyle = kCGLineJoinRound;
                [[UIColor whiteColor] setStroke];
                bezierPath.lineWidth = 4.0f;
                [bezierPath stroke];
            }];
}

#pragma mark - QLPreviewControllerDataSource methods.

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
	return [[self files] count];
}


- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller 
                    previewItemAtIndex:(NSInteger)index {
    id<QLPreviewItem> result = [[self files] objectAtIndex:index];  
    self.showActionButton = [result.previewItemURL isFileURL];
    
	return result;
}


#pragma mark - QLPreviewControllerDelegate methods

- (BOOL)previewController:(QLPreviewController *)controller 
            shouldOpenURL:(NSURL *)url 
           forPreviewItem:(id<QLPreviewItem>)item {
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


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert(self.navigationController, @"RBFilePreviewer must be in a nav controller.");
    
    if (nil != self.navBarTintColor)
        self.navigationController.navigationBar.tintColor = self.navBarTintColor;
}

- (void)viewDidUnload {
    [self setLeftButton:nil];
    [self setRightButton:nil];
    [self setToolbar:nil];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self removeActionButtonIfApplicable];
    
    // Overrides the original done button if the previewer was presented modally.
    if ([self isModalViewController]) {
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                     target:self 
                                                                                     action:@selector(dismissView:)];
        [self.navigationItem setLeftBarButtonItem:doneButton];
    }
    
    [self addToolbarIfApplicable];
    
    // Allows further customization via block.
    if (self.block)
        self.block(self);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
