/**
 * Titanium-Deferred-Deep-Linking-SDK
 *
 * Created by Jestoni Yap
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "IoBranchSdkModule.h"
#import "TiApp.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import "Branch-SDK/Branch.h"

@implementation IoBranchSdkModule

#pragma mark Internal

// this is generated for your module, please do not change it
- (id)moduleGUID
{
	return @"df14a182-464d-4940-bc1d-ae84730366a8";
}

// this is generated for your module, please do not change it
- (NSString*)moduleId
{
	return @"io.branch.sdk";
}

#pragma mark Lifecycle

- (void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    
	NSLog(@"[INFO] %@ loaded",self);
}

- (void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Internal Memory Management

- (void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

- (void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"bio:initSession"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

- (void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"bio:initSession"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma mark Public APIs
#pragma mark - Global Instance Accessors

- (Branch *)getInstance
{
    return [Branch getInstance];
}

- (Branch *)getInstance:(NSString *)branchKey
{
    if (branchKey) {
        return [Branch getInstance:branchKey];
    }
    else {
        return [Branch getInstance];
    }
}

- (Branch *)getTestInstance
{
    return [Branch getTestInstance];
}

- (void)setDebug
{
    [[Branch getInstance] setDebug];
}


#pragma mark - InitSession Permutation methods

- (void)initSession:(id)args
{
    Branch *branch = [self getInstance];
    NSDictionary *launchOptions = [[TiApp app] launchOptions];
    
    [branch initSessionWithLaunchOptions:launchOptions];
    
    [self fireEvent:@"bio:initSession" withObject:@{}];
}

- (void)initSessionIsReferrable:(id)args
{
    ENSURE_SINGLE_ARG(args, NSNumber);
    
    Branch *branch = [self getInstance];
    BOOL isReferrable = [TiUtils boolValue:args];
    
    [branch initSession:isReferrable];
    
    [self fireEvent:@"bio:initSession" withObject:@{}];
}

- (void)initSessionAndAutomaticallyDisplayDeepLinkController:(id)args
{
    ENSURE_ARG_COUNT(args, 1);
    
    Branch *branch = [self getInstance];
    id arg = [args objectAtIndex:0];
    BOOL automaticallyDisplayController = [TiUtils boolValue:arg];
    
    [branch initSessionAndAutomaticallyDisplayDeepLinkController:automaticallyDisplayController];
    
    [self fireEvent:@"bio:initSession" withObject:@{}];
}

- (void)initSessionWithLaunchOptionsAndAutomaticallyDisplayDeepLinkController:(id)args
{
    ENSURE_SINGLE_ARG(args, KrollCallback);
    
    Branch *branch = [self getInstance];
    NSDictionary *launchOptions = [[TiApp app] launchOptions];
    BOOL display = YES;
    
    KrollCallback *deepLinkHandler = args;
    
    [branch initSessionWithLaunchOptions:launchOptions automaticallyDisplayDeepLinkController:display deepLinkHandler:^(NSDictionary *params, NSError *error) {
        if (!error) {
            [deepLinkHandler call:@[params, NUMBOOL(YES)] thisObject:nil];
            [self fireEvent:@"bio:initSession" withObject:params];
        }
        else {
            [deepLinkHandler call:@[params, NUMBOOL(NO)] thisObject:nil];
            [self fireEvent:@"bio:initSession" withObject:params];
        }
    }];
}


#pragma mark - retrieve session/install params
- (NSDictionary *)getLatestReferringParams:(id)args
{
    ENSURE_ARG_COUNT(args, 0);
    
    Branch *branch = [self getInstance];
    NSDictionary *sessionParams = [branch getLatestReferringParams];
    
    return sessionParams;
}

- (NSDictionary *)getFirstReferringParams:(id)args
{
    ENSURE_ARG_COUNT(args, 0);
    
    Branch *branch = [self getInstance];
    NSDictionary *installParams = [branch getFirstReferringParams];
    
    return installParams;
}


#pragma mark - set identity

- (void)setIdentity:(id)args
{
    Branch *branch = [self getInstance];
    NSString *userId = nil;
    KrollCallback *callback = nil;
    
    // if a callback is passed as an argument
    if ([args count]==2) {
        ENSURE_TYPE([args objectAtIndex:0], NSString);
        userId = [args objectAtIndex:0];
        
        ENSURE_TYPE([args objectAtIndex:1], KrollCallback);
        callback = [args objectAtIndex:1];
    }
    else {
        ENSURE_SINGLE_ARG(args, NSString);
        userId = (NSString *)args;
    }
    
    if (!callback) {
        [branch setIdentity:userId];
    }
    else {
        [branch setIdentity:userId withCallback:^(NSDictionary *params, NSError *error) {
            if (!error) {
                [callback call:@[params, NUMBOOL(YES)] thisObject:nil];
            }
            else {
                [callback call:@[params, NUMBOOL(NO)] thisObject:nil];
            }
        }];
    }
}


#pragma mark - register controller

- (void)registerDeepLinkController:(id)args
{
    ENSURE_SINGLE_ARG(args, NSString);
    
    UIViewController <BranchDeepLinkingController> *controller = (UIViewController <BranchDeepLinkingController>*)[TiApp app].controller;
    Branch *branch = [self getInstance];
    
    [branch registerDeepLinkController:controller forKey:args];
}


#pragma mark - handle deep link

- (id)handleDeepLink:(id)args
{
    ENSURE_SINGLE_ARG(args, NSString);
    NSString *arg = [args objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:arg];
    
    Branch *branch = [self getInstance];
    return NUMBOOL([branch handleDeepLink:url]);
}


#pragma mark - URL methods

- (NSString *)getShortURL:(id)args
{
    ENSURE_ARG_COUNT(args, 0);
    
    Branch *branch = [self getInstance];
    return [branch getShortURL];
}

- (id)getShortURLWithParams:(id)args
{
    Branch *branch = [self getInstance];
    NSDictionary *params = nil;
    KrollCallback *callback = nil;
    
    // if a callback is passed as an argument
    if ([args count]==2) {
        ENSURE_TYPE([args objectAtIndex:0], NSDictionary);
        params = [args objectAtIndex:0];
        
        ENSURE_TYPE([args objectAtIndex:1], KrollCallback);
        callback = [args objectAtIndex:1];
    }
    else {
        ENSURE_SINGLE_ARG(args, NSDictionary);
        params = (NSDictionary *)args;
    }
    
    if (!callback){
        return [branch getShortURLWithParams:params];
    }
    else {
        [branch getShortURLWithParams:params andCallback:^(NSString *url, NSError *error) {
            if (!error){
                [callback call:@[url, NUMBOOL(YES)] thisObject:nil];
            }
            else {
                [callback call:@[url, NUMBOOL(NO)] thisObject:nil];
            }
        }];
    }
}

- (NSString *)getLongURLWithParams:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    id params = [args objectAtIndex:0];
    return [[self getInstance] getLongURLWithParams:params];
}

- (NSString *)getContentUrlWithParams:(id)args
{
    ENSURE_ARG_COUNT(args, 2);
    ENSURE_TYPE([args objectAtIndex:0], NSDictionary);
    ENSURE_TYPE([args objectAtIndex:1], NSString);
    
    NSDictionary *params = [args objectAtIndex:0];
    NSString *channel = [args objectAtIndex:1];
    
    Branch *branch = [self getInstance];
    
    return [branch getContentUrlWithParams:params andChannel:channel];
}

- (void)getBranchActivityItemWithParams:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    ENSURE_UI_THREAD(getBranchActivityItemWithParams, args);
    
    UIActivityItemProvider *provider = [Branch getBranchActivityItemWithParams:args];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems:@[ provider ] applicationActivities:nil];
        
        [[TiApp app] showModalController:shareViewController animated:YES];
    });
}


#pragma mark - Referral Reward System

- (void)loadRewards:(id)args
{
    ENSURE_ARG_COUNT(args, 0);
    
    Branch *branch = [self getInstance];
    
    [branch loadRewardsWithCallback:^(BOOL changed, NSError *error) {
        if(!error) {
            NSNumber *credits = [NSNumber numberWithInteger:[branch getCredits]];
            [self fireEvent:@"bio:loadRewards" withObject:@{@"balance":credits}];
        }
        else {
            [self fireEvent:@"bio:loadRewards:ERROR" withObject:@{@"error":[error localizedDescription]}];
        }
    }];
}

- (void)redeemRewards:(id)args
{
    ENSURE_SINGLE_ARG(args, NSNumber);
    
    NSInteger amount = ((NSNumber *)args).integerValue;
    Branch *branch = [self getInstance];
    
    //[branch redeemRewards:amount];
    [branch redeemRewards:amount callback:^(BOOL changed, NSError *error) {
        if (!error) {
            [self fireEvent:@"bio:redeemRewards" withObject:@{}];
        }
        else {
            [self fireEvent:@"bio:redeemRewards:ERROR" withObject:@{@"error":[error localizedDescription]}];
        }
    }];
}

- (void)getCreditHistory:(id)args
{
    ENSURE_ARG_COUNT(args, 0);
    
    Branch *branch = [self getInstance];
    
    [branch getCreditHistoryWithCallback:^(NSArray *list, NSError *error) {
        if (!error) {
            [self fireEvent:@"bio:getCreditHistory" withObject:@{@"history":list}];
        }
        else {
            [self fireEvent:@"bio:getCreditHistory:ERROR" withObject:@{@"error":[error localizedDescription]}];
        }
    }];
}


#pragma mark - logout

- (void)logout:(id)args
{
    ENSURE_ARG_COUNT(args, 0);
    
    Branch *branch = [self getInstance];
    [branch logout];
}

@end
