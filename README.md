#ios-queryable is an Objective-C category that provides IQueryable and IEnumerable-like functionality to Core Data.

Tired of writing boilerplate Core Data code? Can't live without LINQ? ios-queryable is for you!

It supports query composition and deferred execution, and implements a subset of IEnumerable's methods, including where, take, skip, orderBy, first/firstOrDefault, single/singleOrDefault, count, any, and all.


It lets you write code like this:
```objc
NSArray* widgets = [[[[[self.managedObjectContext ofType:@"Widget"]
			where:@"Type == 'abc'"]
			orderBy:@"createddate"]
			take:5]
			toArray];
```

instead of like this:
```objc
NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
NSEntityDescription* entity = [NSEntityDescription
                               entityForName:@"Widget" inManagedObjectContext:self.managedObjectContext];
[fetchRequest setEntity:entity];
 
NSPredicate* predicate = [NSPredicate predicateWithFormat: @"type == 'abc'"];
[fetchRequest setPredicate:predicate];
 
NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                    initWithKey:@"createddate" ascending:YES];
 
NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
[fetchRequest setSortDescriptors:sortDescriptors];
 
[fetchRequest setFetchLimit:5];   
NSError* error;
NSArray* widgets = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
```

It also supports the NSFastEnumeration protocol, allowing for easy use in foreach loops:
```objc
foreach(Widget* widget in [self.managedObjectContext ofType:@"Widget"])
{
	// Do widgety stuff
}
```
#Usage
To use ios-queryable, simply copy NSManagedObjectContext+IQueryable.h and NSManagedObjectContext+IQueryable.m into your project folder. Then, simply include the header file, and start writing your queries!

For examples, check out the tests in the tests project.
