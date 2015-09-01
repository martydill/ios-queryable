//
//  fastEnumerationTests.m
//  ios-queryable
//
//  Created by Marty on 2012-12-01.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "fastEnumerationTests.h"

@implementation fastEnumerationTests

-(void) test_fast_enumeration_returns_correct_records
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];
    
    NSUInteger counter = 0;
    for(Product* product in queryable)
    {
        // Get rid of unused variable warning
        if(product != nil)
            ++counter;
    }
    
    XCTAssertEqual(self.testProductData.count, counter, @"Expected the total number of products");
}

-(void) test_fast_enumeration_caches_nsarray_when_context_changes_during_enumeration
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];
    
    NSUInteger counter = 0;
    for(Product* product in queryable)
    {
        if(counter == 0)
        {
            for(int i = 0; i < 20; ++i)
            {
                [NSEntityDescription insertNewObjectForEntityForName:@"Product"
                                     inManagedObjectContext:context];
            }
            [context save:nil];
        }
        
        // Get rid of unused variable warning
        if(product != nil)
            ++counter;
    }
    
    // Should only contain the original products, not any of the products added during the loop
    XCTAssertEqual(self.testProductData.count, counter, @"Expected the total number of products");
}

-(void) test_fast_enumeration_resets_state_after_enumeration
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [context ofType:@"Product"];
    
    // First, test with fewer items than the typical countByEnumeratingWithState len of 16
    NSUInteger counter = 0;
    for(Product* product in queryable)
    {
        // Get rid of unused variable warning
        if(product != nil)
            ++counter;
    }
    
    XCTAssertEqual(self.testProductData.count, counter, @"Expected the total number of products");
    
    
    const int PRODUCTS_TO_ADD = 1000;
    
    // Then, test with more items
    for(int i = 0; i < PRODUCTS_TO_ADD; ++i)
    {
        [NSEntityDescription insertNewObjectForEntityForName:@"Product"
                             inManagedObjectContext:context];
    }
    [context save:nil];

    counter = 0;
    for(Product* product in queryable)
    {
        // Get rid of unused variable warning
        if(product != nil)
            ++counter;
    }
    
    // Should contain all of the items
    XCTAssertEqual(self.testProductData.count + PRODUCTS_TO_ADD, counter, @"Expected the total number of products");
}

-(void) test_fast_enumeration_supports_empty_queryable
{
    NSManagedObjectContext* context = [self getContext];
    IQueryable* queryable = [[context ofType:@"Product"] where:@"name = 'SomethingThatDoesntExist'"];
    
    NSUInteger counter = 0;
    for(Product* product in queryable)
    {
        // Get rid of unused variable warning
        if(product != nil)
            ++counter;
    }
    
    XCTAssertEqual(0, counter, @"Expected no products");
}

@end
