//
//  SALQuickTutorialViewController.h
//  SALQuickTutorial
//
//  Created by Natan Rolnik on 8/12/14.
//  Copyright (c) 2014 Seeking Alpha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MZFormSheetController/MZFormSheetController.h>

@interface SALQuickTutorialViewController : UIViewController


/**
Convenience methods
If you want, you can initialize SALQuickTutorialViewController with initWithTitle:message:image: and use the show method, or showInFormSheetController: if you want to customize the MZFormSheetController
default transition style is MZFormSheetTransitionStyleFade
 Returns YES if it will be shown, and NO if there is no need to be shown.
*/

+ (BOOL)showIfNeededForKey:(NSString *)uniqueKey title:(NSString *)title message:(NSString *)message image:(UIImage *)image;

+ (BOOL)showIfNeededForKey:(NSString *)uniqueKey title:(NSString *)title message:(NSString *)message image:(UIImage *)image transitionStyle:(MZFormSheetTransitionStyle)transitionStyle;

/**
Returns if a tutorial with the key needs to be shown or not.
*/
+ (BOOL)needsToShowForKey:(NSString *)uniqueKey;

- (instancetype)initWithKey:(NSString *)uniqueKey title:(NSString *)title message:(NSString *)message image:(UIImage *)image;

/**
Shows the SALQuickTutorialViewController object inside a MZFormSheetController with default configurations.
 */
- (void)show;

/**
 Shows the SALQuickTutorialViewController object inside a MZFormSheetController you must provide.
 */
- (void)showInFormSheetController:(MZFormSheetController *)formSheetController;

/**
 The handler to call when presented form sheet is after dismiss.
 */
@property (nonatomic, copy) void (^didDismissCompletionHandler)(void);

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 contentMode set to UIViewContentModeScaleAspectFit
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

/**
 Defaults to NO.
 If set to YES, the gesture recognizers are disabled, and user can only close the quick tutorial by pressing the button.
 If you want to customize or change the title of the button, access the property dismissButton
 */
@property (nonatomic, assign) BOOL dismissesWithButton;

@end

