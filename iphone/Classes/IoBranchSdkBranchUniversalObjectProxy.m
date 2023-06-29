//
//  IoBranchSdkBranchUniversalObjectProxy.m
//  Titanium-Deferred-Deep-Linking-SDK
//
//




#import "IoBranchSdkBranchUniversalObjectProxy.h"
#import "TiApp.h"
#import <BranchSDK/BranchEvent.h>
#import <BranchSDK/Branch.h>



@implementation IoBranchSdkBranchUniversalObjectProxy

-(id)init
{
    return [super init];
}

-(void)_destroy
{
    [super _destroy];
}

-(id)_initWithPageContext:(id<TiEvaluator>)context
{
    // This method is one of the initializers for the proxy class. If the
    // proxy is created without arguments then this initializer will be called.
    // This method is also called from the other _initWithPageContext method.
    // The superclass method calls the init and _configure methods.

    NSLog(@"_initWithPageContext (no arguments)");

    return [super _initWithPageContext:context];
}

-(id)_initWithPageContext:(id<TiEvaluator>)context_ args:(NSArray*)args
{
    // This method is one of the initializers for the proxy class. If the
    // proxy is created with arguments then this initializer will be called.
    // The superclass method calls the _initWithPageContext method without
    // arguments.

    NSLog(@"_initWithPageContext %@", args);

    return [super _initWithPageContext:context_ args:args];
}

-(void)_configure
{
    // This method is called from _initWithPageContext to allow for
    // custom configuration of the module before startup. The superclass
    // method calls the startup method.

    NSLog(@"_configure");

    [super _configure];
}

-(void)_initWithProperties:(NSDictionary *)properties
{
    // This method is called from _initWithPageContext if arguments have been
    // used to create the proxy. It is called after the initializers have completed
    // and is a good point to process arguments that have been passed to the
    // proxy create method since most of the initialization has been completed
    // at this point.

    NSLog(@"_initWithProperties %@", properties);

    [super _initWithProperties:properties];

    self.branchUniversalObj = [[BranchUniversalObject alloc] init];

    for (id key in properties) {
        if ([key isEqualToString:@"contentMetadata"]){
            NSDictionary *metadata = (NSDictionary *)[properties valueForKey:key];

            for (id key_ in metadata) {
                [self.branchUniversalObj addMetadataKey:key_ value:[metadata valueForKey:key_]];
            }
        }
        else if ([key isEqualToString:@"contentIndexingMode"]) {
            NSString *indexingMode = [properties valueForKey:key];
            if ([indexingMode isEqualToString:@"private"]) {
                self.branchUniversalObj.contentIndexMode = BranchContentIndexModePrivate;

            }
            else if ([indexingMode isEqualToString:@"public"]){
                self.branchUniversalObj.contentIndexMode = BranchContentIndexModePublic;
            }
        }
        else if ([key isEqualToString:@"contentImageUrl"]){
            NSString *imageUrl = [properties valueForKey:key];
            self.branchUniversalObj.imageUrl = imageUrl;
        }
        else {
            [self.branchUniversalObj setValue:[properties objectForKey:key] forKey:key];
        }
    }

}

- (id)initWithCanonicalIdentifier:(id)args
{
    ENSURE_SINGLE_ARG(args, NSString);
    if (!self.branchUniversalObj) {
        self.branchUniversalObj = [[BranchUniversalObject alloc] initWithCanonicalIdentifier:args];
    }
    else {
        self.branchUniversalObj.canonicalIdentifier = args;
    }

    return self;
}

- (id)initWithTitle:(id)args
{
    ENSURE_SINGLE_ARG(args, NSString);
    if (!self.branchUniversalObj){
        self.branchUniversalObj = [[BranchUniversalObject alloc] initWithTitle:args];
    }
    else {
        self.branchUniversalObj.title = args;
    }

    return self;
}

- (void)addMetadata:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    [self.branchUniversalObj addMetadataKey:[args objectForKey:@"key"] value:[args objectForKey:@"value"]];
}

- (void)registerView:(id)args
{
    ENSURE_ARG_COUNT(args, 0);
    [self.branchUniversalObj registerView];
}


#pragma mark - generate URL
- (void)generateShortUrl:(id)args
{
    ENSURE_ARG_COUNT(args, 2);
    ENSURE_TYPE([args objectAtIndex:0], NSDictionary);
    ENSURE_TYPE([args objectAtIndex:0], NSDictionary);

    NSDictionary *arg1 = [args objectAtIndex:0];
    NSDictionary *arg2 = [args objectAtIndex:1];
    KrollCallback *callback = [args objectAtIndex:2];

    BranchLinkProperties *props = [[BranchLinkProperties alloc] init];

    for (id key in arg1) {
        if ([key isEqualToString:@"duration"]) {
            props.matchDuration = (NSUInteger)[((NSNumber *)[arg1 objectForKey:key]) integerValue];
        }
        else {
            [props setValue:[arg1 objectForKey:key] forKey:key];
        }
    }

    for (id key in arg2) {
        [props addControlParam:key withValue:[arg1 objectForKey:key]];
    }

    [self.branchUniversalObj getShortUrlWithLinkProperties:props andCallback:^(NSString *url, NSError *error) {
        
        bool success = (error == nil);
        bool cancelled = NO;

        NSDictionary *propertiesDict = [[NSDictionary alloc] initWithObjectsAndKeys:url, @"generatedLink", [error localizedDescription], @"error", nil];
        KrollEvent *invocationEvent = [[KrollEvent alloc] initWithCallback:callback eventObject:propertiesDict thisObject:self];
        
        [[callback context] enqueue:invocationEvent];

    }];
}

- (void)showShareSheet:(id)args
{
    NSString *shareText = nil;
    
    if ([args count]==2) {
        ENSURE_ARG_COUNT(args, 2);
        ENSURE_TYPE([args objectAtIndex:0], NSDictionary);
        ENSURE_TYPE([args objectAtIndex:1], NSDictionary);
    }
    else if ([args count]==3) {
        ENSURE_ARG_COUNT(args, 3);
        ENSURE_TYPE([args objectAtIndex:0], NSDictionary);
        ENSURE_TYPE([args objectAtIndex:1], NSDictionary);
        ENSURE_TYPE([args objectAtIndex:2], NSString);

        shareText = [args objectAtIndex:2];
    }
 /*
    NSDictionary *options = [args objectAtIndex:0];
    NSDictionary *controlParams = [args objectAtIndex:1];
    NSMutableDictionary *mutableCombinedParams = [options mutableCopy];
    [mutableCombinedParams addEntriesFromDictionary:controlParams];
    
    NSDictionary *combinedParams = mutableCombinedParams;
    BranchLinkProperties *linkProperties = [BranchLinkProperties getBranchLinkPropertiesFromDictionary:combinedParams];
    UIActivityItemProvider *itemProvider = [self.branchUniversalObj getBranchActivityItemWithLinkProperties:linkProperties];
    NSMutableArray *items = [NSMutableArray arrayWithObject:itemProvider];
    UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];

    // Change Rect to position Popover
    UIViewController *view = [UIApplication sharedApplication].keyWindow.rootViewController;

    if (shareText) {
        [items addObject:shareText];
    }
    if (linkProperties.controlParams[@"$email_body"]) {
        [items addObject:linkProperties.controlParams[@"$email_body"]];
    }
    if (linkProperties.controlParams[@"$email_subject"]) {
        @try {
            [shareViewController setValue:linkProperties.controlParams[@"$email_subject"] forKey:@"subject"];
        }
        @catch (NSException *exception) {
            NSLog(@"[Branch warning] Unable to setValue 'emailSubject' forKey 'subject' on UIActivityViewController.");
        }
    }

    [shareViewController setCompletionWithItemsHandler: ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        [self fireEvent:@"bio:shareChannelSelected"];
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self.branchUniversalObj showShareSheetWithLinkProperties:linkProperties
                                     andShareText:shareText
                                     fromViewController:shareViewController
                                     completion:^(NSString *activityType, BOOL completed) {}];
            [[TiApp app] showModalController:shareViewController animated:YES];
        } else {
            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:shareViewController];
            [popup presentPopoverFromRect:CGRectMake(view.view.frame.size.width/2, view.view.frame.size.width/2, 100, 100) inView:view.view permittedArrowDirections:0 animated:YES];
        }
    });
  */
}
    
- (void)setBranchEvent:(id)args
    {
        NSString *eventName = [args objectAtIndex:0];
        BranchEvent *event    = [BranchEvent customEventWithName:eventName];
        NSDictionary *options = [args objectAtIndex:1];
       for (id key in options) {
           if ([key isEqualToString:@"affiliation"]) {
              event.affiliation = [options valueForKey:key];
           }
           if ([key isEqualToString:@"coupon"]) {
               event.coupon = [options valueForKey:key];
           }
           if ([key isEqualToString:@"currency"]) {
               event.currency = [options valueForKey:key];
           }
           if ([key isEqualToString:@"description"]) {
               event.eventDescription = [options valueForKey:key];
           }
           if ([key isEqualToString:@"shipping"]) {
               event.shipping =  [options valueForKey:key];
           }
           if ([key isEqualToString:@"tax"]) {
               event.tax =  [options valueForKey:key];
           }
           if ([key isEqualToString:@"revenue"]) {
               event.revenue =  [options valueForKey:key];
           }
           if ([key isEqualToString:@"transactionID"]) {
               event.transactionID = [options valueForKey:key];
           }
           if ([key isEqualToString:@"searchQuery"]) {
               event.searchQuery  = [options valueForKey:key];
           }
           
           NSMutableDictionary *nsmmutableDictionary = [NSMutableDictionary new];

          if ([key isEqualToString:@"contentMetadata"]){
              NSDictionary *metadata = (NSDictionary *)[options valueForKey:key];
              for(id key_ in metadata){
                  [nsmmutableDictionary setObject:[metadata valueForKey:key_] forKey:key_];
              }
              event.customData = nsmmutableDictionary;

           }
       }
        
        event.contentItems = (id) @[ self.branchUniversalObj];
        [event logEvent];
       
    }
    
    
    

@end
