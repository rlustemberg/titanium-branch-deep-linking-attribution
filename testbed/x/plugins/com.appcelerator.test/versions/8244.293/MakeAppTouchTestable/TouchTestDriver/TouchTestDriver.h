//**************************************************
//
//  Copyright 2011-2012 SOASTA, Inc.
//  All rights reserved.
//  Proprietary and confidential.
//
//  File:  TouchTestDriver.h
//
//**************************************************

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * The TouchTestDriver delegate
 */
@protocol TouchTestDelegate <NSObject>

/**
 * Called when before TouchTest capture a screenshot. In this method you need to make sure your view is ready for image output.
 * @param view the UIView used to render the image, if no view is specified TouchTest will render the UIApplication windows in the image.
 */
- (void) willCaptureScreenshot:(UIView*)view;

/**
 * Called when after TouchTest capture a screenshot.
 * @param view the UIView used to render the image, if no view is specified TouchTest will render the UIApplication windows in the image.
 */
- (void) didCaptureScreenshot:(UIView*)view;

/**
 * This is a general purpose function to return internal app state.
 */
- (NSString*) getAppInternalValue:(NSString *)value withArgs:(NSDictionary *)args;

@end

/**
 * The TouchTestDriver interface is used for all interaction with TouchTest Driver.
 */
@interface TouchTestDriver : NSObject

/**
 * Initializes TouchTest Driver.  This should be called from the application's <code>main()</code>
 * function.
 */
+ (void) initDriver;

/**
 * Starts a new TouchTest Driver session.  This should be called from the application
 * delegate's UIApplicationDelegate::handleOpenURL:url method.
 * @param url the NSURL that was passed to UIApplicationDelegate::handleOpenURL:url.
 */
+ (NSURL *) startSession:(NSURL*) url;

/**
 * Install a TouchTestDriver delegate
 * @param TouchTestDelegate
 */
+ (void) setTouchTestDelegate:(id<TouchTestDelegate>)delegate;

@end


/**
 * The CloudTestMobile category provides the ability to
 * set "TouchTest ID's" on arbitrary UI views.
 *
 * This category provides optional functionality that can be used to
 * enhance the testing process when using TouchTest.  Specifically,
 * you can assign arbitrary ID's to UI views by setting the touchTestId
 * property.  Once a "TouchTest ID" has been assigned, it will be
 * automatically detected during the recording process, and used as
 * the locator for any actions on that element.
 *
 * This is especially useful for cases where the normal locator would
 * be ambiguous.
 */
@interface UIView (CloudTestMobile)

/**
 * The current TouchTest ID of this UIView.
 */
@property(retain) NSString *touchTestId;


@end

@interface UIApplication (CloudTestMobile)

/**
 * This is a general purpose function to return internal app state.
 */
+(NSString *)getAppInternalValue:(NSString *)value withArgs:(NSDictionary *)args;

@end
