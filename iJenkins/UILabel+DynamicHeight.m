//
//  UILabel+DynamicHeight.m
//  PublishTheNews
//
//  Created by Ondrej Rafaj on 22/10/2009.
//  Copyright 2009 PublishTheNews.com. All rights reserved.
//

#import "UILabel+DynamicHeight.h"
#import "UIView+Layout.h"

@implementation UILabel (DynamicHeight)

+ (double) getSizeWithText:(NSString *)text andWidth:(double)width forFont:(UIFont *)font {
	CGSize maximumSize = CGSizeMake(width, MAXFLOAT);	
	CGSize dynamicSize = [text sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
	return dynamicSize.height;	
}
	
- (double) setText:(NSString *)text withWidth:(double)width {
	double requiredHeight = [UILabel getSizeWithText:text andWidth:width forFont:[self font]];
	CGRect sizedFrame = self.frame;
	sizedFrame.size.height = requiredHeight;

	[self setLineBreakMode:NSLineBreakByWordWrapping];
	[self setNumberOfLines:0];
	self.frame = sizedFrame;
	[self setText:text];
	
	return requiredHeight;
}

- (void) setTextAndShrink:(NSString *)text {
	CGFloat height = [UILabel getSizeWithText:text andWidth:[self width] forFont:[self font]];
	
	if(height < [self height]) {
		[self setHeight:height];
	}
	
	[self setText:text];
}

- (void)alignTop {
    CGSize fontSize = [self.text sizeWithFont:self.font];
	
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;
		
    CGSize theStringSize = [self.text sizeWithFont:self.font 
								 constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];

    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
	
    for(int i=1; i< newLinesToPad; i++) {
        self.text = [self.text stringByAppendingString:@"\n"];
    }
}

- (void)alignBottom {
    CGSize fontSize = [self.text sizeWithFont:self.font];
	
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;
	
    CGSize theStringSize = [self.text sizeWithFont:self.font 
								 constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
	
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
	
    for(int i=1; i< newLinesToPad; i++) {
        self.text = [NSString stringWithFormat:@"\n%@",self.text];
    }
}

- (void)fitToSuggestedHeight
{
	CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.width, MAXFLOAT)];
	[self setHeight:size.height];
}

@end
