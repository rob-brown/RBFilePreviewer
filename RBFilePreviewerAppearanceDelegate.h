#import <Foundation/Foundation.h>

@class QLPreviewController;

@protocol RBFilePreviewerAppearanceDelegate <NSObject>

-(void)customizeAppearanceForPreviewController:( QLPreviewController* )controller_;

@end
