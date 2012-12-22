//
//  User.h
//  ios-queryable
//
//  Created by Marty on 2012-12-17.
//  Copyright (c) 2012 Marty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;

@end
