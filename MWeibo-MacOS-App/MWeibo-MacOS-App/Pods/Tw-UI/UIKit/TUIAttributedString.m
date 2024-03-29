/*
 Copyright 2011 Twitter, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this work except in compliance with the License.
 You may obtain a copy of the License in the LICENSE file, or at:
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "TUIAttributedString.h"
#import "TUIFont.h"
#import "TUIColor.h"

NSString * const TUIAttributedStringBackgroundColorAttributeName = @"TUIAttributedStringBackgroundColorAttributeName";
NSString * const TUIAttributedStringBackgroundFillStyleName = @"TUIAttributedStringBackgroundFillStyleName";
NSString * const TUIAttributedStringPreDrawBlockName = @"TUIAttributedStringPreDrawBlockName";

@implementation TUIAttributedString

+ (TUIAttributedString *)stringWithString:(NSString *)string
{
	return (TUIAttributedString *)[[NSMutableAttributedString alloc] initWithString:string ? : @""];
}

@end

@implementation NSMutableAttributedString (TUIAdditions)

- (NSRange)_stringRange
{
	return NSMakeRange(0, [self length]);
}

- (void)setFont:(TUIFont *)font inRange:(NSRange)range
{
	[self addAttribute:(NSString *)kCTFontAttributeName value:(id)[font ctFont] range:range];
}

- (void)setColor:(TUIColor *)color inRange:(NSRange)range
{
	[self addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[color CGColor] range:range];
}

- (void)setShadow:(NSShadow *)shadow inRange:(NSRange)range
{
	[self addAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)setKerning:(CGFloat)k inRange:(NSRange)range
{
	[self addAttribute:(NSString *)kCTKernAttributeName value:[NSNumber numberWithFloat:k] range:range];
}

- (void)setFont:(TUIFont *)font
{
	[self setFont:font inRange:[self _stringRange]];
}

- (void)setColor:(TUIColor *)color
{
	[self setColor:color inRange:[self _stringRange]];
}

- (void)setBackgroundColor:(TUIColor *)color
{
	[self setBackgroundColor:color inRange:[self _stringRange]];
}

- (void)setBackgroundColor:(TUIColor *)color inRange:(NSRange)range
{
	[self addAttribute:TUIAttributedStringBackgroundColorAttributeName value:(id)[color CGColor] range:range];
}

- (void)setBackgroundFillStyle:(TUIBackgroundFillStyle)fillStyle
{
	[self setBackgroundFillStyle:fillStyle inRange:[self _stringRange]];
}

- (void)setBackgroundFillStyle:(TUIBackgroundFillStyle)fillStyle inRange:(NSRange)range
{
	[self addAttribute:TUIAttributedStringBackgroundFillStyleName value:[NSNumber numberWithInteger:fillStyle] range:range];
}

- (void)setPreDrawBlock:(TUIAttributedStringPreDrawBlock)block inRange:(NSRange)range
{
	[self addAttribute:TUIAttributedStringPreDrawBlockName value:[block copy] range:range];
}

- (void)setShadow:(NSShadow *)shadow
{
	[self setShadow:shadow inRange:[self _stringRange]];
}

- (void)setKerning:(CGFloat)f
{
	[self setKerning:f inRange:[self _stringRange]];
}

- (void)setLineHeight:(CGFloat)f
{
	[self setLineHeight:f inRange:[self _stringRange]];
}

- (void)setLineHeight:(CGFloat)f inRange:(NSRange)range
{
	CTParagraphStyleSetting settings[] = {
        { kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(f), &f },
        { kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(f), &f },
    };
	
	CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
	[self addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)paragraphStyle, kCTParagraphStyleAttributeName, nil] range:range];
	CFRelease(paragraphStyle);
}

NSParagraphStyle *ABNSParagraphStyleForTextAlignment(TUITextAlignment alignment)
{
    CTTextAlignment a = kCTTextAlignmentLeft;
	switch(alignment) {
		case TUITextAlignmentRight:
            a = kCTTextAlignmentRight;
			break;
		case TUITextAlignmentCenter:
            a = kCTTextAlignmentCenter;
			break;
		case TUITextAlignmentJustified:
            a = kCTTextAlignmentJustified;
			break;
		case TUITextAlignmentLeft:
		default:
            a = kCTTextAlignmentLeft;
			break;
	}
	
	NSMutableParagraphStyle *p = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[p setAlignment:a];
	return p;
}

- (void)setAlignment:(TUITextAlignment)alignment lineBreakMode:(TUILineBreakMode)lineBreakMode
{
	CTLineBreakMode nativeLineBreakMode = kCTLineBreakByTruncatingTail;
	switch(lineBreakMode) {
		case TUILineBreakModeWordWrap:
			nativeLineBreakMode = kCTLineBreakByWordWrapping;
			break;
		case TUILineBreakModeCharacterWrap:
			nativeLineBreakMode = kCTLineBreakByCharWrapping;
			break;
		case TUILineBreakModeClip:
			nativeLineBreakMode = kCTLineBreakByClipping;
			break;
		case TUILineBreakModeHeadTruncation:
			nativeLineBreakMode = kCTLineBreakByTruncatingHead;
			break;
		case TUILineBreakModeTailTruncation:
			nativeLineBreakMode = kCTLineBreakByTruncatingTail;
			break;
		case TUILineBreakModeMiddleTruncation:
			nativeLineBreakMode = kCTLineBreakByTruncatingMiddle;
			break;
	}
	
	CTTextAlignment nativeTextAlignment;
	switch(alignment) {
		case TUITextAlignmentRight:
			nativeTextAlignment = kCTTextAlignmentRight;
			break;
		case TUITextAlignmentCenter:
			nativeTextAlignment = kCTTextAlignmentCenter;
			break;
		case TUITextAlignmentJustified:
			nativeTextAlignment = kCTTextAlignmentJustified;
			break;
		case TUITextAlignmentLeft:
		default:
			nativeTextAlignment = kCTTextAlignmentLeft;
			break;
	}
	
//	TUIAttributedString *s = [TUIAttributedString stringWithString:self];
	CTParagraphStyleSetting settings[] = {
		kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &nativeLineBreakMode,
		kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &nativeTextAlignment,
	};
	CTParagraphStyleRef p = CTParagraphStyleCreate(settings, 2);
	[self addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(__bridge_transfer id)p range:[self _stringRange]];
}

- (void)setAlignment:(TUITextAlignment)alignment
{
	[self setAlignment:alignment lineBreakMode:TUILineBreakModeWordWrap];
}

- (TUIFont *)font
{
	return nil;
}

- (TUIColor *)color
{
	return nil;
}

- (NSShadow *)shadow
{
	return nil;
}

- (TUITextAlignment)alignment
{
	return TUITextAlignmentLeft;
}

- (CGFloat)kerning
{
	return 0.0;
}

- (CGFloat)lineHeight
{
	return 0.0;
}

- (TUIColor *)backgroundColor
{
	return nil;
}

- (TUIBackgroundFillStyle)backgroundFillStyle {
	return TUIBackgroundFillStyleInline;
}

@end

@implementation NSShadow (TUIAdditions)

+ (NSShadow *)shadowWithRadius:(CGFloat)radius offset:(CGSize)offset color:(TUIColor *)color
{
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowBlurRadius:radius];
	[shadow setShadowOffset:offset];
	[shadow setShadowColor:[color nsColor]];
	return shadow;
}

@end
