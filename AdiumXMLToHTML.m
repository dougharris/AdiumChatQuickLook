//
//  AdiumXMLToHTML.m
//  AdiumChatQuickLook
//
//  Created by Doug Harris on 5/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#include "AdiumXMLToHTML.h"
#include <Foundation/Foundation.h>
#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

NSMutableString *HTMLfromXML(NSXMLDocument *xmlDoc) 
{
	NSAutoreleasePool *pool;
	pool = [[NSAutoreleasePool alloc] init];
	NSError *theErr = nil;
	//NSManagedObject *occasion=NULL;
	NSMutableString *html;
	int MAXMSGS = 50;
	NSString *styles;
	styles = @"<style>h1 {font-family: \"Lucida Grande\",verdana} .other { color:blue; } .me { color: green; } td.who { text-align: right; vertical-align: top;} td.what { } </style>";

		
		// Get the account name and protocol from the root node
	NSXMLElement *chatNode = [[xmlDoc nodesForXPath:@"//chat" error:&theErr]
							  objectAtIndex:0];
	NSString *account = [[chatNode attributeForName:@"account"] stringValue];
	NSString *service = [[chatNode attributeForName:@"service"] stringValue];
	
	// Top level node should be chat, look at children, but only get those
	// that are messages (not events or status)
	NSArray *messageNodes = [xmlDoc nodesForXPath:@"//message" error:&theErr];
	int i, count = [messageNodes count];
		
	html=[[[NSMutableString alloc] init] autorelease];
	[html appendFormat:@"<html><head>%@<body bgcolor=white>", styles];
	[html appendFormat:@"<h1>Adium %@ chat log</h1>\n", service];
	
	NSXMLElement *child;
	NSString *sender, *spanstyle;
	
	if (count > 0) {
		[html appendString:@"<table border=\"0\" cellpadding=\"2\">"];
		for (i=0;(i < [messageNodes count] && i< MAXMSGS);i++) {
			child = [messageNodes objectAtIndex:i];
			sender = [[child attributeForName:@"sender"] stringValue];
			if ([sender caseInsensitiveCompare:account] == 0) {
				spanstyle = @"me";
			} else {
				spanstyle = @"other";
			}
			
			[html appendString:@"<tr><td class=\"who\">"];
			[html appendFormat:
			 @"<span class=\"%@\">%@</span>:</td><td class=\"what\">%@</td></tr>\n",
			 spanstyle, sender, [child XMLString]];
		}
		[html appendString:@"</table>"];
	}
	[html appendString:@"</body></html>"];

	return html;
}

