#include <Foundation/Foundation.h>
#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface,
							   QLPreviewRequestRef preview,
							   CFURLRef url,
							   CFStringRef contentTypeUTI,
							   CFDictionaryRef options)
{
	NSAutoreleasePool *pool;
	NSMutableDictionary *props;
	NSError *theErr = nil;
	NSMutableString *html;
	
	pool = [[NSAutoreleasePool alloc] init];
	
	NSXMLDocument *theDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:(NSURL *)url options:0 error:&theErr] autorelease];
	
	if (!theDoc && theErr) {
		NSLog(@"Error creating the XML, %@", theErr);
		[pool release];
		return noErr;
	}
	props=[[[NSMutableDictionary alloc] init] autorelease];
	[props setObject:@"UTF-8"
			  forKey:(NSString *)kQLPreviewPropertyTextEncodingNameKey];
	[props setObject:@"text/html"
			  forKey:(NSString *)kQLPreviewPropertyMIMETypeKey];
	
	
	html = (NSMutableString *)HTMLfromXML(theDoc);
	//NSLog(html);
	
	QLPreviewRequestSetDataRepresentation(preview,
										  (CFDataRef)[html dataUsingEncoding:NSUTF8StringEncoding],
										  kUTTypeHTML,
										  (CFDictionaryRef)props);
	
	
	[pool release];
	return noErr;
}

void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
  // implement only if supported
}
