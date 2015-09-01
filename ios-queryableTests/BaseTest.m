//
//  BaseTest.m
//  ios-queryableTests
//
//  Created by Marty on 2012-11-07.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import "BaseTest.h"
#import "Product.h"
#import <CoreData/CoreData.h>

@implementation BaseTest

static NSArray* seedData;
static NSManagedObjectContext* context;

@synthesize testProductData;

+ (void)seedTestData
{
    NSMutableArray* products = [[NSMutableArray alloc] init];
    NSArray* names = [[NSArray alloc] initWithObjects:@"Peach", @"Apple", @"Banana", @"Orange", @"Strawberry", nil];
    NSArray* quantities = [[NSArray alloc] initWithObjects:@3, @5, @7, @4, @11, nil];
    NSArray* prices = [[NSArray alloc] initWithObjects:@1.1, @2.2, @3.3, @4.4, @5.5, nil];

    for (int i = 0; i < names.count; ++i)
    {
        Product* product = [NSEntityDescription
                insertNewObjectForEntityForName:@"Product"
                         inManagedObjectContext:context];
        product.name = [names objectAtIndex:i];
        product.quantity = [quantities objectAtIndex:i];
        product.price = [prices objectAtIndex:i];

        [products addObject:product];
    }

    seedData = products;
    
    [context save:nil];
}

- (NSManagedObjectContext*)getContext
{
    NSBundle* bundle = [NSBundle bundleWithIdentifier:@"org.codeninja.ios-queryable.tests"];

    NSManagedObjectModel* managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:bundle]];

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ios-queryable-tests.sqlite"];

    if([[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    
    NSError* error = nil;
    NSPersistentStoreCoordinator* persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];

    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = persistentStoreCoordinator;

    [BaseTest seedTestData];
    
    self.testProductData = seedData;
    return context;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    // This is lame. but it makes the unit tests work. The other ones fail.
    return [NSURL fileURLWithPath:@"/var/tmp/"];
    // return [NSURL fileURLWithPath:[[NSFileManager defaultManager] currentDirectoryPath]];
    // return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)assertDouble:(double)a isEqualToDouble:(float)b message:(NSString*)message
{
    bool equal = fabs(a - b) < epsilon;
    XCTAssert(equal);
}

@end
