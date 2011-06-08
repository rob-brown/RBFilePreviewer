//
//  RBBaseFileGenerator.m
//  StatCollector
//
//  Created by Robert Brown on 5/23/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import "RBBaseFileGenerator.h"
#import "RBFile.h"

@implementation RBBaseFileGenerator

- (NSString *) generateFile {
    
    return nil;
}

- (RBFile *) generateRBFile {
    
    return [[[RBFile alloc] initWithFileGenerator:self] autorelease];
}

- (NSString *) MIMEType {
    
    return nil;
}

@end
