//
//  SALQuickTutorialViewController.m
//  SALQuickTutorial
//
//  Created by Natan Rolnik on 8/12/14.
//  Copyright (c) 2014 Seeking Alpha. All rights reserved.
//

#import "SALQuickTutorialViewController.h"

static const NSTimeInterval SALQuickTutorialViewControllerWidth = 284;

static const NSTimeInterval SALQuickTutorialViewMessageHeight = 90;
static const NSTimeInterval SALQuickTutorialViewButtonHeight = 30;
static const NSTimeInterval SALQuickTutorialViewMessageSpace = 10;
static const NSTimeInterval SALQuickTutorialViewButtonSpace = 10;

@interface SALQuickTutorialViewController ()

@property (nonatomic, strong) NSString *uniqueKey;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) UIImage *image;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageSpaceConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonSpaceConstraint;

- (IBAction)dismissTapped:(id)sender;

@end

@implementation SALQuickTutorialViewController

#pragma mark - Convenience methods

+ (BOOL)showIfNeededForKey:(NSString *)uniqueKey title:(NSString *)title message:(NSString *)message image:(UIImage *)image
{
    return [self showIfNeededForKey:uniqueKey title:title message:message image:image transitionStyle:MZFormSheetTransitionStyleFade];
}

+ (BOOL)showIfNeededForKey:(NSString *)uniqueKey title:(NSString *)title message:(NSString *)message image:(UIImage *)image transitionStyle:(MZFormSheetTransitionStyle)transitionStyle
{
    if (![self needsToShowForKey:uniqueKey]) {
        return NO;
    }
    
    SALQuickTutorialViewController *quickTutorialViewController = [[self alloc] initWithKey:uniqueKey title:title message:message image:image];
    MZFormSheetController *formSheetController = [SALQuickTutorialViewController formSheetControllerWithQuickTutorialViewController:quickTutorialViewController];
    formSheetController.transitionStyle = transitionStyle;
    
    [quickTutorialViewController showInFormSheetController:formSheetController];
    
    return YES;
}

+ (BOOL)needsToShowForKey:(NSString *)uniqueKey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:uniqueKey] == nil;
}

+ (MZFormSheetController *)formSheetControllerWithQuickTutorialViewController:(SALQuickTutorialViewController *)quickTutorialViewController
{
    MZFormSheetController *formSheetController = [[MZFormSheetController alloc] initWithViewController:quickTutorialViewController];
    formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
    formSheetController.cornerRadius = 8.0;
    formSheetController.shouldCenterVertically = YES;
    formSheetController.presentedFormSheetSize = CGSizeMake(SALQuickTutorialViewControllerWidth, [quickTutorialViewController tutorialHeight]);
    formSheetController.shadowRadius = 3.0;
    formSheetController.shadowOpacity = 0.25;
    
    if (!quickTutorialViewController.dismissesWithButton) {
        formSheetController.shouldDismissOnBackgroundViewTap = YES;
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:quickTutorialViewController action:@selector(dismiss)];
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionRight;
        [formSheetController.view addGestureRecognizer:swipeGestureRecognizer];
    }
    
    return formSheetController;
}

#pragma mark - SALQuickTutorialViewController creation

- (instancetype)initWithKey:(NSString *)uniqueKey title:(NSString *)title message:(NSString *)message image:(UIImage *)image
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    
    if (!self) {
        return nil;
    }
    
    self.dismissesWithButton = NO;

    self.uniqueKey = uniqueKey;
    self.title = title;
    self.message = message;
    self.image = image;
    
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"SALQuickTutorialViewController must be initialized with initWithKey:title:message:image:" userInfo:nil];
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.title;
    self.messageLabel.text = self.message;
    self.imageView.image = self.image;
    
    self.dismissButton.tintColor = [UIApplication sharedApplication].delegate.window.tintColor;
    
    if (self.dismissesWithButton) {
        self.buttonHeightConstraint.constant = SALQuickTutorialViewButtonHeight;
        self.buttonSpaceConstraint.constant = SALQuickTutorialViewButtonSpace;
    }
    else {
        self.buttonHeightConstraint.constant = 0;
        self.buttonSpaceConstraint.constant = 0;
        self.dismissButton.hidden = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.view addGestureRecognizer:tapGestureRecognizer];
    }
    
    if ([self.message length] > 0) {
        self.messageHeightConstraint.constant = SALQuickTutorialViewMessageHeight;
        self.messageSpaceConstraint.constant = SALQuickTutorialViewMessageSpace;
    }
    else {
        self.messageHeightConstraint.constant = 0;
        self.messageSpaceConstraint.constant = 0;
        self.messageLabel.hidden = YES;
    }
}

#pragma mark - presenting the tutorial

- (void)show
{
    MZFormSheetController *formSheetController = [SALQuickTutorialViewController formSheetControllerWithQuickTutorialViewController:self];
    
    [self showInFormSheetController:formSheetController];
}

- (void)showInFormSheetController:(MZFormSheetController *)formSheetController
{
    NSAssert(formSheetController != nil, @"In order to show a SALQuickTutorialViewController, you must provide a formSheetController");
    NSAssert([formSheetController isKindOfClass:[MZFormSheetController class]], @"In order to show a SALQuickTutorialViewController, you must provide a MZFormSheetController object");
    
    if (self.didDismissCompletionHandler) {
        [formSheetController setDidDismissCompletionHandler:^(UIViewController *presentedViewController){
            self.didDismissCompletionHandler();
        }];
    }
    
    [formSheetController presentAnimated:YES completionHandler:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.uniqueKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dismiss
{
    [self.formSheetController dismissAnimated:YES completionHandler:nil];
}

- (CGFloat)tutorialHeight
{
    CGFloat tutorialHeight = 180;
    
    if (self.dismissesWithButton) {
        tutorialHeight += SALQuickTutorialViewButtonHeight;
        tutorialHeight += SALQuickTutorialViewButtonSpace;
    }
    
    if ([self.message length] > 0) {
        tutorialHeight += SALQuickTutorialViewMessageHeight;
        tutorialHeight += SALQuickTutorialViewMessageSpace;
    }
    
    return tutorialHeight;
}

- (IBAction)dismissTapped:(id)sender
{
    [self dismiss];
}

@end
