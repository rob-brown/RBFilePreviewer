#import "RBResourceManager.h"

@implementation RBResourceManager

+(NSBundle*)previewBundle
{
   NSBundle* main_bundle_ = [ NSBundle bundleForClass: [ self class ] ];
   NSString* bundle_path_ = [ main_bundle_ pathForResource: @"RBFilePreviewerResources" 
                                                    ofType: @"bundle" ];

   NSBundle* result_ = [ NSBundle bundleWithPath: bundle_path_ ];
   return result_;
}

+(UIImage*)previewerPngImageNamed:( NSString* )image_name_
{
   NSBundle* preview_bundle_ = [ self previewBundle ];
   NSString* image_path_ = [ preview_bundle_ pathForResource: image_name_
                                                      ofType: @"png" ];
   
   UIImage* result_ = [ UIImage imageWithContentsOfFile: image_path_ ];
   return result_;
}


@end
