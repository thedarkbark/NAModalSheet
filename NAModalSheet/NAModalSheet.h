//
//  NAModalSheet.h
//  Note All
//
//  Created by Ken Worley on 11/17/13.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NAModalSheetPresentationStyle) {
  
  // Slides in from bottom - you can specify slideInset points from the bottom
  NAModalSheetPresentationStyleSlideInFromBottom,
  
  // Slides in from top - you can specify slideInset points from the top
  NAModalSheetPresentationStyleSlideInFromTop,
  
  // This style requires your window's root view controller to be a UINavigationController - slides in from top
  NAModalSheetPresentationStyleSlideInFromUnderNavBar,
  
  // This style requires your window's root view controller to be a UINavigationController - slides in from bottom
  NAModalSheetPresentationStyleSlideInFromUnderToolbar,
  
  // Centered on the screen - fades in and out
  NAModalSheetPresentationStyleFadeInCentered,
  
  // Displayed in a specified position and size
  NAModalSheetPresentationStyleFixedPositionAndSize
};

typedef NS_ENUM(NSUInteger, NAModalSheetHorizontalJustification) {
  
  // Center the sheet horizontally on the screen - default
  NAModalSheetHorizontalJustificationCentered,
  
  // Left justify the sheet horizontally on the screen
  NAModalSheetHorizontalJustificationLeft,

  // Right justify the sheet horizontally on the screen
  NAModalSheetHorizontalJustificationRight,
  
  // Resize the view's width to fill the screen horizontally
  NAModalSheetHorizontalJustificationFull
};

@class NAModalSheet;

@protocol NAModalSheetDelegate <NSObject>
@optional

/**
 This delegate method will be called if the user touches outside the content view provided. You may want to use this
 to dismiss the sheet.
 If you prefer blocks, you can set the touchedOutsideContent property instead.
 */
-(void)modalSheetTouchedOutsideContent:(NAModalSheet*)sheet;

/**
 modalSheetShouldAutorotate: and modalSheetSupportedInterfaceOrientations: are analogous to the UIViewController
 shouldAutorotate and supportedInterfaceOrientations methods. If the presenting view controller
 is overriding those methods, it should also implement these two methods and return the same values.
 If you specify the presenting view controller when presenting the modal sheet, you don't need to implement this
 as the values will be taken directly from the presenting view controller. If this delegate method is not
 implemented and the presenting view controller is not specified, then the setting is taken from the child/modal
 view controller being presented.
 */
-(BOOL)modalSheetShouldAutorotate:(NAModalSheet*)sheet;

/**
 modalSheetShouldAutorotate: and modalSheetSupportedInterfaceOrientations: are analogous to the UIViewController
 shouldAutorotate and supportedInterfaceOrientations methods. If the presenting view controller
 is overriding those methods, it should also implement these two methods and return the same values.
 If you specify the presenting view controller when presenting the modal sheet, you don't need to implement this
 as the values will be taken directly from the presenting view controller. If this delegate method is not
 implemented and the presenting view controller is not specified, then the setting is taken from the child/modal
 view controller being presented.
 */
-(NSUInteger)modalSheetSupportedInterfaceOrientations:(NAModalSheet*)sheet;

/**
 Called when an orientation change animation is about to happen. If the
 delegate is controlling the position/size of the sheet (using presentation
 style NAModalSheetPresentationStyleFixedPositionAndSize), this is an
 opportunity to modify the presentationRect property so the sheet content
 is properly positioned on completion of the orientation change.
 This is only called when the presentation style is NAModalSheetPresentationStyleFixedPositionAndSize.
 
 @return Return YES if you handled any adjustment necessary for this sheet, NO otherwise.
 */
-(BOOL)modalSheet:(NAModalSheet*)sheet willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

/**
 Called after the sheet is dismissed no matter what caused the dismissal.
 */
-(void)modalSheetDismissed:(NAModalSheet*)sheet;

@end

/**
 @class NAModalSheet
 
 NAModalSheet presents a given view controller in a modal fashion.
 */
@interface NAModalSheet : UIViewController

@property (nonatomic, weak) id<NAModalSheetDelegate> delegate;

/**
 Duration of the slide or fade animation when presenting or dismissing the modal sheet
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 Actual rectangle used to size and position the content view being presented. This is used only with
 the NAModalSheetPresentationStyleFixedPositionAndSize presentation style.
 */
@property (nonatomic, assign) CGRect presentationRect;

/**
 Number of pixels from the top/bottom edge to slide out from when using top.bottom slide in presentation.
 Used only with the NAModalSheetPresentationStyleSlideInFromBottom and NAModalSheetPresentationStyleSlideInFromTop
 presentation styles.
 */
@property (nonatomic, assign) CGFloat slideInset;

/**
 Rounds the corners of the modal view, but only when using the centered presentation
 */
@property (nonatomic, assign) CGFloat cornerRadiusWhenCentered;

/**
 Set YES to disable blurred background to improve performance if your modal view is opaque or you don't want the blur
 */
@property (nonatomic, assign) BOOL disableBlurredBackground;

/**
 Custom background image processing block. If nil, it uses default blurring algorithm
 */
@property (nonatomic, copy) UIImage *(^backgroundProcessingBlock)(UIImage *image);

/**
 This color is used to "tint" the background outside the modal content - by default, it is black at 40% alpha
 */
@property (nonatomic, strong) UIColor *backgroundTintColor;

/**
 Set this to YES to have the sheet automatically dismiss when touched outside the content view
 (only if delegate doesn't respond to modalSheetTouchedOutsideContent:)
 */
@property (nonatomic, assign) BOOL autoDismissWhenTouchedOutsideContent;

/**
 This block will be called if the user touches outside the content view.
 If you set this, the autoDismissWhenTouchedOutsideContent property is ignored.
 */
@property (nonatomic, copy) void (^touchedOutsideContent)(NAModalSheet *sheet);

/**
 Determines the horizontal justification of the content view horizontally within the screen - defaults to centered
 This affects presentation modes that slide in from the top or bottom of the screen.
 */
@property (nonatomic, assign) NAModalSheetHorizontalJustification horizontalJustification;

/**
 Initialize the modal sheet with your view controller and a presentation style
 */
- (instancetype)initWithViewController:(UIViewController *)vc
                     presentationStyle:(NAModalSheetPresentationStyle)style;

/**
 Present the modal to the user
 
 @param completion a block called when the modal is fully displayed (i.e. animations complete)
 */
-(void)presentWithCompletion:(void (^)(void))completion;

/**
 Present the modal to the user specifying the 'presenting' view controller from which orientation change
 cues should be taken.
 
 @param presentingVC the 'presenting' view controller. NAModalSheet checks with this view controller to
        see which orientations are allowed while the modal sheet is displayed
 @param completion a block called when the modal is fully displayed (i.e. animations complete)
 */
-(void)presentFromViewController:(UIViewController*)presentingVC
                  withCompletion:(void (^)(void))completion;

/**
 Dismiss the modal
 
 @param completion a block called when the modal is fully dismissed (i.e. animations complete)
 */
-(void)dismissWithCompletion:(void (^)(void))completion;

/**
 Changes the size of the modal sheet view while presented.
 */
-(void)adjustContentSize:(CGSize)newSize animated:(BOOL)animated;

@end
