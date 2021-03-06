#import "TestNodes.h"

@implementation Node_Standard

@synthesize key = key;
@synthesize childKeys = childKeys;

- (id)init
{
	if ((self = [super init]))
	{
		key = [[NSUUID UUID] UUIDString];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init]))
	{
		key = [decoder decodeObjectForKey:@"key"];
		childKeys = [decoder decodeObjectForKey:@"childKeys"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:key forKey:@"key"];
	[coder encodeObject:childKeys forKey:@"childKeys"];
}

- (NSArray *)yapDatabaseRelationshipEdges
{
	NSUInteger count = [childKeys count];
	if (count == 0) return nil;
	
	NSMutableArray *edges = [NSMutableArray arrayWithCapacity:count];
	
	for (NSString *childKey in childKeys)
	{
		YapDatabaseRelationshipEdge *edge =
		  [YapDatabaseRelationshipEdge edgeWithName:@"child"
		                             destinationKey:childKey
		                                 collection:nil
		                            nodeDeleteRules:YDB_DeleteDestinationIfSourceDeleted];
		
		[edges addObject:edge];
	}
	
	return edges;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Node_Inverse

@synthesize key = key;
@synthesize parentKey = parentKey;

- (id)init
{
	if ((self = [super init]))
	{
		key = [[NSUUID UUID] UUIDString];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init]))
	{
		key = [decoder decodeObjectForKey:@"key"];
		parentKey = [decoder decodeObjectForKey:@"parentKey"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:key forKey:@"key"];
	[coder encodeObject:parentKey forKey:@"parentKey"];
}

- (NSArray *)yapDatabaseRelationshipEdges
{
	if (parentKey == nil)
		return nil;
	
	YapDatabaseRelationshipEdge *edge =
	  [YapDatabaseRelationshipEdge edgeWithName:@"parent"
	                             destinationKey:parentKey
	                                 collection:nil
	                            nodeDeleteRules:YDB_DeleteSourceIfDestinationDeleted];
	
	return @[ edge ];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Node_RetainCount

@synthesize key = key;
@synthesize retainedKey = retainedKey;

- (id)init
{
	if ((self = [super init]))
	{
		key = [[NSUUID UUID] UUIDString];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init]))
	{
		key = [decoder decodeObjectForKey:@"key"];
		retainedKey = [decoder decodeObjectForKey:@"retainedKey"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:key forKey:@"key"];
	[coder encodeObject:retainedKey forKey:@"retainedKey"];
}

- (NSArray *)yapDatabaseRelationshipEdges
{
	if (retainedKey == nil)
		return nil;
	
	YapDatabaseRelationshipEdge *edge =
	  [YapDatabaseRelationshipEdge edgeWithName:@"retained"
	                             destinationKey:retainedKey
	                                 collection:nil
	                            nodeDeleteRules:YDB_DeleteDestinationIfAllSourcesDeleted];
	
	return @[ edge ];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Node_InverseRetainCount

@synthesize key = key;
@synthesize retainerKeys = retainerKeys;

- (id)init
{
	if ((self = [super init]))
	{
		key = [[NSUUID UUID] UUIDString];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init]))
	{
		key = [decoder decodeObjectForKey:@"key"];
		retainerKeys = [decoder decodeObjectForKey:@"retainerKeys"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:key forKey:@"key"];
	[coder encodeObject:retainerKeys forKey:@"retainerKeys"];
}

- (NSArray *)yapDatabaseRelationshipEdges
{
	NSUInteger count = [retainerKeys count];
	if (count == 0) return nil;
	
	NSMutableArray *edges = [NSMutableArray arrayWithCapacity:count];
	
	for (NSString *retainerKey in retainerKeys)
	{
		YapDatabaseRelationshipEdge *edge =
		  [YapDatabaseRelationshipEdge edgeWithName:@"retainer"
		                             destinationKey:retainerKey
		                                 collection:nil
		                            nodeDeleteRules:YDB_DeleteSourceIfAllDestinationsDeleted];
		
		[edges addObject:edge];
	}
	
	return edges;
}

@end