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
  
  // Centered on the screen - fades in and out
  NAModalSheetPresentationStyleFadeInCentered
};

@class NAModalSheet;

@protocol NAModalSheetDelegate <NSObject>
@optional

// This delegate method will be called if the user touches outside the content view provided. You may want to use this
// to dismiss the sheet.
-(void)modalSheetTouchedOutsideContent:(NAModalSheet*)sheet;

// These two delegate methods are analogous to the UIViewController shouldAutorotate and supportedInterfaceOrientations
// methods. If the presenting view controller is overriding those methods, it should also implement these two methods
// and return the same values.
-(BOOL)modalSheetShouldAutorotate:(NAModalSheet*)sheet;
-(NSUInteger)modalSheetSupportedInterfaceOrientations:(NAModalSheet*)sheet;

@end

@interface NAModalSheet : UIViewController

@property (nonatomic, weak) id<NAModalSheetDelegate> delegate;

// Duration of the slide or fade animation when presenting or dismissing the modal sheet
@property (nonatomic, assign) CGFloat animationDuration;

// Number of pixels from the top/bottom edge to slide out from when using top.bottom slide in presentation
@property (nonatomic, assign) CGFloat slideInset;

// Rounds the corners of the modal view, but only when using the centered presentation
@property (nonatomic, assign) CGFloat cornerRadiusWhenCentered;

// Set YES to disable blurred background to improve performance if your modal view is opaque or you don't want the blur
@property (nonatomic, assign) BOOL disableBlurredBackground;

// Initialize the modal sheet with your view controller and a presentation style
- (instancetype)initWithViewController:(UIViewController *)vc
                     presentationStyle:(NAModalSheetPresentationStyle)style;

// Present and dismiss the modal sheet - completion blocks are optional
-(void)presentWithCompletion:(void (^)(void))completion;
-(void)dismissWithCompletion:(void (^)(void))completion;

// Changes the size of the modal sheet view while presented.
-(void)adjustContentSize:(CGSize)newSize animated:(BOOL)animated;

@end
