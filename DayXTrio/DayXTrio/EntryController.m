//
//  EntryController.m
//  DayXTrio
//
//  Created by Ethan Hess on 5/7/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "EntryController.h"

static NSString * const entryListKey = @"entryKey";

@interface EntryController()

@property (nonatomic, strong) NSArray *entries;

@end

@implementation EntryController

+ (EntryController *)sharedInstance {
    static EntryController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [EntryController new];
        
        [sharedInstance loadFromDefaults];
    });
    
    return sharedInstance;
    
}


- (void)addEntry:(Entry *)entry {
    
    if (!entry) {
        return;
    }
    
    NSMutableArray *mutableEntries = [[NSMutableArray alloc]initWithArray:self.entries];
    [mutableEntries addObject:entry];
    
    self.entries = mutableEntries;
    [self synchronize];
    
}

- (void)removeEntry:(Entry *)entry {
    
    if (!entry) {
        return;
    }
    
    NSMutableArray *mutableEntries = self.entries.mutableCopy;
    [mutableEntries removeObject:entry];
    
    self.entries = mutableEntries;
    [self synchronize];
    
}

- (void)loadFromDefaults {
    
    NSArray *entryDictionaries = [[NSUserDefaults standardUserDefaults]objectForKey:entryListKey];
    
    NSMutableArray *entries = [NSMutableArray new];
    
    for (NSDictionary *entry in entryDictionaries) {
        
        [entries addObject:[[Entry alloc] initWithDictionary:entry]];
         
    }
         
    self.entries = entries;
    
}



- (void)synchronize {
    
    NSMutableArray *entryArray = [NSMutableArray new];
    for (Entry *entry in self.entries) {
        [entryArray addObject:[entry entryDictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:entryArray forKey:entryListKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


@end
