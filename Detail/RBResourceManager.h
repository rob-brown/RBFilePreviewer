#import <Foundation/Foundation.h>

@class UIImage;

@interface RBResourceManager : NSObject

+(NSBundle*)previewBundle;
+(UIImage*)previewerPngImageNamed:( NSString* )image_name_;

@end
