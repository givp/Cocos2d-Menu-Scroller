//
//  CCScrollLayer.m
//  Museum
//
//  Created by GParvaneh on 29/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CCScrollLayer.h"


@implementation CCScrollLayer

-(id) initWithLayers:(NSMutableArray *)layers widthOffset: (int) widthOffset
{
	
	if ( (self = [super init]) )
	{
		
		// Make sure the layer accepts touches
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
		
		// Set up the starting variables
		if(!widthOffset){
			widthOffset = 0;
		}	
		currentScreen = 1;
		
		// offset added to show preview of next/previous screens
		scrollWidth = [[CCDirector sharedDirector] winSize].width - widthOffset;
		scrollHeight = [[CCDirector sharedDirector] winSize].height;
		startWidth = scrollWidth;
		startHeight = scrollHeight;
		
		// Loop through the array and add the screens
		int i = 0;
		for (CCLayer *l in layers)
		{
			
			l.anchorPoint = ccp(0,0);
			l.position = ccp((i*scrollWidth),0);
			[self addChild:l];
			i=i+1;
			
		}
		
		// Setup a count of the available screens
		totalScreens = i;
		
	}
	return self;
	
}

-(void) moveToPage:(int)page
{
	
	id changePage = [CCEaseBounce actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(-((page-1)*scrollWidth),0)]];
	[self runAction:changePage];
	currentScreen = page;
	
}

-(void) moveToNextPage
{
	
	id changePage = [CCEaseBounce actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(-(((currentScreen+1)-1)*scrollWidth),0)]];
	[self runAction:changePage];
	currentScreen = currentScreen+1;
	
}

-(void) moveToPreviousPage
{
	
	id changePage = [CCEaseBounce actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(-(((currentScreen-1)-1)*scrollWidth),0)]];
	[self runAction:changePage];
	currentScreen = currentScreen-1;
	
}

- (void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	startSwipe = touchPoint.x;
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	self.position = ccp((-(currentScreen-1)*scrollWidth)+(touchPoint.x-startSwipe),0);
	
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	int newX = touchPoint.x;
	
	
	if ( (newX - startSwipe) < -100 && (currentScreen+1) <= totalScreens )
	{
		
		[self moveToNextPage];
		
	}
	else if ( (newX - startSwipe) > 100 && (currentScreen-1) > 0 )
	{
		
		[self moveToPreviousPage];
		
	}
	else
	{
		
		[self moveToPage:currentScreen];
		
	}
	
}

- (void) dealloc
{
	[super dealloc];
}

@end
