//
//  SNTronMapView.m
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import "SNTronMapView.h"

@implementation SNTronMapView

@synthesize map;

- (void)setMap:(SNTronMap *)newMap {
	map = newMap;
	
	width = map.width;
	height = map.height;
	
	NSSize size = [self frame].size;
	blockWidth = size.width / map.width;
	blockHeight = size.height / map.height;
	
	[self setNeedsDisplay:YES];
}

- (BOOL)isFlipped {
	return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
	CGRect rect = CGRectMake(0, 0, blockWidth, blockHeight);
	int wall = [map wallValue], empty = [map emptyValue], p1 = [map p1Value], p2 = [map p2Value];
	int val;
	
	NSColor *c;
	
	for(int y = 0; y < height; y++) {
		for(int x = 0; x < width; x++) {
			
			val = [map atX:x Y:y];
			if (val == wall) {
				c = [NSColor blackColor];
			} else if (val == empty) {
				c = [NSColor whiteColor];
			} else if (val == p1) {
				c = [NSColor redColor];
			} else if (val == p2) {
				c = [NSColor blueColor];
			} else {
				c = [NSColor whiteColor];
				// stupid
			}

			[c set];
			NSRectFill(rect);
			
			rect = CGRectOffset(rect, blockWidth, 0);
		}

		rect = CGRectOffset(rect, -width * blockWidth, blockHeight);
	}
}

@end
