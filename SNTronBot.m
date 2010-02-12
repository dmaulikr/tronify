//
//  SNTronBot.m
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import "SNTronBot.h"


@implementation SNTronBot

@synthesize filename;

-(id) initFromFile:(NSString *)path {
	self.filename = path;
	return self;
}	

-(void) setFilename:(NSString *)name {
	filename = [name retain];
	
	NSDictionary *lookups = [NSDictionary dictionaryWithObjectsAndKeys:
							@"python $1", @"py",
							@"ruby $1", @"rb", 
							@"$1", @"", 
							@"java -jar $1", @"jar", nil];
	
	NSString *extension = [[filename componentsSeparatedByString:@"."] lastObject];
	
	if ([extension isEqualToString:filename]) {
		extension = @"";
	}
	
	NSString *lookup = [lookups valueForKey:extension];
	command = [[lookup stringByReplacingOccurrencesOfString:@"$1" withString:filename] retain];
}

-(void) launch {
	if ([task isRunning]) {
		NSLog(@"Terminating task.. %d", [task processIdentifier]);
		[task terminate];
	}
	
	input = [NSPipe pipe];
	output = [NSPipe pipe];
	task = [[NSTask alloc] init];
	
	[task setLaunchPath:command];
	[task setEnvironment:[NSDictionary dictionaryWithObject:@"/usr/local/bin:/usr/bin"
													 forKey:@"PATH"]];

	[task setStandardInput:input];
	[task setStandardOutput:output];
	
	[task launch];
	
	NSLog(@"task: in: %@ out: %@", [task standardInput], [task standardOutput]);
}

-(void) kill {
	[task terminate];
	[input release];
	[output release];
	[task release];
}	

-(int) takeATurn:(SNTronMap *)map {
	NSLog(@"Taking a turn...");
	NSFileHandle *write = [input fileHandleForWriting];
	[map dumpToFileHandle:write];
	NSLog(@"Data written...");

//	return 0;
	int fd = [[output fileHandleForReading] fileDescriptor];
	FILE* fp = fdopen(fd, "r");

	char in[100];
	fgets(in, 100, fp);

	NSLog(@"received input: %s", in);
	
	return atoi(in);
}

@end