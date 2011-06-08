//
//  RBBaseFileGenerator.h
//  StatCollector
//
//  Created by Robert Brown on 5/23/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RBFileGenerator.h"

/**
 * Provides a base implementation for file generators. -generateFile and 
 * -mimeType must be overriden.
 */
@interface RBBaseFileGenerator : NSObject <RBFileGenerator>

@end
