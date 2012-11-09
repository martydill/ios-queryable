//
//  ofTypeTests.m
//  ios-queryable
//
//  Created by Marty on 2012-11-08.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "ofTypeTests.h"
#import "NSManagedObjectContext+Queryable.h"

@implementation ofTypeTests

- (void)test_ofType_Returns_IQueryable
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Project"];
    
    STAssertNotNil(queryable, @"Queryable should not be null");
}

@end
