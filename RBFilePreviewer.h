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

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@class RBFilePreviewer;

typedef void(^RBFilePreviewCustomizeBlock)(RBFilePreviewer * previewer);


/**
 * A subclass of QLPreviewController to make previewing files even easier. 
 * Unlike QLPreviewController, RBFilePreviewer show the document navigation 
 * toolbar both when the previewer is pushed or presented modally. You can also 
 * remove the action button if you so desire.
 *
 * NOTE: You must wrap RBFilePreviewer in a navigation controller if you present 
 * it modally.
 */
@interface RBFilePreviewer : QLPreviewController <QLPreviewControllerDataSource, QLPreviewControllerDelegate, UIDocumentInteractionControllerDelegate>

/// You may remove the action button if you don't want it.
@property (nonatomic, assign) BOOL showActionButton;

/// You may add a custom right bar button item instead of using the print button.
@property (nonatomic, strong) UIBarButtonItem * rightBarButtonItem;

/// A custom tint color for the nav bar. Be aware that if this view is pushed, 
/// then this will change the color of all nav bars in the navigation stack.
@property (nonatomic, strong) UIColor * navBarTintColor;

/// A custom tint color for the tool bar.
@property (nonatomic, strong) UIColor * toolBarTintColor;

/// A block for customizing the appearance of the RBFilePreviewer.
@property (nonatomic, copy) RBFilePreviewCustomizeBlock block;


/**
 * Convenience method if you just want to preview on file;
 */
- (id)initWithFile:(id<QLPreviewItem>)file;

/**
 *  Creates a file previewer from the given files. The array must not be empty.
 *
 *  @param theFiles An array of QLPreviewItems.
 *
 *  @return self
 */
- (id)initWithFiles:(NSArray *)theFiles;

/**
 *  This should be called before creating RBFileViewer. Quick Look is not 
 *  supported on pre-4.0 devices. Returns YES if Quick Look is supported.
 *
 *  @return YES if Quick Look is supported.
 */
+ (BOOL)isFilePreviewingSupported;

/**
 * Dismisses the file previewer. Takes into account if the view was presented modally.
 */
- (IBAction)dismissView:(id)sender;

@end
