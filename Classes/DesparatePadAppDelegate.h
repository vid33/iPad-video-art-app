//
//  DesparatePadAppDelegate.h
//  DesparatePad
//
//  Created by Vid Stojevic on 22/07/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DesparatePadViewController;

@interface DesparatePadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DesparatePadViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DesparatePadViewController *viewController;

@end

